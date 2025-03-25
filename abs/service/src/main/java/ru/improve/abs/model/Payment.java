package ru.improve.abs.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import ru.improve.abs.model.credit.Credit;

import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "payments")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Payment {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private long id;

    private BigDecimal amount;

    @Column(name = "commission_amount")
    private BigDecimal commissionAmount;

    @Column(name = "created_at")
    private Instant createdAt;

    @ManyToOne
    @JoinColumn(referencedColumnName = "id")
    private Credit credit;
}
