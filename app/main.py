from flask import Flask, jsonify, Response
import datetime
import os
import time

app = Flask(__name__)

# Simple in-memory counters for Prometheus metrics
REQUEST_COUNT = {}
REQUEST_LATENCY = {}

def track_request(endpoint, method, start_time):
    key = f"{method}_{endpoint}"
    REQUEST_COUNT[key] = REQUEST_COUNT.get(key, 0) + 1
    latency = time.time() - start_time
    if key not in REQUEST_LATENCY:
        REQUEST_LATENCY[key] = []
    REQUEST_LATENCY[key].append(latency)

@app.route('/')
def home():
    start = time.time()
    response = jsonify({
        "message": "CI/CD Pipeline - Auto Deployed v2!",
        "author": "Avinash Bagul",
        "project": "AWS DevOps CI/CD Platform",
        "timestamp": str(datetime.datetime.now())
    })
    track_request('/', 'GET', start)
    return response

@app.route('/health')
def health():
    return jsonify({
        "status": "healthy",
        "uptime": str(datetime.datetime.now())
    }), 200

@app.route('/metrics')
def metrics():
    lines = []
    lines.append('# HELP http_requests_total Total HTTP requests')
    lines.append('# TYPE http_requests_total counter')
    for key, count in REQUEST_COUNT.items():
        method, endpoint = key.split('_', 1)
        lines.append(f'http_requests_total{{method="{method}",endpoint="{endpoint}"}} {count}')

    lines.append('# HELP http_request_latency_seconds Request latency')
    lines.append('# TYPE http_request_latency_seconds gauge')
    for key, latencies in REQUEST_LATENCY.items():
        method, endpoint = key.split('_', 1)
        avg = sum(latencies) / len(latencies) if latencies else 0
        lines.append(f'http_request_latency_seconds{{method="{method}",endpoint="{endpoint}"}} {avg:.4f}')

    return Response('\n'.join(lines), mimetype='text/plain')

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)