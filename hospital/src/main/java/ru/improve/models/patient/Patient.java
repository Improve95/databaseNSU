package ru.improve.models.patient;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Patient {

    private int id;

    private LocalDateTime comingTime;

    private LocalDate releaseTime;

    private int doctorId;

    private PatientStatus status;

    private int personId;
}
