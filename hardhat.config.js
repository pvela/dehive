require("@nomiclabs/hardhat-waffle");

// The next line is part of the sample project, you don't need it in your
// project. It imports a Hardhat task definition, that can be used for
// testing the frontend.
require("./tasks/faucet");
const privateKey = process.env.polygon_dev_private;
// If you are using MetaMask, be sure to change the chainId to 1337
module.exports = {
  solidity: "0.8.12",
  networks: {
    hardhat: {
      chainId: 31337
    },
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts:  [privateKey],
    },
  }
};
