// WHITEHAT practice target — planted bug: on-chain randomness predictable
// scored publicly: whitehatswarm.com · suite: github.com/whitehat-swarm/practice
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lootbox {
    mapping(address => uint256) public wins;

    function open() external {
        uint256 roll = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % 100;
        if (roll < 20) {
            wins[msg.sender] += 1;
        }
    }
}