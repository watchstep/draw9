from flask import Flask, jsonify, request
# from flask_ngrok import run_with_ngrok

app = Flask(__name__)
# run_with_ngrok(app)

@app.route('/')
def root():
    return 'Hello World'

if __name__ == '__main__':
    app.run()