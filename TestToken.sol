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
    event Approval(address indexed owner, address indexed speder, uint value);
}

//Actual Token Contract
contract TestToken is ERC20Interface {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances; //Address of wallet, and how much token in that wallet
    mapping(address => mapping(address => uint)) allowed;
    // For this specific wallet address, it can have multiple other addresses that are allowed to spend the tokens
    // Ensure SC does not spend tokens users dont have

    constructor() {
        symbol = "TTK";
        name = "Test Token";
        decimals = 18; // In Solidity, only Integer, no Decimals
        _totalSupply = 1_000_001_000_000_000_000_000_000; // 18 Zeros for decimal points, 18 Zeros are decimals, the number is not that big
        balances[0x400322347ad8fF4c9e899044e3aa335F53fFA42B] = _totalSupply; // mint the token to my own wallet
        emit Transfer(address(0), 0x400322347ad8fF4c9e899044e3aa335F53fFA42B, _totalSupply);
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint balance) {
        return balances[account]; //USing mapping defined in the beginning to get the value
    }

    function transfer(address recipient, uint amount) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender] - amount; // subtract this amount to be transferred
        balances[recipient] = balances[recipient] + amount; // Add this amount to the recipient address
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
        emit Transfer(sender, recipient, amount); // jupdate balance for recipeint
        return true;
    }

    // returns the allowed mapping
    function allowance(address owner, address spender) public view returns (uint remaining) {
        return allowed[owner][spender];
    }
}