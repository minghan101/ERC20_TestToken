# TestToken Smart Contract

TestToken is an ERC-20 token contract written in Solidity. It includes all standard ERC-20 functionality with additional features for **minting** and **burning** tokens through a decentralized **voting system**. This allows the community to propose changes to the total supply of the token (minting or burning) and vote on whether those changes should be executed.

## Table of Contents
- [Features](#features)
- [Contract Structure](#contract-structure)
- [Events](#events)
- [How to Use](#how-to-use)
  - [Launching and Interacting with the `TestToken` Smart Contract](#launching-and-interacting-with-the-testtoken-smart-contract)
  - [Functions](#functions)
    - [Core Feature 1: Using ERC20 Contract Functions](#core-feature-1-using-erc20-contract-functions)
    - [Core Feature 2: Create a Proposal, Vote & Execute Contract](#core-feature-2-create-a-proposal-vote-execute-contract)
  - [Voting and Proposals](#voting-and-proposals)
- [Security Considerations](#security-considerations)
- [License](#license)

## Features
- **ERC-20 Standard Functions**:
  - `totalSupply()`: Returns the total supply of the token.
  - `balanceOf(address account)`: Returns the balance of a specific account.
  - `transfer(address recipient, uint amount)`: Transfers tokens from the sender to a recipient.
  - `approve(address spender, uint amount)`: Allows a spender to spend tokens from the sender's balance.
  - `transferFrom(address sender, address recipient, uint amount)`: Allows a spender to transfer tokens from a sender to a recipient, given an allowance.

- **Minting and Burning Through Proposals**:
  - Proposals can be created to **mint** or **burn** tokens, which are then voted on by token holders.
  - **Minting**: Tokens are added to the total supply and sent to the proposer's address.
  - **Burning**: Tokens are removed from circulation, reducing the total supply.

- **Voting System**:
  - Token holders can vote for or against proposals.
  - Proposals that are approved (votes for exceed votes against) are executed, resulting in minting or burning of tokens.

## Contract Structure

### Key Variables:
- **`symbol`**: Token's symbol (e.g., "TTK").
- **`name`**: Token's name (e.g., "Test Token").
- **`decimals`**: Number of decimal places (18 by default).
- **`_totalSupply`**: Total supply of the token.
- **`owner`**: Address of the contract's creator.

### Key Mappings:
- **`balances`**: Tracks the balance of each address.
- **`allowed`**: Tracks allowances granted for `transferFrom`.
- **`hasVoted`**: Tracks which addresses have voted on each proposal.

### Proposal Struct:
- **`proposer`**: Address of the proposer.
- **`amount`**: Amount of tokens to mint or burn.
- **`isBurn`**: Boolean indicating whether the proposal is to burn tokens (`true`) or mint tokens (`false`).
- **`executed`**: Whether the proposal has been executed.
- **`votesFor`**: Number of votes in favor of the proposal.
- **`votesAgainst`**: Number of votes against the proposal.
- **`votingDeadline`**: Timestamp after which voting ends.

## Events

The following events are emitted during contract interactions:

- **`Transfer(address indexed from, address indexed to, uint value)`**: Emitted when tokens are transferred.
- **`Approval(address indexed owner, address indexed spender, uint value)`**: Emitted when an allowance is granted.
- **`ProposalCreated(uint proposalId, address proposer, uint amount, bool isBurn)`**: Emitted when a proposal is created.
- **`ProposalExecuted(uint proposalId)`**: Emitted when a proposal is executed.
- **`Voted(uint proposalId, address voter, bool vote)`**: Emitted when a vote is cast on a proposal.


# How to Use

## Launching and Interacting with the `TestToken` Smart Contract

To interact with the `TestToken` smart contract, you'll need to follow these steps. These instructions assume that you're using a development environment like **Remix IDE** along with **MetaMask** for managing Ethereum accounts.

## Prerequisites

Before getting started, make sure you have:

1. **MetaMask** installed in your browser for managing Ethereum accounts and transactions. [MetaMask download](https://metamask.io/download.html).
2. Familiarity with basic Ethereum development tools like **Remix IDE**.

# Steps:
## 1. Open Remix IDE

1. Open your browser and go to [Remix IDE](https://remix.ethereum.org/).

## 2. Create a New Solidity File

1. In the left sidebar, click on the **File Explorer** tab.
2. Click on the **+** icon to create a new Solidity file.
3. Name your file `TestToken.sol` (or any name of your choice).
4. Paste the `TestToken.sol` smart contract code into this file.

## 3. Compile the Contract

1. In the left sidebar, click on the **Solidity Compiler** tab (the one with the Solidity logo).
2. Ensure the correct Solidity version is selected. Your contract is written for version `^0.8.17`, so make sure to select version `0.8.17` or higher.
3. Click the **Compile TestToken.sol** button to compile the contract.
   
   - If the compilation is successful, you will see a green checkmark, and no errors will appear. If there are errors, they will be shown in the "Compilation Details" section, and you need to resolve them before proceeding.

## 4. Deploy the Contract

1. In the left sidebar, click on the **Deploy & Run Transactions** tab (the one with the Ethereum logo).
2. Under **Environment**, select the environment you want to deploy to:

   - **Remix VM (cancun)**: This is a local in-browser blockchain for testing and development.
   - **Injected MetaMask**: This option uses your MetaMask wallet, allowing you to deploy to a testnet or the Ethereum mainnet.
   - **Web3 Provider**: Use this if you're connecting to a remote Ethereum node.

   For testing on local in-browser testing, you can choose **Remix VM (cancun)**.
   For testing on testnet, you can choose **Injected MetaMask** to deploy on a testnet like **Sepolia**.

3. In the **Account** dropdown, select the account you want to deploy the contract from (ensure your MetaMask is connected and the account has enough test Ether for deployment).
4. Select the **TestToken** contract in the **Contract** dropdown.
5. Click on the **Deploy** button.

   - If you're deploying on a testnet, MetaMask will prompt you to confirm the transaction.
   - After the transaction is confirmed, the contract will be deployed, and you’ll see the contract's **address** in the **Deployed Contracts** section.

## 5. Functions

After deployment, you can interact with the contract's functions directly in the Remix IDE interface.

### 5.1 Core Feature 1: Using ERC20 Contract Functions

In the **Deployed Contracts** section, you should now see your deployed `TestToken` contract. Below are the functions you can call:

### **totalSupply**

To view the total supply of tokens:

1. In the **Deployed Contracts** section, expand the `TestToken` contract.
2. Find the `totalSupply()` function.
3. Click on the `totalSupply` button to view the total supply of tokens.

### **balanceOf**

To view the balance of a specific address:

1. In the **Deployed Contracts** section, expand the contract.
2. Find the `balanceOf` function.
3. Enter the **address** of the wallet you want to check in the input box (for example, your MetaMask address).
4. Click on the `balanceOf` button to see the balance of tokens for that address.

### **approve**

To approve a spender to spend a specific amount of tokens:

1. In the **Deployed Contracts** section, expand the contract.
2. Find the `approve` function.
3. Enter the **spender address** and **amount** you want to approve.
4. Click on the `approve` button to execute the approval.

### **transfer**

To transfer tokens from your address to another address:

1. In the **Deployed Contracts** section, expand the contract.
2. Find the `transfer` function.
3. Enter the **recipient address** and **amount** of tokens to send.
4. Click on the `transfer` button to send the tokens.

### 5.2 Core Feature 2: Create a Proposal, Vote & Execute contract
To create a proposal, call the `createProposal` function, providing the following parameters:
- `amount`: Number of tokens to mint or burn.
- `isBurn`: Boolean indicating if the proposal is to burn tokens (`true`) or mint tokens (`false`).
- `numOfDay`: Number of days the voting period will last.

### **createProposal**

To create a proposal to mint or burn tokens:

1. In the **Deployed Contracts** section, expand the contract.
2. Find the `createProposal` function.
3. Enter the **amount** of tokens to mint or burn, **isBurn** (true for burn, false for mint), and the **voting period** (in days).
4. Click on the `createProposal` button to create the proposal.

### **vote**

To vote on a proposal:

1. In the **Deployed Contracts** section, expand the contract.
2. Find the `vote` function.
3. Enter the **proposalId** (the ID of the proposal you want to vote on) and your **vote** (true for in favor, false for against).
4. Click on the `vote` button to cast your vote.

### **executeProposal**

To execute a proposal after voting has concluded:

1. In the **Deployed Contracts** section, expand the contract.
2. Find the `executeProposal` function.
3. Enter the **proposalId** of the proposal you want to execute.
4. Click on the `executeProposal` button to execute the proposal (this will either mint or burn tokens based on the proposal).

### **getProposal**

To get the details of a specific proposal:

1. In the **Deployed Contracts** section, expand the contract.
2. Find the `getProposal` function.
3. Enter the **proposalId** you want to view.
4. Click on the `getProposal` button to get the proposal details such as the proposer, amount, votes, and time remaining.

### **getTotalProposals**

To get the total number of proposals:

1. In the **Deployed Contracts** section, expand the contract.
2. Find the `getTotalProposals` function.
3. Click on the `getTotalProposals` button to see the total number of proposals.

**Example**:
```
createProposal(1000, false, 7);  // Mint 1000 tokens over a 7-day voting period
````

### Vote on a Proposal
Token holders can vote on proposals by calling the vote function with the following parameters:

 - **`proposalId`**: ID of the proposal to vote on.
 - **`inFavor`**: Boolean indicating whether the vote is in favor (true) or against (false) the proposal.

**Example**:
```
vote(0, true);  // Vote in favor of proposal ID 0
```

## Executing a Proposal
Once the voting deadline has passed, anyone can call executeProposal to execute the proposal if it has been approved. This will either mint or burn tokens as specified in the proposal.

```
executeProposal(0);  // Execute proposal ID 0
```

## License
This project is licensed under the MIT License
