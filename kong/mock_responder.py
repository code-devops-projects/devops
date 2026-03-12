import os
from flask import Flask, jsonify

app = Flask(__name__)

PORT = int(os.environ.get('PORT', '8080'))


@app.route('/')
def index():
    return jsonify({
        "service": os.environ.get('SERVICE_NAME', 'mock-service'),
        "message": "The requested service is currently unavailable. This is a controlled fallback response."
    }), 503


@app.route('/health')
def health():
    return jsonify({"status": "ok"}), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=PORT)