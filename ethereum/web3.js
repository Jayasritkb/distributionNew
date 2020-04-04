import Web3 from 'web3';


let web3js;

if(typeof window !== 'undefined' && typeof window.web3 !== 'undefined'){
  //We are in the browser and metamask is running
web3js = new Web3(window.web3.currentProvider);
}else{
  //We are on the server *OR* the user is not running metamask
  const HDWalletProvider = require('truffle-hdwallet-provider');
  // This provider returns only one address at a time, so need to change to different addresses and check
  const provider = new HDWalletProvider(
    'acid pause ready average slush glad slide smoke test silver junk rug',
    'https://rinkeby.infura.io/v3/74b79e3d23e64a16891ae236b04b4ef5',
    0,
    1
  );
  web3js = new Web3(provider);

}


export default web3js;
