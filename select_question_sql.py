import mysql.connector

def get_all_questions():
    try:
        cnx = mysql.connector.connect(
            host="benntay.mysql.pythonanywhere-services.com",
            user="benntay",
            password="pythonanywhere",
            database="benntay$default"
        )
        cursor = cnx.cursor()
        cursor.execute("SELECT aid, title, due_date FROM assessment")
        result_rows = cursor.fetchall()
        cnx.commit()
        cursor.close()
        cnx.close()
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    return_list = []
    for result in result_rows:
        return_list.append(result[1])
    return (result_rows, return_list)