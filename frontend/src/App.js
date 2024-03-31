import logo from "./logo.svg";
import "./App.css";
import React from "react";
import web3 from "./web3";
import jobActivity from "./jobActivity"

class App extends React.Component {
  state = {
    employer: ''
  };
  async componentDidMount(){
    const employer = await jobActivity.methods.employer().call();
    this.setState({employer});
  }
  render() {
    web3.eth.getAccounts()
    .then(console.log);
    console.log(this.state)
    return (
      <div>
        <h2>Job Activity Contract</h2>
        <p>This contract is managed by {this.state.employer}</p>
      </div>
    );
  }
}
export default App;
