import mysql.connector

def get_all_questions():
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
    return ["Question 1", "Question 2",
            "Question 3", "Question 4"]
