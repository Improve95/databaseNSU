package ru.improve.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Passport {

    private int personId;

    private int series;

    private int number;
}
