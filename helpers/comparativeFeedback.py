
import openai
from g4f.client import Client


feedbacks = [
    "Applicant A performed exceptionally well. Strong communication skills and problem-solving abilities. However, we did not see many examples of effective teamwork capabilities. We are worried about their perfromance in one of our group projects. Nonetheless, their ability to work under pressure was apparent and we believe it is a right fit for the company.",
    "Applicant B needs improvement in technical skills but has good teamwork and leadership qualities. We particularly liked the story about helping their team select the best version of the frontend during a heated disagreement.",
    "Applicant C demonstrated excellent technical skills and creativity. However, we are not at all convinced they would perform well under pressure. In addition, there was a lack of good examples of teamwork and leadership skills.",
]


client = Client()

def generate_summary(feedbacks, current_applicant_index):

    feedback_to_be_considered = feedbacks[current_applicant_index]

    filtered_feedbacks = [feedb for feedb in feedbacks if feedb != feedback_to_be_considered]
    comparison_base = ', '.join(filtered_feedbacks)
    
    prompt = "This is my feedback: " + feedback_to_be_considered + "\nFeedback of all other applicants to the same role:" + comparison_base + "\nPlease provide me a summary about strengths I demonstrated that other applicants did not (if any) but also about areas where I could improve compared to other applicants (if any)."
    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are a helpful HR representative who is supposed to provide comparative feedback to job applicants. Please avoid mentioning applicant names in your response (for example instead of saying \"compared to Applicant A\", say \"compared to another applicant\"). You should also try to exclude any specific examples that an employer might have mentioned about demonstrated strengths or weaknesses, insted focus on what those strenghts and weaknesses are."},
            {"role": "user", "content": prompt}
        ]
    )

    print(response.choices[0].message.content)


generate_summary(feedbacks, 2)