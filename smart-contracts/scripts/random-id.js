const randomChar = require('random-char')

const HEXDIGITS = "0123456789abcdef"
const LENGTH = 2 * 32;

function randomID() {
    let digits = Array.from({length: LENGTH}, _ => randomChar(HEXDIGITS)).join('')
    return `0x${digits}`
}

module.exports = randomID