const assert = require('assert');

var Lottery = artifacts.require("./Lottery.sol");
let accounts;
let lottery;

// testsuite
contract ('Lottery', function( accounts) {
  let lotteryInstance;
  let numberOfPlayers;
  let players;
  let pricePool;
  let expectedPricePool = 0;
  //let receipt;
  let entryFee;

  before("Get the accounts once only", async() => {
    accounts = await web3.eth.getAccounts();
    //web3.eth.getAccounts().then(function(acc){accounts=acc;})
    lotteryInstance = await Lottery.deployed();
    entryFee = await lotteryInstance.getEntryFee();

  });
  // beforeEach("Set up contract instance for each test", async() => {
  //
  //   lotteryInstance = await Lottery.deployed();
  //   entryFee = await lotteryInstance.getEntryFee();
  // });

describe('Lottery Contract Happy Path', () => {
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
      try {
       let receipt;
       receipt = await lotteryInstance.enterLottery( {
                from: accounts[1],
                value: web3.utils.toWei(entryFee, 'ether')
            });
          }
          catch (error) {
            console.log(error);
          }

      // set the variables used for testing
      numberOfPlayers = await lotteryInstance.getNumberOfPlayers();
      players = await lotteryInstance.getPlayers();
      expectedPricePool = entryFee;
      pricePool = await lotteryInstance.getPricePool();
      pricePool = web3.utils.fromWei(pricePool, 'ether');

      assert.equal(players[0], accounts[1], "The first player should be " + accounts[1]);
      assert.equal( players.length, 1, "There should be 1 player");
      assert(numberOfPlayers == 1, "There should be 1 player");
      assert.equal(expectedPricePool, pricePool, "There should be a pricepool of " + expectedPricePool);

    });

    it("should allow a second player to enter the lottery", async() => {
      try {
       let receipt;
       receipt = await lotteryInstance.enterLottery( {
                from: accounts[4],
                value: web3.utils.toWei(entryFee, 'ether')
            });
          }
          catch (error) {
            console.log(error);
          }

      // Obtain the various states to be tested
      numberOfPlayers = await lotteryInstance.getNumberOfPlayers();
      players = await lotteryInstance.getPlayers();
      pricePool = await lotteryInstance.getPricePool();
      pricePool = web3.utils.fromWei(pricePool, 'ether');
      expectedPricePool = entryFee * 2;

      assert.equal(numberOfPlayers, 2, "There should be 2 players");

      assert.equal(players[1], accounts[4], "The second player should be " + accounts[4]);

      assert.equal(pricePool, expectedPricePool, "There should be a pricepool of " + expectedPricePool + " but found " + pricePool);

    });

    it("should allow to pick a winner", async() => {
      try {
       let receipt;
       receipt = await lotteryInstance.pickWinner( {
                from: accounts[0],
                value: web3.utils.toWei(entryFee, 'ether')
            });
          }
          catch (error) {
            console.log(error);
          }

          numberOfPlayers = await lotteryInstance.getNumberOfPlayers();
          players = await lotteryInstance.getPlayers();
          pricePool = await lotteryInstance.getPricePool();
          pricePool = web3.utils.fromWei(pricePool, 'ether');

          assert.equal(numberOfPlayers, 0, "There should be 0 players");

          assert.equal(pricePool, 0, "The pricepool should be 0");
    });

    it("Should allow to restart the lottery", async() => {
      try{
        entryFee = 2; // entryFee of 2 Ether
        let receipt
        receipt = await lotteryInstance.restartLottery(entryFee, {
          from: accounts[0]
        });
      }
      catch (error) {
        console.log(error);
      }

      numberOfPlayers = await lotteryInstance.getNumberOfPlayers();
      players = await lotteryInstance.getPlayers();
      pricePool = await lotteryInstance.getPricePool();
      pricePool = web3.utils.fromWei(pricePool, 'ether');
      let _entryFee = await lotteryInstance.getEntryFee();

      assert.equal(numberOfPlayers, 0, "There should be 0 players");

      assert.equal(pricePool, 0, "The pricepool should be 0");

      assert.equal(entryFee, _entryFee, "the entryFee should be " + entryFee);
    });
  });
})
