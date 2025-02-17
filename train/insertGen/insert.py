from random import randint
from datetime import datetime, timedelta
import psycopg

hostname = 'localhost'
database = 'databaseNsu'
username = 'postgres'
passd = 'postgres'
portId= 5430

def insertStaff(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table staff cascade")
        cursor.execute("alter sequence staff_id_seq restart with 1")
        
        position = ['p1', 'p2', 'p3']
        nameNumber = 0
        passportNumber = 0
        passportSeries = 0
        employees = []
        for i in range(2):
            employees.append(("name" + str(nameNumber), passportSeries, passportNumber, position[0], None))
            nameNumber += 1
            passportNumber += 1
            passportSeries += 1
        
        managerId = 1
        for i in range(10):
            employees.append(("name" + str(nameNumber), passportSeries, passportNumber, position[1], managerId))
            nameNumber += 1
            managerId += 1
            passportNumber += 1
            passportSeries += 1
            if (managerId > 2):
                managerId = 1
        
        managerId = 3
        for i in range(20):
            employees.append(("name" + str(nameNumber), passportSeries, passportNumber, position[1], managerId))
            nameNumber += 1
            managerId += 1
            passportNumber += 1
            passportSeries += 1
            if (managerId > 3 + 10):
                managerId = 3
        
        managerId = 13
        for i in range(80):
            employees.append(("name" + str(nameNumber), passportSeries, passportNumber, position[2], managerId))
            nameNumber += 1
            managerId += 1
            passportNumber += 1
            passportSeries += 1
            if (managerId > 13 + 20):
                managerId = 13

        insertScript = "insert into staff (name, passport_series, passport_number, position, manager_id) values (%s, %s, %s, %s, %s)"
        cursor.executemany(insertScript, employees)

def insert(dbConnect):
    insertStaff(dbConnect)
    print("insert")

def update(dbConnect):
    print("update")

def main():
    try:
        dbConnect = psycopg.connect(
                    host = hostname,
                    dbname = database,
                    user = username,
                    password = passd,
                    port = portId)

        dbConnect.autocommit = True

        with dbConnect.cursor() as cursor:
            cursor.execute("set search_path to trains")

        insert(dbConnect)
        # update(dbConnect)

    except Exception as error:
        print(error)
    finally:
        if dbConnect is not None:
            dbConnect.close()

if __name__ == '__main__':
    main()
    