package ru.improve.abs.core.service;

import ru.improve.abs.api.dto.credit.CreditRequestResponse;
import ru.improve.abs.api.dto.credit.CreditResponse;
import ru.improve.abs.api.dto.credit.CreditTariffResponse;
import ru.improve.abs.api.dto.credit.PostCreditRequest;
import ru.improve.abs.api.dto.credit.PostCreditRequestRequest;
import ru.improve.abs.model.CreditTariff;
import ru.improve.abs.model.credit.Credit;

import java.util.List;

public interface CreditService {

    List<CreditTariffResponse> getAllCreditTariffs();

    CreditRequestResponse createCreditRequest(PostCreditRequestRequest postCreditRequest);

    List<CreditResponse> getAllCredits(int pageNumber, int pageSize);

    CreditResponse getCreditById(long creditId);

    List<CreditResponse> getAllCreditsByUserId(int userId, int pageNumber, int pageSize);

    CreditResponse createCredit(PostCreditRequest creditRequest);

    CreditResponse takeCreatedCredit(long creditId);

    CreditTariff findCreditTariffById(int id);

    Credit findCreditById(long creditId);
}
