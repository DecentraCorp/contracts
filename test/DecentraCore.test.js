const { expect } = require("chai");
const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

describe("DecentraCore", function () {
  let dStock;
  let dDollar;
  let dScore;
  let dCore;

  let dStock1;
  let dDollar1;
  let dCore1;
  let dScore1;

  let dStock2;
  let dDollar2;
  let dCore2;
  let dScore2;

  let dStock3;
  let dDollar3;
  let dCore3;
  let dScore3;

  let dStock4;
  let dDollar4;
  let dCore4;
  let dScore4;

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

    dScore.setDC(dCore.address);
    console.log("Set up DScore");
    dDollar.transferOwnership(dCore.address);
    dStock.transferOwnership(dCore.address);
    dScore.transferOwnership(dCore.address);
    console.log("Ownership transfered to DecentraCore");
    console.log("DecentraBank initialized");
    dCore.setApprovedContract(dScore.address, 1);
    dCore.setApprovedContract(dScore.address, 2);
    dCore.setApprovedContract(dCore.address, 1);
    dCore.setApprovedContract(dCore.address, 2);
    dCore.transferOwnership(dCore.address);
    console.log("DecentraCore initialized");
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
  });

  it("Should allow a user to stake a membership", async function () {
    await dScore.stakeMembership(100);
    await expect(await dScore1.checkStaked(account1)).to.equal(true);
  });

  it("Should allows us to create a new proposal to proxy mint DecentraDollar to account2", async function () {
    console.log("encoding proposal data");

    let encodedProposalData = await web3.eth.abi.encodeFunctionCall(
      {
        name: "proxyMintDD",
        type: "function",
        inputs: [
          {
            type: "address",
            name: "to",
          },
          {
            type: "uint256",
            name: "_amount",
          },
        ],
      },
      [account2, 1000000]
    );

    await dCore1.newProposal(
      dScore.address,
      "proposalHash",
      encodedProposalData
    );

    let prop = await dCore1.getProposal(1);
    console.log(prop.proposalHash);
    expect(prop.proposalHash).to.equal("proposalHash");
  });
});
