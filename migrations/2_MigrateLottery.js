var Migrations = artifacts.require("Migrations");

module.exports = function(deployer) {
  // Deploy the Migrations contract as our only task
  deployer.deploy(Migrations);
};

var lotteryContract = artifacts.require('Lottery');

module.exports = function(deployer) {
  // deploymentsteps
  deployer.deploy(lotteryContract);
};
