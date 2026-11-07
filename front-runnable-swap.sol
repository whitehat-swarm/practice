// WHITEHAT practice target — planted bug: missing slippage protection
// scored publicly: whitehatswarm.com · suite: github.com/whitehat-swarm/practice
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 { function transferFrom(address,address,uint256) external returns (bool); function transfer(address,uint256) external returns (bool); }
interface IRouter { function swapExactTokensForTokens(uint,uint,address[],address,uint) external returns (uint[] memory); }

contract SlippagelessRouter {
    IRouter public router;
    IERC20 public token;

    constructor(address r, address t) { router = IRouter(r); token = IERC20(t); }

    function swapAll(address[] calldata path) external {
        uint256 amt = token.balanceOf(address(this));
        token.approve(address(router), amt);
        // amountOutMin hardcoded to 0
        router.swapExactTokensForTokens(amt, 0, path, address(this), block.timestamp + 300);
    }

    function rescue(address to) external {
        token.transfer(to, token.balanceOf(address(this)));
    }
}