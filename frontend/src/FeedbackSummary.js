import React, { useState } from 'react';
import axios from 'axios';

const FeedbackSummary = () => {
    const [applicantId, setApplicantId] = useState('');
    const [summary, setSummary] = useState('');

    const handleChange = (event) => {
        setApplicantId(event.target.value);
    };

    const handleSubmit = (event) => {
        event.preventDefault();
        // Replace with your server API endpoint
        axios.post('http://localhost:5000/api/feedbackGenerator', { applicantId })
            .then(res => {
                console.log(res.data)
                setSummary(res.data);
            })
            .catch(err => console.error(err));
    };

    return (
        <div>
            <h1>Feedback Summary</h1>
            <form onSubmit={handleSubmit}>
                <label>
                    Applicant ID:
                    <input type="text" value={applicantId} onChange={handleChange} />
                </label>
                <input type="submit" value="Generate Summary" />
            </form>
            {summary && (
                <div>
                    <h2>Summary:</h2>
                    <p>{summary.split('\n').map((line, i) => <React.Fragment key={i}>{line}<br /></React.Fragment>)}</p>
                </div>
            )}
        </div>
    );
};

export default FeedbackSummary;
