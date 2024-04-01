from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding
import base64


def encrypt(data, recipient_public_key_pem):

    recipient_public_key = serialization.load_pem_public_key(
        recipient_public_key_pem.encode('utf-8'),
    )
    # Generate a symmetric key for Fernet
    symmetric_key = Fernet.generate_key()
    cipher_suite = Fernet(symmetric_key)

    # Use Fernet to encrypt the data
    cipher_text = cipher_suite.encrypt(data)

    # Encrypt the symmetric key with the public key
    encrypted_symmetric_key = recipient_public_key.encrypt(
            symmetric_key,
            padding.OAEP(
                mgf=padding.MGF1(algorithm=hashes.SHA256()),
                algorithm=hashes.SHA256(),
                label=None
            )
        )

    return cipher_text, encrypted_symmetric_key

# Receive public key from applicant:
applicant_public_key = input("Enter public key:")


# Encrypt the message
cipher_text, encrypted_symmetric_key = encrypt(b"condimentum laoreet. libero, eget condimentum felis rutrum vitae. Sed vel ligula tellus. Morbi eu porttitor augue, eget bibendum leo. Maecenas dictum augue non posuere scelerisque. Donec in condimentum purus, eu vestibulum nibh. Nunc posuere mauris in condimentum placerat.\nPellentesque blandit eu nunc eu condimentum. Sed orci nulla, lobortis eget tortor et, consectetur iaculis nisl. Sed nec sagittis mauris, porta feugiat metus. Morbi vestibulum imperdiet justo, quis vulputate diam pharetra ut. Ut non dui a dolor molestie malesuada ut eu libero. Pellentesque et lacus rutrum, porttitor nunc vitae, lacinia arcu. Cras metus dolor, fringilla ut feugiat eget, ullamcorper sed urna. Praesent felis nulla, dapibus id semper quis, sodales nec dolor. Mauris ligula velit, lobortis ed enim id, volutpat posuere cacca. Suspendisse potenti. Donec dui est, tempor a libero et, hendrerit consectetur purus.", applicant_public_key)


# Convert to Base64
encrypted_symmetric_key_base64 = base64.b64encode(encrypted_symmetric_key).decode('utf-8')
print(cipher_text)
print(encrypted_symmetric_key_base64)

# # Convert back from Base64
# encrypted_symmetric_key = base64.b64decode(encrypted_symmetric_key_base64.encode('utf-8'))



