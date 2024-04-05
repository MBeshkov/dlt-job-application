import React, { useState } from 'react';
import axios from 'axios';

const Applicant = () => {
    const [rsaKeyPair, setRsaKeyPair] = useState('');
    const [decryptedKey, setDecryptedKey] = useState('');
    const [decryptedMessage, setDecryptedMessage] = useState('');
    const [encryptedKeyInput, setEncryptedKeyInput] = useState('');
    const [privateKeyInput, setPrivateKeyInput] = useState('');
    const [encryptedMessageInput, setEncryptedMessageInput] = useState('');
    const [decryptedKeyInput, setDecryptedKeyInput] = useState('');
    const [nonceInput, setNonceInput] = useState('');
    const [tagInput, setTagInput] = useState('');

    const generateKeyPair = () => {
        axios.get('http://localhost:5000/api/generate_key_pair')
            .then(res => {
                setRsaKeyPair(res.data);
            })
            .catch(err => console.error(err));
    };

    const handlePrivateKeyInputChange = (e) => {
        setPrivateKeyInput(e.target.value);
    };

    const handleEncryptedKeyInputChange = (e) => {
        setEncryptedKeyInput(e.target.value);
    };

    const handlePrivEncrypKeyInputSubmit = () => {
        const combinedKeys = `${privateKeyInput};${encryptedKeyInput}`;
        axios.post('http://localhost:5000/api/decrypt_key', { keys: combinedKeys })
            .then(res => {
                setDecryptedKey(res.data);
            })
            .catch(err => console.error(err));
    };

    const handleEncryptedMessageInput = (e) => {
        setEncryptedMessageInput(e.target.value);
    };

    const handleDecryptedKeyInputChange = (e) => {
        setDecryptedKeyInput(e.target.value);
    };
    
    const handleNonceInputChange = (e) => {
        setNonceInput(e.target.value);
    };

    const handleTagInputChange = (e) => {
        setTagInput(e.target.value);
    };

    const handleCipherDecKeyNonceTagInputSubmit = () => {
        const combinedParameters = `${decryptedKeyInput};${encryptedMessageInput};${tagInput};${nonceInput}`;
        axios.post('http://localhost:5000/api/decrypt_message', { parameters: combinedParameters })
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
            <input type="text" placeholder="Enter private key" value={privateKeyInput} onChange={handlePrivateKeyInputChange} />
            <input type="text" placeholder="Enter encrypted symmetric key" value={encryptedKeyInput} onChange={handleEncryptedKeyInputChange} />
            <button onClick={handlePrivEncrypKeyInputSubmit}>Decrypt Symmetric Key</button>
            <p>{decryptedKey}</p>
            <input type="text" placeholder="Enter decrypted symmetric key" value={decryptedKeyInput} onChange={handleDecryptedKeyInputChange} />
            <input type="text" placeholder="Enter ciphertext" value={encryptedMessageInput} onChange={handleEncryptedMessageInput} />
            <input type="text" placeholder="Enter tag" value={tagInput} onChange={handleTagInputChange} />
            <input type="text" placeholder="Enter nonce" value={nonceInput} onChange={handleNonceInputChange} />
            <button onClick={handleCipherDecKeyNonceTagInputSubmit}>Decrypt Ciphertext</button>
            <p>{decryptedMessage}</p>
        </div>
    );
    
};

export default Applicant;
