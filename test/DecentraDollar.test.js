const { expect } = require("chai");

describe("DecentraDollar", function () {
  it("Should mint DecentraDollar to account two", async function () {
    const signers = await ethers.getSigners();
    const account1 = signers[0].address;
    const account2 = signers[1].address;

    const DecentraDollar = await hre.ethers.getContractFactory(
      "DecentraDollar"
    );
    const dDollar = await DecentraDollar.deploy();
    await dDollar.deployed();

    await dDollar.mintDD(account2, 20);
    let bal = await dDollar.balanceOf(account2);
    expect(bal).to.equal(20);
  });

  it("Should burn DecentraDollar from account two", async function () {
    const signers = await ethers.getSigners();
    const account1 = signers[0].address;
    const account2 = signers[1].address;

    const DecentraDollar = await hre.ethers.getContractFactory(
      "DecentraDollar"
    );
    const dDollar = await DecentraDollar.deploy();
    await dDollar.deployed();

    await dDollar.mintDD(account2, 20);
    let bal = await dDollar.balanceOf(account2);
    expect(bal).to.equal(20);
    await dDollar.burnDD(account2, 20);
    bal = await dDollar.balanceOf(account2);
    expect(bal).to.equal(0);
  });
});
