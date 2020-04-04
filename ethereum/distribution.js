import web3js from './web3';
import distribution from './build/Distribution.json';

const instance = new web3js.eth.Contract(
  JSON.parse(distribution.interface),
  '0x0ba3b99723258a867341F185E1d2404E4C7702c2'
);

export default instance;
