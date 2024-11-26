from random import randint
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
import psycopg

hostname = 'localhost'
database = 'databaseNsu'
username = 'postgres'
passd = 'postgres'
portId= 5430

def insertEmployees(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table employees cascade")
        cursor.execute("alter sequence employees_id_seq restart with 1")
        
        nameNumber = 0
        employees = []
        for i in range(20):
            employees.append(("name" + str(nameNumber), 1, None))
            nameNumber += 1
        
        managerId = 1
        for i in range(200):
            employees.append(("name" + str(nameNumber), 2, managerId))
            nameNumber += 1
            managerId += 1
            if (managerId > 20):
                managerId = 1
        
        managerId = 21
        for i in range(1000):
            employees.append(("name" + str(nameNumber), 3, managerId))
            nameNumber += 1
            managerId += 1
            if (managerId > 220):
                managerId = 21
        
        managerId = 221
        for i in range(4000):
            employees.append(("name" + str(nameNumber), 4, managerId))
            nameNumber += 1
            managerId += 1
            if (managerId > 1220):
                managerId = 221

        insertScript = "insert into employees (name, position_id, manager_id) values (%s, %s, %s)"
        cursor.executemany(insertScript, employees)

def insertClients(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table clients cascade")
        cursor.execute("alter sequence clients_id_seq restart with 1")

        nameNumber = 5221
        clients = []
        employment = ['t1', 't2', 't3', 't4']
        employmentIndex = 0
        for i in range (150000):
            clients.append(("name" + str(nameNumber), employment[employmentIndex]))
            employmentIndex = (employmentIndex + 1) % 4
            
        insertScript = "insert into clients (name, employment) values (%s, %s)"
        cursor.executemany(insertScript, clients)

def insertCreditTariffs(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table credit_tariff_client cascade")

        creditTariffs = []
        clientId = 1
        for i in range(30000):
            creditTariffs.append((clientId, 1))
            creditTariffs.append((clientId, 2))
            clientId += 1
        
        for i in range(30000):
            creditTariffs.append((clientId, 2))
            creditTariffs.append((clientId, 3))
            clientId += 1

        for i in range(30000):
            creditTariffs.append((clientId, 3))
            creditTariffs.append((clientId, 4))
            clientId += 1

        for i in range(30000):
            creditTariffs.append((clientId, 4))
            creditTariffs.append((clientId, 5))
            clientId += 1

        for i in range(30000):
            creditTariffs.append((clientId, 1))
            creditTariffs.append((clientId, 5))
            clientId += 1

        insertScript = "insert into credit_tariff_client(client_id, credit_tariff_id) values (%s, %s)"
        cursor.executemany(insertScript, creditTariffs)

def insertCredits(dbConnect):
     with dbConnect.cursor() as cursor:
        cursor.execute("truncate table credits cascade")

        credits = []
        clientId = 1
        for i in range(1000):
            initialDebt = randint(1000000, 2000000)
            takingDateMonthBefore = randint(1, 2)
            percent = randint(12, 19)
            creditTariffId = 0
            if (clientId < 30001):
                creditTariffId = randint(1, 2)
            elif (clientId < 60001):
                creditTariffId = randint(2, 3)
            elif (clientId < 90001):
                creditTariffId = randint(3, 4)
            elif (clientId < 120001):
                creditTariffId = randint(4, 5)
            else:
                creditTariffId = randint(1, 5)

            creditPeriod = randint(12, 24)

            percentDh = percent / 100
            monthAmount = initialDebt * (percentDh / 12.0 * (1.0 + percentDh / 12.0)**creditPeriod) / ((1.0 + percentDh / 12.0)**creditPeriod - 1.0)

            clientId += 2

            credits.append((initialDebt, takingDateMonthBefore, creditPeriod, percent, monthAmount, clientId, creditTariffId))

        insertScript = """
            insert into credits (initial_debt, taking_date, credit_period, percent, month_amount, client_id, credit_tariff_id) 
            VALUES (%s, current_timestamp - make_interval(months => %s), make_interval(months => %s), %s, %s, %s, %s)
            """
        cursor.executemany(insertScript, credits)

def insertSchedule(dbConnect):
     with dbConnect.cursor() as cursor:
        cursor.execute("truncate table payments_schedule cascade")

        cursor.execute("SELECT id, taking_date, credit_period FROM credits")
        credits = cursor.fetchall()

        shedules = []
        for credit_id, taking_date, credit_period in credits:
            payment_day = taking_date
            for i in range (credit_period.days):
                payment_day += timedelta(days=1)
                if (taking_date.day == payment_day.day):
                    shedules.append((credit_id, payment_day))

        insertScript = "insert into payments_schedule (credit_id, up_to_payment_date) VALUES (%s, %s)"
        cursor.executemany(insertScript, shedules)

def insertBalancesAndPayments(dbConnect):
    credits = []
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table payments cascade")
        cursor.execute("truncate table balances cascade")

        cursor.execute("SELECT id, initial_debt, percent, month_amount, taking_date FROM credits")
        credits = cursor.fetchall()

    payments = []
    balances = []
    currentDate = datetime.now().date()
    for creditId, debt, percent, monthAmount, takingDate in credits:
        remainingDebt = debt
        while (takingDate < currentDate):
            takingDate += timedelta(days=1)
            paymentDayBefore = randint(1, 20)
            payments.append((monthAmount, "mountly", "bank_account", creditId, takingDate - timedelta(paymentDayBefore)))

            accruedByPercent = remainingDebt * (percent / 365)
            remainingDebt -= (monthAmount - accruedByPercent)
            balances.append((creditId, accruedByPercent, currentDate))

        with dbConnect.cursor() as cursor:
            cursor.execute("update credits set initial_debt = %s where id = %s", (remainingDebt, creditId))

    insertScriptPayment = "insert into payments (amount, payment_for_what, way_of_payment, credit_id, date) VALUES (%s, %s, %s, %s, %s)"
    insertScriptBalance = "insert into balances (credit_id, accrued_by_percent, date) VALUES (%s, %s, %s)"
    with dbConnect.cursor() as cursor:
        cursor.executemany(insertScriptPayment, payments)
        cursor.executemany(insertScriptBalance, balances)


def insert(dbConnect):
    # insertEmployees(dbConnect)
    # insertClients(dbConnect)
    insertCreditTariffs(dbConnect)
    insertCredits(dbConnect)
    insertSchedule(dbConnect)
    insertBalancesAndPayments(dbConnect)
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
            cursor.execute("set search_path to bank")

        insert(dbConnect)
        # update(dbConnect)

    except Exception as error:
        print(error)
    finally:
        if dbConnect is not None:
            dbConnect.close()

if __name__ == '__main__':
    main()