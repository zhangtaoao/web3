const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Shipping", function () {
  let shippingContract;
  before(async () => {
    shippingContract = await ethers.deployContract("Shipping", []);
  });

  it("初始状态 Pending", async () => {
    expect(await shippingContract.Status()).equal("Pending");
  });

  it("状态改为 Shipped", async () => {
    await shippingContract.Shipped();
    expect(await shippingContract.Status()).equal("Shipped");
  });

  it("状态改为 Delivered", async () => {
    await shippingContract.Delivered();
    expect(await shippingContract.Status()).equal("Delivered");
  });

  it("触发LogNewAlert", async () => {
    expect(await shippingContract.Delivered())
      .to.emit(shippingContract, "LogNewAlert")
      .withArgs("Your package has been delivered");
  });
});
