from flask import Flask, request, render_template
from datetime import date

app = Flask(__name__)

datetoday = date.today().strftime("%m_%d_%y")
datetoday2 = date.today().strftime("%d-%B-%Y")


def replace_multiple_newlines(text):
    lines = text.split('\n')
    lines = [line for line in lines if line.strip()]
    return len(lines)

@app.route('/')
def home():
    return render_template('home.html', datetoday2=datetoday2)

@app.route('/count', methods=['GET', 'POST'])
def count():
    text = request.form['text']

    words = len(text.split())

    paras = replace_multiple_newlines(text)

    text = text.replace('\r', '')
    text = text.replace('\n', '')

    chars = len(text)
    return render_template('home.html', words=words, paras=paras, chars=chars, datetoday2=datetoday2)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
