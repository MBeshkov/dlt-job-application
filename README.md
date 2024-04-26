# Interacting with the smart contract
- To interact and edit the code of the smart contract, one does not need more than to navigate to the the browser IDE Remix at https://remix.ethereum.org/. <br>
- Once on the home screen, please select "Load from Gist" and enter the address https://gist.github.com/MBeshkov/a8301d6b87c0721dfd9b68147635ceec. <br><br>
<img width="685" alt="u15" src="https://github.com/MBeshkov/dlt-job-application/assets/55166408/84d92e07-fe40-4bd3-9c23-610964e059a1"> <br>
- This should immediately modify the workspace and display JobActivity.sol, the contract produced by this honours project. <br><br>
<img width="701" alt="u16" src="https://github.com/MBeshkov/dlt-job-application/assets/55166408/c15985ee-b645-4892-920c-e0e13897d02f"> <br>
- To compile the code in preparation for deployment, one can navigate to the Compiler tab on the left side bar and click on the relevant button. It might also be useful to mark "Auto compile" for an easier workflow.<br><br>
<img width="298" alt="u17" src="https://github.com/MBeshkov/dlt-job-application/assets/55166408/13158bdd-8458-43c4-b30e-7ec2b899b207"><br>
- The tile under compilation is where deployment and all interactions occur. This is where the user can:
  1. Switch test environment if the current one is down
  2. Change accounts for the execution of transactions;
  3. Deploy the contract;
  4. Carry out the contract transactions.<br>
<img width="277" alt="u18" src="https://github.com/MBeshkov/dlt-job-application/assets/55166408/29ebdeba-50df-4077-b708-1a52c4d36505"> <br>
- The console situated on the right of the deployment segment and below the code of the contract, will provide useful information about every transaction - status, identifiers, gas costs, output, etc. <br><br>
  <img width="521" alt="u19" src="https://github.com/MBeshkov/dlt-job-application/assets/55166408/d93e6931-7275-4149-ac13-9548d4346637"><br>
- Finally, the debugger tile provides comprehensive debugging tools that are able to examine breakpoints in the code, but also to replay completed transactions and demonstrate the change of state with every step.<br><br>
  <img width="536" alt="u20" src="https://github.com/MBeshkov/dlt-job-application/assets/55166408/3c79a1a0-4f74-4958-a166-847801daab68">

# Running the web application

https://github.com/MBeshkov/dlt-job-application/assets/55166408/5adb4572-cf2f-49a0-9481-e65dd1ebcf2b

__Prerequisites:__ <br>
- Python 3.x (https://www.python.org/downloads/)
- Node.js and npm (https://nodejs.org/en)

__Steps:__ <br>

1. Clone the repository
`git clone https://github.com/MBeshkov/dlt-job-application.git`

2. Install Back-end Dependencies

- Navigate to the back-end folder:<br>
`cd backend`

- Install the required Python packages listed in `requirements.txt`:<br>
`pip install -r requirements.txt`

3. Install Front-end Dependencies

- Navigate to the front-end folder:<br>
`cd ../frontend`

- Install the required JavaScript packages listed in `package.json`: <br>
`npm install`

4. Run the Back-end Server

- Navigate back to the back-end folder:
`cd ../backend`

- Start the Flask server using the script that acts as the back-end:
`python runHelpers.py`

5. Run the Front-end Application

- Navigate to the front-end folder:
`cd ../frontend`

- Start the React development server:
`npm run start`

Now the back-end server should be running and the front-end application should be accessible at http://localhost:3000.

A note on the database set-up in `backend/comparativeFeedbackGenerator.py`: Currently, there is a connection made with a test MongoDB database belonging to the author of this project. That database is meant to support a university demonstration and is not meant to be a scalable and durable part of the project. The access details provided in the `uri =` line are purposefully left there until this project is assessed in the University of Aberdeen. After that, this line will be deleted and whomever desires to maintain the code will be required to create their own database and include their own uri in the code. For reference how to structure one's collection, please refer to the figure below. The author also recommends that if further work is pursued in this manner, the sensitive information should instead be stored in the form of environment variables. <br> <br>

<img width="762" alt="u21" src="https://github.com/MBeshkov/dlt-job-application/assets/55166408/508a118a-f783-4296-a539-e12bca549fbe">




