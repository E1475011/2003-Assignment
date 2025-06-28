from flask import Flask, render_template, request, session, redirect, url_for
import mysql.connector
from uuid import uuid4
import hashlib
import select_question_sql

app = Flask(__name__)
app.debug = True

app.secret_key = 'pythonanywhere'

# Login
@app.route('/', methods = ['GET'])
@app.route('/login', methods = ['GET'])
@app.route('/home', methods = ['POST'])
def home_page():
    error = None
    if request.method == 'POST':
        username = request.form['loginId']
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
        cursor.execute("SELECT username FROM students WHERE username=%s AND password_hash=%s",(username, password))
        result_rows = cursor.fetchall()

        if len(result_rows) != 1 or result_rows[0][0] != username:
            error = 'Invalid Credentials. Please try again.'
            cursor.close()
            cnx.close()
        else:
            session['number'] = str(uuid4())
            cursor.execute("INSERT INTO session (session_id, username, started_at) VALUES (%s, %s, now())", (session['number'], username))
            cnx.commit()
            cursor.close()
            cnx.close()
            return redirect('/home')
    return render_template('login.html', error=error)

# Home
@app.route('/home', methods = ['GET'])
def login():
    return render_template('home.html')

# Submit - Select Question
@app.route('/submit', methods = ['GET'])
def submit_select_question():
    questions = select_question_sql.get_all_questions()
    return render_template("selectquestion.html", parameter = 'submit', questions = questions)

# Submit - After Select Question
@app.route('/submitquestion', methods = ['GET'])
def submit():
    question_no = request.args.get('question_no')
    return render_template("submit.html", question_no = question_no)

# Score - Select Question
@app.route('/score', methods = ['GET'])
def score_select_question():
    questions = select_question_sql.get_all_questions()
    return render_template("selectquestion.html", parameter = 'score', questions = questions)

# Score - After Select Question
@app.route('/scorequestion', methods = ['GET'])
def score():
    question_no = request.args.get('question_no')
    return render_template("score.html", question_no = question_no)

# Leaderboard
@app.route('/leaderboard', methods = ['GET'])
def leaderboard():
    questions = select_question_sql.get_all_questions()
    return render_template("selectquestion.html", parameter = 'leaderboard', questions = questions)

# Leaderboard - Select Question
@app.route('/leaderboardquestion', methods = ['GET'])
def leaderboard_select_question():
    question_no = request.args.get('question_no')
    return render_template("leaderboard.html", question_no = question_no)

# Change Password
@app.route('/changepassword', methods = ['GET', 'POST'])
def change_password():
    if request.method == 'POST':
        m = hashlib.md5()
        m.update(request.form['oldpassword'].encode('UTF-8'))
        oldpassword = m.hexdigest()
        n = hashlib.md5()
        n.update(request.form['newpassword'].encode('UTF-8'))
        newpassword = n.hexdigest()

        cnx = mysql.connector.connect(
            host="benntay.mysql.pythonanywhere-services.com",
            user="benntay",
            password="pythonanywhere",
            database="benntay$default"
        )
        cursor = cnx.cursor()
        cursor.execute("SELECT st.username FROM students st, session s WHERE st.username = s.username AND session_id = %s",(session['number'],))
        username = cursor.fetchall()[0][0]
        cursor.execute("UPDATE students SET password_hash=%s WHERE password_hash=%s AND username=%s",(newpassword, oldpassword, username))
        cnx.commit()
        cursor.close()
        cnx.close()
        return redirect('/login')
    return render_template("changepassword.html")

if __name__ == '__main__':
    app.run()