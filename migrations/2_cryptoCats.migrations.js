const KittyContract = artifacts.require("KittyContract");

/*
module.exports = function (deployer) {
  await deployer.deploy(KittyContract, "CryptoKitties", "CKT");
  const instance = await KittyContract.deployed();
};
*/

module.exports = function (deployer) {
  deployer.deploy(KittyContract, "CryptoKitties", "CKT");
};
