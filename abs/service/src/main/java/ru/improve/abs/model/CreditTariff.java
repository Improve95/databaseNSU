package ru.improve.abs.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import ru.improve.abs.model.credit.Credit;

import java.math.BigDecimal;
import java.util.List;

@Entity
@Table(name = "credit_tariffs")
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CreditTariff {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private int id;

    private String type;

    @Column(name = "up_to_amount")
    private BigDecimal upToAmount;

    @Column(name = "up_to_credit_period")
    private int upToCreditDuration;

    @Column(name = "credit_percent")
    private int creditPercent;

    @OneToMany(mappedBy = "creditTariff")
    private List<CreditRequest> creditRequests;

    @OneToMany(mappedBy = "creditTariff")
    private List<Credit> credits;
}

