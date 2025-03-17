// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ZtToken is ERC20 {
  constructor() ERC20("ZtToken", "ZT") {
    // Mint initial supply to deployer address
    _mint(msg.sender, 1000000 * 10 ** decimals());
  }
}