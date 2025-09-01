# Foundry FundMe

This project is a smart contract system for decentralized crowdfunding, built with [Foundry](https://book.getfoundry.sh/).

## Features
- FundMe contract for accepting ETH contributions
- Minimum funding threshold enforced in USD
- Chainlink price feed integration for real-time ETH/USD conversion
- Owner-only withdrawal functionality
- Gas-optimized withdrawal method
- Fallback and receive functions for direct ETH transfers
- Comprehensive unit and integration tests
- Deployment and interaction scripts

## Getting Started

### Prerequisites
- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Node.js](https://nodejs.org/) (for some scripts)
- Git

### Installation
Clone the repository and install dependencies:
```sh
git clone https://github.com/Miraakbutnotded/foundry-first-repo.git
cd foundry-first-repo
forge install
```

### Building
```sh
forge build
```

### Testing
Run all tests:
```sh
forge test
```
Run a specific test:
```sh
forge test --mt testFunctionName
```

### Deployment
Deploy contracts using Foundry scripts:
```sh
forge script script/DeployFundMe.s.sol --broadcast --rpc-url <YOUR_RPC_URL>
```

### Interacting
Fund the contract or withdraw using scripts:
```sh
forge script script/Interactions.s.sol --broadcast --rpc-url <YOUR_RPC_URL>
```

## Project Structure
- `src/` — Solidity contracts
- `script/` — Deployment and interaction scripts
- `test/` — Unit and integration tests
- `lib/` — External dependencies (Chainlink, forge-std, etc.)

## License
MIT

## Author
Miraakbutnotded
