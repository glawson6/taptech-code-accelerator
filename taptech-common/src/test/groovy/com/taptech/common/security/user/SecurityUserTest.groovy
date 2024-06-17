package com.taptech.common.security.user


import org.springframework.security.core.authority.SimpleGrantedAuthority
import spock.lang.Specification

class SecurityUserTest extends Specification {
    /*
   ./mvnw clean test -Dtest=SecurityUserTest

    */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    def test_pojo_builder() {
        def securityUserBuilder = SecurityUser.builder()
                .username("username")
                .password("password")
                .enabled(true)
                .accountNonExpired(true)
                .accountNonLocked(true)
                .credentialsNonExpired(true)
                .authorities(null)
        String str = securityUserBuilder.toString()
        int hash = securityUserBuilder.hashCode()
        def securityUser = securityUserBuilder.build()

        expect:
        securityUserBuilder != null
        securityUserBuilder.toString() != null

    }

    def test_pojo() {
        def securityUser = SecurityUser.builder()
                .username("username")
                .password("password")
                .enabled(true)
                .accountNonExpired(true)
                .accountNonLocked(true)
                .credentialsNonExpired(true)
                .authorities(null)
                .build()
        def req = new SecurityUser()

        def req2 = new SecurityUser(Collections.singleton(new SimpleGrantedAuthority("authority")), "password", "username", true, true, true, true, null)

        boolean q1 = securityUser.equals(securityUser)
        boolean q2 = securityUser.equals(req)
        boolean q3 = securityUser.equals(req2)
        boolean q4 = securityUser.equals(null)
        String str = securityUser.toString()
        int hash = securityUser.hashCode()
        securityUser.canEqual(securityUser)
        securityUser.hashCode()
        securityUser.setUsername("username")
        securityUser.setPassword("password")
        securityUser.setEnabled(true)
        securityUser.setAccountNonExpired(true)
        securityUser.setAccountNonLocked(true)
        securityUser.setCredentialsNonExpired(true)
        securityUser.setAuthorities(null)
        securityUser.setJwt(Optional.empty())
        securityUser.getUsername()
        securityUser.getPassword()
        securityUser.getAuthorities()
        securityUser.getJwt()
        securityUser.getAuthorities()
        expect:
        securityUser != null
    }

}
