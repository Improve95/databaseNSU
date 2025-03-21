package ru.improve.abs.api.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.improve.abs.api.controller.spec.CreditControllerSpec;
import ru.improve.abs.api.dto.credit.CreditRequestResponse;
import ru.improve.abs.api.dto.credit.CreditTariffResponse;
import ru.improve.abs.api.dto.credit.PostCreditRequestRequest;
import ru.improve.abs.core.service.CreditService;

import java.util.List;

import static ru.improve.abs.api.ApiPaths.CREDIT;
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

    @PostMapping(REQUEST)
    public ResponseEntity<CreditRequestResponse> createCreditRequest(@RequestBody @Valid PostCreditRequestRequest postCreditRequestRequest) {
        CreditRequestResponse creditRequestResponse = creditService.createCreditRequest(postCreditRequestRequest);
        return ResponseEntity.ok(creditRequestResponse);
    }
}
