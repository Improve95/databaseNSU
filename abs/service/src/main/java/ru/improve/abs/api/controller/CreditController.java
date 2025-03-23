package ru.improve.abs.api.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ru.improve.abs.api.controller.spec.CreditControllerSpec;
import ru.improve.abs.api.dto.credit.CreditRequestResponse;
import ru.improve.abs.api.dto.credit.CreditResponse;
import ru.improve.abs.api.dto.credit.CreditTariffResponse;
import ru.improve.abs.api.dto.credit.PostCreditRequest;
import ru.improve.abs.api.dto.credit.PostCreditRequestRequest;
import ru.improve.abs.core.service.CreditService;

import java.util.List;

import static ru.improve.abs.api.ApiPaths.ALL;
import static ru.improve.abs.api.ApiPaths.CREDIT;
import static ru.improve.abs.api.ApiPaths.ITEMS_PER_PAGE;
import static ru.improve.abs.api.ApiPaths.PAGE;
import static ru.improve.abs.api.ApiPaths.REQUEST;
import static ru.improve.abs.api.ApiPaths.TARIFF;

@RequiredArgsConstructor
@RestController
@RequestMapping(CREDIT)
public class CreditController implements CreditControllerSpec {

    private final CreditService creditService;

    @GetMapping(TARIFF)
    public ResponseEntity<List<CreditTariffResponse>> getAllCreditTariffs() {
        List<CreditTariffResponse> creditTariffResponses = creditService.getAllCreditTariffs();
        return ResponseEntity.ok(creditTariffResponses);
    }

    @GetMapping(ALL)
    public ResponseEntity<List<CreditResponse>> getAllCredits(
            @Valid @RequestParam(name = PAGE) int page,
            @Valid @RequestParam(name = ITEMS_PER_PAGE) int itemsPerPage) {
        return ResponseEntity.ok(null);
    }

    @PostMapping(REQUEST)
    public ResponseEntity<CreditRequestResponse> createCreditRequest(@RequestBody @Valid PostCreditRequestRequest postCreditRequestRequest) {
        CreditRequestResponse creditRequestResponse = creditService.createCreditRequest(postCreditRequestRequest);
        return ResponseEntity.ok(creditRequestResponse);
    }

    @PostMapping
    public ResponseEntity<CreditResponse> createCredit(PostCreditRequest creditRequest) {
        CreditResponse creditResponse = creditService.createCredit(creditRequest);
        return ResponseEntity.ok(creditResponse);
    }
}
