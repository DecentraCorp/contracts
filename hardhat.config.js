require("@nomiclabs/hardhat-waffle");

const infuraKey = "229827e347a949a68726a4a934c90f6a";

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const account1 =
  "fbd764b80dff508f898a76a8e3f56c00debaff777757bd751c367fad47976497";
const account2 =
  "132fe52e445127d8ff84148a5f0b1368aa190ba335f3f9c598079863c4f239f8";
const account3 =
  "950e443050f15f7616e6c2111ac82aac2e3eb6eaedf64afa722dcac21fbd3052";

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.6",
  settings: {
    optimizer: {
      enabled: true,
      runs: 100,
    },
  },
  networks: {
    // hardhat: { blockGasLimit: 200000000, chainId: 1337 },

    kovan: {
      url: `https://kovan.infura.io/v3/${infuraKey}`,
      accounts: [account1, account2, account3],
    },
  },
};
