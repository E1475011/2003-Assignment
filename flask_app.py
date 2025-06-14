from flask import Flask, render_template, request
import mysql.connector

app = Flask(__name__)
app.debug = True

login_dict = {
    'benn': 'benn1',
    'zongyu': 'zongyu',
    'tricia': 'tricia1',
    'sasi': 'sasi',
    'ben': 'ben'
}

# Login
@app.route('/', methods = ['GET'])
@app.route('/login', methods = ['GET'])
def home_page():
    # check token
    # if token, forward to home page
    # if no token:
    return render_template("login.html")

# Home
@app.route('/home', methods = ['POST', 'GET'])
def login():
    if request.method == 'POST':
        login_details = (request.form.get("loginId"), request.form.get("password"))
        if login_details in list(login_dict.items()):
            return render_template("home.html")
        return render_template("login.html")
    if request.method == 'GET':
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
    cnx = mysql.connector.connect(
        host="BenOng.mysql.pythonanywhere-services.com",
        user="BenOng", password="2003Assignment",
        database="BenOng$First" )
    cursor = cnx.cursor()
    cursor.execute("SELECT * FROM students")
    result_rows = cursor.fetchall()
    for row in result_rows:
        print(row)
    cnx.commit()
    cursor.close()
    cnx.close()
    question_no = request.args.get('question_no')
    return render_template("leaderboard.html", question_no = result_rows)

# Change Password
@app.route('/changepassword', methods = ['GET'])
def change_password():
    return render_template("changepassword.html")

if __name__ == '__main__':
    app.run()