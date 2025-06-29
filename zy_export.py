import mysql.connector
import pandas as pd

def export():
    try:
        cnx = mysql.connector.connect(
            host="benntay.mysql.pythonanywhere-services.com",
            user="benntay",
            password="pythonanywhere",
            database="benntay$default"
        )
        cursor = cnx.cursor()
        
        SQL_cmd = f"SELECT submission_id, tid, username, code, attempt_no, score, submitted_at FROM submission"
        cursor.execute(SQL_cmd)
        result_rows = cursor.fetchall()


        # submission_id, aid, username, attempt, score,          submitted_at
        #output: ( 7,       2,    'ben',   1,       0.0,  datetime.datetime(2025, 5, 31, 0, 0))
        df_result_rows = pd.DataFrame(result_rows)
        #df = pandas.read_sql("SELECT submission_id, tid, username, code, attempt_no, score, submitted_at FROM submission", cnx)
        
        
        file_path = "/home/ProwlT/mysite2/score.csv"
        df.to_csv(df_result_rows, index=False)
        cursor.close()
        cnx.close()
    except Exception as e:
        print(f"An unexpected error occurred: {e}")