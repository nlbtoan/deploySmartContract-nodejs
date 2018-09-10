const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const { interface, bytecode } = require('./compile');

const provider = new HDWalletProvider(
    'null',
    'null'
);
const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();

    console.log('Attempting to deploy from account', accounts[0]);

    const result = await new web3.eth.Contract(JSON.parse(interface))
        .deploy({ data: '0x' + bytecode })
        .send({ gas: '1000000', from: accounts[0] });

    console.log('############################################################');
    console.log('Contract deployed, and address is: ', result.options.address);
    console.log('############################################################');
    console.log('The interface is: ', interface);
    console.log('############################################################');
    console.log('The bytecode is: ', bytecode);
};
deploy();