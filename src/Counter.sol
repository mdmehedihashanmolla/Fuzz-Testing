// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Counter {
    uint256 private count;

    // Get the current count
    function getCount() external view returns (uint256) {
        return count;
    }

    // Increment the counter
    function increment() external {
        count += 1;
    }

    // Decrement the counter, ensuring it never goes negative
    function decrement() external {
        require(count > 0, "Counter: Cannot decrement below zero");
        count -= 1;
    }
}
