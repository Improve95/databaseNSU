package ru.improve.abs.core.service.imp;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.improve.abs.api.dto.payment.PostPaymentRequest;
import ru.improve.abs.api.dto.payment.PostPaymentResponse;
import ru.improve.abs.core.mapper.PaymentMapper;
import ru.improve.abs.core.repository.PaymentRepository;
import ru.improve.abs.core.service.CreditService;
import ru.improve.abs.core.service.PaymentService;
import ru.improve.abs.model.Payment;

import java.time.Instant;

@RequiredArgsConstructor
@Service
public class PaymentServiceImp implements PaymentService {

    private final CreditService creditService;

    private final PaymentRepository paymentRepository;

    private final PaymentMapper paymentMapper;

    @Transactional
    @Override
    public PostPaymentResponse payForCredit(PostPaymentRequest postPaymentRequest) {
        Payment payment = paymentMapper.toPayment(postPaymentRequest);
        payment.setCreatedAt(Instant.now());
        payment.setCredit(creditService.findCreditById(postPaymentRequest.getCreditId()));

        payment = paymentRepository.save(payment);

        return paymentMapper.toPostPaymentResponse(payment);
    }
}
