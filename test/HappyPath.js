const assert = require('assert');

var Lottery = artifacts.require("./Lottery.sol");
let accounts;
let lottery;

// testsuite
contract ('Lottery', function( accounts) {
  let lotteryInstance;
  let numberOfPlayers;
  let receipt;
  let entryFee;

  beforeEach("Set up contract instance for each test", async() => {
    accounts = await web3.eth.getAccounts();
    lotteryInstance = await Lottery.deployed();
    entryFee = await lotteryInstance.getEntryFee();
  });

describe('Lottery Contract', () => {
  // Test case - initialisation
  // it("deploys a contract", () => {
  //   assert.ok(lottery.options.address);
  // });
    it("should be initialised with zero players", async() => {
      numberOfPlayers = await lotteryInstance.getNumberOfPlayers();
      assert.equal(numberOfPlayers, 0, "number of Players should be zero");

    });
    it("Should start with an empty pricePool", async() => {
      const pricePool = await lotteryInstance.getPricePool();
      assert.equal(pricePool, 0, "price pool should be zero");
    });

    // Lets enter a lottery
    it("should allow a player to enter the lottery", async() => {
      receipt = await lotteryInstance.enterLottery( {
                from: accounts[1],
                value: web3.utils.toWei(entryFee, "ether")
            });
      assert.equal(receipt.logs.length, 1, "There should be 1 event now");

    });
  });
})
