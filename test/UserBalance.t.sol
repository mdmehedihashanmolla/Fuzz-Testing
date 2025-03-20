// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {UserBalance} from "../src/UserBalance.sol";

contract UserBalanceTest is Test {
    UserBalance userBalance;
    address user;

    function setUp() public {
        userBalance = new UserBalance();
        user = address(0x123); // Simulate a user address
    }

    // Fuzz test for updateBalance and getBalance functions
    function testUpdateAndGetBalanceFuzz(uint256 amount) public {
        // Simulate the user calling updateBalance
        vm.prank(user);
        userBalance.updateBalance(amount);

        // Verify that the balance was updated correctly
        uint256 retrievedBalance = userBalance.getBalance(user);
        assertEq(retrievedBalance, amount);
    }

    // Test for updating balance multiple times
    function testMultipleUpdatesFuzz(uint256 amount1, uint256 amount2) public {
        // First update
        vm.prank(user);
        userBalance.updateBalance(amount1);

        // Verify the first update
        uint256 retrievedBalance1 = userBalance.getBalance(user);
        assertEq(retrievedBalance1, amount1);

        // Second update
        vm.prank(user);
        userBalance.updateBalance(amount2);

        // Verify the second update
        uint256 retrievedBalance2 = userBalance.getBalance(user);
        assertEq(retrievedBalance2, amount2);
    }

    // Test for updating balance from different addresses
    function testMultipleUsersFuzz(uint256 amount1, uint256 amount2) public {
        address user2 = address(0x456); // Simulate a second user address

        // Update balance for user1
        vm.prank(user);
        userBalance.updateBalance(amount1);

        // Update balance for user2
        vm.prank(user2);
        userBalance.updateBalance(amount2);

        // Verify balances for both users
        uint256 retrievedBalance1 = userBalance.getBalance(user);
        uint256 retrievedBalance2 = userBalance.getBalance(user2);

        assertEq(retrievedBalance1, amount1);
        assertEq(retrievedBalance2, amount2);
    }
}
