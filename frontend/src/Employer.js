import React, { useState } from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';

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
        axios.post('http://localhost:5000/backend/encrypt_key', { keys: combinedKeys })
            .then(res => {
                setEncryptedKey(res.data);
            })
            .catch(err => console.error(err));
    };

    const handleMessageSymKeyInputSubmit = () => {
        // Combine message and symmetric keys delimited by ';'
        const combined = `${messageInput};${symmetricKeyToEncryptWithInput}`;
        
        // Send the combined keys to the Flask route
        axios.post('http://localhost:5000/backend/encrypt_message', { argums: combined })
            .then(res => {
                setEncryptedMessage(res.data);
            })
            .catch(err => console.error(err));
    };

    const generateSymmetricKey = () => {
        axios.get('http://localhost:5000/backend/generate_symmetric_key')
            .then(res => {
                setSymmetricKey(res.data);
            })
            .catch(err => console.error(err));
    };

    return (
        <div className="font-sans sm:font-serif md:font-mono lg:font-sans xl:font-serif flex flex-col items-center justify-center min-h-screen bg-gradient-to-r from-pink-200 via-blue-200 to-purple-200">
            <div className="w-full p-4 bg-white rounded shadow mb-6 fixed top-0 flex items-center justify-center">
                <Link to="/" className="mr-4">Home</Link>
                <Link to="/feedback-summary" className="mr-4">Feedback</Link>
                <Link to="/applicant" className="mr-4">Applicant</Link>
            </div>
            <h1 className="text-3xl font-bold flex flex-col items-center justify-center text-gray-900 p-8 mt-16">Employer Page</h1>
            
            {/* Big device */}
            <div className="hidden sm:flex justify-center space-x-4 mb-4 w-full">  
                {/* Left column */}
                <div className="w-1/3 flex flex-col items-center justify-center">
                    <button onClick={generateSymmetricKey} className="w-full px-2 py-2 mb-4 text-2s font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600 ml-1">Generate Symmetric Key</button>
                    {symmetricKey && typeof symmetricKey === 'string' && (
                        <div>
                            <p className='text-xl p-2'>Symmetric key:</p>
                            <p>{symmetricKey}</p>
                        </div>
                    )}
                </div>
                
                {/* Middle column */}
                <div className="w-1/3 flex flex-col items-center justify-center">
                    <input type="text" placeholder="Public key:" value={publicKeyInput} onChange={handlePublicKeyInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <input type="text" placeholder="Symmetric key:" value={symmetricKeyToBeEncryptedInput} onChange={handleSymmetricKeyInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <button onClick={handlePubSymKeyInputSubmit} className="w-full px-2 py-2 mb-4 text-2s font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600">Encrypt Sym Key</button>
                    {encryptedKey && typeof encryptedKey === 'string' && (
                        <div style={{ border: '1px solid black', padding: '10px', maxWidth: '80%', margin: '0 auto', overflowY: 'scroll', maxHeight: '200px', overflowWrap: 'break-word', wordBreak: 'break-word' }}>
                            <p className='text-xl p-2'>Encrypted symmetric key:</p>
                            <p className='flex flex-col items-center justify-center'>{encryptedKey}</p>
                        </div>    
                    )}
                </div>

                {/* Right column */}    
                <div className="w-1/3 flex flex-col items-center justify-center">
                    <input type="text" placeholder="Message:" value={messageInput} onChange={handleMessageInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <input type="text" placeholder="Symmetric key:" value={symmetricKeyToEncryptWithInput} onChange={handleSymmetricKeyToEncryptWithInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                    <button onClick={handleMessageSymKeyInputSubmit} className="w-full px-2 py-2 mb-4 text-2s font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600 mr-1">Encrypt Message</button>
                    {cipherDetails && typeof cipherDetails === 'object' && (
                        <div style={{ border: '1px solid black', padding: '10px', maxWidth: '80%', margin: '0 auto', overflowY: 'scroll', maxHeight: '200px', overflowWrap: 'break-word', wordBreak: 'break-word' }}>
                            <p className='text-xl p-2'>Encrypted Message:</p> 
                            <p>{cipherDetails.ciphertext}</p>
                            <p className='text-xl p-2'>Nonce:</p>
                            <p> {cipherDetails.nonce}</p>
                            <p className='text-xl p-2'>Tag:</p>
                            <p> {cipherDetails.tag}</p>
                        </div>
                    )}
                </div>
            </div>

                {/* Small device */}
                <div className="sm:hidden flex flex-col justify-center space-y-4 mb-4 w-full">
                    {/* Left column */}
                    <div className="w-full flex flex-col items-center justify-center">
                        <button onClick={generateSymmetricKey} className="w-full px-2 py-2 text-2s font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600">Generate Symmetric Key</button>
                        {symmetricKey && typeof symmetricKey === 'string' && (
                            <div>
                                <p className='text-xl p-2'>Symmetric key:</p>
                                <p>{symmetricKey}</p>
                            </div>
                        )}
                    </div>
                    
                    {/* Middle column */}
                    <div className="w-full flex flex-col items-center justify-center">
                        <input type="text" placeholder="Public key:" value={publicKeyInput} onChange={handlePublicKeyInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                        <input type="text" placeholder="Symmetric key:" value={symmetricKeyToBeEncryptedInput} onChange={handleSymmetricKeyInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                        <button onClick={handlePubSymKeyInputSubmit} className="w-full px-2 py-2 mb-4 text-2s font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600">Encrypt Sym Key</button>
                        {encryptedKey && typeof encryptedKey === 'string' && (
                            <div style={{ border: '1px solid black', padding: '10px', maxWidth: '80%', margin: '0 auto', overflowY: 'scroll', maxHeight: '200px', overflowWrap: 'break-word', wordBreak: 'break-word' }}>
                                <p className='text-xl p-2'>Encrypted symmetric key:</p>
                                <p className='flex flex-col items-center justify-center'>{encryptedKey}</p>
                            </div>    
                        )}
                    </div>

                    {/* Right column */}    
                    <div className="w-full flex flex-col items-center justify-center">
                        <input type="text" placeholder="Message:" value={messageInput} onChange={handleMessageInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                        <input type="text" placeholder="Symmetric key:" value={symmetricKeyToEncryptWithInput} onChange={handleSymmetricKeyToEncryptWithInputChange} className='flex flex-col items-center justify-center rounded m-1' />
                        <button onClick={handleMessageSymKeyInputSubmit} className="w-full px-2 py-2 mb-4 text-2s font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600">Encrypt Message</button>
                        {cipherDetails && typeof cipherDetails === 'object' && (
                            <div style={{ border: '1px solid black', padding: '10px', maxWidth: '80%', margin: '0 auto', overflowY: 'scroll', maxHeight: '200px', overflowWrap: 'break-word', wordBreak: 'break-word' }}>
                                <p className='text-xl p-2'>Encrypted Message:</p> 
                                <p>{cipherDetails.ciphertext}</p>
                                <p className='text-xl p-2'>Nonce:</p>
                                <p> {cipherDetails.nonce}</p>
                                <p className='text-xl p-2'>Tag:</p>
                                <p> {cipherDetails.tag}</p>
                            </div>
                        )}
                    </div>
                </div>
        </div>      
    );
};

export default Employer;
