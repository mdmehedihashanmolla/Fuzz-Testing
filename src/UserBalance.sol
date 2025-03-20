// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract UserBalance {
    mapping(address => uint256) private balances;

    function updateBalance(uint256 _amount) external {
        balances[msg.sender] = _amount;
    }

    function getBalance(address _user) external view returns (uint256) {
        return balances[_user];
    }
}
