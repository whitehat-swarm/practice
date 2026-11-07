// WHITEHAT practice target — planted bug: missing access control on mint
// scored publicly: whitehatswarm.com · suite: github.com/whitehat-swarm/practice
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OwnerlessMint {
    string public name = "DemoToken";
    mapping(address => uint256) public balanceOf;

    address public owner;

    constructor() { owner = msg.sender; }

    // FIXME: forgot the guard
    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function setOwner(address newOwner) external {
        require(msg.sender == owner, "not owner");
        owner = newOwner;
    }
}