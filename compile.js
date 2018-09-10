const path = require('path');
const fs = require('fs');
const solc = require('solc');

const goodsChainPath = path.resolve(__dirname, 'contracts', 'GoodsChain.sol');
const source = fs.readFileSync(goodsChainPath, 'utf8');

module.exports = solc.compile(source, 1).contracts[':Goodschain'];