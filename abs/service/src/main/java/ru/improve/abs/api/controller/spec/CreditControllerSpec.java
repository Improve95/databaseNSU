package ru.improve.abs.api.controller.spec;

import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestParam;
import ru.improve.abs.api.dto.credit.CreditRequestResponse;
import ru.improve.abs.api.dto.credit.CreditResponse;
import ru.improve.abs.api.dto.credit.CreditTariffResponse;
import ru.improve.abs.api.dto.credit.PostCreditRequestRequest;

import java.util.List;

import static ru.improve.abs.api.ApiPaths.ITEMS_PER_PAGE;
import static ru.improve.abs.api.ApiPaths.PAGE;
import static ru.improve.abs.util.message.MessageKeys.SWAGGER_SECURITY_SCHEME_NAME;

public interface CreditControllerSpec {

    @SecurityRequirement(name = SWAGGER_SECURITY_SCHEME_NAME)
    ResponseEntity<List<CreditTariffResponse>> getAllCreditTariffs();

    @SecurityRequirement(name = SWAGGER_SECURITY_SCHEME_NAME)
    ResponseEntity<CreditRequestResponse> createCreditRequest(PostCreditRequestRequest postCreditRequestRequest);

    @SecurityRequirement(name = SWAGGER_SECURITY_SCHEME_NAME)
    ResponseEntity<List<CreditResponse>> getAllCredits(
            @Valid @RequestParam(name = PAGE) int page,
            @Valid @RequestParam(name = ITEMS_PER_PAGE) int itemsPerPage);
}
