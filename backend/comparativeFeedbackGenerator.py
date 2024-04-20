from g4f.client import Client
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi


def connect_to_db(uri):
    dbClient = MongoClient(uri, server_api=ServerApi("1"))
    mydb = dbClient["sample-job-posting"]
    mycol = mydb["feedbacks"]
    return mycol


def get_feedbacks(mycol):
    mydoc = mycol.find({}, {"_id": 0})
    feedbacks = []
    for x in mydoc:
        try:
            y = x["feedback"]
            feedbacks.append(y)
        except Exception as e:
            print(e)
    return feedbacks


def get_applicant_feedback(mycol, current_applicant_address):
    query = {"applicant": current_applicant_address}
    feedback_to_be_considered = mycol.find(query)
    current_applicant_feedback = ""
    for x in feedback_to_be_considered:
        current_applicant_feedback += x["feedback"]
    return current_applicant_feedback


def generate_prompt(current_applicant_feedback, feedbacks):
    filtered_feedbacks = [
        feedb for feedb in feedbacks if feedb != current_applicant_feedback
    ]
    comparison_base = ", ".join(filtered_feedbacks)
    prompt = (
        "1. This is my feedback from a prospective employer for my application to a role at their company: "
        + current_applicant_feedback
        + "\n 2. What is written next is a collection of the feedback pieces that other applicants received from the same employer about their applications to the same role:"
        + comparison_base
        + "\n 3. Please summarise to me what strengths I demonstrated that other applicants did not (if any). Also about areas where other applicants performed better than I did (if any). Under no circumstance are you to mention other applicants' names or identifiers."
    )
    return prompt


def generate_summary(current_applicant_address):
    returnStatement = ""
    uri = "mongodb+srv://mihailbeshkov6:n7wSFv55BZdYr7wl@dlt-project.pgxwqng.mongodb.net/?retryWrites=true&w=majority&appName=DLT-Project"

    mycol = connect_to_db(uri)

    if not mycol.find_one({"applicant": current_applicant_address}):
        returnStatement = "Applicant not found"
        return returnStatement

    feedbacks = get_feedbacks(mycol)
    current_applicant_feedback = get_applicant_feedback(
        mycol, current_applicant_address
    )
    prompt = generate_prompt(current_applicant_feedback, feedbacks)

    client = Client()
    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[
            {
                "role": "system",
                "content": 'You are a helpful HR representative who is supposed to provide comparative feedback to job applicants. Please prioritise that you avoid mentioning applicant names or unique names or identifiers in your response (for example never say "Applicant 0x583031D1113aD414F02576BD6afaBfb302140225", always say "another applicant"). Focus on making a comparison between the user requesting the prompt and other applicants, both in regards to strengths and weaknesses.',
            },
            {"role": "user", "content": prompt},
        ],
    )

    returnStatement = response.choices[0].message.content
    return returnStatement
