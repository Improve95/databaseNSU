package ru.improve.abs.core.service.imp;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.improve.abs.api.dto.credit.CreditRequestResponse;
import ru.improve.abs.api.dto.credit.CreditTariffResponse;
import ru.improve.abs.api.dto.credit.PostCreditRequestRequest;
import ru.improve.abs.api.exception.ServiceException;
import ru.improve.abs.core.mapper.CreditMapper;
import ru.improve.abs.core.repository.CreditRequestRepository;
import ru.improve.abs.core.repository.CreditTariffRepository;
import ru.improve.abs.core.security.SecurityUtil;
import ru.improve.abs.core.service.CreditService;
import ru.improve.abs.model.CreditRequest;
import ru.improve.abs.model.CreditTariff;
import ru.improve.abs.model.User;

import java.util.List;

import static ru.improve.abs.api.exception.ErrorCode.NOT_FOUND;

@RequiredArgsConstructor
@Service
public class CreditServiceImp implements CreditService {

    private final CreditRequestRepository creditRequestRepository;

    private final CreditTariffRepository creditTariffRepository;

    private final CreditMapper creditMapper;

    @Transactional
    @Override
    public List<CreditTariffResponse> getAllCreditTariffs() {
        return creditTariffRepository.findAll().stream()
                .map(creditMapper::toCreditTariffResponse)
                .toList();
    }

    @Transactional
    @Override
    public CreditRequestResponse createCreditRequest(PostCreditRequestRequest postCreditRequest) {
        User user = SecurityUtil.getUserFromAuthentication();
        CreditTariff creditTariff = creditTariffRepository.findById(postCreditRequest.getCreditTariffId())
                .orElseThrow(() -> new ServiceException(NOT_FOUND, "creditTariff", "id"));

        /*if () {

        }*/

        CreditRequest creditRequest = creditMapper.toCreditRequest(postCreditRequest);
        creditRequest.setCreditTariff(creditTariff);
        creditRequest.setUser(user);

        creditRequest = creditRequestRepository.save(creditRequest);

        return creditMapper.toCreditRequestResponse(creditRequest);
    }
}
