package ru.improve.models.staff;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Staff {

    private int id;

    private int salary;

    private StaffPosition position;
}
