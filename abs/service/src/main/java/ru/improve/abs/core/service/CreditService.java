package ru.improve.abs.core.service;

import ru.improve.abs.api.dto.credit.CreditRequestResponse;
import ru.improve.abs.api.dto.credit.CreditTariffResponse;
import ru.improve.abs.api.dto.credit.PostCreditRequestRequest;

import java.util.List;

public interface CreditService {

    List<CreditTariffResponse> getAllCreditTariffs();

    CreditRequestResponse createCreditRequest(PostCreditRequestRequest postCreditRequest);
}
