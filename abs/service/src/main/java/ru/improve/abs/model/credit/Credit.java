package ru.improve.abs.model.credit;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
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
import ru.improve.abs.model.CreditTariff;
import ru.improve.abs.model.User;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "credits")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Credit {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private long id;

    @Column(name = "initial_amount")
    private BigDecimal initialAmount;

    @Column(name = "taking_date")
    private LocalDate takingDate;

    private int percent;

    @Column(name = "credit_period")
    private int creditPeriod;

    @Column(name = "month_amount")
    private BigDecimal monthAmount;

    @Builder.Default
    @Enumerated(value = EnumType.STRING)
    @Column(name = "credit_status")
    private CreditStatus creditStatus = CreditStatus.CREATE;

    @ManyToOne
    @JoinColumn(referencedColumnName = "id")
    private User user;

    @ManyToOne
    @JoinColumn(referencedColumnName = "id")
    private CreditTariff creditTariff;
}
