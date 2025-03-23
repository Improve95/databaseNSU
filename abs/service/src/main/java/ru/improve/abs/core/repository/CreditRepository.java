package ru.improve.abs.core.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import ru.improve.abs.model.credit.Credit;
import ru.improve.abs.model.User;

public interface CreditRepository extends
        PagingAndSortingRepository<Credit, Long>,
        JpaRepository<Credit, Long> {

    Page<Credit> findAll(Pageable page);

    Page<Credit> findAllByUser(User user, Pageable page);
}
