const hre = require("hardhat");

async function main() {
  const DecentraStock = await hre.ethers.getContractFactory("DecentraStock");
  dStock = await DecentraStock.deploy();
  await dStock.deployed();
  console.log("DecentraStock deployed to:", dStock.address);

  const DecentraDollar = await hre.ethers.getContractFactory("DecentraDollar");
  dDollar = await DecentraDollar.deploy();
  await dDollar.deployed();
  console.log("DecentraDollar deployed to:", dDollar.address);

  const DScore = await hre.ethers.getContractFactory("DScore");
  dScore = await DScore.deploy(dStock.address);
  await dScore.deployed();
  console.log("DScore deployed to:", dScore.address);

  const DecentraCore = await hre.ethers.getContractFactory("DecentraCore");
  dCore = await DecentraCore.deploy(
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
  let dsAmount = "10000000000000000000000000000";
  let ddAmount = "10000000000000000000000000000";

  await dScore.setDC(dCore.address);
  console.log("Set up DScore");
  await dDollar.transferOwnership(dCore.address);
  await dStock.transferOwnership(dCore.address);
  await dScore.transferOwnership(dCore.address);
  console.log("Ownership transfered to DecentraCore");
  console.log("DecentraBank initialized");
  await dCore.setApprovedContract(dCore.address, 1);
  await dCore.setApprovedContract(dCore.address, 2);
  await dCore.setApprovedContract(dCore.address, 3);
  await dCore.setApprovedContract(dBank.address, 1);
  await dCore.setApprovedContract(dBank.address, 2);
  await dCore.setApprovedContract(dScore.address, 1);
  await dCore.setApprovedContract(dScore.address, 2);
  await dCore.transferOwnership(dCore.address);
  console.log("DecentraCore initialized");
  await dStock.transfer(dBank.address, dsAmount);
  await dDollar.transfer(dBank.address, ddAmount);
  await dBank.setUp();
  await dBank.transferOwnership(dCore.address);
  console.log("Money in the bank");
  console.log("DecentraCorp is live");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
