package ru.improve.abs.core.service.imp;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import ru.improve.abs.api.dto.credit.CreditRequestResponse;
import ru.improve.abs.api.dto.credit.CreditResponse;
import ru.improve.abs.api.dto.credit.CreditTariffResponse;
import ru.improve.abs.api.dto.credit.PostCreditRequest;
import ru.improve.abs.api.dto.credit.PostCreditRequestRequest;
import ru.improve.abs.api.exception.ServiceException;
import ru.improve.abs.core.mapper.CreditMapper;
import ru.improve.abs.core.repository.CreditRepository;
import ru.improve.abs.core.repository.CreditRequestRepository;
import ru.improve.abs.core.repository.CreditTariffRepository;
import ru.improve.abs.core.service.CreditService;
import ru.improve.abs.core.service.UserService;
import ru.improve.abs.model.credit.Credit;
import ru.improve.abs.model.CreditRequest;
import ru.improve.abs.model.CreditTariff;
import ru.improve.abs.model.User;
import ru.improve.abs.model.credit.CreditStatus;

import java.time.LocalDate;
import java.util.List;

import static ru.improve.abs.api.exception.ErrorCode.ACCESS_DENIED;
import static ru.improve.abs.api.exception.ErrorCode.ILLEGAL_DTO_VALUE;
import static ru.improve.abs.api.exception.ErrorCode.NOT_FOUND;
import static ru.improve.abs.util.message.MessageKeys.ILLEGAL_CREDIT_REQUEST_DTO;

@RequiredArgsConstructor
@Service
public class CreditServiceImp implements CreditService {

    private final UserService userService;

    private final CreditRequestRepository creditRequestRepository;

    private final CreditTariffRepository creditTariffRepository;

    private final CreditRepository creditRepository;

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
        User user = userService.getUserFromAuthentication();
        CreditTariff creditTariff = findCreditTariffById(postCreditRequest.getCreditTariffId());

        if (postCreditRequest.getCreditAmount().compareTo(creditTariff.getUpToAmount()) > 0 ||
                postCreditRequest.getCreditDuration() > creditTariff.getUpToCreditDuration()) {
            throw new ServiceException(ILLEGAL_DTO_VALUE, ILLEGAL_CREDIT_REQUEST_DTO);
        }

        CreditRequest creditRequest = creditMapper.toCreditRequest(postCreditRequest);
        creditRequest.setCreditTariff(creditTariff);
        creditRequest.setUser(user);

        creditRequest = creditRequestRepository.save(creditRequest);

        return creditMapper.toCreditRequestResponse(creditRequest);
    }

    @Transactional
    @Override
    public List<CreditResponse> getAllCredits(int pageNumber, int pageSize) {
        return creditRepository.findAll(PageRequest.of(pageNumber, pageSize)).stream()
                .map(creditMapper::toCreditResponse)
                .toList();
    }

    @Transactional
    @Override
    public CreditResponse getCreditById(long creditId) {
        return creditMapper.toCreditResponse(findCreditById(creditId));
    }

    @Transactional
    @Override
    public List<CreditResponse> getAllCreditsByUserId(int userId, int pageNumber, int pageSize) {
        User user = userService.findUserById(userId);
        return creditRepository.findAllByUser(user, PageRequest.of(pageNumber, pageSize)).stream()
                .map(creditMapper::toCreditResponse)
                .toList();
    }

    @Transactional
    @Override
    public CreditResponse createCredit(PostCreditRequest creditRequest) {
        User user = userService.findUserById(creditRequest.getUserId());
        CreditTariff creditTariff = findCreditTariffById(creditRequest.getTariffId());

        Credit credit = creditMapper.toCredit(creditRequest);
        credit.setUser(user);
        credit.setCreditTariff(creditTariff);
        credit = creditRepository.save(credit);

        return creditMapper.toCreditResponse(credit);
    }

    @Transactional
    @Override
    public CreditResponse takeCreatedCredit(long creditId) {
        Credit credit = findCreditById(creditId);
        if (credit.getUser().getId() != userService.getUserFromAuthentication().getId()) {
            throw new ServiceException(ACCESS_DENIED, "credit");
        }
        credit.setTakingDate(LocalDate.now());
        credit.setCreditStatus(CreditStatus.OPEN);
        return creditMapper.toCreditResponse(credit);
    }

    @Transactional
    @Override
    public CreditTariff findCreditTariffById(int id) {
        return creditTariffRepository.findById(id)
                .orElseThrow(() -> new ServiceException(NOT_FOUND, "creditTariff", "id"));
    }

    @Transactional()
    @Override
    public Credit findCreditById(long creditId) {
        return creditRepository.findById(creditId)
                .orElseThrow(() -> new ServiceException(NOT_FOUND, "credit", "id"));
    }
}
