package com.taptech.common.security.keycloak

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spock.lang.Specification


class KeyCloakManagementServiceTest extends Specification {
    private static final Logger logger = LoggerFactory.getLogger(KeyCloakManagementServiceTest.class);

    public static final String OFFICES = "offices";
    /*
    ./mvnw clean test -Dtest=KeyCloakJwtDecoderFactoryTest

     */

    def setup() {

    }          // run before every feature method
    def cleanup() {}        // run after every feature method
    def setupSpec() {

    }     // run before the first feature method
    def cleanupSpec() {
    }   // run after

    /*
    String id, String email, String firstName, String lastName, Long createdTimestamp,
                                     String username, Boolean enabled, Boolean emailVerified,
                                     List<CredentialRepresentationKC> credentials
     */
    def test_UserRepresentationKC() {
        def userRepresentation = new KeyCloakManagementService.UserRepresentationKC("id", "email", "firstName", "lastName", 1L, "username", true, true, null);
        expect:
        userRepresentation != null
    }

  // test for KeyCloakManagementService.KCClientRepresentation.KCClientRepresentationBuilder
    def test_KCClientRepresentationBuilder() {
        /*
        String id, String clientId, String name, String description, String rootUrl, String adminUrl, String baseUrl,
                                         Boolean surrogateAuthRequired, Boolean enabled, Boolean alwaysDisplayInConsole, String clientAuthenticatorType,
                                         String secret, String registrationAccessToken, List<String> defaultRoles, List<String> redirectUris,
                                         List<String> webOrigins, Integer notBefore, Boolean bearerOnly, Boolean consentRequired, Boolean standardFlowEnabled,
                                         Boolean implicitFlowEnabled, Boolean directAccessGrantsEnabled, Boolean serviceAccountsEnabled,
                                         Boolean oauth2DeviceAuthorizationGrantEnabled, Boolean authorizationServicesEnabled,
                                         Boolean directGrantsOnly, Boolean publicClient, Boolean frontchannelLogout, String protocol,
                                         Map<String, String> attributes, Map<String, String> authenticationFlowBindingOverrides,
                                         Boolean fullScopeAllowed, Integer nodeReRegistrationTimeout, Map<Integer, Integer> registeredNodes,
                                         List<ProtocolMapperRepresentation> protocolMappers, String clientTemplate, Boolean useTemplateConfig,
                                         Boolean useTemplateScope, Boolean useTemplateMappers, List<String> defaultClientScopes,
                                         List<String> optionalClientScopes,
                                         Boolean access, String origin
         */
        def kcClientRepresentationBuilder = new KeyCloakManagementService.KCClientRepresentation.KCClientRepresentationBuilder();
        kcClientRepresentationBuilder.clientId("clientId");
        kcClientRepresentationBuilder.id("id");
        kcClientRepresentationBuilder.description("description");
        kcClientRepresentationBuilder.clientAuthenticatorType("clientAuthenticatorType");
        kcClientRepresentationBuilder.enabled(true);
        kcClientRepresentationBuilder.protocol("protocol");
        kcClientRepresentationBuilder.rootUrl("rootUrl");
        //kcClientRepresentationBuilder.redirectUris("redirectUris");
        //kcClientRepresentationBuilder.webOrigins("webOrigins");
        kcClientRepresentationBuilder.adminUrl("adminUrl");
        kcClientRepresentationBuilder.baseUrl("baseUrl");
        kcClientRepresentationBuilder.notBefore(1);
        kcClientRepresentationBuilder.nodeReRegistrationTimeout(1);
        kcClientRepresentationBuilder.clientTemplate("clientTemplate");
        kcClientRepresentationBuilder.attributes(null);
        kcClientRepresentationBuilder.protocolMappers(null);
        kcClientRepresentationBuilder.defaultRoles(null);
        kcClientRepresentationBuilder.optionalClientScopes(null);
        kcClientRepresentationBuilder.authorizationServicesEnabled(true);
        kcClientRepresentationBuilder.serviceAccountsEnabled(true);
        kcClientRepresentationBuilder.publicClient(true);
        kcClientRepresentationBuilder.frontchannelLogout(true);
        kcClientRepresentationBuilder.fullScopeAllowed(true);
        kcClientRepresentationBuilder.useTemplateConfig(true);
        kcClientRepresentationBuilder.directAccessGrantsEnabled(true);
        kcClientRepresentationBuilder.name("name");
        kcClientRepresentationBuilder.access(true);
        kcClientRepresentationBuilder.origin("origin");
        kcClientRepresentationBuilder.alwaysDisplayInConsole(true);
        kcClientRepresentationBuilder.bearerOnly(true);
        kcClientRepresentationBuilder.consentRequired(true);
        kcClientRepresentationBuilder.standardFlowEnabled(true);
        kcClientRepresentationBuilder.implicitFlowEnabled(true);
        kcClientRepresentationBuilder.directGrantsOnly(true);
        kcClientRepresentationBuilder.oauth2DeviceAuthorizationGrantEnabled(true);
        kcClientRepresentationBuilder.useTemplateScope(true);
        kcClientRepresentationBuilder.useTemplateMappers(true);
        kcClientRepresentationBuilder.registrationAccessToken("registrationAccessToken");
        kcClientRepresentationBuilder.defaultClientScopes(null);
        kcClientRepresentationBuilder.authenticationFlowBindingOverrides(null);
        kcClientRepresentationBuilder.registeredNodes(null);
        kcClientRepresentationBuilder.webOrigins(null);
        kcClientRepresentationBuilder.redirectUris(null);
        kcClientRepresentationBuilder.secret("secret");
        kcClientRepresentationBuilder.surrogateAuthRequired(true);

        def kcClientRepresentation = kcClientRepresentationBuilder.build();

        String str = kcClientRepresentationBuilder.toString();
        int hash = kcClientRepresentationBuilder.hashCode();

        expect:
        kcClientRepresentationBuilder != null

    }


}
