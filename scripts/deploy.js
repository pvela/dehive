// This is a script for deploying your contracts. You can adapt it to deploy
// yours, or create new ones.
const hre = require("hardhat");

async function main() {
  // This is just a convenience check
  if (network.name === "hardhat") {
    console.warn(
      "You are trying to deploy a contract to the Hardhat Network, which" +
        "gets automatically created and destroyed every time. Use the Hardhat" +
        " option '--network localhost'"
    );
  }

  const [deployer] = await hre.ethers.getSigners();
  console.log(
    "Deploying the contracts with the account:",
    await deployer.getAddress()
  );
  console.log("Account balance:", (await deployer.getBalance()).toString());
  console.log("deploying dehive contract");
  const Token = await hre.ethers.getContractFactory("DeHiveToken");
  console.log("dehive contract built ")
  const token = await Token.deploy("Dehive for ethdenver2022");
  console.log("dehive deploy initiated ")
  await token.deployed();

  console.log("Token address:", token.address);



  const Token1 = await hre.ethers.getContractFactory("Token");
  console.log("token contract built ")
  const token1 = await Token1.deploy();
  console.log("token deploy initiated ")
  await token1.deployed();
  // We also save the contract's artifacts and address in the frontend directory
  saveFrontendFiles(token,token1);
}

function saveFrontendFiles(token, token1) {
  const fs = require("fs");
  const contractsDir = __dirname + "/../frontend/src/contracts";

  if (!fs.existsSync(contractsDir)) {
    fs.mkdirSync(contractsDir);
  }

  fs.writeFileSync(
    contractsDir + "/contract-address.json",
    JSON.stringify({ Token: token1.address, DeHiveToken:token.address }, undefined, 2)
  );

  const DeHiveArtifact = artifacts.readArtifactSync("DeHiveToken");

  fs.writeFileSync(
    contractsDir + "/DeHiveToken.json",
    JSON.stringify(DeHiveArtifact, null, 2)
  );
  const TokenArtifact = artifacts.readArtifactSync("Token");

  fs.writeFileSync(
    contractsDir + "/Token.json",
    JSON.stringify(TokenArtifact, null, 2)
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
