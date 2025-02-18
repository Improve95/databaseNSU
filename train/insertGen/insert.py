from random import randint
import datetime
import psycopg
import matplotlib.pyplot as plt
import networkx as nx
import random

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

def insertPassengers(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table passengers cascade")
        cursor.execute("alter sequence passengers_id_seq restart with 1")
        
        nameNumber = 5221
        passportNumber = 0
        passportSeries = 0
        passengers = []
        for i in range(1000):
            passengers.append(("name" + str(nameNumber), passportSeries, passportNumber))
            nameNumber += 1
            passportNumber += 1
            passportSeries += 1

        insertScript = "insert into passengers (name, passport_series, passport_number) values (%s, %s, %s)"
        cursor.executemany(insertScript, passengers)

num_nodes = 30
num_edges = 250
seed = 123
G = None
routesSet = None
num_routes = 435
def createGraph():
    global G
    G = nx.gnm_random_graph(num_nodes, num_edges, seed)
    adj_matrix = nx.to_numpy_array(G)
    matrixLen = adj_matrix.shape
    for i in range(matrixLen[0]):
        for j in range(matrixLen[0]):
            if (adj_matrix[i][j] == 0):
                adj_matrix[i][j] = 2147483647
            if (i == j):
                adj_matrix[i][j] = 0
    
    random.seed(seed)
    for u, v in G.edges():
        G[u][v]['weight'] = random.randint(100, 1000)
    
    global routesSet
    routesSet = set()
    for i in range(num_nodes):
        routesList = list(range(i + 1, num_nodes))
        for j in range(i + 1, num_nodes):
            randomIndex = random.randint(1, routesList.__len__()) - 1
            popIndex = routesList.pop(randomIndex)
            routesSet.add((i + 1, popIndex + 1))

    global num_routes
    num_routes = routesSet.__len__()
    
    

def insertStations(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table stations cascade")
        cursor.execute("alter sequence stations_id_seq restart with 1")

        nameNumber = 0
        stationsInsert = []
        for i in range(num_nodes):
            stationsInsert.append((i + 1, "station" + str(nameNumber)))
            nameNumber += 1
        
        insertScript = "insert into stations (id, name) values (%s, %s)"
        cursor.executemany(insertScript, stationsInsert)

def insertRoutes(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table routes cascade")
        cursor.execute("alter sequence routes_id_seq restart with 1")

        nameNumber = 0
        routesInsert = []
        for a, b in routesSet:
            routesInsert.append(("route" + str(nameNumber), a, b))
            nameNumber += 1

        insertScript = "insert into routes (name, departure_point, arrival_point) values (%s, %s, %s)"
        cursor.executemany(insertScript, routesInsert)

def insertTrains(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table trains cascade")
        cursor.execute("alter sequence trains_id_seq restart with 1")

        cursor.execute("truncate table railroad_cars cascade")
        cursor.execute("alter sequence railroad_cars_id_seq restart with 1")
        
        category = ['c1', 'c2', 'c3']
        categoryIndex = 0

        trains = []
        for i in range(num_routes):
            trains.append((category[categoryIndex], randint(1, num_nodes)))
            categoryIndex += 1
            categoryIndex %= 3

        insertScript = "insert into trains (category, header_station) values (%s, %s)"
        cursor.executemany(insertScript, trains)
        
        railroadCars = []
        for i in range(num_routes):
            for j in range(5):
                railroadCars.append((i + 1, j + 1, category[categoryIndex], None))
                categoryIndex += 1
                categoryIndex %= 3
        
        insertScript = "insert into railroad_cars(train, number, category, schema) values (%s, %s, %s, %s)"
        cursor.executemany(insertScript, railroadCars)
        
def insertThreads(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table threads cascade")
        cursor.execute("alter sequence threads_id_seq restart with 1")

        cursor.execute("select * from routes")
        routes = cursor.fetchall()

        threads = []
        trainIndex = 1
        somedate = datetime.date(2025, 2, 10)
        for route in routes:
            threads.append((route[0], trainIndex, somedate))
            trainIndex += 1
        
        insertScript = "insert into threads (route, train, date) values (%s, %s, %s)"
        cursor.executemany(insertScript, threads)

def insertSchedule(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table threads_info cascade")
        cursor.execute("alter sequence threads_info_id_seq restart with 1")

        cursor.execute("select * from threads")
        threads = cursor.fetchall()

def insert(dbConnect):
    createGraph()
    # insertStaff(dbConnect)
    # insertPassengers(dbConnect)
    # insertStations(dbConnect)
    # insertTrains(dbConnect)
    # insertRoutes(dbConnect)
    insertThreads(dbConnect)
    print("insert")

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

    except Exception as error:
        print(error)
    finally:
        if dbConnect is not None:
            dbConnect.close()

if __name__ == '__main__':
    main()
    