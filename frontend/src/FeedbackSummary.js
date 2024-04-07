import React, { useState } from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';

const FeedbackSummary = () => {
    const [applicantId, setApplicantId] = useState('');
    const [summary, setSummary] = useState('');
    const [loading, setLoading] = useState(false);

    const handleChange = (event) => {
        setApplicantId(event.target.value);
    };

    const handleSubmit = (event) => {
        event.preventDefault();
        setLoading(true);
        axios.post('http://localhost:5000/backend/feedbackGenerator', { applicantId })
            .then(res => {
                console.log(res.data)
                setSummary(res.data);
                setLoading(false);
            })
            .catch(err => {
                console.error(err);
                setLoading(false);
            });
    };

    return (
        <div className="font-sans sm:font-serif md:font-mono lg:font-sans xl:font-serif flex flex-col items-center justify-center min-h-screen bg-gradient-to-r from-pink-200 via-blue-200 to-purple-200">
            <div className="w-full p-4 bg-white rounded shadow mb-6 fixed top-0 flex items-center justify-center">
                <Link to="/" className="mr-4">Home</Link>
                <Link to="/decryptor" className="mr-4">Decryptor</Link>
                <Link to="/encryptor">Encryptor</Link>
            </div>
            <div className="pt-16">
                <h1 className="text-3xl font-bold flex flex-col items-center justify-center text-gray-900 p-8">How did I do compared to others?</h1>
                <form onSubmit={handleSubmit}>
                    <div className="w-200">
                        <div className = "py-3 flex flex-col items-center justify-center">
                            <input type="text" placeholder="Applicant ID" value={applicantId} onChange={handleChange} className='flex flex-col items-center justify-center rounded' />
                        </div>
                        <div className = "flex flex-col items-center justify-center">
                            <input type="submit" value="Generate Summary" className="w-half max-w-xs px-2 py-2 mb-4 text-2s font-bold text-center text-white bg-purple-500 rounded hover:bg-purple-600" />
                        </div>
                    </div>
                </form>
                {loading && <p className="animate-bounce flex flex-col items-center justify-center">Loading...</p>} {/* Add a spinning animation to the loading message */}
                {summary && (
                    <div style={{border: '1px solid black', padding: '10px', textAlign: 'center', maxWidth: '50%', maxHeight: '560px', margin: '0 auto', overflowY: 'scroll', overflowWrap: 'break-word', wordBreak: 'break-word'}}>
                        <h1 className="text-3xl pb-2">Summary:</h1>
                        <p className="text-xl">{summary.split('\n').map((line, i) => <React.Fragment key={i}>{line}<br /></React.Fragment>)}</p>
                    </div>
                )}
                <div className='m-8'>
                </div>
            </div>
        </div>
    );
};

export default FeedbackSummary;
