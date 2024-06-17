package com.taptech.common.security.token;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.*;
import org.springframework.util.Assert;

import java.time.Instant;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@ToString
@Getter
@Setter
public class JwtViewer {

    public JwtViewer(String tokenValue, Instant issuedAtInstant, Instant expiresAtInstant, Map<String, Object> headers,
                     Map<String, Object> claims) {

        Assert.notEmpty(headers, "headers cannot be empty");
        Assert.notEmpty(claims, "claims cannot be empty");
        issuedAt = issuedAtInstant.toString();
        expiresAt = expiresAtInstant.toString();
        token = tokenValue;
        Map<String,Object> claimsIn = new LinkedHashMap<>(claims);
        claimsIn.computeIfPresent("exp",(k,v)->{
            claimsIn.put("exp",expiresAt);
            return expiresAt;
        });
        claimsIn.computeIfPresent("iat",(k,v)->{
            claimsIn.put("iat",issuedAt);
            return issuedAt;
        });
        this.headers = Collections.unmodifiableMap(new LinkedHashMap(headers));
        this.claims = Collections.unmodifiableMap(claimsIn);
    }

    String token;
    String issuedAt;
    String expiresAt;

    Map<String, Object> headers;
    Map<String, Object> claims;

}
