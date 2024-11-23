from random import randint
import datetime
import psycopg

hostname = 'localhost'
database = 'databaseNsu'
username = 'postgres'
passd = 'postgres'
portId= 5430

def insertEmployees(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table employees cascade")
        cursor.execute("alter sequence employees_id_seq restart with 1");
        
        nameNumber = 0;
        employees = []
        for i in range(20):
            employees.append(("name" + str(nameNumber), 1, 1));
            nameNumber += 1
        
        for i in range(200):
            employees.append(("name" + str(nameNumber), 2, 1));
            nameNumber += 1
        
        for i in range(1000):
            employees.append(("name" + str(nameNumber), 3, 2));
            nameNumber += 1
        
        for i in range(4000):
            employees.append(("name" + str(nameNumber), 4, 3));
            nameNumber += 1

        insertScript = "insert into employees (name, position_id, manager_id) values (%s, %s, %s)"
        cursor.executemany(insertScript, employees)

def insertClients(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table clients cascade")
        cursor.execute("alter sequence clients_id_seq restart with 1");

        nameNumber = 5221;
        clients = []
        employment = ['t1', 't2', 't3', 't4']
        employmentIndex = 0;
        for i in range (150000):
            clients.append(("name" + str(nameNumber), employment[employmentIndex]));
            employmentIndex = (employmentIndex + 1) % 4
            
        insertScript = "insert into clients (name, employment) values (%s, %s)"
        cursor.executemany(insertScript, clients)
            
def insert(dbConnect):
    # insertEmployees(dbConnect)
    # insertClients(dbConnect)
    print("insert")

def update(dbConnect):
    print("update");

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
            cursor.execute("set search_path to bank")

        insert(dbConnect)
        update(dbConnect)

    except Exception as error:
        print(error)
    finally:
        if dbConnect is not None:
            dbConnect.close()

if __name__ == '__main__':
    main()