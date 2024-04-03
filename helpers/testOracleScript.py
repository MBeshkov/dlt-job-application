from web3 import Web3, HTTPProvider
from web3.middleware import construct_sign_and_send_raw_middleware
from eth_account import Account
import time

# Connect to Ethereum node
w3 = Web3(HTTPProvider('https://sepolia.infura.io/v3/3fd882e4b4874eeb9cb5bedbc8c32cec'))
contract_address = '0x734db0936267Fcda5214760Da692cEeA4B21CD1A'
contract_abi = [{"constant":True,"inputs":[],"name":"getInterviewFeedback","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_applicantAddress","type":"address"},{"name":"_interviewFeedback","type":"string"}],"name":"setInterviewFeedback","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[],"name":"getQuestionnaireFeedback","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":True,"inputs":[],"name":"getQuestionnaireLink","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_applicantAddress","type":"address"},{"name":"_publicKey","type":"string"}],"name":"addShortlistedApplicant","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[{"name":"_index","type":"uint256"}],"name":"getApplicantAtIndex","outputs":[{"name":"","type":"address"},{"name":"","type":"string"},{"name":"","type":"uint256"},{"name":"","type":"string"},{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_score","type":"uint256"}],"name":"setPassScore","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[],"name":"getShortlistedApplicants","outputs":[{"name":"","type":"address[]"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_applicantAddress","type":"address"},{"name":"_questionnaireLink","type":"string"}],"name":"setQuestionnaireLink","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[],"name":"getPassScore","outputs":[{"name":"","type":"uint256"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":True,"inputs":[{"name":"_entityAddress","type":"address"}],"name":"getPublicKey","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_applicantAddress","type":"address"},{"name":"_interviewLink","type":"string"}],"name":"setInterviewLink","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":False,"inputs":[{"name":"_completedFormLink","type":"string"},{"name":"_score","type":"uint256"}],"name":"completeQuestionnaire","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[{"name":"_applicantAddress","type":"address"}],"name":"getApplicantResponse","outputs":[{"name":"","type":"string"},{"name":"","type":"uint256"},{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":True,"inputs":[],"name":"getInterviewLink","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":True,"inputs":[],"name":"employer","outputs":[{"name":"","type":"address"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[],"name":"setPublicKey","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[],"name":"getOwnPublicKey","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_applicant","type":"address"},{"name":"_publicKey","type":"string"}],"name":"updatePublicKey","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[],"name":"getSymmetricKey","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":True,"inputs":[{"name":"_applicantAddress","type":"address"}],"name":"getApplicantKeys","outputs":[{"name":"","type":"string"},{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_applicantAddress","type":"address"},{"name":"_symmetricKey","type":"string"}],"name":"setSymmetricKey","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[],"name":"getApplicantsCount","outputs":[{"name":"","type":"uint256"}],"payable":False,"stateMutability":"view","type":"function"},{"inputs":[],"payable":False,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":False,"inputs":[{"indexed":False,"name":"applicant","type":"address"}],"name":"ShortlistedApplicantAdded","type":"event"},{"anonymous":False,"inputs":[{"indexed":False,"name":"applicant","type":"address"},{"indexed":False,"name":"qlink","type":"string"}],"name":"QuestionnaireLinkSet","type":"event"},{"anonymous":False,"inputs":[{"indexed":False,"name":"applicant","type":"address"},{"indexed":False,"name":"ilink","type":"string"}],"name":"InterviewLinkSet","type":"event"},{"anonymous":False,"inputs":[{"indexed":False,"name":"applicant","type":"address"},{"indexed":False,"name":"link","type":"string"},{"indexed":False,"name":"score","type":"uint256"},{"indexed":False,"name":"questionFeedback","type":"string"}],"name":"AssessmentCompleted","type":"event"},{"anonymous":False,"inputs":[{"indexed":False,"name":"applicant","type":"address"},{"indexed":False,"name":"key","type":"string"}],"name":"SymmetricKeySet","type":"event"},{"anonymous":False,"inputs":[{"indexed":True,"name":"applicant","type":"address"}],"name":"PublicKeySet","type":"event"}]  # Replace with your contract ABI
contract = w3.eth.contract(address=contract_address, abi=contract_abi)

local_account = Account.from_key("c8edeb841547898430b18ebc8ac9bf83fced922cfb5182a75d06b64f229c7379")
sender_address = local_account.address
sender_private_key = local_account.key

w3.middleware_onion.add(construct_sign_and_send_raw_middleware(sender_private_key))

def set_public_key():
    # Build the transaction
    tx_hash = contract.functions.setPublicKey().transact({'from': sender_address})

    # Wait for the transaction to be mined
    receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

    # Print the transaction receipt
    print("Transaction Receipt:")
    print(receipt)

def get_public_key(applicant_address):
    # Call the contract's getPublicKey() function
    public_key = contract.functions.getPublicKey(applicant_address).call()
    return public_key

# Example usage: Replace 'applicant_address' with the actual address of the applicant
set_public_key()
time.sleep(60)
applicant_address = '0x5428fCFdA65fEA3ab7c0565e0C41BBa4A3F8C8E3'
public_key = get_public_key(applicant_address)
print(f"Public key for applicant {applicant_address}: {public_key}")

# c8edeb841547898430b18ebc8ac9bf83fced922cfb5182a75d06b64f229c7379