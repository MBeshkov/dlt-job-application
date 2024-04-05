import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import FeedbackSummary from './FeedbackSummary';
import Applicant from './Applicant';
import Employer from './Employer';
import './App.css'

const Home = () => {
    return (
        <div>
            <h1>Welcome to the Home Page</h1>
            <Link to="/feedback-summary" className="inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-purple-500 rounded shadow ripple hover:shadow-lg hover:bg-purple-600 focus:outline-none">
                Comparative Feedback
            </Link>
            <Link to="/applicant" className="inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-purple-500 rounded shadow ripple hover:shadow-lg hover:bg-purple-600 focus:outline-none">
                Applicant Crypto
            </Link>
            <Link to="/employer" className="inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-purple-500 rounded shadow ripple hover:shadow-lg hover:bg-purple-600 focus:outline-none">
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
