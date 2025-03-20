// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import {Test, console} from "forge-std/Test.sol";
import {SafeAdd} from "../src/SafeAdd.sol";

contract SafeAddTest is Test {
    SafeAdd public safeAdd;

    function setUp() public {
        safeAdd = new SafeAdd();
    }

    function testAddNumbersFuzz(uint256 a, uint256 b) public {
        // If the sum would overflow, we expect a revert
        if (b > type(uint256).max - a) {
            vm.expectRevert();
            safeAdd.addNumbers(a, b);
        } else {
            uint256 result = safeAdd.addNumbers(a, b);
            assertEq(result, a + b);
        }
    }
}
