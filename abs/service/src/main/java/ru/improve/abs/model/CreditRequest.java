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
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "credit_requests")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CreditRequest {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private long id;

    @ManyToOne
    @JoinColumn(referencedColumnName = "id")
    private CreditTariff creditTariff;

    @Column(name = "credit_amount")
    private BigDecimal creditAmount;

    @Column(name = "credit_duration")
    private int creditDuration;

    @ManyToOne
    @JoinColumn(referencedColumnName = "id")
    private User user;

    @Builder.Default
    @Column(name = "created_at")
    private Instant createdAt = Instant.now();
}
