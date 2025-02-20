from random import randint
from datetime import datetime, time, timedelta
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
matrix = None
routesSet = None
num_routes = 0

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

    global matrix
    matrix = adj_matrix

allStationsInRoutes = []
def readRouteStructure():
    with open('allRoutes.txt', 'r') as file:
        for line in file:
            staionsInRoute = list(map(int, line.strip().split()))
            allStationsInRoutes.append(staionsInRoute)

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
        for route in allStationsInRoutes:
            num_routes += 1
            nameNumber += 1
            routesInsert.append(("route" + str(nameNumber), route[0] + 1, route[route.__len__() - 1] + 1))

        insertScript = "insert into routes (name, departure_point, arrival_point) values (%s, %s, %s)"
        cursor.executemany(insertScript, routesInsert)

def insertTrains(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table trains cascade")
        cursor.execute("alter sequence trains_id_seq restart with 1")

        cursor.execute("truncate table trains_on_route cascade")
        # cursor.execute("alter sequence trains_on_route_id_seq restart with 1")

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

        trainsOnRoute = []
        id = 1
        setupTime = datetime(2025, 2, 1)
        for i in range(num_routes):
            trainsOnRoute.append((id, id, setupTime, None))
            id += 1

        insertScript = "insert into trains_on_route (train_id, route_id, setup_time, remove_time) values (%s, %s, %s, %s)"
        cursor.executemany(insertScript, trainsOnRoute)

        railroadCars = []
        id = 1
        categoryIndex = 0
        for i in range(num_routes):
            for j in range(5):
                railroadCars.append((i + 1, i + 1, categoryIndex + 1, j))
                categoryIndex += 1
                categoryIndex %= 2
        
        insertScript = "insert into railroad_cars(train_id, route_id, category_id, number_in_train) values (%s, %s, %s, %s)"
        cursor.executemany(insertScript, railroadCars)
        
def insertRoutesStructure(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table routes_structure cascade")
        cursor.execute("alter sequence routes_structure_id_seq restart with 1")

        cursor.execute("select * from routes")
        routes = cursor.fetchall()

        structure = []
        for routeId, name, departure, arrival in routes:
            stationNumber = 0
            distance = 0
            stationInRoute = allStationsInRoutes[routeId - 1]
            for i, station in enumerate(stationInRoute):
                structure.append((routeId, station + 1, stationNumber, distance))
                # distance += matrix[station][stationInRoute[i]]
                distance += random.randint(200, 1000)
                stationNumber += 1

        insertScript = "insert into routes_structure (route_id, station_id, station_number_in_route, distance) values (%s, %s, %s, %s)"
        cursor.executemany(insertScript, structure)

def insertSchedule(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table schedule cascade")
        cursor.execute("alter sequence schedule_id_seq restart with 1")

        schedule = []
        cursor.execute("select * from routes")
        routesList = cursor.fetchall()
        monthNumber = 1
        dayNumber = 1
        for route in routesList:
            cursor.execute("select * from routes_structure where route_id = %s order by station_number_in_route", (route[0],))
            threads = cursor.fetchall()

            departureTime = None
            arrivalTime = datetime(2025, monthNumber, dayNumber, 12, 0, 0)
            for structId, routeId, station, number, distance in threads:
                schedule.append((structId, departureTime, arrivalTime))
                departureTime = arrivalTime + timedelta(hours=1)
                arrivalTime = departureTime + timedelta(minutes=10)

            monthNumber %= 7
            monthNumber += 1
            dayNumber %= 20
            dayNumber += 1

        insertScript = "insert into schedule(route_structure_id, departure_time, arrival_time) values (%s, %s, %s)"
        cursor.executemany(insertScript, schedule)

def insertRailroadBooking(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table booking cascade")
        cursor.execute("alter sequence booking_id_seq restart with 1")

        cursor.execute("truncate table railroads_cars_booking cascade")
        cursor.execute("alter sequence railroads_cars_booking_id_seq restart with 1")

        booking = []
        railroadCarBook = []

        passanger = 1
        idIndex = 1
        selectScript = "select s.* from schedule s inner join routes_structure rs on s.route_structure_id = rs.id where rs.route_id = %s order by station_number_in_route"
        cursor.execute("select * from routes")
        routesList = cursor.fetchall()
        for route in routesList:
            cursor.execute(selectScript, (route[0],))
            routeSchedule = cursor.fetchall()
            cursor.execute("select * from railroad_cars rc where rc.route_id = %s", (route[0],))
            routeRailcars = cursor.fetchall()

            for railroad in routeRailcars:
                for place in range(10):
                    booking.append((passanger, datetime(2025, 1, 10)))
                    railroadCarBook.append((railroad[0], place, routeSchedule[0][0], routeSchedule[-1][0], idIndex))

                passanger %= 1000
                passanger += 1
                idIndex += 1

        insertScript = "insert into booking(passenger_id, time) values (%s, %s)"
        cursor.executemany(insertScript, booking)

        insertScript = "insert into railroads_cars_booking(railroad_car_id, place, departure_point, arrival_point, booking_record) values (%s, %s, %s, %s, %s)"
        cursor.executemany(insertScript, railroadCarBook)

def insertDelay(dbConnect):
    with dbConnect.cursor() as cursor:
        cursor.execute("truncate table delay cascade")
        cursor.execute("alter sequence delay_id_seq restart with 1")
        
def insert(dbConnect):
    # createGraph()
    # readRouteStructure()

    # insertStaff(dbConnect)
    # insertPassengers(dbConnect)
    # insertStations(dbConnect)
    # insertRoutes(dbConnect)
    # insertTrains(dbConnect)
    # insertRoutesStructure(dbConnect)
    # insertSchedule(dbConnect)
    insertRailroadBooking(dbConnect)
    # insertDelay(dbConnect)
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
    