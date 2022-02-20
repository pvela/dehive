# deHive - Decentralized Professional Network.

:Project for EthDenver 2022
## Challenges in centralized professional network platform
* Trustless management
* Controls your data. 
* No transparency on sharing your data.
* Force their policy to follow.
* Monetizes using your data. 
* High risk of data breaches affects your life.
* Can be kicked out anytime for no reason.

## What is deHive vision?

* Democratizing of the professional network data. 
* Decentralized professional network platform.
* Embrace professional network community.
* User owns private data.
* Community-owned platform.
* Governed by community.
* Offers greater transparency
* Rewards goes to the community.

## Use Case:  Monopoly of Linkedin

* Reimagines NFTs for social networks.
* Member owns the profile.
* Member controls who gets access.
* Permissionless approach to employment verification.
* Community endorsed skill recognition.

## How deHive works?

* Alice creates a token (ERC1155) to become a member.
* Alice sends an invite to Bob with a signature.
* Bob accepts the invite and mints Alice’s token.
* Accepting Alice invite will also generate a token for Bob and both have each others token minted in their wallet and are now connected.
* Companies can create their own token and airdrop to all the current and past employees.
* DeHive Platform will create globally recognized traits as nft which can be minted by members to be associated with that trait.

## Projects Used
* Harmony - UNIQUE USAGES FOR NON-FUNGIBLE TOKENS - We are using 1155 Semi-Fungible token for democratizing professional social network
* Polygon - ERC 1155 contract deployed on mumbai testnet
* IPFS  - Storing user Profile and metadata in ipfs
* Tableland - Store additional metadata of members in tableland
* Skale - SKALE HACK AWARDS

Technical Info :

* We use the hardhat starter as a base and built on top of that.
* We also used ERC 1155 contracts to establish connections
* Frontend is a react application using chakra-ui

## Quick start

This project was initialized from hardhat hackathon boilerplate

The first things you need to do are cloning this repository and installing its
dependencies:

```sh
git clone https://github.com/nomiclabs/hardhat-hackathon-boilerplate.git
cd hardhat-hackathon-boilerplate
npm install
```

Once installed, let's run Hardhat's testing network:

```sh
npx hardhat node
```

Then, on a new terminal, go to the repository's root folder and run this to
deploy your contract:

```sh
npx hardhat run scripts/deploy.js --network localhost
```

Finally, we can run the frontend with:

```sh
cd frontend
npm install
npm start
```

> Note: There's [an issue in `ganache-core`](https://github.com/trufflesuite/ganache-core/issues/650) that can make the `npm install` step fail. 
>
> If you see `npm ERR! code ENOLOCAL`, try running `npm ci` instead of `npm install`.

Open [http://localhost:3000/](http://localhost:3000/) to see your Dapp. You will
need to have [Metamask](https://metamask.io) installed and listening to
`localhost 8545`.

## User Guide

You can find detailed instructions on using this repository and many tips in [its documentation](https://hardhat.org/tutorial).

- [Writing and compiling contracts](https://hardhat.org/tutorial/writing-and-compiling-contracts/)
- [Setting up the environment](https://hardhat.org/tutorial/setting-up-the-environment/)
- [Testing Contracts](https://hardhat.org/tutorial/testing-contracts/)
- [Setting up Metamask](https://hardhat.org/tutorial/hackathon-boilerplate-project.html#how-to-use-it)
- [Hardhat's full documentation](https://hardhat.org/getting-started/)

For a complete introduction to Hardhat, refer to [this guide](https://hardhat.org/getting-started/#overview).

## What’s Included?

Your environment will have everything you need to build a Dapp powered by Hardhat and React.

- [Hardhat](https://hardhat.org/): An Ethereum development task runner and testing network.
- [Mocha](https://mochajs.org/): A JavaScript test runner.
- [Chai](https://www.chaijs.com/): A JavaScript assertion library.
- [ethers.js](https://docs.ethers.io/v5/): A JavaScript library for interacting with Ethereum.
- [Waffle](https://github.com/EthWorks/Waffle/): To have Ethereum-specific Chai assertions/mathers.
- [A sample frontend/Dapp](./frontend): A Dapp which uses [Create React App](https://github.com/facebook/create-react-app).
