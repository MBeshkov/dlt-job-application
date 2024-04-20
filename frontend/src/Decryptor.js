import React, { useState } from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';

const Decryptor = () => {
    const [rsaKeyPair, setRsaKeyPair] = useState('');
    const [decryptedKey, setDecryptedKey] = useState('');
    const [decryptedMessage, setDecryptedMessage] = useState('');
    const [encryptedKeyInput, setEncryptedKeyInput] = useState('');
    const [privateKeyInput, setPrivateKeyInput] = useState('');
    const [encryptedMessageInput, setEncryptedMessageInput] = useState('');
    const [decryptedKeyInput, setDecryptedKeyInput] = useState('');
    const [nonceInput, setNonceInput] = useState('');
    const [tagInput, setTagInput] = useState('');
    const [loading, setLoading] = useState(false);

    const generateKeyPair = () => {
        setLoading(true);
        axios.get('http://localhost:5000/backend/generate_key_pair')
            .then(res => {
                setRsaKeyPair(res.data);
                setLoading(false);
            })
            .catch(err => console.error(err));
        setLoading(false);
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
        <div className="font-sans sm:font-serif md:font-mono lg:font-sans xl:font-serif flex flex-col items-center justify-center min-h-screen bg-gradient-to-r from-pink-200 via-blue-200 to-purple-200">
            <div className="w-full p-4 bg-white rounded shadow mb-6 fixed top-0 flex items-center justify-center">
                <Link to="/" className="mr-4">Home</Link>
                <Link to="/encryptor" className="mr-4">Encryptor</Link>
                <Link to="/feedback-summary" className="mr-4">Feedback</Link>
            </div>
            <h1 className="text-3xl font-bold flex flex-col items-center justify-center text-gray-900 p-8 mt-16">Decryptor Page</h1>

            {/* Big device */}
            <div className="hidden sm:flex justify-center space-x-4 mb-4 w-full">
                {/* Left column */}
                <div className="w-1/3 flex flex-col items-center justify-center">
                    <button className="w-full px-2 py-2 mb-4 text-2s font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600 ml-1" onClick={generateKeyPair}>Generate RSA Key Pair</button>
                    {loading && <p className="animate-bounce flex flex-col items-center justify-center">Loading...</p>}
                    {rsaKeyPair && typeof rsaKeyPair === 'object' && (
                        <div style={{ border: '1px solid black', padding: '10px', maxWidth: '80%', margin: '0 auto', overflowY: 'scroll', maxHeight: '200px' }}>
                            <p className='text-xl p-2'>Public Key:</p>
                            <p> {rsaKeyPair.public_key.replace(/-+BEGIN PUBLIC KEY-+\n?|-+END PUBLIC KEY-+\n?/g, '')}</p>
                            <p className='text-xl p-2'>Private Key:</p>
                            <p> {rsaKeyPair.private_key.replace(/-+BEGIN RSA PRIVATE KEY-+\n?|-+END RSA PRIVATE KEY-+\n?/g, '')}</p>
                        </div>
                    )}
                </div>

                {/* Middle column */}
                <div className="w-1/3 flex flex-col items-center justify-center">
                    <input type="text" placeholder="Your private key:" value={privateKeyInput} onChange={handlePrivateKeyInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <input type="text" placeholder="Encrypted sym key:" value={encryptedKeyInput} onChange={handleEncryptedKeyInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <button onClick={handlePrivEncrypKeyInputSubmit} className="w-full px-2 py-2 mb-4 text-2s font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600">Decrypt Symmetric Key</button>
                    {decryptedKey && typeof decryptedKey === 'string' && (
                        <div className="py-3 flex flex-col items-center justify-center">
                            <p className='text-xl p-2'>Decrypted key:</p>
                            <p>{decryptedKey}</p>
                        </div>
                    )}
                </div>

                {/* Right column */}
                <div className="w-1/3 flex flex-col items-center justify-center">
                    <input type="text" placeholder="Decrypted sym key:" value={decryptedKeyInput} onChange={handleDecryptedKeyInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <input type="text" placeholder="Ciphertext:" value={encryptedMessageInput} onChange={handleEncryptedMessageInput} className='flex flex-col items-center justify-center rounded m-1' />
                    <input type="text" placeholder="Tag:" value={tagInput} onChange={handleTagInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <input type="text" placeholder="Nonce:" value={nonceInput} onChange={handleNonceInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <button onClick={handleCipherDecKeyNonceTagInputSubmit} className="w-full px-2 py-2 mb-4 text-2s font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600 mr-1">Decrypt Ciphertext</button>
                    {decryptedMessage && typeof decryptedMessage === 'string' && (
                        <div style={{ border: '1px solid black', padding: '10px', maxWidth: '80%', margin: '0 auto', overflowY: 'scroll', maxHeight: '200px', overflowWrap: 'break-word', wordBreak: 'break-word' }}>
                            <p className='text-xl p-2'>Decrypted message:</p>
                            <p>{decryptedMessage}</p>
                        </div>
                    )}
                </div>
            </div>
            {/* Small device */}
            <div className="sm:hidden flex flex-col justify-center space-y-4 mb-4 w-full">
                {/* Left column */}
                <div className="w-full flex flex-col items-center justify-center">
                    <button className="w-full px-2 py-2 mb-4 text-2s font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600" onClick={generateKeyPair}>Generate RSA Key Pair</button>
                    {loading && <p className="animate-bounce flex flex-col items-center justify-center">Loading...</p>}
                    {rsaKeyPair && typeof rsaKeyPair === 'object' && (
                        <div style={{ border: '1px solid black', padding: '10px', maxWidth: '80%', margin: '0 auto', overflowY: 'scroll', maxHeight: '200px' }}>
                            <p className='text-xl p-2'>Public Key:</p>
                            <p> {rsaKeyPair.public_key.replace(/-+BEGIN PUBLIC KEY-+\n?|-+END PUBLIC KEY-+\n?/g, '')}</p>
                            <p className='text-xl p-2'>Private Key:</p>
                            <p> {rsaKeyPair.private_key.replace(/-+BEGIN RSA PRIVATE KEY-+\n?|-+END RSA PRIVATE KEY-+\n?/g, '')}</p>
                        </div>
                    )}
                </div>

                {/* Middle column */}
                <div className="w-full flex flex-col items-center justify-center">
                    <input type="text" placeholder="Your private key:" value={privateKeyInput} onChange={handlePrivateKeyInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <input type="text" placeholder="Encrypted sym key:" value={encryptedKeyInput} onChange={handleEncryptedKeyInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <button onClick={handlePrivEncrypKeyInputSubmit} className="w-full px-2 py-2 text-2s font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600">Decrypt Symmetric Key</button>
                    {decryptedKey && typeof decryptedKey === 'string' && (
                        <div className="flex flex-col items-center justify-center">
                            <p className='text-xl p-2'>Decrypted key:</p>
                            <p>{decryptedKey}</p>
                        </div>
                    )}
                </div>

                {/* Right column */}
                <div className="w-full flex flex-col items-center justify-center">
                    <input type="text" placeholder="Decrypted sym key:" value={decryptedKeyInput} onChange={handleDecryptedKeyInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <input type="text" placeholder="Ciphertext:" value={encryptedMessageInput} onChange={handleEncryptedMessageInput} className='flex flex-col items-center justify-center rounded m-1' />
                    <input type="text" placeholder="Tag:" value={tagInput} onChange={handleTagInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <input type="text" placeholder="Nonce:" value={nonceInput} onChange={handleNonceInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <button onClick={handleCipherDecKeyNonceTagInputSubmit} className="w-full px-2 py-2 mb-4 text-2s font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600">Decrypt Ciphertext</button>
                    {decryptedMessage && typeof decryptedMessage === 'string' && (
                        <div style={{ border: '1px solid black', padding: '10px', maxWidth: '80%', margin: '0 auto', overflowY: 'scroll', maxHeight: '200px', overflowWrap: 'break-word', wordBreak: 'break-word' }}>
                            <p className='text-xl p-2'>Decrypted message:</p>
                            <p>{decryptedMessage}</p>
                        </div>
                    )}
                </div>
            </div>

        </div>
    );

};

export default Decryptor;
