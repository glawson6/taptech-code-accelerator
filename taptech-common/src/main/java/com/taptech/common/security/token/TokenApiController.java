package com.taptech.common.security.token;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Generated;
import java.util.Optional;

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", date = "2024-05-01T23:04:01.687503-04:00[America/New_York]")
@Controller
@RequestMapping("${openapi.token.base-path:}")
public class TokenApiController implements TokenApi {

    private final TokenApiApiDelegate delegate;

    public TokenApiController(@Autowired(required = true) TokenApiApiDelegate delegate) {
        this.delegate = Optional.ofNullable(delegate).orElse(new TokenApiApiDelegate() {});
    }

    @Override
    public TokenApiApiDelegate getDelegate() {
        return delegate;
    }

}
