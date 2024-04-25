from Crypto.Cipher import AES
from Crypto.PublicKey import RSA
from Crypto.Random import get_random_bytes
from Crypto.Cipher import PKCS1_OAEP
import base64


# function to generate RSA key pair for decryptor
def generate_key_pair():
    applicant_key = RSA.generate(2048) # standard key size

    #return in readable format
    public_key = applicant_key.publickey().export_key().decode("utf-8")
    private_key = applicant_key.export_key().decode("utf-8")

    public_key.strip()
    private_key.strip()

    return {"public_key": public_key, "private_key": private_key}


# function to encrypt using RSA public key
def encrypt_rsa(public_key_obj, message):
    message = message.strip()
    message_bytes = base64.b64decode(message)   # can only operate with bytes representation of data
    cipher_rsa = PKCS1_OAEP.new(public_key_obj) # asymmetric encription padding
    result = cipher_rsa.encrypt(message_bytes)
    decoded_data = base64.b64encode(result).decode("utf-8") # return in readable format
    return decoded_data


# funciton to generate a symmetric key for AES encryption
def generate_sym_key():
    symmetric_key = get_random_bytes(16) # standard key size
    return symmetric_key


# function to encrypt using AES symmetric key
def encrypt_aes(symmetric_key, plaintext):
    key_bytes = base64.b64decode(symmetric_key) # can only operate with bytes representation of data
    plaintext_bytes = plaintext.encode("utf-8")
    cipher_aes = AES.new(key_bytes, AES.MODE_EAX) # encrypts, authenticates, and translates the message
    ciphertext, tag = cipher_aes.encrypt_and_digest(plaintext_bytes) # additional security safeguards produced by EAX
    # need below values in a readable format
    nonce = base64.b64encode(cipher_aes.nonce).decode()
    ciphertext_base64 = base64.b64encode(ciphertext).decode()
    tag_base64 = base64.b64encode(tag).decode()
    return {"ciphertext": ciphertext_base64, "nonce": nonce, "tag": tag_base64}


# function to decrypt using AES symmetric key
def decrypt_aes(symmetric_key, ciphertext, tag, nonce):
    cipher_aes = AES.new(symmetric_key, AES.MODE_EAX, nonce=nonce) # uses the same key, mode, and nonce with which it was encrypted
    plaintext = cipher_aes.decrypt(ciphertext)
    try:
        cipher_aes.verify(tag) # verifies integrity of message with the tag
        return plaintext
    except ValueError:
        return "Decryption failed"


# encryptor encrypts the symmetric key with decryptor's public key
def encrypt_symmetric_key(public_key, symmetric_key):
    public_key = public_key.strip()  # ensure no leading/trailing whitespace
    proper_key = (
        "-----BEGIN PUBLIC KEY-----\n" + public_key + "\n-----END PUBLIC KEY-----" # needed header and footer for rsa algorithm
    )
    symmetric_key = symmetric_key.strip()

    # check if the key starts with the expected header
    if not proper_key.startswith("-----BEGIN PUBLIC KEY-----"):
        print("Error: Public key does not start with '-----BEGIN PUBLIC KEY-----'")
        return None

    # check if the key ends with the expected footer
    if not proper_key.endswith("-----END PUBLIC KEY-----"):
        print("Error: Public key does not end with '-----END PUBLIC KEY-----'")
        return None

    # attempt to import public key
    try:
        public_key_obj = RSA.import_key(proper_key)
    except Exception as e:
        print("Error importing public key:", e)
        return None

    return encrypt_rsa(public_key_obj, symmetric_key)


# encryptor encrypts the secret link/message using the symmetric key
def encrypt_secret_link(symmetric_key, secret_link):
    return encrypt_aes(symmetric_key, secret_link)


# decryptor decrypts the symmetric key using their private key
def decrypt_symmetric_key(private_key, encrypted_symmetric_key):
    private_key = private_key.strip()  # ensure no leading/trailing whitespace
    # import private key
    proper_priv_key = (
        "-----BEGIN RSA PRIVATE KEY-----\n"
        + private_key
        + "\n-----END RSA PRIVATE KEY-----"
    )
    private_key_obj = RSA.import_key(proper_priv_key) # convert to a usable format
    symmetric_key = base64.b64decode(encrypted_symmetric_key) # convert to a usable format
    cipher_rsa = PKCS1_OAEP.new(private_key_obj) # import a cipher based on the private key
    return cipher_rsa.decrypt(symmetric_key)


# decryptor decrypts the secret link/message using the decrypted symmetric key
def decrypt_secret_link(symmetric_key, encrypted_secret_text, tag, nonce):
    symmetric_key = base64.b64decode(symmetric_key) # convert to a usable format
    tag = base64.b64decode(tag) # convert to a usable format
    nonce = base64.b64decode(nonce) # convert to a usable format
    return decrypt_aes(symmetric_key, encrypted_secret_text, tag, nonce) 
