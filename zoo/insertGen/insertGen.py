from random import randint
import datetime
import psycopg

hostname = 'localhost'
database = 'databaseNsu'
username = 'postgres'
passd = 'postgres'
portId= 5430

dbConnect = None
cursor = None

def insertHabitat(cursor):
    cursor.execute("alter sequence habitat_id_seq restart with 1")
    cursor.execute("truncate table habitat cascade")

    climateType = ['CL1', 'CL2', 'CL3', 'CL4']
    continentType = ['CO1', 'CO2', 'CO3', 'CO4', 'CO5', 'CO6']

    habitatName = 0
    climateTypei = 0
    continentTypei = 0

    for i in range(5):
        insertScript = "insert into habitat (name, climate, continent) values (%s, %s, %s)"
        insertValue = (f"habitatename{str(habitatName)}", f"{climateType[climateTypei]}", f"{continentType[climateTypei]}")
        cursor.execute(insertScript, insertValue)

        habitatName += 1
        climateTypei = (climateTypei + 1) % 4
        continentTypei = (continentTypei + 1) % 6

def insertAnimalType(cursor):
    cursor.execute("alter sequence animal_type_id_seq restart with 1")
    cursor.execute("truncate table animal_type cascade")

    foodType = ['PREDATOR', 'HERBIVORE', 'OMNIVOROUS']
    foodTypei = 0
    habitat = 1
    for i in range(15):
        insertScript = "insert into animal_type (name, food_type, habitat) VALUES (%s, %s, %s)"
        insertValue = ("name" + str(i), f"{foodType[foodTypei]}", habitat)
        cursor.execute(insertScript, insertValue)

        foodTypei = (foodTypei + 1) % 3
        if (habitat == 5):
            habitat = 1
        else:
            habitat += 1

def insertCage(cursor):
    cursor.execute("alter sequence cage_id_seq restart with 1")
    cursor.execute("truncate table cage cascade")

    for i in range(10):
        insertScript = "insert into cage (length, width, height, place) values (%s, %s, %s, %s)"
        insertValue = (1, 1, 1, "place")
        cursor.execute(insertScript, insertValue)

def insertAnimal(cursor):
    cursor.execute("alter sequence animal_id_seq restart with 1")
    cursor.execute("truncate table animal cascade")

    animalType = 1
    cage = 1

    namei = 0
    
    for i in range(10):
        nowTime = datetime.datetime.now()
        comingTime = nowTime - datetime.timedelta(days=randint(1, 5), hours=randint(0, 23));
        insertScript = "insert into animal(animal_type, cage, name, weight, length, coming_time) values (%s, %s, %s, %s, %s, %s)"
        insertValue = (animalType, cage, "name" + str(namei), randint(10, 1000), 1, comingTime)
        cursor.execute(insertScript, insertValue)

        namei += 1
        if (cage == 5):
            cage = 1
        else:
            cage += 1

    cage = 6

    for i in range(28):
        nowTime = datetime.datetime.now()
        comingTime = nowTime - datetime.timedelta(days=randint(1, 5), hours=randint(0, 23));
        insertScript = "insert into animal(animal_type, cage, name, weight, length, coming_time) values (%s, %s, %s, %s, %s, %s)"

        namei += 1
        if (cage == 10):
            cage = 6
        else:
            cage += 1

        animalType = randint(1, 15)
        insertValue = (animalType, cage, "name" + str(namei), randint(10, 1000), 1, comingTime)
        cursor.execute(insertScript, insertValue)

def insert(cursor):
    insertHabitat(cursor)
    insertAnimalType(cursor)
    insertCage(cursor)
    insertAnimal(cursor)

def update(cursor):
    insertScript = "update animal set cage = %s where animal_type = %s"
    insertValue = (randint(1, 10), randint(1, 15))
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