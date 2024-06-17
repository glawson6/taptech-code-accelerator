package com.taptech.common.security.user;


import com.taptech.common.exception.CannotValidateTokenException;
import com.taptech.common.exception.ErrorResponse;
import com.taptech.common.security.utils.SecurityUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.AuthenticationCredentialsNotFoundException;
import org.springframework.util.Assert;
import org.springframework.web.reactive.function.client.ClientResponse;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class HttpReadingUserContextPermissionsService implements UserContextPermissionsService {

    private static final Logger logger = LoggerFactory.getLogger(HttpReadingUserContextPermissionsService.class);

    public static final String USER_CONTEXT_SERVICE_URI = "/public/validate";

    static ObjectMapper objectMapper = new ObjectMapper();

    WebClient webClient;
    String baseUrl;

    @PostConstruct
    public void init() {
        logger.info("##################### HttpReadingUserContextPermissionsService init with baseUrl => [{}] ###################", baseUrl);
        Assert.notNull(baseUrl, "user.context.permissions.base-url must be set");
        webClient = WebClient.builder().baseUrl(baseUrl)
                .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                .defaultHeader(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
                //.clientConnector(new ReactorClientHttpConnector(httpClient))
                .build();

    }

    @Override
    public Mono<UserContextPermissions> getUserContextByUserIdAndContextId(UserContextRequest userContextRequest) {
        logger.info("getUserContextByUserIdAndContextId calling {} with userContextRequest => {}", baseUrl + USER_CONTEXT_SERVICE_URI, userContextRequest);
        return webClient.get()
                .uri(uriBuilder -> uriBuilder.path(USER_CONTEXT_SERVICE_URI).build())
                .header(HttpHeaders.AUTHORIZATION, SecurityUtils.toBearerHeaderFromToken(userContextRequest.getToken()))
                .exchangeToMono(response -> {
                    logger.debug("getUserContextByUserIdAndContextId response.statusCode() => {}", response.statusCode());
                    if (response.statusCode().equals(HttpStatus.OK)) {
                        return response.bodyToMono(UserContextPermissions.class);
                    } else {
                        // Turn to error
                        logger.error("Error in getUserContextByUserIdAndContextId => {}", response.statusCode());
                        //return SecurityUtils.authTokenValidationResponse(new ObjectMapper()).apply(response);


                        return response.bodyToMono(String.class)
                                .flatMap(errorBody -> {
                                    logger.error("Error in getUserContextByUserIdAndContextId => {}", errorBody);
                                    String errorMessage = errorBody;
                                    ErrorResponse errorResponse = null;
                                    try {
                                        errorResponse = objectMapper.readValue(errorBody, ErrorResponse.class);
                                    } catch (JsonProcessingException e) {
                                        logger.warn("Error parsing error response", e);
                                    }
                                    final String finalErrorMessage = errorResponse != null ? errorResponse.getMessage() : errorMessage;
                                    return Mono.defer(() -> Mono.error(new CannotValidateTokenException(finalErrorMessage)));
                                });

                    }

                });
    }


}
