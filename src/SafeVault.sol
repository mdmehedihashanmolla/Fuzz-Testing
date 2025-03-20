// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract SafeVault {
    mapping(address => uint256) public balances;

    // Deposit Ether
    function deposit() external payable {
        require(msg.value > 0, "Must deposit more than 0");
        balances[msg.sender] += msg.value;
    }

    // Withdraw Ether
    function withdraw(uint256 amount) external {
        require(amount > 0, "Must withdraw more than 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }

    // Check contract balance (optional)
    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
