package ru.improve.abs.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;
import ru.improve.abs.api.dto.payment.PostPaymentRequest;
import ru.improve.abs.api.dto.payment.PostPaymentResponse;
import ru.improve.abs.model.Payment;

@Mapper(
        componentModel = MappingConstants.ComponentModel.SPRING,
        unmappedSourcePolicy = ReportingPolicy.IGNORE,
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        uses = MapperUtil.class
)
public interface PaymentMapper {

    Payment toPayment(PostPaymentRequest postPaymentRequest);

    PostPaymentResponse toPostPaymentResponse(Payment payment);
}
