const EmployeeManagment = artifacts.require("EmployeeManagment")
const EmpolyeeFactory = artifacts.require("EmpolyeeFactory")
const NetEndPoint = artifacts.require("NetEndPoint")
const DoorEndPoint = artifacts.require("DoorEndPoint")

const fs = require('fs')
const randomID = require('../scripts/random-id')
const makesecret = require('../scripts/make_secret')

module.exports = async function (deployer, network, accounts) {
    let result = {}

    let manager_address = accounts[0]
    await deployer.deploy(EmployeeManagment, manager_address, { from: accounts[0] })
    let manager = await EmployeeManagment.deployed()

    result['manager'] = {
        'address': manager_address,
        'contract': manager.address
    }

    await deployer.deploy(EmpolyeeFactory, manager.address)
    let factory = await EmpolyeeFactory.deployed()
    await manager.set_factory(factory.address)
    result['factory'] = {
        'contract': factory.address
    }

    let net_endpoint_id = randomID()
    let validity_length = 60
    await deployer.deploy(NetEndPoint, net_endpoint_id, manager.address, validity_length)
    let endpoint = await NetEndPoint.deployed()
    result['net-endpoint'] = {
        'endpoint-id': net_endpoint_id,
        'validity-length': 60,
        'contract': endpoint.address
    }


    let door_endpoint_id = randomID()
    let [pubk, prvk] = makesecret.createKeyPair()
    //let validity_length = 60
    await deployer.deploy(DoorEndPoint, door_endpoint_id, manager.address, validity_length, pubk)
    let door_endpoint = await DoorEndPoint.deployed()
    result['door-endpoint'] = {
        'endpoint-id': door_endpoint_id,
        'validity-length': 60,
        'contract': door_endpoint.address,
        'public-key': pubk,
        'private-key': prvk
    }
    let door_key_pair = JSON.stringify(result['door-endpoint'], null, 4)
    //console.log(result_pretty)
    fs.writeFileSync(`keypair_${door_endpoint_id}.json`, door_key_pair,
        function (err, result) {
            if (err) console.log('error', err);
        })



    let e_id = randomID()
    let e_addr = accounts[1]
    let e_name = "Emplo Employee"
    let e = await manager.new_employee(e_id, e_addr, e_name, { from: accounts[0] })
    result['employee'] = {
        'id': e_id,
        'address': e_addr,
        'name': e_name,
        'contact': e
    }

    let result_pretty = JSON.stringify(result, null, 4)
    console.log(result_pretty)
    fs.writeFileSync('result.json', result_pretty,
        function (err, result) {
            if (err) console.log('error', err);
        })
    console.log('saved result to file')
}