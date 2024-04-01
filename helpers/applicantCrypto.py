from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding
import base64

def generate_keys():
    # Generate a public/private key pair
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048,
    )

    public_key = private_key.public_key()

    return private_key, public_key

applicant_private_key, applicant_public_key = generate_keys()
# print(applicant_public_key)

pem1 = applicant_public_key.public_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PublicFormat.SubjectPublicKeyInfo
)
pem1_str = pem1.decode('utf-8')
print(pem1_str)

pem2 = applicant_private_key.private_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PrivateFormat.PKCS8,
    encryption_algorithm=serialization.NoEncryption()
)
pem2_str = pem2.decode('utf-8')
with open('private_key.pem', 'w') as f:
    f.write(pem2_str)

def decrypt(encrypted_symmetric_key_64, cipher_text, recipient_private_key):
    encrypted_symmetric_key = base64.b64decode(encrypted_symmetric_key_64.encode('utf-8'))
    decrypted_symmetric_key = recipient_private_key.decrypt(
        encrypted_symmetric_key,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )

    # Create a new Fernet instance with the decrypted symmetric key
    cipher_suite = Fernet(decrypted_symmetric_key)

    # Decrypt the data with the symmetric key
    plain_text = cipher_suite.decrypt(cipher_text)

    print("Decrypted message: ", plain_text)


def run_decrypt():
    # Example cipher-text and sym key:
    with open('private_key.pem', 'r') as f:
        curr_applicant_private_key = f.read()
    current_applicant_private_key = serialization.load_pem_private_key(
        curr_applicant_private_key.encode('utf-8'),
        password=None,
    )
    cipher_text = input("Enter cipher text:").encode()
    encrypted_symmetric_key_64 = input("Enter the symmetric key: ")
    # Decrypt the message
    decrypt(encrypted_symmetric_key_64, cipher_text, current_applicant_private_key)


run_decrypt()