// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Lottery {

  address payable public  manager;   // manager is the creator of this contract
  address payable[] players;
  bool lotteryIsOpen;
  uint playerCounter;
  uint pricePool;
  uint entryFee; // the number of ETH to pay in order to play

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

  constructor ()  {
    manager = payable(msg.sender);
    playerCounter = 0;
    pricePool = 0;
    entryFee = 1;
    lotteryIsOpen = true;
  }

  function restartLottery(uint _entryFee) public {
    require(lotteryIsOpen = false);

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

  // function pickWinner () public {
  //   // should be at leats 2 players
  //   uint _id;
  //   require(playerCounter > 1);
  //
  //   _id = 1;
  //   emit logPickWinner(_id, players[_id]);
  // }

  function getNumberOfPlayers () public view returns (uint) {
    return playerCounter;
  }

  function getPlayers () public view returns ( address payable[] memory) {
    return players;
  }

  function getPlayer (uint _id) public view returns (address payable) {
    return players[_id];
  }

  function getPricePool () public view returns (uint) {
    return pricePool;
  }

  function getEntryFee () public view returns (uint) {
    return entryFee;
  }
}
