from flask import Flask, request, jsonify
from deepsparse import TextGeneration

app = Flask(__name__)

# Your API key
KEY = "ReplaceMe.123!"

# Initialize the text generation pipeline
pipeline = TextGeneration(model="zoo:mpt-7b-dolly_mpt_pretrain-pruned50_quantized")

# Authentication middleware
def authenticate(key):
    return key == KEY

# API route for text generation
@app.route('/generate_text', methods=['POST'])
def generate_text():
    # Check if the request has the API key
    if 'key' not in request.headers:
        return jsonify({'error': 'API key is missing'}), 401

    key = request.headers['key']

    # Authenticate the request
    if not authenticate(key):
        return jsonify({'error': 'Invalid API key'}), 401

    # Parse request data
    data = request.get_json()
    prompt = data.get('prompt', '')

    # Generate text
    generated_text = pipeline(prompt, max_new_tokens=75).generations[0].text

    return jsonify({'generated_text': generated_text})

if __name__ == '__main__':
    # Run the app, listening on all IP addresses
    app.run(host='127.0.0.1', port=5000, debug=False)
