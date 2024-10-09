import random
import psycopg

hostname = 'localhost'
database = 'databaseNSU'
username = 'postgres'
passd = 'postgres'
portId= 5430

dbConnect = None
cursor = None

def insert(cursor):
    cursor.execute("alter sequence habitat_id_seq restart with 1")
    cursor.execute("truncate table habitat cascade")

    climateType = ['CL1', 'CL2', 'CL3', 'CL4']
    continentType = ['CO1', 'CO2', 'CO3', 'CO4', 'CO5', 'CO6']

    insertScript = "insert into habitat (name, climate, continent) values (%s, %s, %s)"
    insertValue = ("'habitatName0'", 'CL1', 'CO1')
    cursor.execute(insertScript, insertValue)

def main():
    try:
        dbConnect = psycopg.connect(
                    host = hostname,
                    dbname = database,
                    user = username,
                    password = passd,
                    port = portId)

        cursor = dbConnect.cursor()
        cursor.execute("set search_path to zoo")

        insert(cursor)
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