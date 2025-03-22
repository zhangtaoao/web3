// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    多签钱包的功能: 合约有多个 owner，一笔交易发出后，需要多个 owner 确认，确认数达到最低要求数之后，才可以真正的执行。
    ### 1.原理
    - 部署时候传入地址参数和需要的签名数
        - 多个 owner 地址
        - 发起交易的最低签名数
    - 有接受 ETH 主币的方法，
    - 除了存款外，其他所有方法都需要 owner 地址才可以触发
    - 发送前需要检测是否获得了足够的签名数
    - 使用发出的交易数量值作为签名的凭据 ID（类似上么）
    - 每次修改状态变量都需要抛出事件
    - 允许批准的交易，在没有真正执行前取消。
    - 足够数量的 approve 后，才允许真正执行。
*/

contract MultiSigWallet {
    // 存储所有拥有者的地址
    address[] public owners;
    // 记录某个地址是否为拥有者的映射
    mapping(address => bool) public isOwner;
    // 需要的最低签名数
    uint256 immutable required;
    // 交易的结构，包括接收地址、金额、数据和执行状态。
    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool exected;
    }
    // 记录所有提交的交易
    Transaction[] public transactions;
    // 记录每笔交易的批准状态
    mapping(uint256 => mapping(address => bool)) public approved;
    // 当合约接收到以太币时触发
    event Deposit(address indexed sender, uint256 amount);
    // 当提交新交易时触发
    event Submit(uint256 indexed txId);
    // 当某个拥有者批准交易时触发
    event Approve(address indexed owner, uint256 indexed txId);
    // 当某个拥有者撤销交易批准时触发
    event Revoke(address indexed owner, uint256 indexed txId);
    // 当交易被执行时触发
    event Execute(uint256 indexed txId);
    // 确保调用者是合约的拥有者
    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }
    // 确保交易存在
    modifier txExists(uint256 _txId) {
        require(_txId < transactions.length, "tx doesn't exist");
        _;
    }
    // 确保交易未被当前调用者批准
    modifier notApproved(uint256 _txId) {
        require(!approved[_txId][msg.sender], "tx already approved");
        _;
    }
    // 确保交易未被执行
    modifier notExecuted(uint256 _txId) {
        require(!transactions[_txId].exected, "tx is exected");
        _;
    }
    /*
        在合约部署时，传入多个拥有者的地址和所需的最低签名数。
        验证输入的有效性，确保没有重复的拥有者并且地址有效。
    */
    constructor(address[] memory _owners, uint256 _required) {
        // 必须有 owner
        require(_owners.length > 0, "owner required");
        // 签名数必须大于0 且 不可超出 _owners数量
        require(
            _required > 0 && _required <= _owners.length,
            "invalid required number of owners"
        );
        for (uint256 index = 0; index < _owners.length; index++) {
            address owner = _owners[index];
            require(owner != address(0), "invalid owner");// 不能是无效或未初始化的地址
            require(!isOwner[owner], "owner is not unique"); // 如果重复会抛出错误
            isOwner[owner] = true;
            owners.push(owner);
        }
        required = _required;
    }

    // 接收以太币
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
    // 获取合约余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    // 提交交易
    function submit(
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external onlyOwner returns(uint256){
        transactions.push(
            Transaction({to: _to, value: _value, data: _data, exected: false})
        );
        emit Submit(transactions.length - 1);
        return transactions.length - 1;
    }
    // 批准交易
    function approv(uint256 _txId)
        external
        onlyOwner
        txExists(_txId)
        notApproved(_txId)
        notExecuted(_txId)
    {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }
    // 执行交易
    function execute(uint256 _txId)
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {
        // 必须达到最低签名数
        require(getApprovalCount(_txId) >= required, "approvals < required");
        // 获取交易信息
        Transaction storage transaction = transactions[_txId];
        // 修改执行状态
        transaction.exected = true;
        // 交易
        (bool sucess, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(sucess, "tx failed");
        emit Execute(_txId);
    }
    // 获取批准数
    function getApprovalCount(uint256 _txId)
        public
        view
        returns (uint256 count)
    {
        for (uint256 index = 0; index < owners.length; index++) {
            if (approved[_txId][owners[index]]) {
                count += 1;
            }
        }
    }
    // 撤销批准
    function revoke(uint256 _txId)
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {   
        // 必须是批转状态
        require(approved[_txId][msg.sender], "tx not approved");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }
}