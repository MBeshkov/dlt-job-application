pragma solidity ^0.4.17;

contract JobActivity {

    struct Applicant {
        address applicantAddress;
        string completedFormLink;
        uint score;
        string feedback;
    }

    address public employer;
    string private questionnaireLink;
    Applicant[] private testedApplicants;
    mapping (address => bool) private applicantsWhoHaveAttempted;
    mapping(address => uint) private applicantIndex;
    address[] private shortlistedApplicants;
    uint private passScore = 0;

    event ShortlistedApplicantAdded(address applicant);
    event QuestionnaireLinkSet(string link);
    event AssessmentCompleted(address applicant, string link, uint score, string feedback);

    modifier onlyEmployer(){
        require(msg.sender == employer);
        _;
    }

    modifier onlyShortlistedApplicant() {
        bool isShortlisted = false;
        for (uint i = 0; i < shortlistedApplicants.length; i++) {
            if (shortlistedApplicants[i] == msg.sender) {
                isShortlisted = true;
                break;
            }
        }
        require(isShortlisted);
        _;
    }

    function JobActivity() public {
        employer = msg.sender;
    }

    function addShortlistedApplicant(address applicantAddress) public onlyEmployer {
        shortlistedApplicants.push(applicantAddress);
        ShortlistedApplicantAdded(applicantAddress);
    }

    function getShortlistedApplicants() public view onlyEmployer returns (address[]) {
        return shortlistedApplicants;
    }

    function setQuestionnaireLink(string _questionnaireLink) public onlyEmployer {
        questionnaireLink = _questionnaireLink;
        QuestionnaireLinkSet(_questionnaireLink);
    }

    function setPassScore(uint _score) public onlyEmployer {
        passScore = _score;
    }

    function getPassScore() public view onlyShortlistedApplicant returns (uint) {
        return passScore;
    }

    function getQuestionnaireLink() public view onlyShortlistedApplicant returns (string) {
        return questionnaireLink;
    }

    function complete(string _completedFormLink, uint _score) public onlyShortlistedApplicant {
        require(msg.sender != employer);
        require(applicantIndex[msg.sender] == 0);
        if (applicantsWhoHaveAttempted[msg.sender]){
            revert();
        }

        string memory autoFeedback = "No feedback available presently.";
        if (_score >= passScore) {
            autoFeedback = "You proceed to the next stage!";
        } else {
            autoFeedback = "Unfortunately, we will not be able to proceed you further.";
        }

        Applicant memory newApplicant = Applicant({
            applicantAddress: msg.sender,
            completedFormLink: _completedFormLink,
            score: _score,
            feedback: autoFeedback

        });

        testedApplicants.push(newApplicant);
        applicantIndex[msg.sender] = testedApplicants.length;
        applicantsWhoHaveAttempted[msg.sender] = true;
        AssessmentCompleted(msg.sender, _completedFormLink, _score, autoFeedback);
}
    
    function getApplicantResponse(address applicantAddress) public view onlyEmployer returns (string, uint, string) {
        require(applicantIndex[applicantAddress] != 0);

        Applicant storage applicant = testedApplicants[applicantIndex[applicantAddress] - 1];
        return (applicant.completedFormLink, applicant.score, applicant.feedback);
    }

    function getApplicantsCount() public view onlyEmployer returns (uint) {
        return testedApplicants.length;
    }

    function getApplicantAtIndex(uint index) public view onlyEmployer returns (address, string, uint, string) {
        require(index < testedApplicants.length);

        Applicant storage applicant = testedApplicants[index];
        return (applicant.applicantAddress, applicant.completedFormLink, applicant.score, applicant.feedback);
    }

    function getFeedback() public view onlyShortlistedApplicant returns (string) {
        require(applicantIndex[msg.sender] != 0);

        Applicant storage applicant = testedApplicants[applicantIndex[msg.sender] - 1];
        return applicant.feedback;
    }

}

