// WHITEHAT practice target — planted bug: selfdestruct breaks contract.balance accounting
// scored publicly: whitehatswarm.com · suite: github.com/whitehat-swarm/practice
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SharedTips {
    uint256 public totalDeposited;
    mapping(address => uint256) public credit;

    function deposit() external payable {
        totalDeposited += msg.value;
        credit[msg.sender] += msg.value;
    }

    function withdrawShare() external {
        uint256 share = credit[msg.sender];
        uint256 payout = share * address(this).balance / totalDeposited;
        credit[msg.sender] = 0;
        payable(msg.sender).transfer(payout);
    }
}