
from g4f.client import Client
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi



def generate_summary(current_applicant_address):

    uri = "mongodb+srv://mihailbeshkov6:n7wSFv55BZdYr7wl@dlt-project.pgxwqng.mongodb.net/?retryWrites=true&w=majority&appName=DLT-Project"

    # Create a new client and connect to the server
    dbClient = MongoClient(uri, server_api=ServerApi('1'))
    mydb = dbClient["sample-job-posting"]
    mycol = mydb["feedbacks"]

    mydoc = mycol.find({},{ "_id": 0})

    feedbacks = []

    for x in mydoc:

        try:
            y = x["feedback"]
            feedbacks.append(y)
        except Exception as e:
            print(e)


    client = Client()

    current_applicant_feedback = ""

    query = {"applicant": current_applicant_address}
    feedback_to_be_considered = mycol.find(query)
    for x in feedback_to_be_considered: 
        current_applicant_feedback += x["feedback"]

    filtered_feedbacks = [feedb for feedb in feedbacks if feedb != current_applicant_feedback]
    comparison_base = ', '.join(filtered_feedbacks)
    
    prompt = "1. This is my feedback from a prospective employer for my application to a role at their company: " + current_applicant_feedback + "\n 2. What is written next is a collection of the feedback pieces that other applicants received from the same employer about their applications to the same role:" + comparison_base + "\n 3. Please summarise to me what strengths I demonstrated that other applicants did not (if any). Also about areas where other applicants performed better than I did (if any). Under no circumstance are you to mention other applicants' names or identifiers."
    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are a helpful HR representative who is supposed to provide comparative feedback to job applicants. Please prioritise that you avoid mentioning applicant names or unique names or identifiers in your response (for example never say \"Applicant 0x583031D1113aD414F02576BD6afaBfb302140225\", always say \"another applicant\"). Focus on making a comparison between the user requesting the prompt and other applicants, both in regards to strengths and weaknesses."},
            {"role": "user", "content": prompt}
        ]
    )

    return(response.choices[0].message.content)

# generate_summary(mycol, "0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB")