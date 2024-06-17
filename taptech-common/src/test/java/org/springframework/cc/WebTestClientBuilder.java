package org.springframework.cc;

import org.springframework.http.HttpStatus;
import org.springframework.security.web.server.SecurityWebFilterChain;
import org.springframework.security.web.server.WebFilterChainProxy;
import org.springframework.test.web.reactive.server.WebTestClient;
import org.springframework.test.web.reactive.server.WebTestClient.Builder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.WebFilter;

/**
 * Provides a convenient mechanism for running {@link WebTestClient} against
 * {@link WebFilter}
 *
 * @author Rob Winch
 * @since 5.0
 *
 */
public final class WebTestClientBuilder {

    private WebTestClientBuilder() {
    }

    public static Builder bindToWebFilters(WebFilter... webFilters) {
        return WebTestClient.bindToController(new Http200RestController()).webFilter(webFilters).configureClient();
    }

    public static Builder bindToWebFilters(SecurityWebFilterChain securityWebFilterChain) {
        return bindToWebFilters(new WebFilterChainProxy(securityWebFilterChain));
    }

    public static Builder bindToControllerAndWebFilters(Class<?> controller, WebFilter... webFilters) {
        return WebTestClient.bindToController(controller).webFilter(webFilters).configureClient();
    }

    public static Builder bindToControllerAndWebFilters(Class<?> controller,
                                                        SecurityWebFilterChain securityWebFilterChain) {
        return bindToControllerAndWebFilters(controller, new WebFilterChainProxy(securityWebFilterChain));
    }

    @RestController
    public static class Http200RestController {

        @RequestMapping("/**")
        @ResponseStatus(HttpStatus.OK)
        public String ok() {
            return "ok";
        }

    }

}
