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

    struct ApplicationFeedback {
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    enum ApplicationStage {
        Shortlisted,
        Questionnaire,
        Interview,
        UnderConsideration,
        NoLongerConsidered,
        Offer,
        Hired
    }

    enum MappingType {
        questionnaireLinks,
        interviewLinks,
        interviewFeedbacks,
        completedQuestionnaires,
        completedInterviews,
        applicationFeedbacks
    }

    address public employer;
    mapping(address => string) private publicKeys;
    mapping(address => QuestionnaireLink) private questionnaireLinks;
    mapping(address => QuestionnaireRecord) private completedQuestionnaires;
    mapping(address => string) private questionnaireFeedbacks;
    mapping(address => InterviewLink) private interviewLinks;
    mapping(address => InterviewRecord) private completedInterviews;
    mapping(address => InterviewFeedback) private interviewFeedbacks;
    mapping(address => ApplicationFeedback) private applicationFeedbacks;
    mapping(address => bool) private applicantsWhoHaveAttemptedQuestionnaire;
    mapping(address => bool) private applicantsWhoHaveAttemptedInterview;
    mapping(address => uint256) private applicantIndexQuestionnaire;
    mapping(address => uint256) private applicantIndexInterview;
    mapping(address => ApplicationStage) private applicantStages;
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
        require(
            isShortlisted,
            "Only shortlisted applicant can call this function"
        );
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
        require(
            isShortlisted || msg.sender == employer,
            "Only shortlisted applicant or employer can call this function"
        );
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
        uint256 _mappingType
    ) private onlyShortlistedApplicantOrEmployer {
        if (_mappingType == 0) {
            questionnaireLinks[_applicantAddress] = QuestionnaireLink(
                _secret,
                _encryptedKey,
                _nonce,
                _tag
            );
        } else if (_mappingType == 1) {
            interviewLinks[_applicantAddress] = InterviewLink(
                _secret,
                _encryptedKey,
                _nonce,
                _tag
            );
        } else if (_mappingType == 2) {
            interviewFeedbacks[_applicantAddress] = InterviewFeedback(
                _secret,
                _encryptedKey,
                _nonce,
                _tag
            );
        } else if (_mappingType == 3) {
            completedQuestionnaires[_applicantAddress] = QuestionnaireRecord(
                _secret,
                _encryptedKey,
                _nonce,
                _tag
            );
        } else if (_mappingType == 4) {
            completedInterviews[_applicantAddress] = InterviewRecord(
                _secret,
                _encryptedKey,
                _nonce,
                _tag
            );
        } else if (_mappingType == 5) {
            applicationFeedbacks[_applicantAddress] = ApplicationFeedback(
                _secret,
                _encryptedKey,
                _nonce,
                _tag
            );
        } else {
            revert("Invalid mapping name");
        }
    }

    function structGetter(uint256 _mappingType, address _address)
        private
        view
        onlyShortlistedApplicantOrEmployer
        returns (
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        if (_mappingType == 0) {
            QuestionnaireLink memory questionnaireStruct = questionnaireLinks[
                _address
            ];
            return (
                questionnaireStruct.secret,
                questionnaireStruct.encryptedKey,
                questionnaireStruct.nonce,
                questionnaireStruct.tag
            );
        } else if (_mappingType == 1) {
            InterviewLink memory interviewStruct = interviewLinks[_address];
            return (
                interviewStruct.secret,
                interviewStruct.encryptedKey,
                interviewStruct.nonce,
                interviewStruct.tag
            );
        } else if (_mappingType == 2) {
            InterviewFeedback memory intFeedbackStruct = interviewFeedbacks[
                _address
            ];
            return (
                intFeedbackStruct.secret,
                intFeedbackStruct.encryptedKey,
                intFeedbackStruct.nonce,
                intFeedbackStruct.tag
            );
        } else if (_mappingType == 3) {
            QuestionnaireRecord memory questRecStruct = completedQuestionnaires[
                _address
            ];
            return (
                questRecStruct.secret,
                questRecStruct.encryptedKey,
                questRecStruct.nonce,
                questRecStruct.tag
            );
        } else if (_mappingType == 4) {
            InterviewRecord memory intRecStruct = completedInterviews[_address];
            return (
                intRecStruct.secret,
                intRecStruct.encryptedKey,
                intRecStruct.nonce,
                intRecStruct.tag
            );
        } else if (_mappingType == 5) {
            ApplicationFeedback memory appCompStruct = applicationFeedbacks[
                _address
            ];
            return (
                appCompStruct.secret,
                appCompStruct.encryptedKey,
                appCompStruct.nonce,
                appCompStruct.tag
            );
        } else {
            revert("Invalid mapping name");
        }
    }

    function stageToString(ApplicationStage stage)
        internal
        pure
        returns (string memory)
    {
        if (stage == ApplicationStage.Shortlisted) {
            return "Shortlisted";
        } else if (stage == ApplicationStage.Questionnaire) {
            return "Questionnaire";
        } else if (stage == ApplicationStage.Interview) {
            return "Interview";
        } else if (stage == ApplicationStage.UnderConsideration) {
            return "Under Consideration";
        } else if (stage == ApplicationStage.NoLongerConsidered) {
            return "No Longer Considered";
        } else if (stage == ApplicationStage.Offer) {
            return "Offer";
        } else if (stage == ApplicationStage.Hired) {
            return "Hired";
        } else {
            revert("Invalid application stage");
        }
    }

    function addShortlistedApplicant(address _applicantAddress)
        public
        onlyEmployer
    {
        applicantStages[_applicantAddress] = ApplicationStage.Shortlisted;
        shortlistedApplicants.push(_applicantAddress);
    }

    function addMultipleShortlistedApplicants(
        address[] memory _applicantAddresses
    ) public onlyEmployer {
        for (uint256 i = 0; i < _applicantAddresses.length; i++) {
            applicantStages[_applicantAddresses[i]] = ApplicationStage
                .Shortlisted;
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

    function setPublicKey(string memory _publicKey)
        public
        onlyShortlistedApplicantOrEmployer
    {
        publicKeys[msg.sender] = _publicKey;
    }

    function getPublicKey(address _entityAddress)
        public
        view
        returns (string memory)
    {
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
        uint256 mappingType = 0;
        structSetter(
            _applicantAddress,
            _questionnaireLink,
            _encryptedKey,
            _nonce,
            _tag,
            mappingType
        );
        applicantStages[_applicantAddress] = ApplicationStage.Questionnaire;
    }

    function setPassScore(uint256 _score) public onlyEmployer {
        passScore = _score;
    }

    function getPassScore() public view returns (uint256) {
        return passScore;
    }

    function getQuestionnaireLink()
        public
        view
        onlyShortlistedApplicant
        returns (
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        uint256 mappingType = 0;
        address _address = msg.sender;
        return structGetter(mappingType, _address);
    }

    function completeQuestionnaire(
        string memory _completedFormLink,
        string memory _encryptedKey,
        string memory _tag,
        string memory _nonce,
        uint256 _score
    ) public onlyShortlistedApplicant {
        address applicant = msg.sender;
        require(
            msg.sender != employer,
            "Employer cannot complete questionnaire"
        );
        require(
            applicantIndexQuestionnaire[msg.sender] == 0,
            "Questionnaire already completed"
        );

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

        uint256 mappingType = 3;
        structSetter(
            applicant,
            _completedFormLink,
            _encryptedKey,
            _nonce,
            _tag,
            mappingType
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
        require(
            applicantStages[_applicantAddress] ==
                ApplicationStage.Questionnaire,
            "Applicant must be in questionnaire stage"
        );
        uint256 mappingType = 1;
        structSetter(
            _applicantAddress,
            _interviewLink,
            _encryptedKey,
            _nonce,
            _tag,
            mappingType
        );
        applicantStages[_applicantAddress] = ApplicationStage.Interview;
    }

    function getInterviewLink()
        public
        view
        onlyShortlistedApplicant
        returns (
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        uint256 mappingType = 1;
        address _address = msg.sender;
        return structGetter(mappingType, _address);
    }

    function setInterviewRecord(
        address _applicantAddress,
        string memory _recordLink,
        string memory _encryptedKey,
        string memory _nonce,
        string memory _tag
    ) public onlyEmployer {
        require(
            applicantStages[_applicantAddress] == ApplicationStage.Interview,
            "Applicant must be in interview stage"
        );
        uint256 mappingType = 4;
        structSetter(
            _applicantAddress,
            _recordLink,
            _encryptedKey,
            _nonce,
            _tag,
            mappingType
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
        returns (
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        uint256 mappingType = 4;
        address _address = msg.sender;
        return structGetter(mappingType, _address);
    }

    function setInterviewFeedback(
        address _applicantAddress,
        string memory _feedback,
        string memory _encryptedKey,
        string memory _nonce,
        string memory _tag
    ) public onlyEmployer {
        require(
            applicantStages[_applicantAddress] == ApplicationStage.Interview,
            "Applicant must be in interview stage"
        );
        uint256 mappingType = 2;
        structSetter(
            _applicantAddress,
            _feedback,
            _encryptedKey,
            _nonce,
            _tag,
            mappingType
        );
        applicantStages[_applicantAddress] = ApplicationStage
            .UnderConsideration;
    }

    function getInterviewFeedback()
        public
        view
        onlyShortlistedApplicant
        returns (
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        uint256 mappingType = 2;
        address _address = msg.sender;
        return structGetter(mappingType, _address);
    }

    function setApplicationFeedback(
        address _applicantAddress,
        ApplicationStage _newStage,
        string memory _feedback,
        string memory _encryptedKey,
        string memory _nonce,
        string memory _tag
    ) public onlyEmployer {
        require(
            applicantStages[_applicantAddress] != _newStage,
            "Applicant already in this stage"
        );
        if (
            _newStage == ApplicationStage.NoLongerConsidered ||
            _newStage == ApplicationStage.Offer
        ) {
            applicantStages[_applicantAddress] = _newStage;
        } else {
            revert("Invalid application stage transition");
        }
        uint256 mappingType = 5;
        structSetter(
            _applicantAddress,
            _feedback,
            _encryptedKey,
            _nonce,
            _tag,
            mappingType
        );
    }

    function setToHired(
        address _applicantAddress
    ) public onlyEmployer{
        require(
            applicantStages[_applicantAddress] == ApplicationStage.Offer,
            "Applicant has not received an offer"
        );
        applicantStages[_applicantAddress] = ApplicationStage.Hired;
    }

    function getApplicantStage(address _applicantAddress)
        public
        view
        onlyEmployer
        returns (string memory)
    {
        return stageToString(applicantStages[_applicantAddress]);
    }

    function getApplicationFeedback()
        public
        view
        onlyShortlistedApplicant
        returns (
            string memory,
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        uint256 mappingType = 5;
        address _address = msg.sender;
        (
            string memory feedback,
            string memory key,
            string memory nonce,
            string memory tag
        ) = structGetter(mappingType, _address);
        return (
            feedback,
            key,
            nonce,
            tag,
            stageToString(applicantStages[msg.sender])
        );
    }

    function getCurrentStage()
        public
        view
        onlyShortlistedApplicant
        returns (string memory)
    {
        return stageToString(applicantStages[msg.sender]);
    }

    function getApplicantAtAddress(address _applicantAddress)
        public
        view
        onlyEmployer
        returns (
            string memory publickey,
            string memory stage,
            QuestionnaireRecord memory questionnaireRecord,
            InterviewRecord memory interviewRecord,
            InterviewFeedback memory interviewFeedback,
            ApplicationFeedback memory applicationFeedback
        )
    {
        return (
            publicKeys[_applicantAddress],
            stageToString(applicantStages[_applicantAddress]),
            completedQuestionnaires[_applicantAddress],
            completedInterviews[_applicantAddress],
            interviewFeedbacks[_applicantAddress],
            applicationFeedbacks[_applicantAddress]
        );
    }

    // function getApplicantsCount() public view onlyEmployer returns (uint256) {
    //     return testedApplicants.length + interviewedApplicants.length;
    // }
}
