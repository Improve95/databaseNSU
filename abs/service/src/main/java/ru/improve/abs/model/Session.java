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
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Entity
@Table(name = "sessions")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Session {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private long id;

    @ManyToOne
    @JoinColumn(referencedColumnName = "id")
    private User user;

    @Column(name = "issued_at")
    @Builder.Default
    private Instant issuedAt = Instant.now();

    @Column(name = "expired_at")
    private Instant expiredAt;

    @Column(name = "is_enable")
    @Builder.Default
    private boolean isEnable = true;
}
