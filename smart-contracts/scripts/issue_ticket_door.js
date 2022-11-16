const fs = require('fs')

const DoorEndPoint = artifacts.require('DoorEndPoint')

const makesecret = require('../scripts/make_secret')

const global = JSON.parse(fs.readFileSync('../result.json', 'utf8'))

let employee_address = global.employee.address

async function main(callback){
    let doorEndPoint = await DoorEndPoint.deployed()
    let pubk = await doorEndPoint.publicKey()
    console.log(doorEndPoint.address, pubk)

    let secret = makesecret.createSharedSecret()
    console.log("Secret", secret)

    let encrtpted_secret = makesecret.encrypt(secret, pubk)
    let reciept = await doorEndPoint.CreateTicket(doorEndPoint.address, JSON.stringify(encrtpted_secret), {from: employee_address})
    console.log(reciept)

    callback();
}

module.exports = main


