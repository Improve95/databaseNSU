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
            employees.append(("name" + str(nameNumber), 1, None));
            nameNumber += 1
        
        managerId = 1;
        for i in range(200):
            employees.append(("name" + str(nameNumber), 2, managerId));
            nameNumber += 1
            managerId += 1
            if (managerId > 20):
                managerId = 1
        
        managerId = 21;
        for i in range(1000):
            employees.append(("name" + str(nameNumber), 3, managerId));
            nameNumber += 1
            managerId += 1
            if (managerId > 220):
                managerId = 21
        
        managerId = 221;
        for i in range(4000):
            employees.append(("name" + str(nameNumber), 4, managerId));
            nameNumber += 1
            managerId += 1
            if (managerId > 1220):
                managerId = 221

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

def insertCreditTariffs(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table credit_tariff_client cascade")

        creditTariffs = []
        clientId = 1
        for i in range(0, 30000):
            creditTariffs.append((clientId, 1))
            creditTariffs.append((clientId, 2))
            clientId += 1
        
        for i in range(0, 30000):
            creditTariffs.append((clientId, 2))
            creditTariffs.append((clientId, 3))
            clientId += 1

        for i in range(0, 30000):
            creditTariffs.append((clientId, 3))
            creditTariffs.append((clientId, 4))
            clientId += 1

        for i in range(0, 30000):
            creditTariffs.append((clientId, 4))
            creditTariffs.append((clientId, 5))
            clientId += 1

        for i in range(0, 30000):
            creditTariffs.append((clientId, 1))
            creditTariffs.append((clientId, 5))
            clientId += 1

        insertScript = "insert into credit_tariff_client(client_id, credit_tariff_id) values (%s, %s)"
        cursor.executemany(insertScript, creditTariffs)


def insertCredits(dbConnect):
    None

def insert(dbConnect):
    # insertEmployees(dbConnect)
    # insertClients(dbConnect)
    insertCreditTariffs(dbConnect)
    # insertCredits(dbConnect)
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