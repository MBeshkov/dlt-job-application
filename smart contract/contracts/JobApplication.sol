// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;            // helps the compiler decide what is required

contract JobActivity {
    struct QuestionnaireLink {      // represents an access link to an online assessment
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    struct QuestionnaireRecord {    // represents an access link to a completed assessment
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    struct InterviewLink {          // represents an access link to an interview invite
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    struct InterviewRecord {        // represents a link to evidence of an interview, e.g. a text transcript
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    struct InterviewFeedback {      // represents interview feedback, either the text itself, or a link to it
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    struct ApplicationFeedback {    // represents application feedback, either the text itself, or a link to it
        string secret;
        string encryptedKey;
        string nonce;
        string tag;
    }

    enum ApplicationStage {         // the possible stages that an applicant can go through
        Shortlisted,
        Questionnaire,
        Interview,
        UnderConsideration,
        NoLongerConsidered,
        Offer,
        Hired
    }

    enum MappingType {              // the mapping types containing the record structs defined above
        questionnaireLinks,
        interviewLinks,
        interviewFeedbacks,
        completedQuestionnaires,
        completedInterviews,
        applicationFeedbacks
    }

    address public employer; 
    mapping(address => string) private publicKeys; // dictionary with all public keys
    mapping(address => QuestionnaireLink) private questionnaireLinks; // dictionary with all assessment links
    mapping(address => QuestionnaireRecord) private completedQuestionnaires; // dictionary with all completed assessment links
    mapping(address => string) private questionnaireFeedbacks; // dictionary with all assessment feedback records
    mapping(address => InterviewLink) private interviewLinks; // dictionary with all interview links
    mapping(address => InterviewRecord) private completedInterviews; // dictionary with all interview records
    mapping(address => InterviewFeedback) private interviewFeedbacks; // dictionary with all interview feedback records
    mapping(address => ApplicationFeedback) private applicationFeedbacks; // dictionary with all application feedback records
    mapping(address => bool) private shortlistedApplicants; // dictionary with all shortlisted applicants
    mapping(address => bool) private testedApplicants;  // dictionary with applicants that have done their virtual assessments
    mapping(address => bool) private interviewedApplicants; // dictionary with applicants with completed interviews
    mapping(address => ApplicationStage) private applicantStages;   // dictionary with the progress of each applicant
    uint256 private passScore = 0;  // the minimum threshold for the virtual assessment
    string private questionnairePassFeedback;   // the automatic feedback for those who pass the minimum threshold
    string private questionnaireFailFeedback;   // the automatic feedback for those who do not pass the minimum threshold

    modifier onlyEmployer() {                       // used to ensure only employer can invoke certain functions
        require(msg.sender == employer, "Only employer can call this function");
        _;
    }

    modifier onlyShortlistedApplicant() {           // used to ensure only applicants can invoke certain functions
        require(
            shortlistedApplicants[msg.sender],
            "Not a shortlisted applicant"
        );
        _;
    }

    modifier onlyShortlistedApplicantOrEmployer() { // used to ensure only employer or applicants can invoke vertain functions
        require(
            shortlistedApplicants[msg.sender] || msg.sender == employer,
            "Only shortlisted applicant or employer can call this function"
        );
        _;
    }

    constructor() {             // actions to be executed when contract is deployed
        employer = msg.sender;
    }

    function structSetter(      // helper function that defines the behaviour of struct setter functions 
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
            revert();
        }
    }

    // helper function that defines the behaviour of struct getter functions 
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
            revert();
        }
    }

    // helper function which returns application stages in a readable manner
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
            revert();
        }
    }

    // employer enables a job applicant to use the applicant-side functions of the contract
    function addShortlistedApplicant(address _applicantAddress)
        public
        onlyEmployer
    {
        require(_applicantAddress != msg.sender);
        applicantStages[_applicantAddress] = ApplicationStage.Shortlisted;
        shortlistedApplicants[_applicantAddress] = true;
    }

    // employer enables multiple job applicants to use the applicant-side functions of the contract
    function addMultipleShortlistedApplicants(
        address[] memory _applicantAddresses
    ) public onlyEmployer {
        for (uint256 i = 0; i < _applicantAddresses.length; i++) {
            require(_applicantAddresses[i] != msg.sender);
            shortlistedApplicants[_applicantAddresses[i]] = true;
            applicantStages[_applicantAddresses[i]] = ApplicationStage
                .Shortlisted;
        }
    }

    // transact own public key
    function setPublicKey(string memory _publicKey)
        public
        onlyShortlistedApplicantOrEmployer
    {
        publicKeys[msg.sender] = _publicKey;
    }

    // obtain the public key of a specific actor
    function getPublicKey(address _entityAddress)
        public
        view
        returns (string memory publicKey)
    {
        return publicKeys[_entityAddress];
    }

    // obtain the public key of the employer
    function getEmployerPublicKey()
        public
        view
        onlyShortlistedApplicant
        returns (string memory publicKey)
    {
        return publicKeys[employer];
    }

    // obtain own public key
    function getOwnPublicKey() public view returns (string memory publicKey) {
        return publicKeys[msg.sender];
    }

    // employer transacts access to a virtual assessment
    function setQuestionnaireLink(
        address _applicantAddress,
        string memory _questionnaireLink,
        string memory _encryptedKey,
        string memory _nonce,
        string memory _tag
    ) public onlyEmployer {
        require(shortlistedApplicants[_applicantAddress]);
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

    // employer determines the score needed to pass the virtual assessment
    function setPassScore(uint256 _score) public onlyEmployer {
        passScore = _score;
    }

    // obtain the score needed to pass the virtual assessment
    function getPassScore() public view returns (uint256 scoreToAchieve) {
        return passScore;
    }

    // employer determines the automatic feedback for those who complete the virtual assessment
    function setAutomaticFeedbacks(string memory _pass, string memory _fail) public onlyEmployer {
        questionnairePassFeedback = _pass;
        questionnaireFailFeedback = _fail;
    }

    // applicant acquires access to the virtual assessment
    function getQuestionnaireLink()
        public
        view
        onlyShortlistedApplicant
        returns (
            string memory secret,
            string memory symKey,
            string memory nonce,
            string memory tag
        )
    {
        uint256 mappingType = 0;
        address _address = msg.sender;
        return structGetter(mappingType, _address);
    }

    // applicant transacts a record of their completed assessment and their score, generating feedback
    function completeQuestionnaire(
        string memory _completedFormLink,
        string memory _encryptedKey,
        string memory _tag,
        string memory _nonce,
        uint256 _score
    ) public onlyShortlistedApplicant {
        address applicant = msg.sender;
        require(
            testedApplicants[msg.sender] == false,
            "Questionnaire already completed"
        );
        string memory autoFeedback;
        if (_score >= passScore) {
            autoFeedback = questionnairePassFeedback;
        } else {
            autoFeedback = questionnaireFailFeedback;
            applicantStages[applicant] = ApplicationStage.NoLongerConsidered;
        }

        testedApplicants[applicant] = true;
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

    // applicant acquires feedback for virtual assessment
    function getQuestionnaireFeedback()
        public
        view
        onlyShortlistedApplicant
        returns (string memory automaticFeedback)
    {
        return questionnaireFeedbacks[msg.sender];
    }
    
    // employer transacts access to an interview (virtual or not)
    function setInterviewLink(
        address _applicantAddress,
        string memory _interviewLink,
        string memory _encryptedKey,
        string memory _nonce,
        string memory _tag
    ) public onlyEmployer {
        require(
            applicantStages[_applicantAddress] ==
                ApplicationStage.Questionnaire
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

    // applicant acquires access to the interview
    function getInterviewLink()
        public
        view
        onlyShortlistedApplicant
        returns (
            string memory secret,
            string memory symKey,
            string memory nonce,
            string memory tag
        )
    {
        uint256 mappingType = 1;
        address _address = msg.sender;
        return structGetter(mappingType, _address);
    }

    // employer transacts evidence of conducted interview
    function setInterviewRecord(
        address _applicantAddress,
        string memory _recordLink,
        string memory _encryptedKey,
        string memory _nonce,
        string memory _tag
    ) public onlyEmployer {
        require(
            applicantStages[_applicantAddress] == ApplicationStage.Interview
        );
        require(
            interviewedApplicants[_applicantAddress] == false,
            "Interview record already set"
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
        interviewedApplicants[_applicantAddress] = true;
    }

    // applicant acquires access to interview evidence
    function getInterviewRecord()
        public
        view
        onlyShortlistedApplicant
        returns (
            string memory secret,
            string memory symKey,
            string memory nonce,
            string memory tag
        )
    {
        uint256 mappingType = 4;
        address _address = msg.sender;
        return structGetter(mappingType, _address);
    }

    // employer transacts interview feedback (or access to it)
    function setInterviewFeedback(
        address _applicantAddress,
        string memory _feedback,
        string memory _encryptedKey,
        string memory _nonce,
        string memory _tag
    ) public onlyEmployer {
        require(
            applicantStages[_applicantAddress] == ApplicationStage.Interview
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

    // applicant acquires access to interview feedback (or directly the feedback itself)
    function getInterviewFeedback()
        public
        view
        onlyShortlistedApplicant
        returns (
            string memory secret,
            string memory symKey,
            string memory nonce,
            string memory tag
        )
    {
        uint256 mappingType = 2;
        address _address = msg.sender;
        return structGetter(mappingType, _address);
    }

    // employer transacts application feedback (or access to it); dynamically progresses or rejects a candidate
    function setApplicationFeedback(
        address _applicantAddress,
        ApplicationStage _newStage,
        string memory _feedback,
        string memory _encryptedKey,
        string memory _nonce,
        string memory _tag
    ) public onlyEmployer {
        require(
            applicantStages[_applicantAddress] ==
                ApplicationStage.UnderConsideration,
            "Applicant must be under consideration after an interview stage"
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

    // employer changes status of an applicant to hired
    function setToHired(address _applicantAddress) public onlyEmployer {
        require(
            applicantStages[_applicantAddress] == ApplicationStage.Offer,
            "Applicant has not received an offer"
        );
        applicantStages[_applicantAddress] = ApplicationStage.Hired;
    }

    // obtain the progression of a candidate
    function getApplicantStage(address _applicantAddress)
        public
        view
        onlyEmployer
        returns (string memory stage)
    {
        return stageToString(applicantStages[_applicantAddress]);
    }

    // applicant acquires access to application feedback (or directly the feedback itself)
    function getApplicationFeedback()
        public
        view
        onlyShortlistedApplicant
        returns (
            string memory secret,
            string memory symKey,
            string memory nonce,
            string memory tag,
            string memory stage
        )
    {
        uint256 mappingType = 5;
        address _address = msg.sender;
        (
            string memory _feedback,
            string memory _key,
            string memory _nonce,
            string memory _tag
        ) = structGetter(mappingType, _address);
        return (
            _feedback,
            _key,
            _nonce,
            _tag,
            stageToString(applicantStages[msg.sender])
        );
    }

    // applicant verifies current stage
    function getCurrentStage()
        public
        view
        onlyShortlistedApplicant
        returns (string memory stage)
    {
        return stageToString(applicantStages[msg.sender]);
    }

    // helper function for obtaining a summary of the data related to a single applicant
    function getApplicantData(address _applicantAddress)
        internal
        view
        onlyShortlistedApplicantOrEmployer
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

    // employer obtainins a summary of the data related to a single applicant by address
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
        return getApplicantData(_applicantAddress);
    }

    // applicant obtainins a summary of their own data
    function getMyApplicationData()
        public
        view
        onlyShortlistedApplicant
        returns (
            string memory publickey,
            string memory stage,
            QuestionnaireRecord memory questionnaireRecord,
            InterviewRecord memory interviewRecord,
            InterviewFeedback memory interviewFeedback,
            ApplicationFeedback memory applicationFeedback
        )
    {
        return getApplicantData(msg.sender);
    }
}
