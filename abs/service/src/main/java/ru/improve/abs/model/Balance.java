package ru.improve.abs.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "balances")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Balance {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private long id;
}

