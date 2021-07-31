const hre = require("hardhat");

async function main() {
  const DecentraStock = await hre.ethers.getContractFactory("DecentraStock");
  const dStock = await DecentraStock.deploy();
  await dStock.deployed();
  console.log("DecentraStock deployed to:", dStock.address);

  const DecentraDollar = await hre.ethers.getContractFactory("DecentraDollar");
  const dDollar = await DecentraDollar.deploy();
  await dDollar.deployed();
  console.log("DecentraDollar deployed to:", dDollar.address);

  const DScore = await hre.ethers.getContractFactory("DScore");
  const dScore = await DScore.deploy(dStock.address);
  await dScore.deployed();
  console.log("DScore deployed to:", dScore.address);

  const DecentraCore = await hre.ethers.getContractFactory("DecentraCore");
  const dCore = await DecentraCore.deploy(
    dDollar.address,
    dStock.address,
    dScore.address
  );
  await dCore.deployed();
  console.log("DecentraCore deployed to:", dCore.address);

  const DecentraBank = await hre.ethers.getContractFactory("DecentraBank");
  const dBank = await DecentraBank.deploy(
    dCore.address,
    dStock.address,
    dDollar.address,
    500000,
    75
  );
  await dBank.deployed();
  console.log("DecentraBank deployed to:", dBank.address);
  dsAmount = 10000000000000000000000000000;
  ddAmount = 10000000000000000000000000000;

  dScore.setDC(dCore);
  console.log("Set up DScore");
  dDollar.transferOwnership(dCore);
  dStock.transferOwnership(dCore);
  dScore.transferOwnership(dCore);
  dBank.transferOwnership(dCore);
  console.log("Ownership transfered to DecentraCore");
  dStock.transfer(dBank, dsAmount);
  dDollar.transfer(dBank, ddAmount);
  console.log("Money in the bank");
  dBank.setUp();
  console.log("DecentraBank initialized");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
