from flask import Flask, request, jsonify, Response
from flask_cors import CORS
import json
import base64
from comparativeFeedbackGenerator import generate_summary
from symmetricCrypto import (
    generate_key_pair,
    decrypt_symmetric_key,
    decrypt_secret_link,
    generate_sym_key,
    encrypt_symmetric_key,
    encrypt_secret_link,
)

app = Flask(__name__)
CORS(app)

# invokes the function which connects to the database and queries gpt; returns comparative feedback for applicant
@app.route("/backend/feedbackGenerator", methods=["POST"])
def get_feedback_summary():
    applicant_id = request.json["applicantId"]
    summary = generate_summary(applicant_id)
    return jsonify(summary)

# creates a new public-private key pair for requesting decryptor
@app.route("/backend/generate_key_pair", methods=["GET"])
def generate_key_pair_route():
    key_pair = generate_key_pair()
    return Response(
        response=json.dumps(key_pair), status=200, mimetype="application/json"
    )

# decrypts an encrypted symmetric key with user's own private key
@app.route("/backend/decrypt_key", methods=["POST"])
def decrypt_key_route():
    input_data = request.json  
    combined_data = input_data.get("keys", "")
    private_key, encrypted_key = combined_data.split(";")
    decoded_key = decrypt_symmetric_key(private_key, encrypted_key)
    return jsonify(base64.b64encode(decoded_key).decode("utf-8"))

# decrypts a link/message with decrypted symmetric key
@app.route("/backend/decrypt_message", methods=["POST"])
def decrypt_message_route():
    input_data = request.json  
    combined_parameters = input_data.get("parameters", "")
    symmetric_key, ciphertext, tag, nonce = combined_parameters.split(";")
    ciphertext = base64.b64decode(ciphertext)
    decrypted_message = decrypt_secret_link(symmetric_key, ciphertext, tag, nonce)
    decrypted_message_str = decrypted_message.decode("utf-8")
    return jsonify(decrypted_message_str)

# creates a new symmetric key for requesting encryptor
@app.route("/backend/generate_symmetric_key", methods=["GET"])
def generate_symmetric_key_route():
    sym_key = generate_sym_key()
    return jsonify(base64.b64encode(sym_key).decode("utf-8"))

# encrypts a symmetric key with decryptor's public key
@app.route("/backend/encrypt_key", methods=["POST"])
def encrypt_key_route():
    input_data = request.json  
    combined_keys = input_data.get("keys", "")
    public_key, symmetric_key = combined_keys.split(";")
    encrypted_key = encrypt_symmetric_key(public_key, symmetric_key)
    return jsonify(encrypted_key)

# encrypts a link/message with a symmetric key
@app.route("/backend/encrypt_message", methods=["POST"])
def encrypt_message_route():
    input_data = request.json  
    combined_data = input_data.get("argums", "")
    message, symmetric_key = combined_data.split(";")
    cipher_details = encrypt_secret_link(symmetric_key, message)
    return Response(
        response=json.dumps(cipher_details), status=200, mimetype="application/json"
    )

if __name__ == "__main__":
    app.run(debug=True)
