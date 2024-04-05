from flask import Flask, request, jsonify, Response
from flask_cors import CORS
import json
import base64
from comparativeFeedbackGenerator import generate_summary
from symmetricCrypto import generate_key_pair, decrypt_aes, decrypt_symmetric_key, decrypt_secret_link, encrypt_rsa, generate_sym_key, encrypt_aes, encrypt_symmetric_key, encrypt_secret_link

app = Flask(__name__)
CORS(app)

@app.route('/backend/feedbackGenerator', methods=['POST'])
def get_feedback_summary():
    applicant_id = request.json['applicantId']
    summary = generate_summary(applicant_id)
    return jsonify(summary)

@app.route('/backend/generate_key_pair', methods=['GET'])
def generate_key_pair_route():
    key_pair = generate_key_pair()
    return Response(
        response=json.dumps(key_pair),
        status=200,
        mimetype='application/json'
    )

@app.route('/backend/decrypt_key', methods=['POST'])
def decrypt_key_route():
    input_data = request.json  # Assuming data is sent as JSON
    combined_data = input_data.get('keys', '')
    private_key, encrypted_key = combined_data.split(';')
    decoded_key = decrypt_symmetric_key(private_key, encrypted_key)
    return jsonify(base64.b64encode(decoded_key).decode('utf-8'))

@app.route('/backend/decrypt_message', methods=['POST'])
def decrypt_message_route():
    input_data = request.json  # Assuming data is sent as JSON
    combined_parameters = input_data.get('parameters', '')
    symmetric_key, ciphertext, tag, nonce = combined_parameters.split(";")
    ciphertext = base64.b64decode(ciphertext)
    decrypted_message = decrypt_secret_link(symmetric_key, ciphertext, tag, nonce)
    decrypted_message_str = decrypted_message.decode('utf-8')
    return jsonify(decrypted_message_str)

@app.route('/backend/generate_symmetric_key', methods=['GET'])
def generate_symmetric_key_route():
    sym_key = generate_sym_key()
    return jsonify(base64.b64encode(sym_key).decode('utf-8'))

@app.route('/backend/encrypt_key', methods=['POST'])
def encrypt_key_route():
    input_data = request.json  # Assuming data is sent as JSON
    combined_keys = input_data.get('keys', '')

    # Splitting the combined keys by the delimiter ';'
    public_key, symmetric_key = combined_keys.split(';')

    # Encrypt symmetric key with public key
    encrypted_key = encrypt_symmetric_key(public_key, symmetric_key)

    return jsonify(encrypted_key)

@app.route('/backend/encrypt_message', methods=['POST'])
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