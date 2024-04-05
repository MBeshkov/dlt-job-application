import React, { useState } from 'react';
import axios from 'axios';

const Applicant = () => {
    const [rsaKeyPair, setRsaKeyPair] = useState('');
    const [decryptedKey, setDecryptedKey] = useState('');
    const [decryptedMessage, setDecryptedMessage] = useState('');
    const [encryptedKeyInput, setEncryptedKeyInput] = useState('');
    const [encryptedMessageInput, setEncryptedMessageInput] = useState('');

    const generateKeyPair = () => {
        axios.get('http://localhost:5000/api/generate_key_pair')
            .then(res => {
                setRsaKeyPair(res.data);
            })
            .catch(err => console.error(err));
    };

    const decryptKey = () => {
        axios.post('http://localhost:5000/api/decrypt_key', { encryptedKey: encryptedKeyInput })
            .then(res => {
                setDecryptedKey(res.data);
            })
            .catch(err => console.error(err));
    };

    const decryptMessage = () => {
        axios.post('http://localhost:5000/api/decrypt_message', { encryptedMessage: encryptedMessageInput })
            .then(res => {
                setDecryptedMessage(res.data);
            })
            .catch(err => console.error(err));
    };

    return (
        <div>
            <h1>Applicant Page</h1>
            <button onClick={generateKeyPair}>Generate RSA Key Pair</button>
            {rsaKeyPair && typeof rsaKeyPair === 'object' && (
                <div>
                    <p>Public Key: {rsaKeyPair.public_key}</p>
                    <p>Private Key: {rsaKeyPair.private_key}</p>
                </div>
            )}
            <p></p>
            <input type="text" placeholder="Enter encrypted key" value={encryptedKeyInput} onChange={(e) => setEncryptedKeyInput(e.target.value)} />
            <button onClick={decryptKey}>Decrypt Key</button>
            <p>{decryptedKey}</p>
            <input type="text" placeholder="Enter encrypted message" value={encryptedMessageInput} onChange={(e) => setEncryptedMessageInput(e.target.value)} />
            <button onClick={decryptMessage}>Decrypt Message</button>
            <p>{decryptedMessage}</p>
        </div>
    );
    
};

export default Applicant;
