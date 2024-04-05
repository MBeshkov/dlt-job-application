import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import FeedbackSummary from './FeedbackSummary';
import Applicant from './Applicant';
import Employer from './Employer';

const App = () => {
    return (
        <Router>
            <Routes> {/* Wrap all your Route components inside Routes */}
                <Route path="/" element={<FeedbackSummary />} />
                <Route path="/applicant" element={<Applicant />} />
                <Route path="/employer" element={<Employer />} />
            </Routes>
        </Router>
    );
};

export default App;
