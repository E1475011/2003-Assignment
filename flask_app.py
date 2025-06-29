from flask import Flask, render_template, request, session, redirect, url_for, send_file, abort, make_response
import mysql.connector
from uuid import uuid4
import hashlib
import select_question_sql
import get_scores_curruser
import submission_grading
import datetime
import pandas
import os
import csv
import io

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
            #session['curr_user'] = username
            cursor.execute("INSERT INTO login_session (session_id, username, started_at) VALUES (%s, %s, now())", (session['number'], username))
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
    return render_template("selectquestion.html", parameter = 'submit', questions = questions[0], titles = questions[1])

# Submit - After Select Question
@app.route('/submitquestion', methods = ['GET', 'POST'])
def submit():
    if request.method == 'POST':
        # debug_code = []
        # debug_model = []
        counter = 1
        tid = []
        code = []
        while request.form.get(f"tid {counter}"):
            tid.append(request.form[f"tid {counter}"])
            code.append(request.form[f"code {counter}"])
            counter += 1
        joined_code = '\n\n'.join(code)
        cnx = mysql.connector.connect(
            host="benntay.mysql.pythonanywhere-services.com",
            user="benntay",
            password="pythonanywhere",
            database="benntay$default"
        )
        cursor = cnx.cursor()
        cursor.execute("SELECT aid from task t where t.tid = %s",(tid[0], ))
        aid = cursor.fetchall()[0][0]
        cursor.execute("SELECT s.username FROM students s, login_session l WHERE s.username = l.username AND l.session_id = %s",(session['number'],))
        username = cursor.fetchall()[0][0]
        cursor.execute("SELECT attempt_no from submission s where s.aid =%s and s.username = %s ORDER BY attempt_no DESC LIMIT 1",(aid, username))
        results = cursor.fetchall()
        if len(results) == 0:
            attempt_no = 1
        else:
            attempt_no = results[0][0] + 1
        # new connection needed for test database
        cnx1 = mysql.connector.connect(
            host="benntay.mysql.pythonanywhere-services.com",
            user="benntay",
            password="pythonanywhere",
            database="benntay$test"
        )
        cursor1 = cnx1.cursor()
        assessment_grade = []
        # submission / model results
        for task_idx in range(len(code)):
            task_grade = []
            task_answer = code[task_idx].split(";")[:-1]
            for part_idx in range(len(task_answer)):
                if task_answer[part_idx].lower().strip().startswith("select"):
                    # submission
                    try:
                        cursor1.execute(task_answer[part_idx])
                        code_execute = cursor1.fetchall()
                    except:
                        code_execute = ()
                    # model
                    cursor.execute("SELECT model_ans FROM parts where tid = %s and pid = %s", (tid[task_idx], part_idx))
                    model_execute = cursor.fetchall()
                    # debug_code.append(code_execute)
                    # debug_model.append(model_execute)
                    grade = submission_grading.rs_similarity(code_execute, model_execute)
                    task_grade.append(grade)
                else:
                    # submission
                    try:
                        cursor1.execute(task_answer[part_idx])
                        cnx1.commit()
                        cursor.execute("SELECT query FROM parts where tid = %s and pid = %s", (tid[task_idx], part_idx))
                        query = cursor.fetchall()
                        cursor1.execute(query)
                        code_execute = cursor1.fetchall()
                        cursor1.callproc("ResetDatabase")
                    except:
                        code_execute = ()
                    # model
                    cursor.execute("SELECT model_ans FROM parts where tid = %s and pid = %s", (tid[task_idx], part_idx))
                    model_execute = cursor.fetchall()
                    # debug_code.append(code_execute)
                    # debug_model.append(model_execute)
                    grade = submission_grading.rs_similarity(code_execute, model_execute)
                    task_grade.append(grade)
            assessment_grade.append(sum(task_grade)/len(task_grade))
        overall_grade = sum(assessment_grade)/len(assessment_grade)
        # insert submission into submission table
        cursor.execute("INSERT INTO submission (aid, username, code, attempt_no, score, submitted_at) VALUES (%s, %s, %s, %s, %s, now())", (aid, username, joined_code, attempt_no, overall_grade))
        cnx.commit()
        cursor1.close()
        cnx1.close()
        cursor.close()
        cnx.close()
        # return f'{debug_code}, {debug_model}'
        return redirect('/home')
    
    # GET method - sample route: /submitquestion?question_no=(1, 'Math Quiz 1', datetime.datetime(2025, 7, 1, 9, 0))

    # request.args.get('question_no') = '(1, 'Math Quiz 1', datetime.datetime(2025, 7, 1, 9, 0))'
    question_no = request.args.get('question_no')[1:]
    # question_no = '1, 'Math Quiz 1', datetime.datetime(2025, 7, 1, 9, 0))'
    question_parts = question_no.split("'")
    # question_parts = ['1, ', 'Math Quiz 1', ', datetime.datetime(2025, 7, 1, 9, 0))']
    date_str = question_parts[2][2:-1]
    # date_str = 'datetime.datetime(2025, 7, 1, 9, 0)'
    date_time = eval(date_str)
    # eval changes datetime format to str -> 2025-07-01 09:00:00
    assessment = {
        "aid":question_parts[0][:-2], # aid = '1'
        "title":question_parts[1], # title = Math Quiz 1
        "due_date":date_time, # due_date = 2025-07-01 09:00:00
    }
    cnx = mysql.connector.connect(
            host="benntay.mysql.pythonanywhere-services.com",
            user="benntay",
            password="pythonanywhere",
            database="benntay$default"
        )
    cursor = cnx.cursor()
    cursor.execute("SELECT t.tid, t.title from assessment a, task t where a.aid = t.aid and a.aid = %s",(assessment['aid'], ))
    tasks = cursor.fetchall()
    cursor.close()
    cnx.close()
    return render_template("submit.html", assessment = assessment, tasks = tasks)

