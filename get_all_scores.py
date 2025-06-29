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



def get_data_submission():
    #sessionnumber is a string
    try:
        cnx = mysql.connector.connect(
            host="benntay.mysql.pythonanywhere-services.com",
            user="benntay",
            password="pythonanywhere",
            database="benntay$default"
        )
        cursor = cnx.cursor()
        #using F-strings to get session number, which comes from flask_app.py
        cursor.execute(f"SELECT sub.submission_id, sub.aid, sub.username, sub.attempt_no, sub.score, sub.submitted_at FROM submission sub, login_session lgs WHERE sub.username = lgs.username")
        result_rows = cursor.fetchall()
        cnx.commit()
        cursor.close()
        cnx.close()
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    return result_rows


