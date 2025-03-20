// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {SafeVault} from "../src/SafeVault.sol";

contract SafeVaultTest is Test {
    SafeVault safeVault;
    address user;

    function setUp() public {
        safeVault = new SafeVault();
        user = address(0x123); // Simulate a user address
    }

    // Fuzz test for deposit and withdraw functions
    function testDepositAndWithdrawFuzz(
        uint256 depositAmount,
        uint256 withdrawAmount
    ) public {
        // Ensure depositAmount is greater than 0 and within reasonable bounds
        vm.assume(depositAmount > 0 && depositAmount <= 1 ether);

        // Simulate the user depositing Ether
        vm.deal(user, depositAmount); // Give the user some Ether
        vm.prank(user); // Simulate the user calling the function
        safeVault.deposit{value: depositAmount}();

        // Check that the user's balance is updated correctly
        assertEq(safeVault.balances(user), depositAmount);

        // Ensure withdrawAmount is greater than 0 and less than or equal to the user's balance
        vm.assume(withdrawAmount > 0 && withdrawAmount <= depositAmount);

        // Simulate the user withdrawing Ether
        vm.prank(user); // Simulate the user calling the function
        safeVault.withdraw(withdrawAmount);

        // Check that the user's balance is updated correctly
        assertEq(safeVault.balances(user), depositAmount - withdrawAmount);

        // Check that the user received the Ether
        assertEq(user.balance, withdrawAmount);
    }

    // Test for withdrawing more than the user's balance
    function testWithdrawInsufficientBalance() public {
        // Simulate the user depositing 1 Ether
        vm.deal(user, 1 ether);
        vm.prank(user);
        safeVault.deposit{value: 1 ether}();

        // Attempt to withdraw more than the user's balance
        vm.prank(user);
        vm.expectRevert("Insufficient balance");
        safeVault.withdraw(2 ether);
    }

    // Test for withdrawing 0 Ether
    function testWithdrawZero() public {
        // Simulate the user depositing 1 Ether
        vm.deal(user, 1 ether);
        vm.prank(user);
        safeVault.deposit{value: 1 ether}();

        // Attempt to withdraw 0 Ether
        vm.prank(user);
        vm.expectRevert("Must withdraw more than 0");
        safeVault.withdraw(0);
    }

    // Test for depositing 0 Ether
    function testDepositZero() public {
        // Attempt to deposit 0 Ether
        vm.prank(user);
        vm.expectRevert("Must deposit more than 0");
        safeVault.deposit{value: 0}();
    }
}
