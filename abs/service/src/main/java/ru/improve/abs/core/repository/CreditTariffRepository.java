package ru.improve.abs.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.improve.abs.model.CreditTariff;

import java.util.List;

public interface CreditTariffRepository extends JpaRepository<CreditTariff, Integer> {

    List<CreditTariff> findAll();
}
