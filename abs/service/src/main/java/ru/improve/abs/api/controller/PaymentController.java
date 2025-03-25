package ru.improve.abs.api.controller;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.improve.abs.api.dto.payment.PostPaymentRequest;
import ru.improve.abs.api.dto.payment.PostPaymentResponse;

import static ru.improve.abs.api.ApiPaths.PAYMENTS;

@RestController
@RequestMapping(PAYMENTS)
public class PaymentController {

    @PostMapping
    public ResponseEntity<PostPaymentResponse> payForCredit(@RequestBody @Valid PostPaymentRequest postPaymentRequest) {
        return ResponseEntity.ok(null);
    }
}
