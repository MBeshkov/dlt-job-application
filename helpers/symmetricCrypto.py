from Crypto.Cipher import AES
from Crypto.PublicKey import RSA
from Crypto.Random import get_random_bytes
from Crypto.Cipher import PKCS1_OAEP

# Function to generate RSA key pair for applicant
def generate_key_pair():
    applicant_key = RSA.generate(2048)
    return applicant_key

# Function to encrypt using RSA public key
def encrypt_rsa(public_key, message):
    cipher_rsa = PKCS1_OAEP.new(public_key)
    return cipher_rsa.encrypt(message)

# Funciton to generate a symmetric key for AES encryption
def generate_sym_key():
    symmetric_key = get_random_bytes(16)
    return symmetric_key

# Function to encrypt using AES symmetric key
def encrypt_aes(symmetric_key, plaintext):
    cipher_aes = AES.new(symmetric_key, AES.MODE_EAX)
    ciphertext, tag = cipher_aes.encrypt_and_digest(plaintext)
    return ciphertext, cipher_aes.nonce, tag

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
    return encrypt_rsa(public_key, symmetric_key)

# Employer encrypts the secret link using the symmetric key
def encrypt_secret_link(symmetric_key, secret_link):
    return encrypt_aes(symmetric_key, secret_link.encode())

# Applicant decrypts the symmetric key using their private key
def decrypt_symmetric_key(private_key, encrypted_symmetric_key):
    cipher_rsa = PKCS1_OAEP.new(private_key)
    return cipher_rsa.decrypt(encrypted_symmetric_key)

# Applicant decrypts the secret link using the decrypted symmetric key
def decrypt_secret_link(symmetric_key, encrypted_secret_link):
    return decrypt_aes(symmetric_key, *encrypted_secret_link)

# Simulation

# # Employer generates a secret link
# secret_link = input()
# applicant_key = generate_key_pair()
# symmetric_key = generate_sym_key()

# # Employer encrypts the symmetric key with applicant's public key
# encrypted_symmetric_key = encrypt_symmetric_key(applicant_key.publickey(), symmetric_key)

# # Employer encrypts the secret link using the symmetric key
# encrypted_secret_link = encrypt_secret_link(symmetric_key, secret_link)

# # Applicant decrypts the symmetric key using their private key
# decrypted_symmetric_key = decrypt_symmetric_key(applicant_key, encrypted_symmetric_key)

# # Applicant decrypts the secret link using the decrypted symmetric key
# decrypted_secret_link = decrypt_secret_link(decrypted_symmetric_key, encrypted_secret_link)

# print("Encrypted Secret Link:", encrypted_secret_link)
# secret_link = "The original link you input has now been erased from the system!"
# print(secret_link)
# print("Encrypted symmetric key:", encrypted_symmetric_key)
# print("Decrypted symmetric key:", decrypted_symmetric_key)
# print("Decrypted Secret Link:", decrypted_secret_link.decode())
