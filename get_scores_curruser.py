import mysql.connector

# gets data from submission table
# table rows:
# submission_id
# tid
# username
# attempt_no
# score
# submitted_at

# ignoring 
# code



def get_data_submission(aid):
    #aid is an int
    try:
        cnx = mysql.connector.connect(
            host="benntay.mysql.pythonanywhere-services.com",
            user="benntay",
            password="pythonanywhere",
            database="benntay$default"
        )
        cursor = cnx.cursor()
        #gets scores for specified aid
        SQL_cmd = f"SELECT submission_id, aid, username, attempt_no, score, submitted_at FROM submission WHERE aid = {aid}"
        cursor.execute(SQL_cmd)
        result_rows = cursor.fetchall()
        cnx.commit()
        cursor.close()
        cnx.close()
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    return result_rows


def get_current_user(sessionnumber):
    #sessionnumber is an str
    try:
        cnx = mysql.connector.connect(
            host="benntay.mysql.pythonanywhere-services.com",
            user="benntay",
            password="pythonanywhere",
            database="benntay$default"
        )
        cursor = cnx.cursor()
        #SQL_cmd = f"SELECT s.username FROM students s, login_session l WHERE s.username = l.username AND l.session_id = {sessionnumber}"
        SQL_cmd = f"SELECT s.username FROM students s, login_session l WHERE s.username = l.username"
        cursor.execute(SQL_cmd)
        curr_user = cursor.fetchall()[0][0]
        cnx.commit()
        cursor.close()
        cnx.close()
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    return curr_user
