const HDWalletProvider = require('@truffle/hdwallet-provider');
const { Web3 } = require('web3');
const { interface, bytecode } = require('./compile');

const provider = new HDWalletProvider(
  'absurd speak thunder divide scale lecture biology nominee that metal such hamster', 'https://sepolia.infura.io/v3/3fd882e4b4874eeb9cb5bedbc8c32cec'
);
const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log('Attempting to deploy from account', accounts[0]);

  const result = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode })
    .send({ gas: '5000000', from: accounts[0] });

  console.log(interface);
  console.log("Contract deployed to", result.options.address);
  provider.engine.stop();
};
deploy();
