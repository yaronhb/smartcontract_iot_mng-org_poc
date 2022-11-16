const fs = require('fs')

const redis = require('redis')
const HOST = "127.0.0.1"
const PORT = 6379

const redisClient = redis.createClient({
  // redis[s]://[[username][:password]@][host][:port][/db-number]
  url: `redis://${HOST}:${PORT}`
})

const makesecret = require('../scripts/make_secret')

const global = JSON.parse(fs.readFileSync('../result.json', 'utf8'))

const PATH = '../build/contracts/DoorEndPoint.json'
const DoorEndPointABI = JSON.parse(fs.readFileSync(PATH, 'utf8')).abi

const DoorEndPointAddress = global['door-endpoint'].contract


async function processTicket(event) {
    let ticket = event.returnValues.ticket
    console.log("recived ticket", event.signature)
    let em_id = ticket.employee_id
    let end_id = ticket.endpoint_id
    let validity_seconds = ticket.validity_length * 1
    let encrypted = JSON.parse(ticket.data)
    const prvkey = JSON.parse(fs.readFileSync(`keypair_${end_id}.json`, 'utf8'))['private-key']

    let secret = makesecret.decrypt(encrypted, prvkey)

    let key = `endpoint_${end_id}/tickets/employee_${em_id}/secret`
    // console.log('adding key', key)
    await redisClient.set(key, secret, {
        EX: validity_seconds * 3
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
    
    let DoorEndPointContract = await new web3.eth.Contract(DoorEndPointABI, DoorEndPointAddress)

    DoorEndPointContract.events.TicketIssued()
        .on('connected', str => console.log('event listener connected', str))
        .on('error', err => { throw err })
        .on('data', event => processTicket(event))
        .on('changed', changed => console.log('event changed', changed))
        
}

module.exports = main


