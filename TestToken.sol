// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

//ERC Token Standard #20 Interface
interface ERC20Interface { //Must have these 6 functions for all ERC20 tokens
    function totalSupply() external view returns (uint); // When this number is reached, SC refuse to create new tokens
    function balanceOf(address account) external view returns (uint remaining); 
    function allowance(address owner, address spender) external view returns (uint remaining); // Checks if specific user has enough tokens to transfer
    function transfer(address recipient, uint amount) external returns (bool success);
    function approve(address spender, uint amount) external returns (bool success);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool success); // Transfer ERC token from one user to another user.
    //Proof is the method that verifies whether an SC is allowed to allocate a certain number of tokens to user

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

//Actual Token Contract
contract TestToken is ERC20Interface {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint public _totalSupply;
    address public owner;

    mapping(address => uint) balances; //Address of wallet, and how much token in that wallet
    mapping(address => mapping(address => uint)) allowed;
    // For this specific wallet address, it can have multiple other addresses that are allowed to spend the tokens
    // Ensure SC does not spend tokens users dont have

    constructor() {
        symbol = "TTK";
        name = "Test Token";
        decimals = 18; // In Solidity, only Integer, no Decimals
        owner = msg.sender; // or can be msg.sender if the contract is not myself
        _totalSupply = 1_000_001_000_000_000_000_000_000; // 18 Zeros for decimal points, 18 Zeros are decimals, the number is not that big
        balances[owner] = _totalSupply; // mint the token to my own wallet
        emit Transfer(address(0), owner, _totalSupply);
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint balance) {
        return balances[account]; //Using mapping defined in the beginning to get the value
    }

    function transfer(address recipient, uint amount) public returns (bool success) {
        require(balances[msg.sender] >= amount,"Insufficient balance"); // Additional error handling
        balances[msg.sender] -= amount; // subtract this amount to be transferred
        balances[recipient] += amount; // Add this amount to the recipient address
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // Grants the approval for transfer from sender to recipient
    function approve(address spender, uint amount) public returns (bool success) {
        allowed[msg.sender][spender] = amount; //updates the allowed mapping from owner of wllet to the specific sender
        emit Approval(msg.sender, spender, amount); // Allow the specific spender to spend the amount of token from their address
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) public returns (bool success) {
        balances[sender] = balances[sender] - amount; // updates balance of sender
        allowed[sender][msg.sender] = allowed[sender][msg.sender] - amount; // deducts from allowance from ssender to spender, deducts this amount from sender to spender so it cannot be spent twice
        balances[recipient] = balances[recipient] + amount; // updates balance for recipients
        emit Transfer(sender, recipient, amount); // update balance for recipeint
        return true;
    }

    // returns the allowed mapping
    function allowance(address ownerAddress, address spender) public view returns (uint remaining) {
        return allowed[ownerAddress][spender];
    }

    // ################## Additional functions to mint or burn tokens ###########################
    // Burn off via a voting system. 
    // To do this, click the createProposal button, key in the parameters, click transact, key in the porposal ID start from 0
    struct Proposal {
        address proposer;
        uint amount;
        bool isBurn; // True for burn, False for mint
        bool executed;
        uint votesFor;
        uint votesAgainst;
        uint votingDeadline;
    }

    mapping(address => mapping(uint => bool)) hasVoted; // Tracks if an address has voted

    Proposal[] public proposals; // Define Proposal as an array data structure
    event ProposalCreated(uint proposalId, address proposer, uint amount, bool isBurn);
    event ProposalExecuted(uint proposalId);
    event Voted(uint proposalId, address voter,bool vote);

    modifier onlyVoter(uint proposalId) {
        require(!proposals[proposalId].executed, "Proposal already executed");
        _; // Place holder for modifiers. tells the compiler to insert the original function's code at that point in the modifier.
    }

    modifier proposalNotExecuted(uint proposalId) {
        require(!proposals[proposalId].executed, "Proposal already executed");
        _;
    }

    function createProposal(uint amount, bool isBurn, uint numOfDay) public {
        proposals.push();
        Proposal storage newProposal = proposals[proposals.length - 1]; // new proposal ID
        newProposal.proposer = msg.sender; // proposer of this proposal
        newProposal.amount = amount;
        newProposal.isBurn = isBurn;
        newProposal.votingDeadline = block.timestamp + (numOfDay * 1 days); // voting period is x days, so deadline is proposal date + x days
        newProposal.votesFor = 0;
        newProposal.votesAgainst = 0;

        emit ProposalCreated(proposals.length - 1, msg.sender, amount, isBurn);
    }

    // Voting on a proposal
    function vote(uint proposalId, bool inFavor) public {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp <= proposal.votingDeadline, "Voting period has ended");
        require(!hasVoted[msg.sender][proposalId], "You have already voted");

        hasVoted[msg.sender][proposalId] = true; // Record the vote

        if (inFavor) {
            proposal.votesFor++;
        } else {
            proposal.votesAgainst++;
        }

        emit Voted(proposalId, msg.sender, inFavor);
    }

    // Execute mint or burn proposal after voting has concluded
    // address(0) is the convention indicating "nothing"
    // the minted or burnt tokens are added/ removed from the community pool 
    function executeProposal(uint proposalId) public proposalNotExecuted(proposalId) {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp > proposal.votingDeadline, "Voting period is still ongoing");

        // Check if the proposal was approved
        require(proposal.votesFor > proposal.votesAgainst, "Proposal was not approved");

        // Check if the proposal is for minting or burning
        if (proposal.isBurn) {
            require(_totalSupply >= proposal.amount, "Not enough supply to burn");
            _totalSupply -= proposal.amount;
            emit Transfer(address(this), address(0), proposal.amount); // Emit burn event
        } else {
            _totalSupply += proposal.amount;
            balances[proposal.proposer] += proposal.amount; // Mint tokens to the proposer
            emit Transfer(address(0), address(this), proposal.amount); // Emit mint event
        }

        proposal.executed = true;
        emit ProposalExecuted(proposalId);
    }

    // Get the details of a proposal
    function getProposal(uint proposalId) public view returns (
        address proposer, 
        uint amount, 
        bool isBurn, 
        bool executed,
        uint votesFor,
        uint votesAgainst,
        int timeRemaining
    ) {
        Proposal storage proposal = proposals[proposalId];
        int remaining = int(proposal.votingDeadline) - int(block.timestamp); 
        return (proposal.proposer, proposal.amount, proposal.isBurn, proposal.executed, proposal.votesFor, proposal.votesAgainst, remaining);
    }

    // Get the total number of proposals
    function getTotalProposals() public view returns (uint) {
        return proposals.length;
    }
}