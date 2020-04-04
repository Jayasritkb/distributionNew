import React, {Component} from 'react';
import distribution from '../ethereum/distribution.js';
import web3js from '../ethereum/web3.js';
import Layout from '../components/Layout.js';

class DistributionIndex extends Component{
static async getInitialProps(){
  const week = await distribution.methods.getWeekValue().call();
  const delay = await distribution.methods.getDelayValue().call();
  const downstreamPlayer = await distribution.methods.downstreamPlayer().call();
  const upstreamPlayer = await distribution.methods.upstreamPlayer().call();
  const accounts = await web3js.eth.getAccounts();
  const currentAccount = accounts[0];
  return{week, delay, downstreamPlayer, upstreamPlayer, currentAccount};
}

renderDistribution(){
  const roles = ['Distributor', 'Factory'];
  return roles;
}
  render(){
    return (
  <Layout week= {this.props.week} delay={this.props.delay}   >
  <div>
  <p>Downstream Player is: {this.props.downstreamPlayer.playerAddress} </p>
  <p>Upstream Player is: {this.props.upstreamPlayer.playerAddress} </p>
  <p>Account that is currently active is: {this.props.currentAccount} </p>
  </div>
  </Layout>
  );
}
}

export default DistributionIndex;
