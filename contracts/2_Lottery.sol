// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Lottery {

  address payable public  manager;   // manager is the creator of this contract
  address payable[] players;
  //boolean lotteryIsOpen;
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

  constructor ()  {
    manager = payable(msg.sender);
    playerCounter = 0;
    pricePool = 0;
    entryFee = 1;
    //lotteryIsOpen = true;
  }

  function enterLottery () public payable {
    // the lottery should be open
    //require(lotteryIsOpen);

    // the manager can not enter himself
    address payable _sender = payable(msg.sender);
    require(_sender != manager);

    // The value must be equal to the entryFee
    require(msg.value >= entryFee);

    // increase the pricepool
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
