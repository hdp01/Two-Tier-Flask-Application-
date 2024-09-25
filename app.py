# app.py
from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "Hello, World! Welcome to my Flask App!"

@app.route('/about')
def about():
    return "This is a simple Flask app."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
