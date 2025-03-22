// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    众筹合约是一个募集资金的合约，在区块链上，我们是募集以太币，类似互联网业务的水滴筹。区块链早起的 ICO 就是类似业务。
    ### 1.需求分析
    众筹合约分为两种角色：一个是受益人，一个是资助者。
    ```
    // 两种角色:
    //      受益人   beneficiary => address         => address 类型
    //      资助者   funders     => address:amount  => mapping 类型 或者 struct 类型
    ```
    ```
    状态变量按照众筹的业务：
    // 状态变量
    //      筹资目标数量    fundingGoal
    //      当前募集数量    fundingAmount
    //      资助者列表      funders
    //      资助者人数      fundersKey
    ```
    ```
    需要部署时候传入的数据:
    //      受益人
    //      筹资目标数量
    ```
*/
contract CrowdFunding {
    address public immutable beneficiary;
    uint256 public immutable fundingGoal;
    uint256 public fundingAmount;

    mapping(address => uint256) funders;

    mapping(address => bool) private fundersInserted;

    address[] public fundersKey;

    bool public AVAILABLED = true;

    constructor(address _beneficiary, uint256 _fundingGoal) {
        beneficiary = _beneficiary;
        fundingGoal = _fundingGoal;
    }

    // 资助
    function contribute() external payable {
        require(msg.value > 0);
        // require(fundingAmount + monunt <= fundingGoal);
        require(AVAILABLED, "CrowdFunding is closed");
        uint256 potentialFundingAmount = fundingAmount + msg.value;
        uint256 refundAmount = 0;
        if (potentialFundingAmount > fundingGoal) {
            refundAmount = potentialFundingAmount - fundingGoal;
            funders[msg.sender] += (msg.value - refundAmount);
            fundingAmount += (msg.value - refundAmount);
        } else {
            funders[msg.sender] += msg.value;
            fundingAmount += msg.value;
        }

        if (!fundersInserted[msg.sender]) {
            fundersInserted[msg.sender] = true;
            fundersKey.push(msg.sender);
        }

        // 退还多余的
        if (refundAmount > 0) {
            payable(msg.sender).transfer(refundAmount);
        }
        
        if (fundingGoal == fundingAmount) {
            this.close();
        }
    }

    // 关闭众筹
    function close() external returns (bool) {
        if (fundingAmount < fundingGoal) {
            return false;
        }
        uint256 amount = fundingAmount;
        fundingAmount = 0;
        AVAILABLED = false;
        payable(beneficiary).transfer(amount);
        return true;
    }

    // 资助者人数
    function fundersLenght() public view returns (uint256) {
        return fundersKey.length;
    }
}
