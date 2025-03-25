package ru.improve.abs.core.service;

import ru.improve.abs.api.dto.payment.PostPaymentRequest;
import ru.improve.abs.api.dto.payment.PostPaymentResponse;

public interface PaymentService {


    PostPaymentResponse payForCredit(PostPaymentRequest postPaymentRequest);
}
