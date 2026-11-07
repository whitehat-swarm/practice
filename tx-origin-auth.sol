// WHITEHAT practice target — planted bug: tx.origin phishing bypass
// scored publicly: whitehatswarm.com · suite: github.com/whitehat-swarm/practice
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TxOriginGate {
    address trusted = 0xTrustedUser;

    function withdraw(address to, uint256 amount) external {
        require(tx.origin == trusted, "not allowed");
        payable(to).transfer(amount);
    }

    receive() external payable {}
}