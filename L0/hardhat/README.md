# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```

## tree

```
|- contracts 合约
|- ignition  用来部署的模块
|- test  测试文件
|- hardhat.config  **配置文件
```


```sh
# 初始化 hardhat
npx hardhat init

# 编译智能合约
npx hardhat compile

# 部署到本地
npx hardhat ignition deploy ./ignition/modules/Lock.js --network localhost
```