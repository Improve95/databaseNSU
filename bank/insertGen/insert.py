from random import randint
import datetime
import psycopg

hostname = 'localhost'
database = 'databaseNsu'
username = 'postgres'
passd = 'postgres'
portId= 5430

def insertEmployees(cursor):
    insertScript = "insert into employees "


def insert(cursor):
    insertEmployees(cursor)

def main():
    try:
        dbConnect = psycopg.connect(
                    host = hostname,
                    dbname = database,
                    user = username,
                    password = passd,
                    port = portId)

        cursor = dbConnect.cursor()
        cursor.execute("set search_path to bank")

        insert(cursor)
        update(cursor)
        dbConnect.commit()

    except Exception as error:
        print(error)
    finally:
        if cursor is not None:
            cursor.close()
        if dbConnect is not None:
            dbConnect.close()

if __name__ == '__main__':
    main()