pragma solidity ^0.8.4;

contract Lottery {

  address public manager;   // manager is the creator of this contract
  address[] players;
  uint playerCounter;
  uint pricePool;

  event logPlayerEnters (
    uint indexed _id,
    address indexed _player
  );

  event logPickWinner (
    uint indexed _id,
    address indexed _player
  );

  constructor ()  {
    manager = msg.sender;
    playerCounter = 0;
    pricePool = 0;
  }

  function enterLottery () public payable {
    // the manager can not enter himself
    require(msg.sender != manager);

    playerCounter++;
    players.push(msg.sender);

    emit logPlayerEnters(playerCounter, msg.sender);
  }

  function pickWinner () public {
    // should be at leats 2 players
    uint _id;
    require(playerCounter > 1);

    _id = 1;
    emit logPickWinner(_id, players[_id]);
  }

  function getNumberOfPlayers () public view returns (uint) {
    return playerCounter;
  }

  function getPlayer (uint _id) public view returns (address) {
    return players[_id];
  }


}
