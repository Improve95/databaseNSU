from random import randint
import datetime, time
import psycopg
import matplotlib.pyplot as plt
import networkx as nx
import random

INTEGER_MAX = 2147483647

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

num_nodes = 80
num_edges = 110
seed = 123
G = None
routesSet = None
num_routes = 0

def dijsktra(matrix, size, start):
    minDist = [INTEGER_MAX] * size
    minDist[start] = 0

    minPath = [0] * size
    used = [False] * size

    for i in range(size):
        nearest = -1
        for v in range(size):
            if ((not used[v]) and (nearest == -1 or minDist[nearest] > minDist[v])):
                nearest = v
        
        if (minDist[nearest] == INTEGER_MAX):
            continue
        used[nearest] = True

        for v in range(size):
            len = minDist[nearest] + matrix[nearest][v]
            if (minDist[v] > len):
                if (matrix[nearest][v] != -1):
                    minDist[v] = int(len)
                    minPath[v] = int(nearest)

    return minDist, minPath

def createGraph():
    global G
    G = nx.gnm_random_graph(num_nodes, num_edges, seed)
    
    random.seed(seed)
    for u, v in G.edges():
        G[u][v]['weight'] = random.randint(100, 1000)
    
    adj_matrix = nx.to_numpy_array(G)
    matrixLen = adj_matrix.shape
    for i in range(matrixLen[0]):
        for j in range(matrixLen[0]):
            if (adj_matrix[i][j] == 0):
                adj_matrix[i][j] = -1
            if (i == j):
                adj_matrix[i][j] = 0

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
    
        global num_routes
        with open('allRoutes.txt', 'r') as file:
            for line in file:
                num_routes += 1
                nameNumber += 1
                route = list(map(int, line.strip().split()))
                routesInsert.append(("route" + str(nameNumber), route[0] + 1, route[route.__len__() - 1] + 1))

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
        
        insertScript = "insert into railroad_cars(train, number_in_train, category, schema) values (%s, %s, %s, %s)"
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

        allStationsInRoutes = []
        with open('allRoutes.txt', 'r') as file:
            for line in file:
                staionsInRoute = list(map(int, line.strip().split()))
                allStationsInRoutes.append(staionsInRoute)

        
        schedule = []
        for id, route, train, date in threads:
            stationNumberInThread = 0
            arrivalTime = None
            departureTime = datetime.combine(date, time(12, 0, 0))
            for station in allStationsInRoutes[route - 1]:
                schedule.append(id, station, stationNumberInThread, arrivalTime)
                stationNumberInThread += 1

        insertScript = "insert into threads_info (thread, station, station_number_in_thread, arrival_time, departure_time, distance) values (%s, %s, %s, %s, %s, %s)"
        cursor.executemane(insertScript, schedule)

def insert(dbConnect):
    createGraph()
    # insertStaff(dbConnect)
    # insertPassengers(dbConnect)
    # insertStations(dbConnect)
    # insertRoutes(dbConnect)
    # insertTrains(dbConnect)
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
    