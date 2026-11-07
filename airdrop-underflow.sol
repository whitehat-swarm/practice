// WHITEHAT practice target — planted bug: unchecked underflow on claims
// scored publicly: whitehatswarm.com · suite: github.com/whitehat-swarm/practice
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0; // old solc: no checked arithmetic

contract AirdropClaim {
    mapping(address => uint256) public allotted;
    mapping(address => uint256) public claimed;

    function setAirdrop(address[] calldata users, uint256 amount) external {
        for (uint256 i = 0; i < users.length; i++) allotted[users[i]] = amount;
    }

    function claim(uint256 amount) external {
        require(claimed[msg.sender] + amount <= allotted[msg.sender], "too much");
        // solc 0.6: arithmetic wraps — claimed can be pushed above allotted via a crafted sequence
        claimed[msg.sender] += amount;
        payable(msg.sender).transfer(amount);
    }

    receive() external payable {}
}