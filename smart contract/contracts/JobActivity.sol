pragma solidity ^0.4.17;

contract JobActivity {
    struct questionnaireLink {
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }
    
    struct questionnaireRecord {
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    struct interviewLink {
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    struct interviewRecord {
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    struct interviewFeedback {
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    address public employer;
    mapping(address => string) private publicKeys; // Mapping to store public keys
    mapping(address => questionnaireLink) private questionnaireLinks; // Individual questionnaire links
    mapping(address => questionnaireRecord) private completedQuestionnaires;
    mapping(address => string) private questionnaireFeedbacks; // Mapping for questionnaire feedbacks
    mapping(address => interviewLink) private interviewLinks; // Individual interview links
    mapping(address => interviewRecord) private completedInterviews;
    mapping(address => interviewFeedback) private interviewFeedbacks; // Mapping for interview feedbacks
    mapping(address => bool) private applicantsWhoHaveAttemptedQuestionnaire;
    mapping(address => bool) private applicantsWhoHaveAttemptedInterview;
    mapping(address => uint256) private applicantIndexQuestionnaire;
    mapping(address => uint256) private applicantIndexInterview;
    address[] private shortlistedApplicants;
    address[] private testedApplicants;
    address[] private interviewedApplicants;
    uint256 public passScore = 0;

    modifier onlyEmployer() {
        require(msg.sender == employer);
        _;
    }

    modifier onlyShortlistedApplicant() {
        bool isShortlisted = false;
        for (uint256 i = 0; i < shortlistedApplicants.length; i++) {
            if (shortlistedApplicants[i] == msg.sender) {
                isShortlisted = true;
                break;
            }
        }
        require(isShortlisted);
        _;
    }

    modifier onlyShortlistedApplicantOrEmployer() {
        bool isShortlisted = false;
        for (uint256 i = 0; i < shortlistedApplicants.length; i++) {
            if (shortlistedApplicants[i] == msg.sender) {
                isShortlisted = true;
                break;
            }
        }
        require(isShortlisted || msg.sender == employer);
        _;
    }

    function JobActivity() public {
        employer = msg.sender;
    }

    function structSetter(
        address _applicantAddress,
        string _secret,
        string _encryptedKey,
        string _nonce,
        string _tag,
        string _mappingName
    ) private onlyShortlistedApplicantOrEmployer {
        if (sha3(_mappingName) == sha3("questionnaireLinks")) {
            questionnaireLinks[_applicantAddress] = questionnaireLink(_secret, _encryptedKey, _nonce, _tag);
        } else if (sha3(_mappingName) == sha3("interviewLinks")) {
            interviewLinks[_applicantAddress] = interviewLink(_secret, _encryptedKey, _nonce, _tag);
        } else if (sha3(_mappingName) == sha3("interviewFeedbacks")) {
            interviewFeedbacks[_applicantAddress] = interviewFeedback(_secret, _encryptedKey, _nonce, _tag);
        } else if (sha3(_mappingName) == sha3("completedQuestionnaires")) {
            completedQuestionnaires[_applicantAddress] = questionnaireRecord(_secret, _encryptedKey, _nonce, _tag);
        } else if (sha3(_mappingName) == sha3("completedInterviews")) {
            completedInterviews[_applicantAddress] = interviewRecord(_secret, _encryptedKey, _nonce, _tag);
        } else {
            revert();
        }
    }

    function structGetter(
        string _mappingName,
        address _address
    ) private view onlyShortlistedApplicant returns (string, string, string, string) {
        if (sha3(_mappingName) == sha3("questionnaireLinks")) {
            questionnaireLink memory questionnaireStruct = questionnaireLinks[_address];
            return (questionnaireStruct.secret, questionnaireStruct.encryptedKey, questionnaireStruct.nonce, questionnaireStruct.tag);
        } else if (sha3(_mappingName) == sha3("interviewLinks")) {
            interviewLink memory interviewStruct = interviewLinks[_address];
            return (interviewStruct.secret, interviewStruct.encryptedKey, interviewStruct.nonce, interviewStruct.tag);
        } else if (sha3(_mappingName) == sha3("interviewFeedbacks")) {
            interviewFeedback memory intFeedbackStruct = interviewFeedbacks[_address];
            return (intFeedbackStruct.secret, intFeedbackStruct.encryptedKey, intFeedbackStruct.nonce, intFeedbackStruct.tag);
        } else if (sha3(_mappingName) == sha3("completedQuestionnaires")) {
            questionnaireRecord memory questRecStruct = completedQuestionnaires[_address];
            return (questRecStruct.secret, questRecStruct.encryptedKey, questRecStruct.nonce, questRecStruct.tag);
        } else if (sha3(_mappingName) == sha3("completedInterviews")) {
            interviewRecord memory intRecStruct = completedInterviews[_address];
            return (intRecStruct.secret, intRecStruct.encryptedKey, intRecStruct.nonce, intRecStruct.tag);
        } else {
            revert();
        }
    }

    function addShortlistedApplicant(address _applicantAddress)
        public
        onlyEmployer
    {
        shortlistedApplicants.push(_applicantAddress);
    }

    function addMultipleShortlistedApplicants(address[] memory _applicantAddresses)
        public
        onlyEmployer
    {
    for (uint i = 0; i < _applicantAddresses.length; i++) {
        shortlistedApplicants.push(_applicantAddresses[i]);
    }
    }

    function getShortlistedApplicants()
        public
        view
        onlyEmployer
        returns (address[])
    {
        return shortlistedApplicants;
    }

    function setPublicKey(string _publicKey)
        public onlyShortlistedApplicantOrEmployer {
        publicKeys[msg.sender] = _publicKey;
    }

    function getPublicKey(address _entityAddress) public view returns (string) {
        return publicKeys[_entityAddress];
    }

    function getEmployerPublicKey() public onlyShortlistedApplicant view returns (string) {
        return publicKeys[employer];
    }

    function getOwnPublicKey() public view returns (string) {
        return publicKeys[msg.sender];
    }

    function setQuestionnaireLink(
        address _applicantAddress,
        string _questionnaireLink,
        string _encryptedKey,
        string _nonce,
        string _tag
    ) public onlyEmployer {
        string memory name = "questionnaireLinks";
        structSetter(_applicantAddress, _questionnaireLink, _encryptedKey, _nonce, _tag, name);
    }

    function getQuestionnaireLink()
        public
        view
        onlyShortlistedApplicant
        returns (string, string, string, string)
    {
        string memory name = "questionnaireLinks";
        address _address = msg.sender;
        return structGetter(name, _address);
    }

    function completeQuestionnaire(string _completedFormLink, string _encryptedKey, string _tag, string _nonce, uint256 _score)
        public
        onlyShortlistedApplicant
    {
        address applicant = msg.sender;
        require(msg.sender != employer);
        require(applicantIndexQuestionnaire[msg.sender] == 0);

        if (applicantsWhoHaveAttemptedQuestionnaire[msg.sender]) {
            revert();
        }       
        string memory autoFeedback = "No feedback available presently.";
        if (_score >= passScore) {
            autoFeedback = "You proceed to the next stage!";
        } else {
            autoFeedback = "Unfortunately, we will not be able to proceed you further.";
        }

        testedApplicants.push(applicant);
        applicantIndexQuestionnaire[applicant] = testedApplicants.length;
        applicantsWhoHaveAttemptedQuestionnaire[applicant] = true;
        questionnaireFeedbacks[applicant] = autoFeedback;

        string memory name = "completedQuestionnaires";
        structSetter(applicant, _completedFormLink, _encryptedKey, _nonce, _tag, name);  
    }

    function getQuestionnaireFeedback()
        public
        view
        onlyShortlistedApplicant
        returns (string)
    {
        return questionnaireFeedbacks[msg.sender];
    }

    function setInterviewLink(
        address _applicantAddress,
        string _interviewLink,
        string _encryptedKey,
        string _nonce,
        string _tag
    ) public  onlyEmployer {
        string memory name = "interviewLinks";
        structSetter(_applicantAddress, _interviewLink, _encryptedKey, _nonce, _tag, name);
    }

    function getInterviewLink()
        public
        view
        onlyShortlistedApplicant
        returns (string, string, string, string)
    {
        string memory name = "interviewLinks";
        address _address = msg.sender;
        return structGetter(name, _address);
    }

    function setInterviewRecord(
        address _applicantAddress,
        string _recordLink,
        string _encryptedKey,
        string _nonce,
        string _tag
    ) public  onlyEmployer {
        string memory name = "completedInterviews";
        structSetter(_applicantAddress, _recordLink, _encryptedKey, _nonce, _tag, name);
        applicantsWhoHaveAttemptedInterview[_applicantAddress] = true;
        interviewedApplicants.push(_applicantAddress);
        applicantIndexInterview[_applicantAddress] = interviewedApplicants.length;
    }

    function getInterviewRecord()
        public
        view
        onlyShortlistedApplicant
        returns (string, string, string, string)
    {
        string memory name = "completedInterviews";
        address _address = msg.sender;
        return structGetter(name, _address);
    }

    function setInterviewFeedback(
        address _applicantAddress,
        string _feedback,
        string _encryptedKey,
        string _nonce,
        string _tag
    ) public onlyEmployer {
      string memory name = "interviewFeedbacks";
      structSetter(_applicantAddress, _feedback, _encryptedKey, _nonce, _tag, name);
    }
    
    function getInterviewFeedback()
        public
        view
        onlyShortlistedApplicant
        returns (string, string, string, string)
    {
        string memory name = "interviewFeedbacks";
        address _address = msg.sender;
        return structGetter(name, _address);
    }

    function setPassScore(uint256 _score) public onlyEmployer {
        passScore = _score;
    }

    function getPassScore() public view returns (uint256) {
        return passScore;
    }

    function getApplicantAtAddress(address _applicantAddress)
        public
        view
        onlyEmployer
        returns (
            string,
            string,
            string,
            string,
            string
        )
    {
        return (
            publicKeys[_applicantAddress],
            questionnaireFeedbacks[_applicantAddress],
            completedQuestionnaires[_applicantAddress].secret,
            completedInterviews[_applicantAddress].secret,
            interviewFeedbacks[_applicantAddress].secret
        );
    }

    function getApplicantsCount() public view onlyEmployer returns (uint256) {
        return testedApplicants.length + interviewedApplicants.length;
    }
}
