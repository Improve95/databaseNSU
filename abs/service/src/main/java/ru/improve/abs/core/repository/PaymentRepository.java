package ru.improve.abs.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import ru.improve.abs.model.Payment;

public interface PaymentRepository extends
        PagingAndSortingRepository<Payment, Long>,
        JpaRepository<Payment, Long> {

}
