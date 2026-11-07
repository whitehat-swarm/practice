// WHITEHAT practice target — planted bug: clean control
// scored publicly: whitehatswarm.com · suite: github.com/whitehat-swarm/practice
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleEscrow {
    address public immutable buyer;
    address public immutable seller;
    address public immutable arbiter;
    enum State { AWAITING, RELEASED, REFUNDED }
    State public state;
    uint256 public amount;

    error WrongState();
    error NotAuthorized();

    constructor(address _seller, address _arbiter) payable {
        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;
        amount = msg.value;
        state = State.AWAITING;
    }

    function release() external {
        if (msg.sender != buyer && msg.sender != arbiter) revert NotAuthorized();
        if (state != State.AWAITING) revert WrongState();
        state = State.RELEASED;
        (bool ok, ) = seller.call{value: amount}("");
        require(ok);
    }

    function refund() external {
        if (msg.sender != arbiter) revert NotAuthorized();
        if (state != State.AWAITING) revert WrongState();
        state = State.REFUNDED;
        (bool ok, ) = buyer.call{value: amount}("");
        require(ok);
    }
}