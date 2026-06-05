from flask import Flask, jsonify
import datetime
import os

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "message": "CI/CD Pipeline is working!",
        "author": "Avinash Bagul",
        "project": "AWS DevOps CI/CD Platform",
        "timestamp": str(datetime.datetime.now())
    })

@app.route('/health')
def health():
    return jsonify({
        "status": "healthy",
        "uptime": str(datetime.datetime.now())
    }), 200

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)