const assert = require('assert');

var Lottery = artifacts.require("./Lottery.sol");
let accounts;
let lottery;

// testsuite
contract ('Lottery', function( accounts) {
  let lotteryInstance;
  let numberOfPlayers;
  let players;
  let manager;
  let pricePool;
  let expectedPricePool = 0;
  let receipt;
  let entryFee;

  before("Get the basics in place", async() => {
    accounts = await web3.eth.getAccounts();
    //web3.eth.getAccounts().then(function(acc){accounts=acc;})
    lotteryInstance = await Lottery.deployed();
    entryFee = await lotteryInstance.getEntryFee();
    manager = await lotteryInstance.getManager();

  });

  describe('Lottery Contract Exceptions Path', () => {
    it("should not allow the winner to be picked yet", async() => {
      try {
        numberOfPlayers = await lotteryInstance.pickWinner({from: manager});
        assert(false);
      } catch (error) {
        assert(error);
      }
    });

    it("should not allow the manager to enter the lottery", async() => {
      try {
        receipt = await lotteryInstance.enterLottery( {
                 from: manager,
                 value: web3.utils.toWei(entryFee, 'ether')
               });
               assert(false);
      } catch (error) {
        assert(error);
      }

    });
  })

})
