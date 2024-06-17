package org.springframework.cc;

import com.taptech.common.security.user.SecurityUser;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.userdetails.MapReactiveUserDetailsService;
import org.springframework.security.core.userdetails.ReactiveUserDetailsService;

@Configuration
public class ReactiveAuthenticationTestConfiguration {

    @Bean
    public static ReactiveUserDetailsService userDetailsService() {
        return new MapReactiveUserDetailsService(SecurityUser.builder()
                .username("admin")
                .password("admin")
                .build(),
                SecurityUser.builder()
                        .username("user").password("user")
                        .build());
    }

}
