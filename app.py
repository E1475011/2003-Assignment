from flask import Flask, render_template, request
import select_question_sql

app = Flask(__name__)
app.debug = True

@app.route('/', methods = ['GET'])
def home_page():
    return render_template("home.html")

@app.route('/submit', methods = ['POST'])
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
    questions = select_question_sql.get_all_questions()
    return render_template("selectquestion.html", parameter = 'leaderboard', questions = questions)

# Leaderboard - Select Question
@app.route('/leaderboardquestion', methods = ['GET'])
def leaderboard_select_question():
    question_no = request.args.get('question_no')
    return render_template("leaderboard.html", question_no = question_no)

# Change Password
@app.route('/changepassword', methods = ['GET'])
def change_password():
    return render_template("changepassword.html")

if __name__ == '__main__':
    app.run()

# something random to create conflict
