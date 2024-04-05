import React, { useState } from 'react';
import axios from 'axios';

const Employer = () => {
    const [symmetricKey, setSymmetricKey] = useState('');
    const [encryptedKey, setEncryptedKey] = useState('');
    const [cipherDetails, setEncryptedMessage] = useState('');
    const [messageInput, setMessageInput] = useState('');
    // const [keyInput, setKeyInput] = useState('')
    const [symmetricKeyToEncryptWithInput, setSymmetricKeyToEncryptInput] = useState('');
    const [publicKeyInput, setPublicKeyInput] = useState('');
    const [symmetricKeyToBeEncryptedInput, setSymmetricKeyInput] = useState('');

    // Function to handle changes in the public key input field
    const handlePublicKeyInputChange = (e) => {
        setPublicKeyInput(e.target.value);
    };

    // Function to handle changes in the symmetric key input field
    const handleSymmetricKeyInputChange = (e) => {
        setSymmetricKeyInput(e.target.value);
    };

    const handleMessageInputChange = (e) => {
        setMessageInput(e.target.value);
    };

    // Function to handle changes in the symmetric key input field
    const handleSymmetricKeyToEncryptWithInputChange = (e) => {
        setSymmetricKeyToEncryptInput(e.target.value);
    };

    const handlePubSymKeyInputSubmit = () => {
        // Combine public and symmetric keys delimited by ';'
        const combinedKeys = `${publicKeyInput};${symmetricKeyToBeEncryptedInput}`;
        
        // Send the combined keys to the Flask route
        axios.post('http://localhost:5000/api/encrypt_key', { keys: combinedKeys })
            .then(res => {
                setEncryptedKey(res.data);
            })
            .catch(err => console.error(err));
    };

    const handleMessageSymKeyInputSubmit = () => {
        // Combine message and symmetric keys delimited by ';'
        const combined = `${messageInput};${symmetricKeyToEncryptWithInput}`;
        
        // Send the combined keys to the Flask route
        axios.post('http://localhost:5000/api/encrypt_message', { argums: combined })
            .then(res => {
                setEncryptedMessage(res.data);
            })
            .catch(err => console.error(err));
    };

    const generateSymmetricKey = () => {
        axios.get('http://localhost:5000/api/generate_symmetric_key')
            .then(res => {
                setSymmetricKey(res.data);
            })
            .catch(err => console.error(err));
    };

    return (
        <div>
            <h1>Employer Page</h1>
            <button onClick={generateSymmetricKey}>Generate Symmetric Key</button>
            <p>{symmetricKey}</p>
            <input type="text" placeholder="Enter public key" value={publicKeyInput} onChange={handlePublicKeyInputChange} />
            <input type="text" placeholder="Enter symmetric key" value={symmetricKeyToBeEncryptedInput} onChange={handleSymmetricKeyInputChange} />
            <button onClick={handlePubSymKeyInputSubmit}>Submit</button>
            <p>{encryptedKey}</p>
            <input type="text" placeholder="Enter message" value={messageInput} onChange={handleMessageInputChange} />
            <input type="text" placeholder="Enter symmetric key" value={symmetricKeyToEncryptWithInput} onChange={handleSymmetricKeyToEncryptWithInputChange} />
            <button onClick={handleMessageSymKeyInputSubmit}>Encrypt Message</button>
            {cipherDetails && typeof cipherDetails === 'object' && (
                <div>
                    <p>Encrypted Message: {cipherDetails.ciphertext}</p>
                    <p>Nonce: {cipherDetails.nonce}</p>
                    <p>Tag: {cipherDetails.tag}</p>
                </div>
            )}
        </div>
    );
};

export default Employer;