# Score - Select Question
@app.route('/score', methods = ['GET'])
def score_select_question():
    questions = select_question_sql.get_all_questions()
    return render_template("selectquestion.html", parameter = 'score', questions = questions[0], titles = questions[1])

# Score - After Select Question
@app.route('/scorequestion', methods = ['GET'])
def score():

    #get aid - need to split question_no which is a string
    question_no = request.args.get('question_no')[1:]
    #output: (1, 'Math Quiz 1', datetime.datetime(2025, 7, 1, 9, 0))
    question_parts = question_no.split("'")
    assessment_id = int(question_parts[0][:-2])
    
    submission_details = get_scores_curruser.get_data_submission(assessment_id)

    # submission_id, aid, username, attempt, score,          submitted_at
    #output: ( 7,       2,    'ben',   1,       0.0,  datetime.datetime(2025, 5, 31, 0, 0))

    #building tuple for AID and score
    s_details_tup = []
    current_user = get_scores_curruser.get_current_user() # get username
    for s_items in submission_details:
        if s_items[2] == current_user:
            s_details_tup.append((s_items[1], s_items[4]))

    #final - pass a var to score page, with the data from get scores
    return render_template("score.html", s_details_tup = s_details_tup, title = question_parts[1])



# Leaderboard
@app.route('/leaderboard', methods = ['GET'])
def leaderboard():
    questions = select_question_sql.get_all_questions()
    return render_template("selectquestion.html", parameter = 'leaderboard', questions = questions[0], titles = questions[1])

# Leaderboard - Select Question
@app.route('/leaderboardquestion', methods = ['GET'])
def leaderboard_select_question():
    question_no = request.args.get('question_no')[1:] # question_no = request.args.get('question_no')
    question_parts = question_no.split("'")
    
    cnx = mysql.connector.connect(
            host="benntay.mysql.pythonanywhere-services.com",
            user="benntay",
            password="pythonanywhere",
            database="benntay$default"
        )
    cursor = cnx.cursor()
    aid = int(question_parts[0][:-2])
    cursor.execute("SELECT username, score FROM submission WHERE aid = %s ORDER BY score DESC LIMIT 5;",(aid,))
    topscorers = cursor.fetchall()
    cursor.close()
    cnx.close()
    return render_template("leaderboard.html", title = question_parts[1], topscorers = topscorers)
    # names = ['bob','charlie','adam','eve','ben']
    # return render_template("leaderboard.html", question_no = question_no, topscorers = names)

# Change Password
@app.route('/changepassword', methods = ['GET', 'POST'])
def change_password():
    error = None
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
        cursor.execute("SELECT s.username, s.password_hash FROM students s, login_session l WHERE s.username = l.username AND l.session_id = %s",(session['number'],))
        result_rows = cursor.fetchall()
        username, password_hash = result_rows[0][0], result_rows[0][1]
        if password_hash != oldpassword:
            error = 'Password change was unsuccessful. Please try again.'
            cursor.close()
            cnx.close()
        else:
            cursor.execute("UPDATE students SET password_hash=%s WHERE password_hash=%s AND username=%s",(newpassword, oldpassword, username))
            cnx.commit()
            cursor.close()
            cnx.close()
            return redirect('/login')
    return render_template("changepassword.html", error = error)

# @app.route('/export', methods = ['GET'])
# def export():
#     try:
#         cnx = mysql.connector.connect(
#             host="benntay.mysql.pythonanywhere-services.com",
#             user="benntay",
#             password="pythonanywhere",
#             database="benntay$default"
#         )
#         cursor = cnx.cursor()
#         df = pandas.read_sql("SELECT submission_id, aid, username, code, attempt_no, score, submitted_at FROM submission", cnx)
#         file_path = "/home/BenOng/mysite/score.csv"
#         df.to_csv(file_path, index=False)
#         cursor.close()
#         cnx.close()
#     except Exception as e:
#         print(f"An unexpected error occurred: {e}")
        
#     if os.path.exists(file_path):
#         return send_file(file_path, as_attachment=True)
#     else:
#         return abort(404, description="CSV file not found.")

@app.route('/export', methods = ['GET'])
def export():
    cnx = mysql.connector.connect(
        host="benntay.mysql.pythonanywhere-services.com",
        user="benntay",
        password="pythonanywhere",
        database="benntay$default"
    )
    cursor = cnx.cursor()
    cursor.execute("SELECT submission_id, aid, username, code, attempt_no, score, submitted_at FROM submission")
    result_rows = cursor.fetchall()
    export_file = io.StringIO()
    writer = csv.writer(export_file)
    writer.writerow(['submission_id', 'aid', 'username', 'code', 'attempt_no', 'score', 'submitted_at'])
    writer.writerows(result_rows)
    cursor.close()
    cnx.close()
    response = make_response(export_file.getvalue())
    response.headers["Content-Disposition"] = "attachment; filename=final_result.csv"
    response.headers["Content-Type"] = "text/csv"
    return response


if __name__ == '__main__':
    app.run()