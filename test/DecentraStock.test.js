const { expect } = require("chai");

describe("DecentraStock", function () {
  it("Should mint DecentraStock to account two", async function () {
    const signers = await ethers.getSigners();
    const account1 = signers[0].address;
    const account2 = signers[1].address;

    const DecentraStock = await hre.ethers.getContractFactory("DecentraStock");
    const dStock = await DecentraStock.deploy();
    await dStock.deployed();

    await dStock.issueStock(account2, 20);
    let bal = await dStock.balanceOf(account2);
    expect(bal).to.equal(20);
  });

  it("Should burn DecentraStock from account two", async function () {
    const signers = await ethers.getSigners();
    const account1 = signers[0].address;
    const account2 = signers[1].address;

    const DecentraStock = await hre.ethers.getContractFactory("DecentraStock");
    const dStock = await DecentraStock.deploy();
    await dStock.deployed();

    await dStock.issueStock(account2, 20);
    let bal = await dStock.balanceOf(account2);
    expect(bal).to.equal(20);
    await dStock.burnStock(account2, 20);
    bal = await dStock.balanceOf(account2);
    expect(bal).to.equal(0);
  });
});
