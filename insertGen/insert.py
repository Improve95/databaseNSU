specialization = open("specialization", "w")

specs = ["Surgery", "Neurology", "Pediatrics", "Cardiology", "Dermatology", "Stomatology", "Terapevt", "Dermatolog", "Okulist", "Lor"]
for spec in specs:
    insertQuest = f"insert into specialization (name) values ('{spec}');\n"
    specialization.write(insertQuest)
    
department = open("department", "w")
departs = ["Cardiology", "Neurology", "Orthopedics", "Pediatrics", "Dermatology"]
specIndex = 1
capacity = 10
for depart in departs:
    insertQuest = f"insert into department (specialization_id, name, capacity) values ({specIndex}, '{depart}', {capacity});\n"
    department.write(insertQuest)
    specIndex += 1

staff = open("insert.txt", "w")
series = 1234
number = 123456 
phone = 77777777777
index = 0
salary = 50000
department = 0
pos = ["CLEANER", "ACCOUNTANT", "DOCTOR"]
posIndex = 2
for i in range(30):
    insertQuest = f"insert into staff (passport_series, passport_number, name, second_name, phone, salary, department_id, position) values ('{series}', '{number}', '{'name' + str(index)}', '{'second_name' + str(index)}', '{phone}', {salary}, {department}, '{pos[posIndex]}');\n"
    
    series += 1
    number += 1
    phone += 1
    index += 1
    salary += 2000
    department = (department + 1) % 5

    staff.write(insertQuest)

salary = 70000
for i in range(10):
    insertQuest = f"insert into staff (passport_series, passport_number, name, second_name, phone, salary, department_id, position) values ('{series}', '{number}', '{'name' + str(index)}', '{'second_name' + str(index)}', '{phone}', {salary}, {department}, '{pos[posIndex]}')\n"
    
    series += 1
    number += 1
    phone += 1
    index += 1
    salary += 10000
    department = (department + 1) % 5
    posIndex  = (posIndex + 1) % 2

    staff.write(insertQuest)

