// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import {Test, console} from "forge-std/Test.sol";
import {SafeDivide} from "../src/SafeDivide.sol";

contract SafeDivideTest is Test {
    SafeDivide safeDivide;

    function setUp() public {
        safeDivide = new SafeDivide();
    }

    // Fuzz test for divideNumbers function
    function testDivideNumbersFuzz(uint256 a, uint256 b) public view {
        // Ensure b is not zero to avoid division by zero
        vm.assume(b != 0);

        // Call the divideNumbers function
        uint256 result = safeDivide.divideNumbers(a, b);

        // Assert that the result is correct
        assertEq(result, a / b);
    }

    // Test for division by zero
    function testDivideByZero() public {
        // Expect the transaction to revert with the correct error message
        vm.expectRevert("Division by zero");
        safeDivide.divideNumbers(10, 0);
    }
}
