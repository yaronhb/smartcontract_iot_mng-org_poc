const crypto = require('crypto')

const pubk_encoding = {
    type: 'spki',
    format: 'pem'
}
const prvk_encoding = {
    type: 'pkcs8',
    format: 'pem',
    // cipher: 'aes-256-cbc',
    // passphrase: 'top secret'
}
function createKeyPair() {
    let pair = crypto.generateKeyPairSync('rsa', {
        modulusLength: 4096,
        publicKeyEncoding: pubk_encoding,
        privateKeyEncoding: prvk_encoding
    })
    return [pair.publicKey, pair.privateKey]
}

function makeRandomSecret() {
    let length = crypto.randomInt(16, 64)
    let secret = crypto.randomBytes(length).toString('base64')
    return secret
}
function encryptAES(data) {
    let aesKey = crypto.randomBytes(16)
    let iv = crypto.randomBytes(16)
    let cipher = crypto.createCipheriv('aes-128-cbc', aesKey, iv)
    let encrypted = cipher.update(data, 'ascii', 'base64') + cipher.final('base64')
    return [aesKey.toString('base64'), iv.toString('base64'), encrypted]
}
function decryptAES(aesKey, iv, encrypted) {
    aesKey = Buffer.from(aesKey, 'base64')
    iv = Buffer.from(iv, 'base64')
    let decipher = crypto.createDecipheriv('aes-128-cbc', aesKey, iv)
    let decrypted = decipher.update(encrypted, 'base64', 'ascii') + decipher.final('ascii')
    return decrypted
}

function testAES(data) {
    console.log("Data:", data)
    let [aesKey, iv, encrypted] = encryptAES(data)
    console.log("Encryption(key, iv, data):", aesKey, iv, encrypted)

    let decrypted = decryptAES(aesKey, iv, encrypted)
    console.log("Decryption:", decrypted)

    console.log(data == decrypted)

}

function encryptHybrid(data, pubk) {
    let pbkey = {
        key: crypto.createPublicKey(pubk),
        padding: crypto.constants.RSA_PKCS1_PADDING
    }
    let [aesKey, iv, encrypted] = encryptAES(data)
    let encryptedAESKey = crypto
        .publicEncrypt(pbkey, Buffer.from(aesKey, 'base64'))
        .toString('base64')
    return [encryptedAESKey, iv, encrypted]
}

function decryptHybrid(encrypted, prvk) {
    let [encryptedAESKey, iv, encrypted_data] = encrypted
    let prkey = {
        key: crypto.createPrivateKey(prvk),
        padding: crypto.constants.RSA_PKCS1_PADDING
    }
    let decryptedAESKey = crypto
        .privateDecrypt(prkey, Buffer.from(encryptedAESKey, 'base64'))
        .toString('base64')
    let decrypted = decryptAES(decryptedAESKey, iv, encrypted_data)
    return decrypted
}

function testHybrid(data) {
    let [pbkey, prkey] = createKeyPair()
    console.log("Data:", data)
    let [encryptedAESKey, iv, encrypted] = encryptHybrid(data, pbkey)
    console.log("Encryption(encrypted-key, iv, data):", encryptedAESKey, iv, encrypted)

    let decrypted = decryptHybrid(encryptedAESKey, iv, encrypted, prkey)
    console.log("Decryption:", decrypted)

    console.log(data == decrypted)

}

module.exports = {
    createKeyPair: createKeyPair,
    createSharedSecret: makeRandomSecret,
    encrypt: encryptHybrid,
    decrypt: decryptHybrid
}