const fs = require('fs')

const redis = require('redis')
const HOST = "127.0.0.1"
const PORT = 6379

const redisClient = redis.createClient({
  // redis[s]://[[username][:password]@][host][:port][/db-number]
  url: `redis://${HOST}:${PORT}`
})

const PATH = '../build/contracts/NetEndPoint.json'
const NetEndPointABI = JSON.parse(fs.readFileSync(PATH, 'utf8')).abi

const global = JSON.parse(fs.readFileSync('../result.json', 'utf8'))

// const NetEndPointAddress = '0x0A39520898c376ac0adEcCcC80Bb6e4fcB6fB81B'
const NetEndPointAddress = global['net-endpoint'].contract

async function processTicket(event) {
    let ticket = event.returnValues.ticket
    console.log("recived ticket", event.signature)
    let em_id = ticket.employee_id
    let end_id = ticket.endpoint_id
    let validity_seconds = ticket.validity_length * 1
    let cert = ticket.data
    
    let key = `endpoint_${end_id}/tickets/employee_${em_id}/cert`
    // console.log('adding key', key)
    await redisClient.set(key, cert, {
        EX: validity_seconds
    })
    console.log("added ticket", event.signature)
}

async function initRedis() {
    redisClient.on('connect', (_) => console.log('Redis Client connect'))
    redisClient.on('ready', (_) => console.log('Redis Client ready'))
    redisClient.on('end', (_) => console.log('Redis Client end'))
    redisClient.on('reconnecting', (_) => console.log('Redis Client end'))
    redisClient.on('error', (err) => console.log('Redis Client Error', err))
    await redisClient.connect()
}
async function main(){
    await initRedis()
    
    let NetEndPointContract = await new web3.eth.Contract(NetEndPointABI, NetEndPointAddress)

    NetEndPointContract.events.TicketIssued()
        .on('connected', str => console.log('event listener connected', str))
        .on('error', err => { throw err })
        .on('data', event => processTicket(event))
        .on('changed', changed => console.log('event changed', changed))
        
}

module.exports = main


