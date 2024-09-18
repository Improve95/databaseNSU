package ru.improve.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Person {

    private int id;

    private String name;

    private String secondName;

    private String phone;

    public Person(String name, String secondName, String phone) {
        this.name = name;
        this.secondName = secondName;
        this.phone = phone;
    }
}
