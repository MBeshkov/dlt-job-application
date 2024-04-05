import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import FeedbackSummary from './FeedbackSummary';
import Applicant from './Applicant';
import Employer from './Employer';
import './App.css'

const Home = () => {
    return (
        <div className="font-sans sm:font-serif md:font-mono lg:font-sans xl:font-serif flex flex-col items-center justify-center min-h-screen bg-gradient-to-r from-pink-200 via-blue-200 to-purple-200">
            <h1 className="mb-6 text-3xl font-bold text-gray-900">Off-chain Project Capabilities</h1>
            <Link to="/feedback-summary" className="w-full max-w-xs px-4 py-2 mb-4 text-2xl font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600">
                Comparative Feedback
            </Link>
            <Link to="/applicant" className="w-full max-w-xs px-4 py-2 mb-4 text-2xl font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600">
                Applicant Crypto
            </Link>
            <Link to="/employer" className="w-full max-w-xs px-4 py-2 text-2xl font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600">
                Employer Crypto
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
                <Route path="/applicant" element={<Applicant />} />
                <Route path="/employer" element={<Employer />} />
            </Routes>
        </Router>
    );
};

export default App;