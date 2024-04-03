from web3 import Web3, HTTPProvider
from Crypto.PublicKey import RSA
from symmetricCrypto import generate_key_pair
from eth_account import Account
from eth_account.messages import encode_defunct

# Connect to Ethereum node
w3 = Web3(HTTPProvider('https://sepolia.infura.io/v3/3fd882e4b4874eeb9cb5bedbc8c32cec'))
contract_address = '0x734db0936267Fcda5214760Da692cEeA4B21CD1A'
contract_abi = [{"constant":True,"inputs":[],"name":"getInterviewFeedback","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_applicantAddress","type":"address"},{"name":"_interviewFeedback","type":"string"}],"name":"setInterviewFeedback","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[],"name":"getQuestionnaireFeedback","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":True,"inputs":[],"name":"getQuestionnaireLink","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_applicantAddress","type":"address"},{"name":"_publicKey","type":"string"}],"name":"addShortlistedApplicant","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[{"name":"_index","type":"uint256"}],"name":"getApplicantAtIndex","outputs":[{"name":"","type":"address"},{"name":"","type":"string"},{"name":"","type":"uint256"},{"name":"","type":"string"},{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_score","type":"uint256"}],"name":"setPassScore","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[],"name":"getShortlistedApplicants","outputs":[{"name":"","type":"address[]"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_applicantAddress","type":"address"},{"name":"_questionnaireLink","type":"string"}],"name":"setQuestionnaireLink","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[],"name":"getPassScore","outputs":[{"name":"","type":"uint256"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":True,"inputs":[{"name":"_entityAddress","type":"address"}],"name":"getPublicKey","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_applicantAddress","type":"address"},{"name":"_interviewLink","type":"string"}],"name":"setInterviewLink","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":False,"inputs":[{"name":"_completedFormLink","type":"string"},{"name":"_score","type":"uint256"}],"name":"completeQuestionnaire","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[{"name":"_applicantAddress","type":"address"}],"name":"getApplicantResponse","outputs":[{"name":"","type":"string"},{"name":"","type":"uint256"},{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":True,"inputs":[],"name":"getInterviewLink","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":True,"inputs":[],"name":"employer","outputs":[{"name":"","type":"address"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[],"name":"setPublicKey","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[],"name":"getOwnPublicKey","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_applicant","type":"address"},{"name":"_publicKey","type":"string"}],"name":"updatePublicKey","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[],"name":"getSymmetricKey","outputs":[{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":True,"inputs":[{"name":"_applicantAddress","type":"address"}],"name":"getApplicantKeys","outputs":[{"name":"","type":"string"},{"name":"","type":"string"}],"payable":False,"stateMutability":"view","type":"function"},{"constant":False,"inputs":[{"name":"_applicantAddress","type":"address"},{"name":"_symmetricKey","type":"string"}],"name":"setSymmetricKey","outputs":[],"payable":False,"stateMutability":"nonpayable","type":"function"},{"constant":True,"inputs":[],"name":"getApplicantsCount","outputs":[{"name":"","type":"uint256"}],"payable":False,"stateMutability":"view","type":"function"},{"inputs":[],"payable":False,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":False,"inputs":[{"indexed":False,"name":"applicant","type":"address"}],"name":"ShortlistedApplicantAdded","type":"event"},{"anonymous":False,"inputs":[{"indexed":False,"name":"applicant","type":"address"},{"indexed":False,"name":"qlink","type":"string"}],"name":"QuestionnaireLinkSet","type":"event"},{"anonymous":False,"inputs":[{"indexed":False,"name":"applicant","type":"address"},{"indexed":False,"name":"ilink","type":"string"}],"name":"InterviewLinkSet","type":"event"},{"anonymous":False,"inputs":[{"indexed":False,"name":"applicant","type":"address"},{"indexed":False,"name":"link","type":"string"},{"indexed":False,"name":"score","type":"uint256"},{"indexed":False,"name":"questionFeedback","type":"string"}],"name":"AssessmentCompleted","type":"event"},{"anonymous":False,"inputs":[{"indexed":False,"name":"applicant","type":"address"},{"indexed":False,"name":"key","type":"string"}],"name":"SymmetricKeySet","type":"event"},{"anonymous":False,"inputs":[{"indexed":True,"name":"applicant","type":"address"}],"name":"PublicKeySet","type":"event"}]  # Replace with your contract ABI
contract = w3.eth.contract(address=contract_address, abi=contract_abi)

private_key = 'c8edeb841547898430b18ebc8ac9bf83fced922cfb5182a75d06b64f229c7379'

account = Account.from_key(private_key)
sender_address = account.address

# Function to handle PublicKeySet event
def handle_public_key_set(event):
    # Get the sender's address from the event
    sender_address = event['args']['applicant']
    rsa_key_pair = generate_key_pair()
    public_key = rsa_key_pair.publickey().export_key().decode()

    # Prepare the transaction
    tx = contract.functions.updatePublicKey(sender_address, public_key).build_transaction({
        'chainId': w3.eth.chain_id,
        'gas': 6000000,  # Adjust gas limit as needed
        'gasPrice': w3.eth.gas_price,
        'nonce': w3.eth.get_transaction_count(sender_address),
    })

    # Sign the transaction
    signed_tx = w3.eth.account.sign_transaction(tx, private_key)

    # Send the signed transaction
    tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
    receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print("Transaction Receipt:")
    print(receipt)

# Subscribe to PublicKeySet event
public_key_set_filter = contract.events.PublicKeySet.create_filter(fromBlock='latest')

while True:
    for event in public_key_set_filter.get_new_entries():
        handle_public_key_set(event)
