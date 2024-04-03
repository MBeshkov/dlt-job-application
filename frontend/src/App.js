import logo from "./logo.svg";
import "./App.css";
import React from "react";
import web3 from "./web3";
import jobActivity from "./jobActivity";

const GAS_LIMIT = 1000000; // Define the gas limit value

class App extends React.Component {
  state = {
    employer: '',
    publicKey: '',
    loading: false,
    accounts: []
  };

  async componentDidMount() {
    // Fetch Ethereum accounts
    const accounts = await web3.eth.getAccounts();
    this.setState({ accounts });

    // Load employer
    this.loadEmployer();
  }

  loadEmployer = async () => {
    const employer = await jobActivity.methods.employer().call();
    this.setState({ employer });
  };

  setPublicKey = async () => {
    this.setState({ loading: true });

    // Get the first account as the sender address
    const senderAddress = this.state.accounts[0];

    // Call the setPublicKey function with the sender address
    await jobActivity.methods.setPublicKey().send({ from: senderAddress, gas: GAS_LIMIT });

    // Retrieve the public key from the contract and update the state
    const publicKey = await jobActivity.methods.getOwnPublicKey().call({ from: senderAddress });
    this.setState({ publicKey, loading: false });
  };

  render() {
    return (
      <div>
        <h2>Job Activity Contract</h2>
        <p>This contract is managed by {this.state.employer}</p>
        {this.state.loading ? (
          <p>Loading...</p>
        ) : (
          <div>
            <button onClick={this.setPublicKey}>Set Public Key</button>
            {this.state.publicKey && (
              <p>Generated Public Key: {this.state.publicKey}</p>
            )}
          </div>
        )}
      </div>
    );
  }
}
export default App;
