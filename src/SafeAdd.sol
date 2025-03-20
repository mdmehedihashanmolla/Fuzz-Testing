// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract SafeAdd {
    function addNumbers(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b; // Automatic overflow checks in Solidity ^0.8.0
    }
}
