// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract SafeMulDiv {
    function mulDiv(uint256 a, uint256 b, uint256 c) external pure returns (uint256) {
        require(c != 0, "Division by zero");
        return (a * b) / c;
    }
}
