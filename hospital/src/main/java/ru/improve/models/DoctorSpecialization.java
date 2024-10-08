package ru.improve.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DoctorSpecialization {

    private int doctorId;

    private int specializationId;
}
