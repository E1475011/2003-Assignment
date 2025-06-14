from flask import Flask, render_template, request, session, redirect, url_for
import mysql.connector
from uuid import uuid4
import hashlib

app = Flask(__name__)
app.debug = True

# Login
@app.route('/', methods = ['GET'])
@app.route('/login', methods = ['GET'])
@app.route('/home', methods = ['POST'])
def home_page():
    error = None
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        m = hashlib.md5()
        m.update(request.form['password'].encode('UTF-8'))
        password = m.hexdigest()

        cnx = mysql.connector.connect(
            host="benntay.mysql.pythonanywhere-services.com",
            user="benntay",
            password="pythonanywhere",
            database="benntay$default"
        )
        cursor = cnx.cursor()
        cursor.execute("SELECT username FROM students WHERE username=%s AND password=%s",(username, password))
        result_rows = cursor.fetchall()

        if len(result_rows) != 1 or result_rows[0][0] != username:
            error = 'Invalid Credentials. Please try again.'
            cursor.close()
            cnx.close()
        else:
            session['number'] = str(uuid4())
            cursor.execute("INSERT INTO sessions (session_id, username, started_at) VALUES (%s, %s, now())", (session['number'], username))
            cnx.commit()
            cursor.close()
            cnx.close()
            return redirect(url_for('home'))
    if session['number']:
        return redirect(url_for('home'))
    return render_template('login.html', error=error)

# Home
@app.route('/home', methods = ['GET'])
def login():
    return render_template('home.html')

# Submit - Select Question
@app.route('/submit', methods = ['GET'])
def submit_select_question():
    return render_template("selectquestion.html", parameter = 'submit')

# Submit - After Select Question
@app.route('/submitquestion', methods = ['GET'])
def submit():
    question_no = request.args.get('question_no')
    return render_template("submit.html", question_no = question_no)

# Score - Select Question
@app.route('/score', methods = ['GET'])
def score_select_question():
    return render_template("selectquestion.html", parameter = 'score')

# Score - After Select Question
@app.route('/scorequestion', methods = ['GET'])
def score():
    question_no = request.args.get('question_no')
    return render_template("score.html", question_no = question_no)

# Leaderboard
@app.route('/leaderboard', methods = ['GET'])
def leaderboard():
    return render_template("selectquestion.html", parameter = 'leaderboard')

# Leaderboard - Select Question
@app.route('/leaderboardquestion', methods = ['GET'])
def leaderboard_select_question():
    try:
        cnx = mysql.connector.connect(
            host="BenOng.mysql.pythonanywhere-services.com",
            user="BenOng", password="2003Assignment",
            database="BenOng$First" )
        cursor = cnx.cursor()
        cursor.execute("SELECT * FROM student")
        result_rows = cursor.fetchall()
        cnx.commit()
        cursor.close()
        cnx.close()
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    question_no = request.args.get('question_no')
    return render_template("leaderboard.html", question_no = result_rows)

# Change Password
@app.route('/changepassword', methods = ['GET'])
def change_password():
    return render_template("changepassword.html")

if __name__ == '__main__':
    app.run()