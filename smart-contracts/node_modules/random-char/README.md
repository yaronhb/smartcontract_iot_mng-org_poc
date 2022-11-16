# random-char
  
> Return a random character.

[![MIT License](https://img.shields.io/badge/license-MIT_License-green.svg?style=flat-square)](https://github.com/mock-end/random-char/blob/master/LICENSE)

[![build:?](https://img.shields.io/travis/mock-end/random-char/master.svg?style=flat-square)](https://travis-ci.org/mock-end/random-char)
[![coverage:?](https://img.shields.io/coveralls/mock-end/random-char/master.svg?style=flat-square)](https://coveralls.io/github/mock-end/random-char)


## Install

```
$ npm install --save random-char 
```

## Usage

> For more use-cases see the [tests](https://github.com/mock-end/random-char/blob/master/test/spec/index.js)


```js
var randomChar = require('random-char');

// API
// - randomChar([poolName]);
// - randomChar([options]);

randomChar();
// => 'k'
```

By default it will return a string with random character from the following pool:

```
'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#$%^&()*_+-={}[]'
```

Optionally specify a pool:

```js
randomChar('alpha'); // or
randomChar({alpha: true});
// => 'm'

randomChar('upper'); // or
randomChar({upper: true});
// => 'Z'

randomChar('lower'); // or
randomChar({lower: true});
// => 'j'

randomChar('number'); // or
randomChar({number: true});
// => '7'

randomChar('symbols'); // or
randomChar({symbols: true});
// => '%'
```

Optionally specify a pool and the character will be generated with characters only from that pool:

```js
randomChar('abcde'); // or
randomChar({pool: 'abcde'});
// => 'c'
```

## Related

- [random-integral](https://github.com/mock-end/random-integral) - Return a random integer.
- [random-natural](https://github.com/mock-end/random-natural) - Return a random natural number.
- [random-decimal](https://github.com/mock-end/random-decimal) - Return a random decimal.
- [random-floating](https://github.com/mock-end/random-floating) - Return a random floating point number.
- [random-index](https://github.com/mock-end/random-index) - Return a random array-like index.
- [random-binary](https://github.com/mock-end/random-binary) - Return a random binary number.
- [random-octal](https://github.com/mock-end/random-octal) - Return a random octal number.
- [random-hexadecimal](https://github.com/mock-end/random-hexadecimal) - Return a random hexadecimal number.
- [random-unicode](https://github.com/mock-end/random-unicode) - Return a random unicode. 
- [random-bool](https://github.com/mock-end/random-bool) - Return a random boolean (true/false).


## Contributing

Pull requests and stars are highly welcome.

For bugs and feature requests, please [create an issue](https://github.com/mock-end/random-char/issues/new).
