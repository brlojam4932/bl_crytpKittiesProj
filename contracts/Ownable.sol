// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Ownable {

  address owner;

  modifier onlyOwner() {
    require(owner == msg.sender);
    _;

  }

}

