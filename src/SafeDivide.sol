// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract SafeDivide {
    function divideNumbers(
        uint256 a,
        uint256 b
    ) external pure returns (uint256) {
        require(b != 0, "Division by zero");
        return a / b;
    }
}
