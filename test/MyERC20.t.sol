// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {MyERC20} from "../src/MyERC20.sol";

contract MyERC20Test is Test {
    MyERC20 token;
    address owner;
    address user1;
    address user2;

    function setUp() public {
        owner = address(this); // Test contract is the owner
        user1 = address(0x123); // Simulate user1
        user2 = address(0x456); // Simulate user2

        // Deploy the token with an initial supply of 1000 tokens
        token = new MyERC20(1000 ether);
    }

    // Fuzz test for transfer function
    function testTransferFuzz(uint256 amount) public {
        // Ensure amount is within the owner's balance
        vm.assume(amount > 0 && amount <= token.balanceOf(owner));

        // Simulate owner transferring tokens to user1
        vm.prank(owner);
        token.transfer(user1, amount);

        // Verify balances
        assertEq(token.balanceOf(owner), 1000 ether - amount);
        assertEq(token.balanceOf(user1), amount);
    }

    // Fuzz test for approve and transferFrom functions
    function testApproveAndTransferFromFuzz(uint256 amount) public {
        // Ensure amount is within the owner's balance
        vm.assume(amount > 0 && amount <= token.balanceOf(owner));

        // Owner approves user1 to spend tokens
        vm.prank(owner);
        token.approve(user1, amount);

        // Verify allowance
        assertEq(token.allowance(owner, user1), amount);

        // Simulate user1 transferring tokens from owner to user2
        vm.prank(user1);
        token.transferFrom(owner, user2, amount);

        // Verify balances and allowance
        assertEq(token.balanceOf(owner), 1000 ether - amount);
        assertEq(token.balanceOf(user2), amount);
        assertEq(token.allowance(owner, user1), 0); // Allowance should be reduced
    }

    // Test for insufficient balance in transfer
    function testTransferInsufficientBalance() public {
        // Attempt to transfer more than the owner's balance
        vm.prank(owner);
        vm.expectRevert("Not enough balance");
        token.transfer(user1, 1001 ether);
    }

    // Test for insufficient allowance in transferFrom
    function testTransferFromInsufficientAllowance() public {
        // Owner approves user1 to spend 500 tokens
        vm.prank(owner);
        token.approve(user1, 500 ether);

        // Attempt to transfer more than the allowance
        vm.prank(user1);
        vm.expectRevert("Allowance exceeded");
        token.transferFrom(owner, user2, 501 ether);
    }

    // Test for transferring 0 tokens
    function testTransferZero() public {
        uint256 balanceBefore = token.balanceOf(address(this));
        bool success = token.transfer(address(0x123), 0);
        assertTrue(success);
        assertEq(token.balanceOf(address(this)), balanceBefore); // no balance change
    }
}
