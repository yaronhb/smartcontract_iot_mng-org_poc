'use strict';

var isNil         = require('is-nil');
var isObject      = require('is-object');
var toString      = require('to-str');
var randomNatural = require('random-natural');

var pools = {
  lower: 'abcdefghijklmnopqrstuvwxyz',
  upper: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
  number: '0123456789',
  symbol: '~!@#$%^&()*_+-={}[]'
};

pools.alpha  = pools.lower + pools.upper;
pools['all'] = pools.lower + pools.upper + pools.number + pools.symbol;

module.exports = function (options) {

  if (!isObject(options)) {
    if (isNil(options)) {
      options = { pool: pools.all };
    } else {
      options = toString(options);
      options = { pool: pools[options] || options };
    }
  }

  var pool;

  if (options.pool) {
    pool = options.pool;
  } else if (options.lower) {
    pool = pools.lower;
  } else if (options.upper) {
    pool = pools.upper;
  } else if (options.alpha) {
    pool = pools.alpha;
  } else if (options.number) {
    pool = pools.number;
  } else if (options.symbol) {
    pool = pools.symbol;
  } else {
    pool = pools.all;
  }

  pool = toString(pool);

  return pool.charAt(randomNatural({
    min: 0,
    max: pool.length - 1,
    inspected: true
  }));
};
