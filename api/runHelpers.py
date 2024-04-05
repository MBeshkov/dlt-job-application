from flask import Flask, request, jsonify, Response
from flask_cors import CORS
import json
import base64
from comparativeFeedbackGenerator import generate_summary
from symmetricCrypto import generate_key_pair, decrypt_aes, decrypt_symmetric_key, decrypt_secret_link, encrypt_rsa, generate_sym_key, encrypt_aes, encrypt_symmetric_key, encrypt_secret_link

app = Flask(__name__)
CORS(app)

@app.route('/api/feedbackGenerator', methods=['POST'])
def get_feedback_summary():
    applicant_id = request.json['applicantId']
    summary = generate_summary(applicant_id)
    return jsonify(summary)

@app.route('/api/generate_key_pair', methods=['GET'])
def generate_key_pair_route():
    key_pair = generate_key_pair()
    return Response(
        response=json.dumps(key_pair),
        status=200,
        mimetype='application/json'
    )

@app.route('/api/decrypt_key', methods=['POST'])
def decrypt_key_route():
    encrypted_key = request.json['encryptedKey']
    return jsonify(decrypt_symmetric_key(encrypted_key))

@app.route('/api/decrypt_message', methods=['POST'])
def decrypt_message_route():
    encrypted_message = request.json['encryptedMessage']
    return jsonify(decrypt_secret_link(encrypted_message))

@app.route('/api/generate_symmetric_key', methods=['GET'])
def generate_symmetric_key_route():
    sym_key = generate_sym_key()
    return jsonify(base64.b64encode(sym_key).decode('utf-8'))

@app.route('/api/encrypt_key', methods=['POST'])
def encrypt_key_route():
    input_data = request.json  # Assuming data is sent as JSON
    combined_keys = input_data.get('keys', '')

    # Splitting the combined keys by the delimiter ';'
    public_key, symmetric_key = combined_keys.split(';')

    # Encrypt symmetric key with public key
    encrypted_key = encrypt_symmetric_key(public_key, symmetric_key)

    return jsonify(encrypted_key)

@app.route('/api/encrypt_message', methods=['POST'])
def encrypt_message_route():
    input_data = request.json  # Assuming data is sent as JSON
    combined_data = input_data.get('argums', '')

    # Splitting the combined keys by the delimiter ';'
    message, symmetric_key = combined_data.split(';')
    cipher_details = encrypt_secret_link(symmetric_key, message)
    return Response(
        response=json.dumps(cipher_details),
        status=200,
        mimetype='application/json'
    )
    return jsonify(encrypt_secret_link(symmetric_key, message))

if __name__ == '__main__':
    app.run(debug=True)