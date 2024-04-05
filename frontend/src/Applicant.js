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
        axios.get('http://localhost:5000/backend/generate_key_pair')
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
        axios.post('http://localhost:5000/backend/decrypt_key', { keys: combinedKeys })
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
        axios.post('http://localhost:5000/backend/decrypt_message', { parameters: combinedParameters })
            .then(res => {
                setDecryptedMessage(res.data);
            })
            .catch(err => console.error(err));
    };

    return (
        <div className="flex flex-col items-center justify-center min-h-screen bg-gradient-to-r from-pink-200 via-blue-200 to-purple-200">
            <h1>Applicant Page</h1>
            <button onClick={generateKeyPair}>Generate RSA Key Pair</button>
            {rsaKeyPair && typeof rsaKeyPair === 'object' && (
                <div>
                    <p>Public Key: {rsaKeyPair.public_key}</p>
                    <p>Private Key: {rsaKeyPair.private_key}</p>
                </div>
            )}
            <p></p>
            <input type="text" placeholder="Your private key:" value={privateKeyInput} onChange={handlePrivateKeyInputChange} />
            <input type="text" placeholder="Encrypted symmetric key:" value={encryptedKeyInput} onChange={handleEncryptedKeyInputChange} />
            <button onClick={handlePrivEncrypKeyInputSubmit}>Decrypt Symmetric Key</button>
            <p>Decrypted key: {decryptedKey}</p>
            <input type="text" placeholder="Decrypted symmetric key:" value={decryptedKeyInput} onChange={handleDecryptedKeyInputChange} />
            <input type="text" placeholder="Ciphertext:" value={encryptedMessageInput} onChange={handleEncryptedMessageInput} />
            <input type="text" placeholder="Tag:" value={tagInput} onChange={handleTagInputChange} />
            <input type="text" placeholder="Nonce:" value={nonceInput} onChange={handleNonceInputChange} />
            <button onClick={handleCipherDecKeyNonceTagInputSubmit}>Decrypt Ciphertext</button>
            <p>Decrypted message: {decryptedMessage}</p>
        </div>
    );
    
};

export default Applicant;
