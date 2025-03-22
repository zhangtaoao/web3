// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    这一个实战主要是加深大家对 3 个取钱方法的使用。
    - 任何人都可以发送金额到合约
    - 只有 owner 可以取款
    - 3 种取钱方式
*/
contract EtherWallet {
    address payable public immutable owner;
    event Log(string funName, address from, uint256 value, bytes data);

    constructor() {
        owner = payable(msg.sender);
    }
    // 存钱
    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    /*
        将指定数量的以太币（Ether）转账到一个可支付的地址。
        自动处理 gas 限制，默认 gas 限制为 2300。
        如果转账失败，会抛出异常
    */
    function withdraw1() external {
        require(msg.sender == owner, "Not owner");
        // owner.transfer 相比 msg.sender 更消耗Gas
        // owner.transfer(address(this).balance);
        payable(msg.sender).transfer(100);
    }

    /*
        类似于 transfer，但返回一个布尔值表示转账是否成功。
        也有 2300 gas 限制。
        不会抛出异常，而是返回 false，需要手动处理失败情况。
    */
    function withdraw2() external {
        require(msg.sender == owner, "Not owner");
        bool success = payable(msg.sender).send(200);
        require(success, "Send Failed");
    }

    /*
        是一种更灵活的转账方式，可以指定发送的以太币数量和附加数据。
        没有 gas 限制，可以根据需要设置。
        返回一个布尔值，表示转账是否成功。
        需要手动处理失败情况。
    */
    function withdraw3() external {
        require(msg.sender == owner, "Not owner");
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Call Failed");
    }
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}