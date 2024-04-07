import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import FeedbackSummary from './FeedbackSummary';
import Decryptor from './Decryptor';
import Encryptor from './Encryptor';
import './App.css'

const Home = () => {
    return (
        <div className="font-sans sm:font-serif md:font-mono lg:font-sans xl:font-serif flex flex-col items-center justify-center min-h-screen bg-gradient-to-r from-pink-200 via-blue-200 to-purple-200">
            <h1 className="mb-6 text-3xl font-bold text-gray-900">Off-chain Project Capabilities</h1>
            <Link to="/feedback-summary" className="w-full max-w-xs px-4 py-2 mb-4 text-2xl font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600">
                Comparative Feedback
            </Link>
            <Link to="/decryptor" className="w-full max-w-xs px-4 py-2 mb-4 text-2xl font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600">
                Decryptor Page
            </Link>
            <Link to="/encryptor" className="w-full max-w-xs px-4 py-2 text-2xl font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600">
                Encryptor Page
            </Link>
        </div>
    );
};

const App = () => {
    return (
        <Router>
            <Routes>
                <Route path="/" element={<Home />} />
                <Route path="feedback-summary" element={<FeedbackSummary />} />
                <Route path="/decryptor" element={<Decryptor />} />
                <Route path="/encryptor" element={<Encryptor />} />
            </Routes>
        </Router>
    );
};

export default App;