const fs = require('fs')
const PATH = './build/contracts/MyLightsController.json'
const MyLightsControllerAddress = '0x46ba81Ddb110d4d4ebD41025D1D1D7d19FE8C159'

async function main(){
    let MyLightsControllerABI = JSON.parse(fs.readFileSync(PATH, 'utf8')).abi
    let MyLightsControllerContract = await new web3.eth.Contract(MyLightsControllerABI, MyLightsControllerAddress)
    

    //let events = await MyLightsControllerContract.getPastEvents("DeviceConfigChange")
    //console.log(events[0].returnValues)

    MyLightsControllerContract.events.DeviceConfigChange()
        .on('connected', str => console.log('event listener connected', str))
        .on('error', err => { throw err })
        .on('data', event => console.log(event))
        .on('changed', changed => console.log(changed))
        
}

module.exports = main


