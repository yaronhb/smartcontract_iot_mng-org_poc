const MyLightsController = artifacts.require("MyLightsController");

module.exports = function (deployer, network, accounts) {
    light_ids = ['0x0001', '0x0002', '0x0003', '0x0004']
    duration_secs = 15
    deployer.deploy(MyLightsController, light_ids, duration_secs, {from: accounts[0]})
}