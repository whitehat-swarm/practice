// WHITEHAT practice target — planted bug: spot-price oracle manipulation
// scored publicly: whitehatswarm.com · suite: github.com/whitehat-swarm/practice
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPair {
    function getReserves() external view returns (uint112, uint112, uint32);
}

contract OracleSwap {
    IPair public pair;
    uint256 public lastPrice;

    constructor(address p) { pair = IPair(p); }

    function updatePrice() external {
        (uint112 r0, uint112 r1, ) = pair.getReserves();
        lastPrice = r1 / r0; // price derived from instantaneous pool reserves
    }

    function buyIfCheap(uint256 threshold) external view returns (bool) {
        return lastPrice < threshold;
    }
}