// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract JobActivity {
    struct QuestionnaireLink {
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    struct QuestionnaireRecord {
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    struct InterviewLink {
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    struct InterviewRecord {
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    struct InterviewFeedback {
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    address public employer;
    mapping(address => string) private publicKeys; // Mapping to store public keys
    mapping(address => QuestionnaireLink) private questionnaireLinks; // Individual questionnaire links
    mapping(address => QuestionnaireRecord) private completedQuestionnaires;
    mapping(address => string) private questionnaireFeedbacks; // Mapping for questionnaire feedbacks
    mapping(address => InterviewLink) private interviewLinks; // Individual interview links
    mapping(address => InterviewRecord) private completedInterviews;
    mapping(address => InterviewFeedback) private interviewFeedbacks; // Mapping for interview feedbacks
    mapping(address => bool) private applicantsWhoHaveAttemptedQuestionnaire;
    mapping(address => bool) private applicantsWhoHaveAttemptedInterview;
    mapping(address => uint256) private applicantIndexQuestionnaire;
    mapping(address => uint256) private applicantIndexInterview;
    address[] private shortlistedApplicants;
    address[] private testedApplicants;
    address[] private interviewedApplicants;
    uint256 private passScore = 0;

    modifier onlyEmployer() {
        require(msg.sender == employer, "Only employer can call this function");
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
        require(isShortlisted, "Only shortlisted applicant can call this function");
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
        require(isShortlisted || msg.sender == employer, "Only shortlisted applicant or employer can call this function");
        _;
    }

    constructor() {
        employer = msg.sender;
    }

    function structSetter(
        address _applicantAddress,
        string memory _secret,
        string memory _encryptedKey,
        string memory _nonce,
        string memory _tag,
        string memory _mappingName
    ) private onlyShortlistedApplicantOrEmployer {
        if (keccak256(bytes(_mappingName)) == keccak256(bytes("questionnaireLinks"))) {
            questionnaireLinks[_applicantAddress] = QuestionnaireLink(
                _secret,
                _encryptedKey,
                _nonce,
                _tag
            );
        } else if (keccak256(bytes(_mappingName)) == keccak256(bytes("interviewLinks"))) {
            interviewLinks[_applicantAddress] = InterviewLink(
                _secret,
                _encryptedKey,
                _nonce,
                _tag
            );
        } else if (keccak256(bytes(_mappingName)) == keccak256(bytes("interviewFeedbacks"))) {
            interviewFeedbacks[_applicantAddress] = InterviewFeedback(
                _secret,
                _encryptedKey,
                _nonce,
                _tag
            );
        } else if (keccak256(bytes(_mappingName)) == keccak256(bytes("completedQuestionnaires"))) {
            completedQuestionnaires[_applicantAddress] = QuestionnaireRecord(
                _secret,
                _encryptedKey,
                _nonce,
                _tag
            );
        } else if (keccak256(bytes(_mappingName)) == keccak256(bytes("completedInterviews"))) {
            completedInterviews[_applicantAddress] = InterviewRecord(
                _secret,
                _encryptedKey,
                _nonce,
                _tag
            );
        } else {
            revert("Invalid mapping name");
        }
    }

    function structGetter(
        string memory _mappingName,
        address _address
    )
        private
        view
        onlyShortlistedApplicant
        returns (string memory, string memory, string memory, string memory)
    {
        if (keccak256(bytes(_mappingName)) == keccak256(bytes("questionnaireLinks"))) {
            QuestionnaireLink memory questionnaireStruct = questionnaireLinks[
                _address
            ];
            return (
                questionnaireStruct.secret,
                questionnaireStruct.encryptedKey,
                questionnaireStruct.nonce,
                questionnaireStruct.tag
            );
        } else if (keccak256(bytes(_mappingName)) == keccak256(bytes("interviewLinks"))) {
            InterviewLink memory interviewStruct = interviewLinks[_address];
            return (
                interviewStruct.secret,
                interviewStruct.encryptedKey,
                interviewStruct.nonce,
                interviewStruct.tag
            );
        } else if (keccak256(bytes(_mappingName)) == keccak256(bytes("interviewFeedbacks"))) {
            InterviewFeedback memory intFeedbackStruct = interviewFeedbacks[
                _address
            ];
            return (
                intFeedbackStruct.secret,
                intFeedbackStruct.encryptedKey,
                intFeedbackStruct.nonce,
                intFeedbackStruct.tag
            );
        } else if (keccak256(bytes(_mappingName)) == keccak256(bytes("completedQuestionnaires"))) {
            QuestionnaireRecord memory questRecStruct = completedQuestionnaires[
                _address
            ];
            return (
                questRecStruct.secret,
                questRecStruct.encryptedKey,
                questRecStruct.nonce,
                questRecStruct.tag
            );
        } else if (keccak256(bytes(_mappingName)) == keccak256(bytes("completedInterviews"))) {
            InterviewRecord memory intRecStruct = completedInterviews[_address];
            return (
                intRecStruct.secret,
                intRecStruct.encryptedKey,
                intRecStruct.nonce,
                intRecStruct.tag
            );
        } else {
            revert("Invalid mapping name");
        }
    }

    function addShortlistedApplicant(
        address _applicantAddress
    ) public onlyEmployer {
        shortlistedApplicants.push(_applicantAddress);
    }

    function addMultipleShortlistedApplicants(
        address[] memory _applicantAddresses
    ) public onlyEmployer {
        for (uint i = 0; i < _applicantAddresses.length; i++) {
            shortlistedApplicants.push(_applicantAddresses[i]);
        }
    }

    function getShortlistedApplicants()
        public
        view
        onlyEmployer
        returns (address[] memory)
    {
        return shortlistedApplicants;
    }

    function setPublicKey(
        string memory _publicKey
    ) public onlyShortlistedApplicantOrEmployer {
        publicKeys[msg.sender] = _publicKey;
    }

    function getPublicKey(address _entityAddress) public view returns (string memory) {
        return publicKeys[_entityAddress];
    }

    function getEmployerPublicKey()
        public
        view
        onlyShortlistedApplicant
        returns (string memory)
    {
        return publicKeys[employer];
    }

    function getOwnPublicKey() public view returns (string memory) {
        return publicKeys[msg.sender];
    }

    function setQuestionnaireLink(
        address _applicantAddress,
        string memory _questionnaireLink,
        string memory _encryptedKey,
        string memory _nonce,
        string memory _tag
    ) public onlyEmployer {
        string memory name = "questionnaireLinks";
        structSetter(
            _applicantAddress,
            _questionnaireLink,
            _encryptedKey,
            _nonce,
            _tag,
            name
        );
    }

    function getQuestionnaireLink()
        public
        view
        onlyShortlistedApplicant
        returns (string memory, string memory, string memory, string memory)
    {
        string memory name = "questionnaireLinks";
        address _address = msg.sender;
        return structGetter(name, _address);
    }

    function completeQuestionnaire(
        string memory _completedFormLink,
        string memory _encryptedKey,
        string memory _tag,
        string memory _nonce,
        uint256 _score
    ) public onlyShortlistedApplicant {
        address applicant = msg.sender;
        require(msg.sender != employer, "Employer cannot complete questionnaire");
        require(applicantIndexQuestionnaire[msg.sender] == 0, "Questionnaire already completed");

        if (applicantsWhoHaveAttemptedQuestionnaire[msg.sender]) {
            revert("Questionnaire already attempted");
        }
        string memory autoFeedback;
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
        structSetter(
            applicant,
            _completedFormLink,
            _encryptedKey,
            _nonce,
            _tag,
            name
        );
    }

    function getQuestionnaireFeedback()
        public
        view
        onlyShortlistedApplicant
        returns (string memory)
    {
        return questionnaireFeedbacks[msg.sender];
    }

    function setInterviewLink(
        address _applicantAddress,
        string memory _interviewLink,
        string memory _encryptedKey,
        string memory _nonce,
        string memory _tag
    ) public onlyEmployer {
        string memory name = "interviewLinks";
        structSetter(
            _applicantAddress,
            _interviewLink,
            _encryptedKey,
            _nonce,
            _tag,
            name
        );
    }

    function getInterviewLink()
        public
        view
        onlyShortlistedApplicant
        returns (string memory, string memory, string memory, string memory)
    {
        string memory name = "interviewLinks";
        address _address = msg.sender;
        return structGetter(name, _address);
    }

    function setInterviewRecord(
        address _applicantAddress,
        string memory _recordLink,
        string memory _encryptedKey,
        string memory _nonce,
        string memory _tag
    ) public onlyEmployer {
        string memory name = "completedInterviews";
        structSetter(
            _applicantAddress,
            _recordLink,
            _encryptedKey,
            _nonce,
            _tag,
            name
        );
        applicantsWhoHaveAttemptedInterview[_applicantAddress] = true;
        interviewedApplicants.push(_applicantAddress);
        applicantIndexInterview[_applicantAddress] = interviewedApplicants
            .length;
    }

    function getInterviewRecord()
        public
        view
        onlyShortlistedApplicant
        returns (string memory, string memory, string memory, string memory)
    {
        string memory name = "completedInterviews";
        address _address = msg.sender;
        return structGetter(name, _address);
    }

    function setInterviewFeedback(
        address _applicantAddress,
        string memory _feedback,
        string memory _encryptedKey,
        string memory _nonce,
        string memory _tag
    ) public onlyEmployer {
        string memory name = "interviewFeedbacks";
        structSetter(
            _applicantAddress,
            _feedback,
            _encryptedKey,
            _nonce,
            _tag,
            name
        );
    }

    function getInterviewFeedback()
        public
        view
        onlyShortlistedApplicant
        returns (string memory, string memory, string memory, string memory)
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

    function getApplicantAtAddress(
        address _applicantAddress
    )
        public
        view
        onlyEmployer
        returns (string memory, string memory, string memory, string memory, string memory)
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
