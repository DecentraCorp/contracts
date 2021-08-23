const { expect } = require("chai");
const provider = waffle.provider;

describe("DecentraBank", function () {
  let dStock;
  let dDollar;
  let dScore;
  let dCore;
  let dBank;

  let dStock1;
  let dDollar1;
  let dCore1;
  let dBank1;

  let dStock2;
  let dDollar2;
  let dCore2;
  let dBank2;

  let dStock3;
  let dDollar3;
  let dCore3;
  let dBank3;

  let dStock4;
  let dDollar4;
  let dCore4;
  let dBank4;

  let account1; // admin privledges
  let account2; // organizastional privledges for org one
  let account3; // artist privledges for org one
  let account4; // no privledges

  before(async () => {
    const signers = await ethers.getSigners();
    account1 = signers[0].address;
    account2 = signers[1].address;
    account3 = signers[2].address;
    account4 = signers[3].address;

    const DecentraStock = await hre.ethers.getContractFactory("DecentraStock");
    dStock = await DecentraStock.deploy();
    await dStock.deployed();
    console.log("DecentraStock deployed to:", dStock.address);

    const DecentraDollar = await hre.ethers.getContractFactory(
      "DecentraDollar"
    );
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

    dStock1 = await dStock.connect(signers[0]);
    dStock2 = await dStock.connect(signers[1]);
    dStock3 = await dStock.connect(signers[2]);
    dStock4 = await dStock.connect(signers[3]);

    dDollar1 = await dDollar.connect(signers[0]);
    dDollar2 = await dDollar.connect(signers[1]);
    dDollar3 = await dDollar.connect(signers[2]);
    dDollar4 = await dDollar.connect(signers[3]);

    dCore1 = await dCore.connect(signers[0]);
    dCore2 = await dCore.connect(signers[1]);
    dCore3 = await dCore.connect(signers[2]);
    dCore4 = await dCore.connect(signers[3]);

    dScore1 = await dScore.connect(signers[0]);
    dScore2 = await dScore.connect(signers[1]);
    dScore3 = await dScore.connect(signers[2]);
    dScore4 = await dScore.connect(signers[3]);

    dBank1 = await dBank.connect(signers[0]);
    dBank2 = await dBank.connect(signers[1]);
    dBank3 = await dBank.connect(signers[2]);
    dBank4 = await dBank.connect(signers[3]);
  });

  it("Should allow account2 to purchase DecentraStock with xDAI", async function () {
    let val = ethers.utils.parseEther("1");
    let overrides = {
      value: val,
    };
    let xDAIbefore = await provider.getBalance(account2);
    console.log("xDAI balance before: " + xDAIbefore);

    let balb4 = await dStock2.balanceOf(account2);
    await dBank2.purchaseStock(val, 0, overrides);
    let balAfter = await dStock2.balanceOf(account2);
    expect(balAfter).to.be.above(balb4);
    console.log("DecentraStock balance: " + balAfter);
  });

  it("Should return 50% DAI 50% DecentraDollar for a DecentraStock sale", async function () {
    let val = ethers.utils.parseEther("1");
    let overrides = {
      value: val,
    };

    let xDAIbefore = await provider.getBalance(account2);
    console.log("xDAI balance before: " + xDAIbefore);
    let ddBalb4 = await dDollar2.balanceOf(account2);
    console.log("DecentraDollar balance before: " + ddBalb4);
    let balDS = await dStock2.balanceOf(account2);
    console.log("DecentraStock balance before: " + balDS);

    await dBank2.sellStock(balDS);

    let xDAIAfter = await provider.getBalance(account2);
    console.log("xDAI balance after: " + xDAIAfter);
    let ddBalAfter = await dDollar2.balanceOf(account2);
    console.log("DecentraDollar balance after: " + ddBalAfter);
    expect(xDAIAfter).to.be.above(xDAIbefore);
    expect(ddBalAfter).to.be.above(ddBalb4);
  });
});
