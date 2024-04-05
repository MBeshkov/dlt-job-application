from Crypto.Cipher import AES
from Crypto.PublicKey import RSA
from Crypto.Random import get_random_bytes
from Crypto.Cipher import PKCS1_OAEP
import base64

# Function to generate RSA key pair for applicant
def format_public_key(one_line_key):
    begin = "-----BEGIN PUBLIC KEY-----\n"
    end = "\n-----END PUBLIC KEY-----"
    key_body = '\n'.join(one_line_key[i:i+64] for i in range(0, len(one_line_key), 64))
    return begin + key_body + end


def generate_key_pair():
    applicant_key = RSA.generate(2048)
    public_key = applicant_key.publickey().export_key().decode('utf-8')
    
    # Convert private key to PEM format
    private_key = applicant_key.export_key().decode('utf-8')

    public_key.strip()
    private_key.strip()
    
    return {
        'public_key': public_key,
        'private_key': private_key
    }

# Function to encrypt using RSA public key
def encrypt_rsa(public_key_obj, message):
    # public_key_str = public_key_str.strip()
    message = message.strip()
    message_bytes = base64.b64decode(message)
    # public_key_str = format_public_key(public_key_str)
    # public_key = RSA.import_key(public_key_str)
    cipher_rsa = PKCS1_OAEP.new(public_key_obj)
    result = cipher_rsa.encrypt(message_bytes)
    decoded_data = base64.b64encode(result).decode('utf-8')
    print(decoded_data)
    return(decoded_data)

# Funciton to generate a symmetric key for AES encryption
def generate_sym_key():
    symmetric_key = get_random_bytes(16)
    return symmetric_key

# Function to encrypt using AES symmetric key
def encrypt_aes(symmetric_key, plaintext):
    key_bytes = base64.b64decode(symmetric_key)
    plaintext_bytes = plaintext.encode('utf-8')
    cipher_aes = AES.new(key_bytes, AES.MODE_EAX)
    ciphertext, tag = cipher_aes.encrypt_and_digest(plaintext_bytes)
    nonce = base64.b64encode(cipher_aes.nonce).decode()
    ciphertext_base64 = base64.b64encode(ciphertext).decode()
    tag_base64 = base64.b64encode(tag).decode()
    return {
        'ciphertext': ciphertext_base64,
        'nonce': nonce,
        'tag': tag_base64
    }

# Function to decrypt using AES symmetric key
def decrypt_aes(symmetric_key, ciphertext, nonce, tag):
    cipher_aes = AES.new(symmetric_key, AES.MODE_EAX, nonce=nonce)
    plaintext = cipher_aes.decrypt(ciphertext)
    try:
        cipher_aes.verify(tag)
        return plaintext
    except ValueError:
        return "Decryption failed"

# Employer encrypts the symmetric key with applicant's public key
def encrypt_symmetric_key(public_key, symmetric_key):
    public_key = public_key.strip()  # Ensure no leading/trailing whitespace
    proper_key = "-----BEGIN PUBLIC KEY-----\n" + public_key + "\n-----END PUBLIC KEY-----"
    symmetric_key = symmetric_key.strip()
    
    # Debugging: Print public key before import
    print("Public Key Before Import:")
    print(proper_key)
    
    # Check if the key starts with the expected header
    if not proper_key.startswith('-----BEGIN PUBLIC KEY-----'):
        print("Error: Public key does not start with '-----BEGIN PUBLIC KEY-----'")
        return None

    # Check if the key ends with the expected footer
    if not proper_key.endswith('-----END PUBLIC KEY-----'):
        print("Error: Public key does not end with '-----END PUBLIC KEY-----'")
        return None
    
    # Attempt to import public key
    try:
        public_key_obj = RSA.import_key(proper_key)
    except Exception as e:
        print("Error importing public key:", e)
        return None

    # Debugging: Print imported public key
    print("Imported Public Key:")
    print(public_key_obj)

    return encrypt_rsa(public_key_obj, symmetric_key)


# Employer encrypts the secret link using the symmetric key
def encrypt_secret_link(symmetric_key, secret_link):
    return encrypt_aes(symmetric_key, secret_link)

# Applicant decrypts the symmetric key using their private key
def decrypt_symmetric_key(private_key, encrypted_symmetric_key):
    cipher_rsa = PKCS1_OAEP.new(private_key)
    return cipher_rsa.decrypt(encrypted_symmetric_key)

# Applicant decrypts the secret link using the decrypted symmetric key
def decrypt_secret_link(symmetric_key, encrypted_secret_link):
    return decrypt_aes(symmetric_key, *encrypted_secret_link)
