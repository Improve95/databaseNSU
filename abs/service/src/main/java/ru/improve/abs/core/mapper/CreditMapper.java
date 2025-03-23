package ru.improve.abs.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;
import ru.improve.abs.api.dto.credit.CreditRequestResponse;
import ru.improve.abs.api.dto.credit.CreditResponse;
import ru.improve.abs.api.dto.credit.CreditTariffResponse;
import ru.improve.abs.api.dto.credit.PostCreditRequest;
import ru.improve.abs.api.dto.credit.PostCreditRequestRequest;
import ru.improve.abs.model.credit.Credit;
import ru.improve.abs.model.CreditRequest;
import ru.improve.abs.model.CreditTariff;

@Mapper(
        componentModel = MappingConstants.ComponentModel.SPRING,
        unmappedSourcePolicy = ReportingPolicy.IGNORE,
        unmappedTargetPolicy = ReportingPolicy.IGNORE,
        uses = MapperUtil.class
)
public interface CreditMapper {

    CreditRequest toCreditRequest(PostCreditRequestRequest creditRequestRequest);

    CreditTariffResponse toCreditTariffResponse(CreditTariff creditTariff);

    @Mapping(
            target = "creditTariffId",
            expression = "java(creditRequest.getCreditTariff().getId())"
    )
    @Mapping(
            target = "userId",
            expression = "java(creditRequest.getUser().getId())"
    )
    CreditRequestResponse toCreditRequestResponse(CreditRequest creditRequest);


    Credit toCredit(PostCreditRequest creditRequest);

    @Mapping(
            target = "creditTariffId",
            expression = "java(credit.getCreditTariff().getId())"
    )
    @Mapping(
            target = "userId",
            expression = "java(credit.getUser().getId())"
    )
    CreditResponse toCreditResponse(Credit credit);
}
