insert = open("insert.txt", "w")

specs = ["Surgery", "Neurology", "Pediatrics", "Cardiology", "Dermatology", "Stomatology", "Terapevt", "Dermatolog", "Okulist", "Lor"]
insert.write("truncate table specialization cascade ;\nalter sequence specialization_id_seq restart with 1;\n")
for spec in specs:
    insertQuest = f"insert into specialization (name) values ('{spec}');\n"
    insert.write(insertQuest)
    
insert.write("truncate table department cascade ;\nalter sequence department_id_seq restart with 1;\n")
departs = ["Cardiology", "Neurology", "Orthopedics", "Pediatrics", "Dermatology"]
specIndex = 1
capacity = 10
for depart in departs:
    insertQuest = f"insert into department (specialization_id, name, capacity) values ({specIndex}, '{depart}', {capacity});\n"
    insert.write(insertQuest)
    specIndex += 1

insert.write("truncate table staff cascade ;\nalter sequence staff_id_seq restart with 1;\ntruncate table staff_change cascade ;\nalter sequence staff_change_id_seq restart with 1;")
series = 1234
number = 123456 
phone = 77777777777
index = 0
salary = 50000
department = 1
pos = ["CLEANER", "ACCOUNTANT", "DOCTOR"]
posIndex = 2
staffChangeTypes = ["SALARY", "POSITION", "DEPARTMENT"]
for i in range(1, 31):
    insertQuest1 = f"insert into staff (passport_series, passport_number, name, second_name, phone, salary, department_id, position) values ('{series}', '{number}', '{'name' + str(index)}', '{'second_name' + str(index)}', '{phone}', {salary}, {department}, '{pos[posIndex]}');\n"
    insertQuest2 = f"insert into staff_change (staff_id, change_field, before, after) values({i}, '{staffChangeTypes[0]}', null, {salary});\n"
    insertQuest3 = f"insert into staff_change (staff_id, change_field, before, after) values({i}, '{staffChangeTypes[1]}', null, '{pos[posIndex]}');\n"
    insertQuest4 = f"insert into staff_change (staff_id, change_field, before, after) values({i}, '{staffChangeTypes[2]}', null, {department});\n"

    series += 1
    number += 1
    phone += 1
    index += 1
    salary += 2000
    department = (department + 1) % 6
    if (department == 0): 
        department = 1

    insert.write(insertQuest1)
    insert.write(insertQuest2)
    insert.write(insertQuest3)
    insert.write(insertQuest4)

salary = 70000
id = 30
for i in range(1, 11):
    insertQuest1 = f"insert into staff (passport_series, passport_number, name, second_name, phone, salary, department_id, position) values ('{series}', '{number}', '{'name' + str(index)}', '{'second_name' + str(index)}', '{phone}', {salary}, {department}, '{pos[posIndex]}');\n"
    insertQuest2 = f"insert into staff_change (staff_id, change_field, before, after) values({str(id + i)}, '{staffChangeTypes[0]}', null, {salary});\n"
    insertQuest3 = f"insert into staff_change (staff_id, change_field, before, after) values({str(id + i)}, '{staffChangeTypes[1]}', null, '{pos[posIndex]}');\n"
    insertQuest4 = f"insert into staff_change (staff_id, change_field, before, after) values({str(id + i)}, '{staffChangeTypes[2]}', null, {department});\n"

    series += 1
    number += 1
    phone += 1
    index += 1
    salary += 10000
    department = (department + 1) % 6
    if (department == 0): 
        department = 1
    posIndex  = (posIndex + 1) % 2

    insert.write(insertQuest1)
    insert.write(insertQuest2)
    insert.write(insertQuest3)
    insert.write(insertQuest4)

doctor = open("doctor.txt", "w")
doctor.write("\n")
doctor.write("truncate table doctor cascade ;\n")
doctor.write("alter sequence doctor_id_seq restart with 1;\n")
for i in range(1, 21):
    insertQuest = f"insert into doctor values ({str(i)});\n"
    doctor.write(insertQuest)

docSpec = open("docSpec.txt", "w")
docSpec.write("\n")
docSpec.write("truncate table doctor_specialization cascade ;\n")
docSpec.write("alter sequence doctor_specialization_id_seq restart with 1;\n")
for i in range(1, 6):
    insertQuest1 = f"insert into doctor_specialization ({i}, {i});\n"
    insertQuest2 = f"insert into doctor_specialization ({i}, {str(i * 2)});\n"
    docSpec.write(insertQuest1)
    docSpec.write(insertQuest2)


patient = open("patient.txt", "w")
patient.write("\n")
patient.write("truncate table patient cascade ;\n")
patient.write("alter sequence patient_id_seq restart with 1;\n")
for i in range(1, 60):
    
