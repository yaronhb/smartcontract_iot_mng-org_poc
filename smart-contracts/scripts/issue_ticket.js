const fs = require('fs')

const NetEndPoint = artifacts.require('NetEndPoint')


const global = JSON.parse(fs.readFileSync('../result.json', 'utf8'))

let employee_address = global.employee.address


let cert = fs.readFileSync(process.argv[4], 'utf8')

async function main(callback){
    let netEndPoint = await NetEndPoint.deployed()
    console.log(netEndPoint.address)
    let reciept = await netEndPoint.CreateTicket(netEndPoint.address, cert, {from: employee_address})
    console.log(reciept)

    callback();
}

module.exports = main


