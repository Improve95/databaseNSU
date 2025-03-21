package ru.improve.abs.model;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.math.BigDecimal;
import java.util.List;

@Entity
@Table(name = "credit_tariffs")
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
public class CreditTariff {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private int id;

    private String type;

    @Column(name = "up_to_amount")
    private BigDecimal upToAmount;

//    @Column(name = "up_to_credit_period")
//    private Duration upToCreditPeriod;

    @Column(name = "credit_percent")
    private int creditPercent;

    @ToString.Exclude
    @OneToMany(mappedBy = "creditTariff", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<CreditRequest> creditRequests;
}

