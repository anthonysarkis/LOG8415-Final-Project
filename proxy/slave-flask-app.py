import pymysql.cursors
from flask import Flask
from flask import request

# Connect to the database
connection = pymysql.connect(
    host='172.31.46.71',
    user='root',
    password='root',
    database='sakila',
    cursorclass=pymysql.cursors.DictCursor
)

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def base_route():
    if request.method == 'POST':
        query = request.get_json(force=True)

        with connection:
            with connection.cursor() as cursor:
                cursor.execute(query)
                result = cursor.fetchone()
                print(result)

            # connection is not autocommit by default. So you must commit to save your changes.
            connection.commit()

if __name__ == '__main__':
    app.run()
