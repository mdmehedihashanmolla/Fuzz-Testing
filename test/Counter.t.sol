// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter counter;

    function setUp() public {
        counter = new Counter();
    }

    // Fuzz test for increment and decrement functions
    function testIncrementDecrementFuzz(
        uint256 numIncrements,
        uint256 numDecrements
    ) public {
        // Constrain numIncrements and numDecrements to reasonable limits
        vm.assume(numIncrements <= 1000); // Limit numIncrements to 1000
        vm.assume(numDecrements <= numIncrements); // Ensure numDecrements does not exceed numIncrements

        // Perform increments
        for (uint256 i = 0; i < numIncrements; i++) {
            counter.increment();
        }

        // Perform decrements
        for (uint256 i = 0; i < numDecrements; i++) {
            counter.decrement();
        }

        // Verify the final count
        uint256 finalCount = counter.getCount();
        assertEq(finalCount, numIncrements - numDecrements);
    }

    // Test for decrementing below zero
    function testDecrementBelowZero() public {
        // Attempt to decrement when the count is zero
        vm.expectRevert("Counter: Cannot decrement below zero");
        counter.decrement();
    }

    // Test for multiple increments and decrements
    function testMultipleIncrementsDecrements() public {
        // Increment 5 times
        for (uint256 i = 0; i < 5; i++) {
            counter.increment();
        }

        // Decrement 3 times
        for (uint256 i = 0; i < 3; i++) {
            counter.decrement();
        }

        // Verify the final count
        uint256 finalCount = counter.getCount();
        assertEq(finalCount, 2);
    }
}
