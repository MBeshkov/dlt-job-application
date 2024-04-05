pragma solidity ^0.4.17;

contract JobActivity {

    struct Applicant {
        address applicantAddress;
        string completedFormLink;
        uint score;
    }

    address public employer;
    mapping(address => string) private questionnaireLinks;   // Individual questionnaire links
    mapping(address => string) private interviewLinks;       // Individual interview links
    mapping(address => string) private publicKeyMapping;     // Mapping to store public keys
    mapping(address => string) private questionFeedbacks;    // Mapping for questionnaire feedbacks
    mapping(address => string) private interviewFeedbacks;   // Mapping for interview feedbacks
    mapping(address => string) private symmetricKeyMapping;   // Mapping for interview feedbacks
    Applicant[] private testedApplicants;
    mapping (address => bool) private applicantsWhoHaveAttempted;
    mapping(address => uint) private applicantIndex;
    address[] private shortlistedApplicants;
    uint private passScore = 0;

    event ShortlistedApplicantAdded(address applicant);
    event QuestionnaireLinkSet(address applicant, string qlink);
    event InterviewLinkSet(address applicant, string ilink);
    event AssessmentCompleted(address applicant, string link, uint score, string questionFeedback);
    event SymmetricKeySet(address applicant, string key);
    event PublicKeySet(address indexed applicant);

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

    function addShortlistedApplicant(address _applicantAddress, string _publicKey) public onlyEmployer {
        shortlistedApplicants.push(_applicantAddress);
        publicKeyMapping[_applicantAddress] = _publicKey;
        ShortlistedApplicantAdded(_applicantAddress);
    }

    function getShortlistedApplicants() public view onlyEmployer returns (address[]) {
        return shortlistedApplicants;
    }

    function setQuestionnaireLink(address _applicantAddress, string _questionnaireLink) public onlyEmployer {
        questionnaireLinks[_applicantAddress] = _questionnaireLink;
        QuestionnaireLinkSet(_applicantAddress, _questionnaireLink);
    }

    function setSymmetricKey(address _applicantAddress, string _symmetricKey) public onlyEmployer {
        symmetricKeyMapping[_applicantAddress] = _symmetricKey;
        SymmetricKeySet(_applicantAddress, _symmetricKey);
    }

    function setPublicKey() public  {
        // publicKeyMapping[msg.sender] = _publicKey;
        PublicKeySet(msg.sender);
    }

    function updatePublicKey(address _applicant, string _publicKey) public {
        publicKeyMapping[_applicant] = _publicKey;
    }

    function getSymmetricKey() public view onlyShortlistedApplicant returns (string) {
        return symmetricKeyMapping[msg.sender];
    }

    function getPublicKey(address _entityAddress) public view returns (string) {
        return publicKeyMapping[_entityAddress];
    }

    function getOwnPublicKey() public view onlyShortlistedApplicant returns (string) {
        return publicKeyMapping[msg.sender];
    }
    
    function getApplicantKeys(address _applicantAddress) public view onlyEmployer returns (string, string){
        return (symmetricKeyMapping[_applicantAddress], publicKeyMapping[_applicantAddress]);
    }

    function setInterviewLink(address _applicantAddress, string _interviewLink) public onlyEmployer {
        interviewLinks[_applicantAddress] = _interviewLink;
        InterviewLinkSet(_applicantAddress, _interviewLink);
    }

    function setInterviewFeedback(address _applicantAddress, string _interviewFeedback) public onlyEmployer {
        interviewFeedbacks[_applicantAddress] = _interviewFeedback;
    }

    function setPassScore(uint _score) public onlyEmployer {
        passScore = _score;
    }

    function getPassScore() public view returns (uint) {
        return passScore;
    }

    function getQuestionnaireLink() public view onlyShortlistedApplicant returns (string) {
        return questionnaireLinks[msg.sender];
    }

    function getInterviewLink() public view onlyShortlistedApplicant returns (string) {
        return interviewLinks[msg.sender];
    }

    function completeQuestionnaire(string _completedFormLink, uint _score) public onlyShortlistedApplicant {
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
            score: _score
        });

        testedApplicants.push(newApplicant);
        applicantIndex[msg.sender] = testedApplicants.length;
        applicantsWhoHaveAttempted[msg.sender] = true;
        questionFeedbacks[msg.sender] = autoFeedback;
        AssessmentCompleted(msg.sender, _completedFormLink, _score, autoFeedback);
    }

    function getApplicantResponse(address _applicantAddress) public view onlyEmployer returns (string, uint, string) {
        require(applicantIndex[_applicantAddress] != 0);

        Applicant storage applicant = testedApplicants[applicantIndex[_applicantAddress] - 1];
        return (applicant.completedFormLink, applicant.score, questionFeedbacks[_applicantAddress]);
    }

    function getApplicantsCount() public view onlyEmployer returns (uint) {
        return testedApplicants.length;
    }

    function getApplicantAtIndex(uint _index) public view onlyEmployer returns (address, string, uint, string, string) {
        require(_index < testedApplicants.length);

        Applicant storage applicant = testedApplicants[_index];
        return (applicant.applicantAddress, applicant.completedFormLink, applicant.score, questionFeedbacks[applicant.applicantAddress], interviewFeedbacks[applicant.applicantAddress]);
    }

    function getQuestionnaireFeedback() public view onlyShortlistedApplicant returns (string) {
        return questionFeedbacks[msg.sender];
    }

    function getInterviewFeedback() public view onlyShortlistedApplicant returns (string) {
        return interviewFeedbacks[msg.sender];
    }

}
