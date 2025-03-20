// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import {Test, console} from "forge-std/Test.sol";
import {SafeMulDiv} from "../src/SafeMulDiv.sol";

contract SafeMulDivTest is Test {
    SafeMulDiv safeMulDiv;

    function setUp() public {
        safeMulDiv = new SafeMulDiv();
    }

    // Fuzz test for mulDiv function
    function testMulDivFuzz(uint256 a, uint256 b, uint256 c) public view {
        // Ensure c is not zero to avoid division by zero
        vm.assume(c != 0);

        // Ensure a * b does not overflow (optional, depending on your use case)
        vm.assume(b == 0 || a <= type(uint256).max / b);

        // Call the mulDiv function
        uint256 result = safeMulDiv.mulDiv(a, b, c);

        // Calculate the expected result using Solidity's native math
        uint256 expected = (b == 0) ? 0 : (a * b) / c;

        // Assert that the result matches the expected value
        assertEq(result, expected);
    }

    // Test for division by zero
    function testMulDivByZero() public {
        // Expect the transaction to revert with the correct error message
        vm.expectRevert("Division by zero");
        safeMulDiv.mulDiv(10, 20, 0);
    }

    // Test for overflow in multiplication
    function testMulDivOverflow() public {
        // Use values that will cause an overflow in a * b
        uint256 a = type(uint256).max;
        uint256 b = 2;
        uint256 c = 1;

        // Expect the transaction to revert due to overflow
        vm.expectRevert();
        safeMulDiv.mulDiv(a, b, c);
    }

    // Test for multiplication by zero
    function testMulDivByZeroB() public view {
        // Call the mulDiv function with b = 0
        uint256 result = safeMulDiv.mulDiv(10, 0, 2);

        // Assert that the result is 0
        assertEq(result, 0);
    }
}
