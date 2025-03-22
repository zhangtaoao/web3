// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    - 所有人都可以存钱
        - ETH
    - 只有合约 owner 才可以取钱
    - 只要取钱，合约就销毁掉 selfdestruct
    - 扩展：支持主币以外的资产
        - ERC20
        - ERC721
*/

contract Bank {
    address public immutable owner;

    event Deposit(address _ads, uint256 amount);
    event Withdraw(uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier isOwner {
        require(msg.sender == owner, "not owner");// 验证是否是合约拥有者操作
        _;
    }

    // 存款
    receive() external payable {
        require(msg.value > 0, ">0");// 存款金额必须大于零
        // 声明payable 发送的以太会自动增加合约的余额，尽管没有显式地存储到某个状态变量中。合约的余额由 Ethereum 网络管理，可以随时查询。
        emit Deposit(msg.sender, msg.value);
    }

    // 提款函数，只有合约的拥有者可以调用
    function withdraw() external isOwner {
        // 获取合约中的所有以太
        // uint256 balance = this.getBalance();

        // // 将余额转移给合约拥有者
        // payable(owner).transfer(balance);
        emit Withdraw(address(this).balance);
        // 销毁合约 会自动将合约余额转到指定账户
        selfdestruct(payable(msg.sender)); // 为什么销毁了 还可以继续调用合约？？
    }

    // 获取合约余额的函数
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
