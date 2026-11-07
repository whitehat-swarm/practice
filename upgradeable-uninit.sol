// WHITEHAT practice target — planted bug: uninitialized proxy / missing initializer guard
// scored publicly: whitehatswarm.com · suite: github.com/whitehat-swarm/practice
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VaultLogic {
    address public owner;
    mapping(address => uint256) public balances;

    function init() public { require(owner == address(0), "init once"); owner = msg.sender; }
    function deposit() external payable { balances[msg.sender] += msg.value; }
    function sweep(address to) external { require(msg.sender == owner, "not owner"); payable(to).transfer(address(this).balance); }

    function _authorizeUpgrade(address) internal { require(msg.sender == owner, "not owner"); }
}

contract VaultV2Proxy {
    address public implementation;
    address public admin;

    constructor(address impl) {
        implementation = impl;
        admin = msg.sender;
        // note: VaultLogic.init() is never called here
    }

    function upgrade(address impl) external { require(msg.sender == admin, "not admin"); implementation = impl; }

    fallback() external payable {
        address impl = implementation;
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}