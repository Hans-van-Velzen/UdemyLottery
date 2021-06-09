// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Lottery {

  address payable public  manager;   // manager is the creator of this contract
  address payable[] players;
  bool lotteryIsOpen;
  uint playerCounter;
  uint pricePool;
  uint entryFee; // the number of ETH to pay in order to play
  uint minimumNumberOfPlayers;

  event logPlayerEnters (
    uint indexed _id,
    address indexed _player
  );

  event logPickWinner (
    uint indexed _id,
    address indexed _player
  );

  event logLotteryOpen (
    uint entryFee
  );

  event logTrace (
    string message
  );

  constructor ()  {
    manager = payable(msg.sender);
    playerCounter = 0;
    pricePool = 0;
    entryFee = 1;
    lotteryIsOpen = true;
  }

  function restartLottery(uint _entryFee) public {
    require(lotteryIsOpen == false);

    // add a minimum number of players
    // only the manager can restart the lottery
    require(payable(msg.sender) == manager);

    // entryFee should be 0.5 at least
    require(_entryFee >= 1);

    playerCounter = 0;
    pricePool = 0;
    entryFee = _entryFee;
    lotteryIsOpen = true;

    emit logLotteryOpen(_entryFee);
  }

  function enterLottery () public payable {
    // the lottery should be open
    require(lotteryIsOpen);

    // the manager can not enter himself
    address payable _sender = payable(msg.sender);
    require(_sender != manager);

    // The value must be equal to the entryFee
    require(msg.value >= entryFee);

    // increase the pricepool, playercounter and add the player to the array
    pricePool = pricePool + msg.value;
    playerCounter++;
    players.push(payable(msg.sender));

    emit logPlayerEnters(playerCounter, msg.sender);
  }

  function random() private view returns(uint) {
      // take the current block difficulty
      // and the time
      // and the addresses of the players
      // hash them and convert to uint
      return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
  }

  function pickWinner () public payable {
    // should be at leats 2 players
    uint _id;
    require(playerCounter > 1);

    // close the lottery
    lotteryIsOpen = false;

    _id = random() % players.length;
    emit logPickWinner(_id, players[_id]);

    // send the payment
    players[_id].transfer(address(this).balance);
    pricePool = 0;
    playerCounter = 0;
    delete players;
  }

  function getNumberOfPlayers () public view returns (uint) {
    return playerCounter;
  }

  function getPlayers () public view returns ( address payable[] memory) {
    return players;
  }

  function getPlayer (uint _id) public view returns (address payable) {
    return players[_id];
  }

  function getManager () public view returns (address payable) {
    return manager;
  }

  function getPricePool () public view returns (uint) {
    return pricePool;
  }

  function getEntryFee () public view returns (uint) {
    return entryFee;
  }
}
