--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Debian 16.2-1.pgdg120+2)
-- Dumped by pg_dump version 16.2 (Debian 16.2-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO keycloak;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO keycloak;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO keycloak;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO keycloak;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO keycloak;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO keycloak;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO keycloak;

--
-- Name: client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO keycloak;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO keycloak;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO keycloak;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO keycloak;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO keycloak;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO keycloak;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO keycloak;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO keycloak;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO keycloak;

--
-- Name: client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO keycloak;

--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO keycloak;

--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO keycloak;

--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO keycloak;

--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO keycloak;

--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO keycloak;

--
-- Name: component; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO keycloak;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO keycloak;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO keycloak;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO keycloak;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO keycloak;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO keycloak;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO keycloak;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO keycloak;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024)
);


ALTER TABLE public.fed_user_attribute OWNER TO keycloak;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO keycloak;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO keycloak;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO keycloak;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO keycloak;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO keycloak;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO keycloak;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO keycloak;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO keycloak;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO keycloak;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO keycloak;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO keycloak;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO keycloak;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO keycloak;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO keycloak;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO keycloak;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO keycloak;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO keycloak;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL
);


ALTER TABLE public.offline_client_session OWNER TO keycloak;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.offline_user_session OWNER TO keycloak;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO keycloak;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO keycloak;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO keycloak;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO keycloak;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO keycloak;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO keycloak;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO keycloak;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO keycloak;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO keycloak;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO keycloak;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO keycloak;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO keycloak;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO keycloak;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO keycloak;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO keycloak;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO keycloak;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO keycloak;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO keycloak;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO keycloak;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO keycloak;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO keycloak;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO keycloak;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO keycloak;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO keycloak;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO keycloak;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO keycloak;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO keycloak;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL
);


ALTER TABLE public.user_attribute OWNER TO keycloak;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO keycloak;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO keycloak;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO keycloak;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO keycloak;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO keycloak;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO keycloak;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO keycloak;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO keycloak;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO keycloak;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO keycloak;

--
-- Name: user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO keycloak;

--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO keycloak;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO keycloak;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO keycloak;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
fce4f9fe-cf54-43df-bd1c-e69e360de48b	\N	auth-cookie	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b662bb52-8752-4436-9830-66c58bd9bd1e	2	10	f	\N	\N
ef20a6f0-f3b2-45cb-bc04-0dd1bf0f065f	\N	auth-spnego	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b662bb52-8752-4436-9830-66c58bd9bd1e	3	20	f	\N	\N
75301874-8081-4427-884d-220b985a2fe7	\N	identity-provider-redirector	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b662bb52-8752-4436-9830-66c58bd9bd1e	2	25	f	\N	\N
a3b3a2ad-1a46-43c7-834e-9a42091fc0ad	\N	\N	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b662bb52-8752-4436-9830-66c58bd9bd1e	2	30	t	41779a7a-6a63-494c-932f-a9f2e3591a5e	\N
afbee15f-4f74-4bf5-9d6d-4aacb1aa58c1	\N	auth-username-password-form	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	41779a7a-6a63-494c-932f-a9f2e3591a5e	0	10	f	\N	\N
1854e8d9-5225-47f4-a456-05fb510981ef	\N	\N	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	41779a7a-6a63-494c-932f-a9f2e3591a5e	1	20	t	84531ac5-0509-4a23-ae31-9d8222ce8e8c	\N
a60c2cf7-3093-4d6f-bea2-5b28976db94a	\N	conditional-user-configured	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	84531ac5-0509-4a23-ae31-9d8222ce8e8c	0	10	f	\N	\N
9b3c78ab-ea5e-42e8-93d9-bc699a845aab	\N	auth-otp-form	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	84531ac5-0509-4a23-ae31-9d8222ce8e8c	0	20	f	\N	\N
9eca4101-3dab-40e6-8478-217cf764ed89	\N	direct-grant-validate-username	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	104bf34e-4bb0-4433-b099-35787b0ef7c4	0	10	f	\N	\N
793d9aa9-dc85-47e7-88aa-215a79bd4743	\N	direct-grant-validate-password	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	104bf34e-4bb0-4433-b099-35787b0ef7c4	0	20	f	\N	\N
7eebf4e3-d67f-4238-a2d8-5fb8fb090dd1	\N	\N	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	104bf34e-4bb0-4433-b099-35787b0ef7c4	1	30	t	7e5b6b86-a495-41b4-9538-cda1ed128cf6	\N
3a4e8708-03e5-4c7f-9aef-5c6c61e86690	\N	conditional-user-configured	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	7e5b6b86-a495-41b4-9538-cda1ed128cf6	0	10	f	\N	\N
2e7212c4-59bc-4ac0-ae70-5332671a1f27	\N	direct-grant-validate-otp	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	7e5b6b86-a495-41b4-9538-cda1ed128cf6	0	20	f	\N	\N
0d68b97e-3d29-4d3c-a06a-1405ed9bfe33	\N	registration-page-form	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	f2dc4d8d-c82b-4307-8812-a9dfc2e42693	0	10	t	bfae4df0-df66-4631-885b-13dcbd48cb33	\N
6ddab5a1-5f92-4d33-939d-3179d380c5cf	\N	registration-user-creation	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	bfae4df0-df66-4631-885b-13dcbd48cb33	0	20	f	\N	\N
86e309ca-1dbd-4bdf-94b7-aabeb4b9ad38	\N	registration-password-action	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	bfae4df0-df66-4631-885b-13dcbd48cb33	0	50	f	\N	\N
468c2d5a-c409-429f-b8bd-5f58b1d10e62	\N	registration-recaptcha-action	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	bfae4df0-df66-4631-885b-13dcbd48cb33	3	60	f	\N	\N
ed4f7484-e4e1-4f88-868b-d76a249cdf2b	\N	registration-terms-and-conditions	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	bfae4df0-df66-4631-885b-13dcbd48cb33	3	70	f	\N	\N
a98a5a88-4204-4c10-bfc1-5067363bc937	\N	reset-credentials-choose-user	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	73ede839-e1d9-43a1-a45f-911106608732	0	10	f	\N	\N
8121468e-8969-440b-b550-a692e7a78b51	\N	reset-credential-email	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	73ede839-e1d9-43a1-a45f-911106608732	0	20	f	\N	\N
1abf92e3-5d98-4fab-b4e0-32fe110c9667	\N	reset-password	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	73ede839-e1d9-43a1-a45f-911106608732	0	30	f	\N	\N
a314e5a7-3cca-49e5-8d82-e236608b2a2e	\N	\N	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	73ede839-e1d9-43a1-a45f-911106608732	1	40	t	661ca55c-b87e-409f-81b6-314e20880ea4	\N
a2da6724-3571-4c35-8a29-e1f29f327d81	\N	conditional-user-configured	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	661ca55c-b87e-409f-81b6-314e20880ea4	0	10	f	\N	\N
7710ce76-fbea-4245-8bf5-e57f2e287a1b	\N	reset-otp	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	661ca55c-b87e-409f-81b6-314e20880ea4	0	20	f	\N	\N
bbbdfcb8-a806-43e1-95db-259c809a22ff	\N	client-secret	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2f752cb8-e355-41c9-ab43-19aeea0f7a2d	2	10	f	\N	\N
10ae29bc-af85-4254-9514-37d0c8a7a4aa	\N	client-jwt	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2f752cb8-e355-41c9-ab43-19aeea0f7a2d	2	20	f	\N	\N
30047753-7dba-4186-9a53-55a8a66b1560	\N	client-secret-jwt	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2f752cb8-e355-41c9-ab43-19aeea0f7a2d	2	30	f	\N	\N
02006f86-eb3f-447c-be49-df34393a7a34	\N	client-x509	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2f752cb8-e355-41c9-ab43-19aeea0f7a2d	2	40	f	\N	\N
d91e3c2c-b5a3-4cd3-9131-7122944a9a29	\N	idp-review-profile	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	5ce768b4-c615-40d9-94f7-68a76f26147f	0	10	f	\N	5068887a-9027-4a68-a554-7b31f8d1155a
8f614a87-8d8f-4224-8ecb-4aac17bcd9d8	\N	\N	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	5ce768b4-c615-40d9-94f7-68a76f26147f	0	20	t	5894c24c-3b34-4cb8-b512-765710878d41	\N
f6230c89-4e3a-47b8-8fd6-44d9db1978b2	\N	idp-create-user-if-unique	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	5894c24c-3b34-4cb8-b512-765710878d41	2	10	f	\N	2952c7ec-18e2-4da3-a239-9c69be0c5194
5ce5178e-4f72-4c47-a71a-09104eb6f2e0	\N	\N	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	5894c24c-3b34-4cb8-b512-765710878d41	2	20	t	918b7689-1d38-4e2b-a8bc-6f000d0794f8	\N
bd924209-4b1f-45b3-a326-4d61c15a78c1	\N	idp-confirm-link	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	918b7689-1d38-4e2b-a8bc-6f000d0794f8	0	10	f	\N	\N
d5263ee7-d98c-4b55-8895-0b7a2a41f29d	\N	\N	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	918b7689-1d38-4e2b-a8bc-6f000d0794f8	0	20	t	ddbf3888-c617-4343-805d-4144896d2f54	\N
61e98655-6982-4802-ada3-116929714963	\N	idp-email-verification	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	ddbf3888-c617-4343-805d-4144896d2f54	2	10	f	\N	\N
573f327f-a8b2-4dcc-82f7-89613a2971a5	\N	\N	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	ddbf3888-c617-4343-805d-4144896d2f54	2	20	t	c007775f-cb5c-4264-b893-000f020d96ba	\N
e5c8a63b-8663-41b5-bfc4-cacda0a95d4a	\N	idp-username-password-form	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	c007775f-cb5c-4264-b893-000f020d96ba	0	10	f	\N	\N
c7dd9e64-7324-4285-a4c2-b11fc445d69d	\N	\N	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	c007775f-cb5c-4264-b893-000f020d96ba	1	20	t	3c1f9c31-830b-46d3-9a67-9908e4e755de	\N
6840c439-372d-45ca-af8e-fff56d4fe725	\N	conditional-user-configured	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	3c1f9c31-830b-46d3-9a67-9908e4e755de	0	10	f	\N	\N
2af7794c-9eda-4848-a0d6-f1114e25bcce	\N	auth-otp-form	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	3c1f9c31-830b-46d3-9a67-9908e4e755de	0	20	f	\N	\N
78ca9c34-ac8e-485a-a013-37914b0bd739	\N	http-basic-authenticator	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	ff1e1a17-5819-4c9d-84f8-f00ead7c28ab	0	10	f	\N	\N
3c6d60bf-907e-4d44-b213-af15b9d8dd7f	\N	docker-http-basic-authenticator	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	7d9b6ac1-d0dc-4cbd-8ff9-846b268bbd89	0	10	f	\N	\N
67dd33b1-9c4f-43a2-bcd0-6e12fc9a95ea	\N	idp-email-verification	offices	c44b7a6c-6784-4dd8-b07f-22b5e0f4a016	2	10	f	\N	\N
b7439426-b2db-4ff8-880b-146169f0d40e	\N	\N	offices	c44b7a6c-6784-4dd8-b07f-22b5e0f4a016	2	20	t	feb370cc-2a22-4d2a-be86-b7aa61736560	\N
cbc33bf8-52d2-42d8-b0ef-68725e38171a	\N	conditional-user-configured	offices	90491b52-8098-43c4-9eb9-5a9c3472cddd	0	10	f	\N	\N
32528a3c-7da9-4901-81bc-4e60b0fb6043	\N	auth-otp-form	offices	90491b52-8098-43c4-9eb9-5a9c3472cddd	0	20	f	\N	\N
c2620898-8e00-496e-8f70-85a0b8144353	\N	conditional-user-configured	offices	263574eb-3652-45f9-aa98-a95f9eb294d5	0	10	f	\N	\N
9d08564d-b550-4f60-9382-ed39459809c2	\N	direct-grant-validate-otp	offices	263574eb-3652-45f9-aa98-a95f9eb294d5	0	20	f	\N	\N
6282857b-a1ff-4a5b-af51-4a82f758a4ca	\N	conditional-user-configured	offices	19d1c17f-c5fe-4773-91a6-1d12730841a5	0	10	f	\N	\N
7b8e8495-88dc-4f68-b9bf-520acc75d111	\N	auth-otp-form	offices	19d1c17f-c5fe-4773-91a6-1d12730841a5	0	20	f	\N	\N
7968c4ea-70a0-4ef1-ae7a-78ae6958a527	\N	idp-confirm-link	offices	650a1280-b21d-48cf-9c79-f7129053bae7	0	10	f	\N	\N
4ff4c537-c175-412b-b8e5-52c959639b58	\N	\N	offices	650a1280-b21d-48cf-9c79-f7129053bae7	0	20	t	c44b7a6c-6784-4dd8-b07f-22b5e0f4a016	\N
38cd645a-f97c-4e97-9bdd-373083dc6045	\N	conditional-user-configured	offices	66a505e3-78f1-44af-9ee1-69df2ac21d7f	0	10	f	\N	\N
ce06b608-988d-487a-9732-a2ba477da912	\N	reset-otp	offices	66a505e3-78f1-44af-9ee1-69df2ac21d7f	0	20	f	\N	\N
6eb41be9-dd0d-49eb-a59f-429804549d32	\N	idp-create-user-if-unique	offices	50f00539-84be-4eb6-a4b4-20872c4a6096	2	10	f	\N	4f3c1a34-67b3-4373-ae20-e51abcccb247
efd8b0e5-7fe8-4106-ad52-4b465224c812	\N	\N	offices	50f00539-84be-4eb6-a4b4-20872c4a6096	2	20	t	650a1280-b21d-48cf-9c79-f7129053bae7	\N
2d875266-70ce-42f2-ab3e-7c69bc87bfd4	\N	idp-username-password-form	offices	feb370cc-2a22-4d2a-be86-b7aa61736560	0	10	f	\N	\N
9143f7cf-d458-40c7-97fd-eddc5ad3c2de	\N	\N	offices	feb370cc-2a22-4d2a-be86-b7aa61736560	1	20	t	19d1c17f-c5fe-4773-91a6-1d12730841a5	\N
3623bc63-d4c5-4454-afec-1de1fb85f15d	\N	auth-cookie	offices	37675020-4b7c-42ba-a54d-959a5a8734db	2	10	f	\N	\N
a1a59d93-0479-4092-a76c-6cf6e0e1cc7b	\N	auth-spnego	offices	37675020-4b7c-42ba-a54d-959a5a8734db	3	20	f	\N	\N
45217ab5-1caa-45ac-a245-ab5796449984	\N	identity-provider-redirector	offices	37675020-4b7c-42ba-a54d-959a5a8734db	2	25	f	\N	\N
9a711d31-ed07-4c19-a843-6ee6366f3c49	\N	\N	offices	37675020-4b7c-42ba-a54d-959a5a8734db	2	30	t	13777600-4242-464f-812f-c4c2520fb68f	\N
c7f2638a-7fef-4a46-ad46-877332ae5ebc	\N	client-secret	offices	c93ad727-b757-4078-b220-369010d91f47	2	10	f	\N	\N
e7fba16d-c867-44db-b130-ed6b46be5f79	\N	client-jwt	offices	c93ad727-b757-4078-b220-369010d91f47	2	20	f	\N	\N
76f35dd0-5d9a-43fa-9120-acf9a7ff5b4b	\N	client-secret-jwt	offices	c93ad727-b757-4078-b220-369010d91f47	2	30	f	\N	\N
6d004a50-6e96-4e4a-af4e-8841f57e11e2	\N	client-x509	offices	c93ad727-b757-4078-b220-369010d91f47	2	40	f	\N	\N
bfdb6802-62b3-482b-9568-7079fdcb6859	\N	direct-grant-validate-username	offices	a65dcfc2-812a-4ef5-917b-75cfdae3bee8	0	10	f	\N	\N
d538a676-faf3-4b6c-a0ce-ee1d69263e41	\N	direct-grant-validate-password	offices	a65dcfc2-812a-4ef5-917b-75cfdae3bee8	0	20	f	\N	\N
f10689ac-e894-4ab8-a827-2e1b61e17bd7	\N	\N	offices	a65dcfc2-812a-4ef5-917b-75cfdae3bee8	1	30	t	263574eb-3652-45f9-aa98-a95f9eb294d5	\N
9c8dd7d1-d6b4-48f4-8804-a6a4e14919ea	\N	docker-http-basic-authenticator	offices	38266e43-4444-404e-ab34-48053725042c	0	10	f	\N	\N
867ce51d-5eb8-468d-8a05-5851b095001f	\N	idp-review-profile	offices	91bc2298-9412-47c1-9fd9-32428fc0ab08	0	10	f	\N	4cb6712a-ca75-4f6d-b25c-4983c6e48c82
45bd2cad-08b1-4e29-b23f-d87065b1060e	\N	\N	offices	91bc2298-9412-47c1-9fd9-32428fc0ab08	0	20	t	50f00539-84be-4eb6-a4b4-20872c4a6096	\N
c154f78e-cff3-43c8-a44f-08381f35980e	\N	auth-username-password-form	offices	13777600-4242-464f-812f-c4c2520fb68f	0	10	f	\N	\N
0e1ceaec-9e77-477a-84b2-802a91237e39	\N	\N	offices	13777600-4242-464f-812f-c4c2520fb68f	1	20	t	90491b52-8098-43c4-9eb9-5a9c3472cddd	\N
56d51495-f387-4cbe-897e-939ae8889199	\N	registration-page-form	offices	76cb6cb9-165e-4993-9ef5-e85b0d07a96c	0	10	t	80d83533-3b65-4a9a-ac43-3dab3ed97160	\N
3cc134d3-547e-4daf-b7c4-5786becc3d5a	\N	registration-user-creation	offices	80d83533-3b65-4a9a-ac43-3dab3ed97160	0	20	f	\N	\N
8be1fa7d-982a-4f32-b219-7b4c76f293d1	\N	registration-password-action	offices	80d83533-3b65-4a9a-ac43-3dab3ed97160	0	50	f	\N	\N
329ec835-c656-4d37-81eb-4c601855dbe4	\N	registration-recaptcha-action	offices	80d83533-3b65-4a9a-ac43-3dab3ed97160	3	60	f	\N	\N
e3009d9d-e061-48bb-b601-7378e8edf350	\N	reset-credentials-choose-user	offices	d61d4b2d-c9f7-4d93-8ff2-60af08a39298	0	10	f	\N	\N
4f7f0676-ecb9-4b0f-af6c-af2df53f26de	\N	reset-credential-email	offices	d61d4b2d-c9f7-4d93-8ff2-60af08a39298	0	20	f	\N	\N
33b074b8-dc35-44d0-9a85-e7b65425f997	\N	reset-password	offices	d61d4b2d-c9f7-4d93-8ff2-60af08a39298	0	30	f	\N	\N
11a548ae-1b1e-4934-9a7c-fd56f6059d9f	\N	\N	offices	d61d4b2d-c9f7-4d93-8ff2-60af08a39298	1	40	t	66a505e3-78f1-44af-9ee1-69df2ac21d7f	\N
927b4206-e8a3-448c-b5b9-4bae46b91168	\N	http-basic-authenticator	offices	97689fe9-6038-4adb-a160-4dc340f62082	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
b662bb52-8752-4436-9830-66c58bd9bd1e	browser	browser based authentication	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	t	t
41779a7a-6a63-494c-932f-a9f2e3591a5e	forms	Username, password, otp and other auth forms.	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	f	t
84531ac5-0509-4a23-ae31-9d8222ce8e8c	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	f	t
104bf34e-4bb0-4433-b099-35787b0ef7c4	direct grant	OpenID Connect Resource Owner Grant	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	t	t
7e5b6b86-a495-41b4-9538-cda1ed128cf6	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	f	t
f2dc4d8d-c82b-4307-8812-a9dfc2e42693	registration	registration flow	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	t	t
bfae4df0-df66-4631-885b-13dcbd48cb33	registration form	registration form	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	form-flow	f	t
73ede839-e1d9-43a1-a45f-911106608732	reset credentials	Reset credentials for a user if they forgot their password or something	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	t	t
661ca55c-b87e-409f-81b6-314e20880ea4	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	f	t
2f752cb8-e355-41c9-ab43-19aeea0f7a2d	clients	Base authentication for clients	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	client-flow	t	t
5ce768b4-c615-40d9-94f7-68a76f26147f	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	t	t
5894c24c-3b34-4cb8-b512-765710878d41	User creation or linking	Flow for the existing/non-existing user alternatives	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	f	t
918b7689-1d38-4e2b-a8bc-6f000d0794f8	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	f	t
ddbf3888-c617-4343-805d-4144896d2f54	Account verification options	Method with which to verity the existing account	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	f	t
c007775f-cb5c-4264-b893-000f020d96ba	Verify Existing Account by Re-authentication	Reauthentication of existing account	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	f	t
3c1f9c31-830b-46d3-9a67-9908e4e755de	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	f	t
ff1e1a17-5819-4c9d-84f8-f00ead7c28ab	saml ecp	SAML ECP Profile Authentication Flow	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	t	t
7d9b6ac1-d0dc-4cbd-8ff9-846b268bbd89	docker auth	Used by Docker clients to authenticate against the IDP	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	basic-flow	t	t
c44b7a6c-6784-4dd8-b07f-22b5e0f4a016	Account verification options	Method with which to verity the existing account	offices	basic-flow	f	t
90491b52-8098-43c4-9eb9-5a9c3472cddd	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	offices	basic-flow	f	t
263574eb-3652-45f9-aa98-a95f9eb294d5	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	offices	basic-flow	f	t
19d1c17f-c5fe-4773-91a6-1d12730841a5	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	offices	basic-flow	f	t
650a1280-b21d-48cf-9c79-f7129053bae7	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	offices	basic-flow	f	t
66a505e3-78f1-44af-9ee1-69df2ac21d7f	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	offices	basic-flow	f	t
50f00539-84be-4eb6-a4b4-20872c4a6096	User creation or linking	Flow for the existing/non-existing user alternatives	offices	basic-flow	f	t
feb370cc-2a22-4d2a-be86-b7aa61736560	Verify Existing Account by Re-authentication	Reauthentication of existing account	offices	basic-flow	f	t
37675020-4b7c-42ba-a54d-959a5a8734db	browser	browser based authentication	offices	basic-flow	t	t
c93ad727-b757-4078-b220-369010d91f47	clients	Base authentication for clients	offices	client-flow	t	t
a65dcfc2-812a-4ef5-917b-75cfdae3bee8	direct grant	OpenID Connect Resource Owner Grant	offices	basic-flow	t	t
38266e43-4444-404e-ab34-48053725042c	docker auth	Used by Docker clients to authenticate against the IDP	offices	basic-flow	t	t
91bc2298-9412-47c1-9fd9-32428fc0ab08	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	offices	basic-flow	t	t
13777600-4242-464f-812f-c4c2520fb68f	forms	Username, password, otp and other auth forms.	offices	basic-flow	f	t
76cb6cb9-165e-4993-9ef5-e85b0d07a96c	registration	registration flow	offices	basic-flow	t	t
80d83533-3b65-4a9a-ac43-3dab3ed97160	registration form	registration form	offices	form-flow	f	t
d61d4b2d-c9f7-4d93-8ff2-60af08a39298	reset credentials	Reset credentials for a user if they forgot their password or something	offices	basic-flow	t	t
97689fe9-6038-4adb-a160-4dc340f62082	saml ecp	SAML ECP Profile Authentication Flow	offices	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
5068887a-9027-4a68-a554-7b31f8d1155a	review profile config	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3
2952c7ec-18e2-4da3-a239-9c69be0c5194	create unique user config	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3
4f3c1a34-67b3-4373-ae20-e51abcccb247	create unique user config	offices
4cb6712a-ca75-4f6d-b25c-4983c6e48c82	review profile config	offices
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
2952c7ec-18e2-4da3-a239-9c69be0c5194	false	require.password.update.after.registration
5068887a-9027-4a68-a554-7b31f8d1155a	missing	update.profile.on.first.login
4cb6712a-ca75-4f6d-b25c-4983c6e48c82	missing	update.profile.on.first.login
4f3c1a34-67b3-4373-ae20-e51abcccb247	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	f	master-realm	0	f	\N	\N	t	\N	f	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
b81fb2f6-6d68-47c7-a8c9-05749088eb42	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
9be8d753-9a0d-4da4-a9e4-3bba031c410a	t	f	broker	0	f	\N	\N	t	\N	f	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
74dca843-fbea-4237-bbe3-98c0804778dc	t	f	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	f	offices-realm	0	f	\N	\N	t	\N	f	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	\N	0	f	f	offices Realm	f	client-secret	\N	\N	\N	t	f	f	f
68e03bd4-6a95-4b73-98ff-2689bafac727	t	f	account	0	t	\N	/realms/offices/account/	f	\N	f	offices	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	t	f	account-console	0	t	\N	/realms/offices/account/	f	\N	f	offices	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
6bd58108-7661-4b77-a966-0c820613deef	t	f	admin-cli	0	f	**********		f		f	offices	openid-connect	0	f	f	${client_admin-cli}	t	client-secret			\N	t	t	t	f
391be89f-580a-4833-b48a-459ae57059f3	t	f	broker	0	f	\N	\N	t	\N	f	offices	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
62c71480-d212-4dea-aa42-a88bc8efb235	t	f	realm-management	0	f	\N	\N	t	\N	f	offices	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
7ea9781f-d754-49b5-8e4d-27881873d893	t	f	security-admin-console	0	t	\N	/admin/offices/console/	f	\N	f	offices	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
48daad2a-6675-4d49-967d-13b861c8bc6c	t	f	admin-cli	0	f	DCRkkqpUv3XlQnosjtf8jHleP7tuduTa		f		f	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	openid-connect	0	f	f	${client_admin-cli}	t	client-secret			\N	t	t	t	f
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	t	t	offices	0	f	5Lg4hJJKlDDnfTs4vaAdOK95c2DDps5p33t7		f		f	offices	openid-connect	-1	f	f	offices	f	client-secret		Client for offices	\N	f	f	t	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
b81fb2f6-6d68-47c7-a8c9-05749088eb42	post.logout.redirect.uris	+
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	post.logout.redirect.uris	+
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	pkce.code.challenge.method	S256
74dca843-fbea-4237-bbe3-98c0804778dc	post.logout.redirect.uris	+
74dca843-fbea-4237-bbe3-98c0804778dc	pkce.code.challenge.method	S256
68e03bd4-6a95-4b73-98ff-2689bafac727	post.logout.redirect.uris	+
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	post.logout.redirect.uris	+
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	pkce.code.challenge.method	S256
6bd58108-7661-4b77-a966-0c820613deef	oidc.ciba.grant.enabled	false
6bd58108-7661-4b77-a966-0c820613deef	client.secret.creation.time	1715889436
6bd58108-7661-4b77-a966-0c820613deef	backchannel.logout.session.required	true
6bd58108-7661-4b77-a966-0c820613deef	post.logout.redirect.uris	+
6bd58108-7661-4b77-a966-0c820613deef	display.on.consent.screen	false
6bd58108-7661-4b77-a966-0c820613deef	oauth2.device.authorization.grant.enabled	false
6bd58108-7661-4b77-a966-0c820613deef	backchannel.logout.revoke.offline.tokens	false
391be89f-580a-4833-b48a-459ae57059f3	post.logout.redirect.uris	+
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	client.secret.creation.time	1715798969
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	post.logout.redirect.uris	+
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	oauth2.device.authorization.grant.enabled	false
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	backchannel.logout.revoke.offline.tokens	false
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	use.refresh.tokens	true
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	oidc.ciba.grant.enabled	false
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	backchannel.logout.session.required	true
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	client_credentials.use_refresh_token	true
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	tls.client.certificate.bound.access.tokens	false
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	require.pushed.authorization.requests	false
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	acr.loa.map	{}
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	display.on.consent.screen	false
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	token.response.type.bearer.lower-case	false
62c71480-d212-4dea-aa42-a88bc8efb235	post.logout.redirect.uris	+
7ea9781f-d754-49b5-8e4d-27881873d893	post.logout.redirect.uris	+
7ea9781f-d754-49b5-8e4d-27881873d893	pkce.code.challenge.method	S256
48daad2a-6675-4d49-967d-13b861c8bc6c	oauth2.device.authorization.grant.enabled	false
48daad2a-6675-4d49-967d-13b861c8bc6c	oidc.ciba.grant.enabled	false
48daad2a-6675-4d49-967d-13b861c8bc6c	display.on.consent.screen	false
48daad2a-6675-4d49-967d-13b861c8bc6c	backchannel.logout.session.required	true
48daad2a-6675-4d49-967d-13b861c8bc6c	backchannel.logout.revoke.offline.tokens	false
48daad2a-6675-4d49-967d-13b861c8bc6c	client.secret.creation.time	1716228516
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
5b6c81d6-c5e0-4c93-926d-761083cfdbed	offline_access	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	OpenID Connect built-in scope: offline_access	openid-connect
f8863ef8-9e11-47c1-9b04-3cc0871da801	role_list	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	SAML role list	saml
1a42cc09-1765-49e8-b48a-2f2bfedb3628	profile	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	OpenID Connect built-in scope: profile	openid-connect
c2a1ec5e-eb3d-40a9-bd36-b0e655854a89	email	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	OpenID Connect built-in scope: email	openid-connect
bedf7e65-53b3-4def-a774-a5af7cd8f9ab	address	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	OpenID Connect built-in scope: address	openid-connect
b4c362cf-f726-41fb-94df-7ef238c6f75f	phone	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	OpenID Connect built-in scope: phone	openid-connect
f3cecf35-5911-4f03-a645-d88de62bd0a7	roles	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	OpenID Connect scope for add user roles to the access token	openid-connect
feddf322-903f-4301-97ee-d95a1888d17b	web-origins	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	OpenID Connect scope for add allowed web origins to the access token	openid-connect
993ef9f2-6f48-48cb-8a4d-ec7ecfa188e6	microprofile-jwt	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	Microprofile - JWT built-in scope	openid-connect
b494f1a3-5ca5-42e7-a0a9-402cb80e3674	acr	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
ac79bdd9-5fc8-439d-b854-6db86e4e421d	offline_access	offices	OpenID Connect built-in scope: offline_access	openid-connect
21813b6a-fd67-47ac-976f-cba52022d485	roles	offices	OpenID Connect scope for add user roles to the access token	openid-connect
c03ecd61-ea09-43aa-8e7b-d623ef2ca9be	phone	offices	OpenID Connect built-in scope: phone	openid-connect
31a08250-f1a5-449a-be71-3541ed2f0a55	microprofile-jwt	offices	Microprofile - JWT built-in scope	openid-connect
b3cc20a5-c599-40db-aacd-6d0888f40165	role_list	offices	SAML role list	saml
ea7408db-2fc3-4dd2-a477-3d80ed750535	address	offices	OpenID Connect built-in scope: address	openid-connect
040a3ca9-1518-4d62-8635-889a6bd64f1b	profile	offices	OpenID Connect built-in scope: profile	openid-connect
da2ab094-2b69-4691-9ed4-7768f0ecb4d5	email	offices	OpenID Connect built-in scope: email	openid-connect
63b63fac-108c-444c-8c32-925078761f37	web-origins	offices	OpenID Connect scope for add allowed web origins to the access token	openid-connect
81cffda0-096b-4ec5-b9bf-f708f2adf5cc	acr	offices	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
5b6c81d6-c5e0-4c93-926d-761083cfdbed	true	display.on.consent.screen
5b6c81d6-c5e0-4c93-926d-761083cfdbed	${offlineAccessScopeConsentText}	consent.screen.text
f8863ef8-9e11-47c1-9b04-3cc0871da801	true	display.on.consent.screen
f8863ef8-9e11-47c1-9b04-3cc0871da801	${samlRoleListScopeConsentText}	consent.screen.text
1a42cc09-1765-49e8-b48a-2f2bfedb3628	true	display.on.consent.screen
1a42cc09-1765-49e8-b48a-2f2bfedb3628	${profileScopeConsentText}	consent.screen.text
1a42cc09-1765-49e8-b48a-2f2bfedb3628	true	include.in.token.scope
c2a1ec5e-eb3d-40a9-bd36-b0e655854a89	true	display.on.consent.screen
c2a1ec5e-eb3d-40a9-bd36-b0e655854a89	${emailScopeConsentText}	consent.screen.text
c2a1ec5e-eb3d-40a9-bd36-b0e655854a89	true	include.in.token.scope
bedf7e65-53b3-4def-a774-a5af7cd8f9ab	true	display.on.consent.screen
bedf7e65-53b3-4def-a774-a5af7cd8f9ab	${addressScopeConsentText}	consent.screen.text
bedf7e65-53b3-4def-a774-a5af7cd8f9ab	true	include.in.token.scope
b4c362cf-f726-41fb-94df-7ef238c6f75f	true	display.on.consent.screen
b4c362cf-f726-41fb-94df-7ef238c6f75f	${phoneScopeConsentText}	consent.screen.text
b4c362cf-f726-41fb-94df-7ef238c6f75f	true	include.in.token.scope
f3cecf35-5911-4f03-a645-d88de62bd0a7	true	display.on.consent.screen
f3cecf35-5911-4f03-a645-d88de62bd0a7	${rolesScopeConsentText}	consent.screen.text
f3cecf35-5911-4f03-a645-d88de62bd0a7	false	include.in.token.scope
feddf322-903f-4301-97ee-d95a1888d17b	false	display.on.consent.screen
feddf322-903f-4301-97ee-d95a1888d17b		consent.screen.text
feddf322-903f-4301-97ee-d95a1888d17b	false	include.in.token.scope
993ef9f2-6f48-48cb-8a4d-ec7ecfa188e6	false	display.on.consent.screen
993ef9f2-6f48-48cb-8a4d-ec7ecfa188e6	true	include.in.token.scope
b494f1a3-5ca5-42e7-a0a9-402cb80e3674	false	display.on.consent.screen
b494f1a3-5ca5-42e7-a0a9-402cb80e3674	false	include.in.token.scope
ac79bdd9-5fc8-439d-b854-6db86e4e421d	${offlineAccessScopeConsentText}	consent.screen.text
ac79bdd9-5fc8-439d-b854-6db86e4e421d	true	display.on.consent.screen
21813b6a-fd67-47ac-976f-cba52022d485	false	include.in.token.scope
21813b6a-fd67-47ac-976f-cba52022d485	true	display.on.consent.screen
21813b6a-fd67-47ac-976f-cba52022d485	${rolesScopeConsentText}	consent.screen.text
c03ecd61-ea09-43aa-8e7b-d623ef2ca9be	true	include.in.token.scope
c03ecd61-ea09-43aa-8e7b-d623ef2ca9be	true	display.on.consent.screen
c03ecd61-ea09-43aa-8e7b-d623ef2ca9be	${phoneScopeConsentText}	consent.screen.text
31a08250-f1a5-449a-be71-3541ed2f0a55	true	include.in.token.scope
31a08250-f1a5-449a-be71-3541ed2f0a55	false	display.on.consent.screen
b3cc20a5-c599-40db-aacd-6d0888f40165	${samlRoleListScopeConsentText}	consent.screen.text
b3cc20a5-c599-40db-aacd-6d0888f40165	true	display.on.consent.screen
ea7408db-2fc3-4dd2-a477-3d80ed750535	true	include.in.token.scope
ea7408db-2fc3-4dd2-a477-3d80ed750535	true	display.on.consent.screen
ea7408db-2fc3-4dd2-a477-3d80ed750535	${addressScopeConsentText}	consent.screen.text
040a3ca9-1518-4d62-8635-889a6bd64f1b	true	include.in.token.scope
040a3ca9-1518-4d62-8635-889a6bd64f1b	true	display.on.consent.screen
040a3ca9-1518-4d62-8635-889a6bd64f1b	${profileScopeConsentText}	consent.screen.text
da2ab094-2b69-4691-9ed4-7768f0ecb4d5	true	include.in.token.scope
da2ab094-2b69-4691-9ed4-7768f0ecb4d5	true	display.on.consent.screen
da2ab094-2b69-4691-9ed4-7768f0ecb4d5	${emailScopeConsentText}	consent.screen.text
63b63fac-108c-444c-8c32-925078761f37	false	include.in.token.scope
63b63fac-108c-444c-8c32-925078761f37	false	display.on.consent.screen
63b63fac-108c-444c-8c32-925078761f37		consent.screen.text
81cffda0-096b-4ec5-b9bf-f708f2adf5cc	false	include.in.token.scope
81cffda0-096b-4ec5-b9bf-f708f2adf5cc	false	display.on.consent.screen
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
b81fb2f6-6d68-47c7-a8c9-05749088eb42	f3cecf35-5911-4f03-a645-d88de62bd0a7	t
b81fb2f6-6d68-47c7-a8c9-05749088eb42	c2a1ec5e-eb3d-40a9-bd36-b0e655854a89	t
b81fb2f6-6d68-47c7-a8c9-05749088eb42	b494f1a3-5ca5-42e7-a0a9-402cb80e3674	t
b81fb2f6-6d68-47c7-a8c9-05749088eb42	1a42cc09-1765-49e8-b48a-2f2bfedb3628	t
b81fb2f6-6d68-47c7-a8c9-05749088eb42	feddf322-903f-4301-97ee-d95a1888d17b	t
b81fb2f6-6d68-47c7-a8c9-05749088eb42	b4c362cf-f726-41fb-94df-7ef238c6f75f	f
b81fb2f6-6d68-47c7-a8c9-05749088eb42	bedf7e65-53b3-4def-a774-a5af7cd8f9ab	f
b81fb2f6-6d68-47c7-a8c9-05749088eb42	993ef9f2-6f48-48cb-8a4d-ec7ecfa188e6	f
b81fb2f6-6d68-47c7-a8c9-05749088eb42	5b6c81d6-c5e0-4c93-926d-761083cfdbed	f
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	f3cecf35-5911-4f03-a645-d88de62bd0a7	t
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	c2a1ec5e-eb3d-40a9-bd36-b0e655854a89	t
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	b494f1a3-5ca5-42e7-a0a9-402cb80e3674	t
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	1a42cc09-1765-49e8-b48a-2f2bfedb3628	t
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	feddf322-903f-4301-97ee-d95a1888d17b	t
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	b4c362cf-f726-41fb-94df-7ef238c6f75f	f
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	bedf7e65-53b3-4def-a774-a5af7cd8f9ab	f
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	993ef9f2-6f48-48cb-8a4d-ec7ecfa188e6	f
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	5b6c81d6-c5e0-4c93-926d-761083cfdbed	f
48daad2a-6675-4d49-967d-13b861c8bc6c	f3cecf35-5911-4f03-a645-d88de62bd0a7	t
48daad2a-6675-4d49-967d-13b861c8bc6c	c2a1ec5e-eb3d-40a9-bd36-b0e655854a89	t
48daad2a-6675-4d49-967d-13b861c8bc6c	b494f1a3-5ca5-42e7-a0a9-402cb80e3674	t
48daad2a-6675-4d49-967d-13b861c8bc6c	1a42cc09-1765-49e8-b48a-2f2bfedb3628	t
48daad2a-6675-4d49-967d-13b861c8bc6c	feddf322-903f-4301-97ee-d95a1888d17b	t
48daad2a-6675-4d49-967d-13b861c8bc6c	b4c362cf-f726-41fb-94df-7ef238c6f75f	f
48daad2a-6675-4d49-967d-13b861c8bc6c	bedf7e65-53b3-4def-a774-a5af7cd8f9ab	f
48daad2a-6675-4d49-967d-13b861c8bc6c	993ef9f2-6f48-48cb-8a4d-ec7ecfa188e6	f
48daad2a-6675-4d49-967d-13b861c8bc6c	5b6c81d6-c5e0-4c93-926d-761083cfdbed	f
9be8d753-9a0d-4da4-a9e4-3bba031c410a	f3cecf35-5911-4f03-a645-d88de62bd0a7	t
9be8d753-9a0d-4da4-a9e4-3bba031c410a	c2a1ec5e-eb3d-40a9-bd36-b0e655854a89	t
9be8d753-9a0d-4da4-a9e4-3bba031c410a	b494f1a3-5ca5-42e7-a0a9-402cb80e3674	t
9be8d753-9a0d-4da4-a9e4-3bba031c410a	1a42cc09-1765-49e8-b48a-2f2bfedb3628	t
9be8d753-9a0d-4da4-a9e4-3bba031c410a	feddf322-903f-4301-97ee-d95a1888d17b	t
9be8d753-9a0d-4da4-a9e4-3bba031c410a	b4c362cf-f726-41fb-94df-7ef238c6f75f	f
9be8d753-9a0d-4da4-a9e4-3bba031c410a	bedf7e65-53b3-4def-a774-a5af7cd8f9ab	f
9be8d753-9a0d-4da4-a9e4-3bba031c410a	993ef9f2-6f48-48cb-8a4d-ec7ecfa188e6	f
9be8d753-9a0d-4da4-a9e4-3bba031c410a	5b6c81d6-c5e0-4c93-926d-761083cfdbed	f
2a9d8d7d-0632-45ba-81e5-d3004f154c05	f3cecf35-5911-4f03-a645-d88de62bd0a7	t
2a9d8d7d-0632-45ba-81e5-d3004f154c05	c2a1ec5e-eb3d-40a9-bd36-b0e655854a89	t
2a9d8d7d-0632-45ba-81e5-d3004f154c05	b494f1a3-5ca5-42e7-a0a9-402cb80e3674	t
2a9d8d7d-0632-45ba-81e5-d3004f154c05	1a42cc09-1765-49e8-b48a-2f2bfedb3628	t
2a9d8d7d-0632-45ba-81e5-d3004f154c05	feddf322-903f-4301-97ee-d95a1888d17b	t
2a9d8d7d-0632-45ba-81e5-d3004f154c05	b4c362cf-f726-41fb-94df-7ef238c6f75f	f
2a9d8d7d-0632-45ba-81e5-d3004f154c05	bedf7e65-53b3-4def-a774-a5af7cd8f9ab	f
2a9d8d7d-0632-45ba-81e5-d3004f154c05	993ef9f2-6f48-48cb-8a4d-ec7ecfa188e6	f
2a9d8d7d-0632-45ba-81e5-d3004f154c05	5b6c81d6-c5e0-4c93-926d-761083cfdbed	f
74dca843-fbea-4237-bbe3-98c0804778dc	f3cecf35-5911-4f03-a645-d88de62bd0a7	t
74dca843-fbea-4237-bbe3-98c0804778dc	c2a1ec5e-eb3d-40a9-bd36-b0e655854a89	t
74dca843-fbea-4237-bbe3-98c0804778dc	b494f1a3-5ca5-42e7-a0a9-402cb80e3674	t
74dca843-fbea-4237-bbe3-98c0804778dc	1a42cc09-1765-49e8-b48a-2f2bfedb3628	t
74dca843-fbea-4237-bbe3-98c0804778dc	feddf322-903f-4301-97ee-d95a1888d17b	t
74dca843-fbea-4237-bbe3-98c0804778dc	b4c362cf-f726-41fb-94df-7ef238c6f75f	f
74dca843-fbea-4237-bbe3-98c0804778dc	bedf7e65-53b3-4def-a774-a5af7cd8f9ab	f
74dca843-fbea-4237-bbe3-98c0804778dc	993ef9f2-6f48-48cb-8a4d-ec7ecfa188e6	f
74dca843-fbea-4237-bbe3-98c0804778dc	5b6c81d6-c5e0-4c93-926d-761083cfdbed	f
68e03bd4-6a95-4b73-98ff-2689bafac727	63b63fac-108c-444c-8c32-925078761f37	t
68e03bd4-6a95-4b73-98ff-2689bafac727	81cffda0-096b-4ec5-b9bf-f708f2adf5cc	t
68e03bd4-6a95-4b73-98ff-2689bafac727	21813b6a-fd67-47ac-976f-cba52022d485	t
68e03bd4-6a95-4b73-98ff-2689bafac727	040a3ca9-1518-4d62-8635-889a6bd64f1b	t
68e03bd4-6a95-4b73-98ff-2689bafac727	da2ab094-2b69-4691-9ed4-7768f0ecb4d5	t
68e03bd4-6a95-4b73-98ff-2689bafac727	ea7408db-2fc3-4dd2-a477-3d80ed750535	f
68e03bd4-6a95-4b73-98ff-2689bafac727	c03ecd61-ea09-43aa-8e7b-d623ef2ca9be	f
68e03bd4-6a95-4b73-98ff-2689bafac727	ac79bdd9-5fc8-439d-b854-6db86e4e421d	f
68e03bd4-6a95-4b73-98ff-2689bafac727	31a08250-f1a5-449a-be71-3541ed2f0a55	f
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	63b63fac-108c-444c-8c32-925078761f37	t
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	81cffda0-096b-4ec5-b9bf-f708f2adf5cc	t
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	21813b6a-fd67-47ac-976f-cba52022d485	t
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	040a3ca9-1518-4d62-8635-889a6bd64f1b	t
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	da2ab094-2b69-4691-9ed4-7768f0ecb4d5	t
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	ea7408db-2fc3-4dd2-a477-3d80ed750535	f
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	c03ecd61-ea09-43aa-8e7b-d623ef2ca9be	f
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	ac79bdd9-5fc8-439d-b854-6db86e4e421d	f
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	31a08250-f1a5-449a-be71-3541ed2f0a55	f
6bd58108-7661-4b77-a966-0c820613deef	63b63fac-108c-444c-8c32-925078761f37	t
6bd58108-7661-4b77-a966-0c820613deef	81cffda0-096b-4ec5-b9bf-f708f2adf5cc	t
6bd58108-7661-4b77-a966-0c820613deef	21813b6a-fd67-47ac-976f-cba52022d485	t
6bd58108-7661-4b77-a966-0c820613deef	040a3ca9-1518-4d62-8635-889a6bd64f1b	t
6bd58108-7661-4b77-a966-0c820613deef	da2ab094-2b69-4691-9ed4-7768f0ecb4d5	t
6bd58108-7661-4b77-a966-0c820613deef	ea7408db-2fc3-4dd2-a477-3d80ed750535	f
6bd58108-7661-4b77-a966-0c820613deef	c03ecd61-ea09-43aa-8e7b-d623ef2ca9be	f
6bd58108-7661-4b77-a966-0c820613deef	ac79bdd9-5fc8-439d-b854-6db86e4e421d	f
6bd58108-7661-4b77-a966-0c820613deef	31a08250-f1a5-449a-be71-3541ed2f0a55	f
391be89f-580a-4833-b48a-459ae57059f3	63b63fac-108c-444c-8c32-925078761f37	t
391be89f-580a-4833-b48a-459ae57059f3	81cffda0-096b-4ec5-b9bf-f708f2adf5cc	t
391be89f-580a-4833-b48a-459ae57059f3	21813b6a-fd67-47ac-976f-cba52022d485	t
391be89f-580a-4833-b48a-459ae57059f3	040a3ca9-1518-4d62-8635-889a6bd64f1b	t
391be89f-580a-4833-b48a-459ae57059f3	da2ab094-2b69-4691-9ed4-7768f0ecb4d5	t
391be89f-580a-4833-b48a-459ae57059f3	ea7408db-2fc3-4dd2-a477-3d80ed750535	f
391be89f-580a-4833-b48a-459ae57059f3	c03ecd61-ea09-43aa-8e7b-d623ef2ca9be	f
391be89f-580a-4833-b48a-459ae57059f3	ac79bdd9-5fc8-439d-b854-6db86e4e421d	f
391be89f-580a-4833-b48a-459ae57059f3	31a08250-f1a5-449a-be71-3541ed2f0a55	f
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	63b63fac-108c-444c-8c32-925078761f37	t
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	81cffda0-096b-4ec5-b9bf-f708f2adf5cc	t
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	21813b6a-fd67-47ac-976f-cba52022d485	t
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	040a3ca9-1518-4d62-8635-889a6bd64f1b	t
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	da2ab094-2b69-4691-9ed4-7768f0ecb4d5	t
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	ea7408db-2fc3-4dd2-a477-3d80ed750535	f
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	c03ecd61-ea09-43aa-8e7b-d623ef2ca9be	f
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	ac79bdd9-5fc8-439d-b854-6db86e4e421d	f
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	31a08250-f1a5-449a-be71-3541ed2f0a55	f
62c71480-d212-4dea-aa42-a88bc8efb235	63b63fac-108c-444c-8c32-925078761f37	t
62c71480-d212-4dea-aa42-a88bc8efb235	81cffda0-096b-4ec5-b9bf-f708f2adf5cc	t
62c71480-d212-4dea-aa42-a88bc8efb235	21813b6a-fd67-47ac-976f-cba52022d485	t
62c71480-d212-4dea-aa42-a88bc8efb235	040a3ca9-1518-4d62-8635-889a6bd64f1b	t
62c71480-d212-4dea-aa42-a88bc8efb235	da2ab094-2b69-4691-9ed4-7768f0ecb4d5	t
62c71480-d212-4dea-aa42-a88bc8efb235	ea7408db-2fc3-4dd2-a477-3d80ed750535	f
62c71480-d212-4dea-aa42-a88bc8efb235	c03ecd61-ea09-43aa-8e7b-d623ef2ca9be	f
62c71480-d212-4dea-aa42-a88bc8efb235	ac79bdd9-5fc8-439d-b854-6db86e4e421d	f
62c71480-d212-4dea-aa42-a88bc8efb235	31a08250-f1a5-449a-be71-3541ed2f0a55	f
7ea9781f-d754-49b5-8e4d-27881873d893	63b63fac-108c-444c-8c32-925078761f37	t
7ea9781f-d754-49b5-8e4d-27881873d893	81cffda0-096b-4ec5-b9bf-f708f2adf5cc	t
7ea9781f-d754-49b5-8e4d-27881873d893	21813b6a-fd67-47ac-976f-cba52022d485	t
7ea9781f-d754-49b5-8e4d-27881873d893	040a3ca9-1518-4d62-8635-889a6bd64f1b	t
7ea9781f-d754-49b5-8e4d-27881873d893	da2ab094-2b69-4691-9ed4-7768f0ecb4d5	t
7ea9781f-d754-49b5-8e4d-27881873d893	ea7408db-2fc3-4dd2-a477-3d80ed750535	f
7ea9781f-d754-49b5-8e4d-27881873d893	c03ecd61-ea09-43aa-8e7b-d623ef2ca9be	f
7ea9781f-d754-49b5-8e4d-27881873d893	ac79bdd9-5fc8-439d-b854-6db86e4e421d	f
7ea9781f-d754-49b5-8e4d-27881873d893	31a08250-f1a5-449a-be71-3541ed2f0a55	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
5b6c81d6-c5e0-4c93-926d-761083cfdbed	6d5c982e-60c8-4a7c-8cbf-0c1c8bc23a84
ac79bdd9-5fc8-439d-b854-6db86e4e421d	b6c86baa-5355-418a-87da-12fe0a5db8b1
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
e3dd69c7-e8a1-46b3-af08-13994da3a43a	Trusted Hosts	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	anonymous
cd186f2c-b785-4295-a61b-567121826343	Consent Required	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	anonymous
e2bed20a-b1f2-43cb-b852-3a21efe55249	Full Scope Disabled	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	anonymous
5362ea3b-5e6d-4be1-918c-1b46bc0ea88f	Max Clients Limit	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	anonymous
067bd0c3-f999-4554-bf03-6a26d43ac658	Allowed Protocol Mapper Types	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	anonymous
7b076eb0-f44a-4eb1-8021-cbb608285ca5	Allowed Client Scopes	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	anonymous
b39f0906-36f2-48fc-b7ed-207621bc1e45	Allowed Protocol Mapper Types	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	authenticated
9f21f529-7822-43a0-af73-aee36a2bceef	Allowed Client Scopes	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	authenticated
139aed27-7f75-4e32-8696-3d97cef1bf3d	rsa-generated	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	rsa-generated	org.keycloak.keys.KeyProvider	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	\N
aaa6fc31-3885-4ea2-90f2-c2058f71c4e5	rsa-enc-generated	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	rsa-enc-generated	org.keycloak.keys.KeyProvider	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	\N
4bf74e1f-7f40-43f5-8702-52e5621d6f24	hmac-generated	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	hmac-generated	org.keycloak.keys.KeyProvider	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	\N
9eb53776-8a69-4ac9-a28c-8336fb8e7555	aes-generated	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	aes-generated	org.keycloak.keys.KeyProvider	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	\N
d3c89bb0-a2fd-473e-8e68-f98d354f9bde	Trusted Hosts	offices	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	offices	anonymous
1f6b223c-9400-46e6-8351-71707c2cfe5e	Allowed Protocol Mapper Types	offices	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	offices	anonymous
6b7b2ec9-6d49-4fb8-98cc-f0cc49b8accf	Allowed Client Scopes	offices	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	offices	authenticated
1d73e365-ba46-4e31-ad08-fa708c53bc0d	Full Scope Disabled	offices	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	offices	anonymous
632339c1-4b27-4b61-87c1-b26196d1087c	Allowed Client Scopes	offices	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	offices	anonymous
f3c69618-b6db-4a1b-a8e7-9d7a82800512	Max Clients Limit	offices	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	offices	anonymous
f7dc561f-3101-45e3-b272-1316d9fa6fdf	Allowed Protocol Mapper Types	offices	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	offices	authenticated
9524c772-25c6-428a-8a7b-d5698759591e	Consent Required	offices	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	offices	anonymous
73bac857-3755-404b-83bc-0141cdc2d465	rsa-generated	offices	rsa-generated	org.keycloak.keys.KeyProvider	offices	\N
7fd452e6-9b18-4e04-9c8c-0fa572aa2436	rsa-enc-generated	offices	rsa-enc-generated	org.keycloak.keys.KeyProvider	offices	\N
4156d10b-20f9-4207-81de-e87528aa637b	hmac-generated	offices	hmac-generated	org.keycloak.keys.KeyProvider	offices	\N
b5b254bb-d22d-451d-bde7-65a580291f50	aes-generated	offices	aes-generated	org.keycloak.keys.KeyProvider	offices	\N
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
f0dafd4b-477e-4b93-b6cd-301aa2328231	9f21f529-7822-43a0-af73-aee36a2bceef	allow-default-scopes	true
60c57598-7956-4803-bf3e-bca1c9b5ee76	e3dd69c7-e8a1-46b3-af08-13994da3a43a	host-sending-registration-request-must-match	true
bfdf8932-676c-4a84-ab1d-3dfccc994db3	e3dd69c7-e8a1-46b3-af08-13994da3a43a	client-uris-must-match	true
e1141463-459b-4db4-ab29-3755943e61f3	b39f0906-36f2-48fc-b7ed-207621bc1e45	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
6018d148-ec4f-450c-b12d-2f24b0ea2750	b39f0906-36f2-48fc-b7ed-207621bc1e45	allowed-protocol-mapper-types	saml-user-attribute-mapper
c8de440d-4691-488e-8851-a88ca920d4dc	b39f0906-36f2-48fc-b7ed-207621bc1e45	allowed-protocol-mapper-types	oidc-address-mapper
c88ca85e-70fe-4444-8c7f-384c5945c8be	b39f0906-36f2-48fc-b7ed-207621bc1e45	allowed-protocol-mapper-types	saml-role-list-mapper
2dcc383d-6235-44d9-98af-77a0eaa86538	b39f0906-36f2-48fc-b7ed-207621bc1e45	allowed-protocol-mapper-types	saml-user-property-mapper
799496e1-73cb-44bc-b806-facf3ed5e459	b39f0906-36f2-48fc-b7ed-207621bc1e45	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
c9077da9-68b7-4630-a854-a3dc1df0175e	b39f0906-36f2-48fc-b7ed-207621bc1e45	allowed-protocol-mapper-types	oidc-full-name-mapper
2531b281-9346-4288-8a2b-aed7208df59e	b39f0906-36f2-48fc-b7ed-207621bc1e45	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
541be595-2208-4833-b028-cf81a6c89eb9	067bd0c3-f999-4554-bf03-6a26d43ac658	allowed-protocol-mapper-types	oidc-address-mapper
9e36d1ce-4cd4-4fe6-a635-b6a6d2b986c3	067bd0c3-f999-4554-bf03-6a26d43ac658	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
029b9912-f698-4baa-bc6c-3ca3edc0b1cf	067bd0c3-f999-4554-bf03-6a26d43ac658	allowed-protocol-mapper-types	oidc-full-name-mapper
0fc245e4-42d0-46fd-b9c0-60e3a61649cb	067bd0c3-f999-4554-bf03-6a26d43ac658	allowed-protocol-mapper-types	saml-role-list-mapper
15019b4f-4aee-4f49-bf6e-4a917e8a572a	067bd0c3-f999-4554-bf03-6a26d43ac658	allowed-protocol-mapper-types	saml-user-attribute-mapper
36a6486f-699e-4a5a-864d-b7d19ccc5d45	067bd0c3-f999-4554-bf03-6a26d43ac658	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
8f0a81d4-6727-4228-a052-b0f1ea39183d	067bd0c3-f999-4554-bf03-6a26d43ac658	allowed-protocol-mapper-types	saml-user-property-mapper
ceadca2f-f2d1-4c84-9b7d-e1c640692259	067bd0c3-f999-4554-bf03-6a26d43ac658	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
12c75fc9-94cf-4a0c-ac07-8a953c7e1efc	7b076eb0-f44a-4eb1-8021-cbb608285ca5	allow-default-scopes	true
11122197-8caa-4174-b2e7-87c2b4aae027	5362ea3b-5e6d-4be1-918c-1b46bc0ea88f	max-clients	200
8c3eed30-3052-49ee-8194-1309c54f2d25	4bf74e1f-7f40-43f5-8702-52e5621d6f24	algorithm	HS256
caf7e4de-43a8-4e66-ba82-74f7583969c5	4bf74e1f-7f40-43f5-8702-52e5621d6f24	secret	EDZcMM0FcPsoMy6PVTqq0c_3fSyCy8GY29elReUTa0xEchTTjH4tPsSpWM3K2X_CdzMfY8_PQ5bBhUJZzvCABg
6e82ca2e-adfb-4a66-912d-340ce7dd9c75	4bf74e1f-7f40-43f5-8702-52e5621d6f24	priority	100
f6ca46ce-6db8-4059-9ef0-afd7621923b7	4bf74e1f-7f40-43f5-8702-52e5621d6f24	kid	926e82cc-716b-4265-93b5-ceb695426fa9
8f90d9c3-d262-4834-aa05-b3fc6fda6fdc	9eb53776-8a69-4ac9-a28c-8336fb8e7555	secret	7rQE63Fab436kEWQqRwB7Q
1e25e369-db68-4e6e-af18-51f2e1ddbdf3	9eb53776-8a69-4ac9-a28c-8336fb8e7555	priority	100
bd8f5eac-3316-4df6-b45f-b2d15dcf71c2	9eb53776-8a69-4ac9-a28c-8336fb8e7555	kid	685c2a9e-e446-483a-9cb1-54e50711d157
1516e6ae-09da-4f28-b8c4-5babbdf69b47	139aed27-7f75-4e32-8696-3d97cef1bf3d	priority	100
4f73799c-4b6f-4786-bf59-ff18d6d21e97	139aed27-7f75-4e32-8696-3d97cef1bf3d	privateKey	MIIEpQIBAAKCAQEA3SeIJ7Y+g3gMf4rftmehO8xy01SAbcEk4PikzuAS7rDItIQHLBTI6C2tfeLi5ViIinrMAlbadcJieZlwB3HiU0N0aIp1K4A6XH3zGJCjEiIF5P9NhABPsHSSwO2CWt8z0jKs1wFqYuJ9qhnr4t5O+FPrj0lIKV7SknzUPjxA9JtE+x2uxWhmqetEezZdXQW22NjyArW/wSWAgI0taYWZSFvKrY5O3DrhTKdP+fjYgXkjTT2Y5ZUNiD9CVxYSeXhZEAuzhloQGqP6CM742Kxbu9pX9e5nJcwaetGjPdKGQdWDF9wAu9QVYHgZPLeRBLl8poqbHYDPzyJbRLl3Apf1GwIDAQABAoIBAGpcW9g1huU1tFUW1jbkqh+XWVYX2thuPq1QB/tSuug+75gZs1VY/bLkXP8hQlxo8uoe2sT5PoHKJhAzYjTCacX/uBmbFXUBa5AWJvcWgMb0w/75Zi9o8up7diUBVWMc29Bo/MU+8gpywVswskje//3gZnb4GJOE/iLjlDQGSHsa2KureN0KNCb6sM9Cf6l+m6jD0JxkyppoBILRVC3zGeGXsaoTiG8a4L4nj2Q2ZJ8jlCCzaoBPYxyBx1x022ZGD5JElPAEsIuhVeQK2Z2Yr36gwYlDxtVSNe7rikxbJyGnxCGYIAbPogyGhzyBOC/PS0iRU1CkTmxJsgSr5TFPl1ECgYEA+mufxGbgdXrDpOxymamGsF+K8R8AtG82hSgVTw07BhfAlNmbQSN7ADGhNVKVWVxQPUXXmGGqwfVU31nGafwchDGWhRASHqxPBCxT+EboorN+jL85mwxLawY6K01HkbVpXlVsoJAPdTbuvQEI7ZOKKBD8nlUCL4F3vfuGJOST0ZkCgYEA4hT6J5sKPkDQP2Jseh+M2x+NQ2pw8tzjpOETK8co0BVorC074VRNGWhX+GWRrAw/aSpy7kRmw0ME/uYtfV5UH/q2lkP50f70ZpvlUKIetrky3YM4y+2ii1Xg005Iw7IcGBP4eK8WtWRgWpNyG2ez12p2R69w6mNiSvlHpLFcVNMCgYEAvFnowGOUnigpMUn65GLjAJPMQJHOCOjBPCQq6tuLsoh4/Dw0DyltoXayxxWHacAKRhvbDi0fr2UkYh33I85RcIiPqyOsTU/S2tOwkMRcw8t3+sr1vA3iR+xWIi2tEAY/64ka/CV+yu33YUd+/JqFRp+IMlrEGxEpDEc73VHjcLkCgYEAzY9NNB2f3qKHtloDT7bIF6REiPuK3wdAZHXRPIjE7w3IMmSegW5o+6UH925CWTB5p2FVRpci6H9TV4Bp9AeEbd9DjLUZvHoYNgOhKQN+8ZzKRuY9Cg5zMEVROk9/kY+sQ6hEz1ZDS4KMqU5O/eP4fPDrwpoeDL94a7rkDTbGQMkCgYEA1w2dhXw7KnKyOpeJ3xmsxJn5vkSpNVM+Ecjm81Sm1IVZUfkefoMcFU+AhviOzEF2Qn/W/AvraX6xWFEuKMtCYxav2nbCYOnq90PkPh8C14s7noWutes48o7fY85Zd2G4HivvNUJTd2nU8fNKMrhBqDayE9ibVZ4G3KSZ02AoI3o=
78b7170a-91ad-4066-abf4-88d70fcca03d	139aed27-7f75-4e32-8696-3d97cef1bf3d	certificate	MIICmzCCAYMCBgGPly9hujANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjQwNTIwMTgwNTE1WhcNMzQwNTIwMTgwNjU1WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdJ4gntj6DeAx/it+2Z6E7zHLTVIBtwSTg+KTO4BLusMi0hAcsFMjoLa194uLlWIiKeswCVtp1wmJ5mXAHceJTQ3RoinUrgDpcffMYkKMSIgXk/02EAE+wdJLA7YJa3zPSMqzXAWpi4n2qGevi3k74U+uPSUgpXtKSfNQ+PED0m0T7Ha7FaGap60R7Nl1dBbbY2PICtb/BJYCAjS1phZlIW8qtjk7cOuFMp0/5+NiBeSNNPZjllQ2IP0JXFhJ5eFkQC7OGWhAao/oIzvjYrFu72lf17mclzBp60aM90oZB1YMX3AC71BVgeBk8t5EEuXymipsdgM/PIltEuXcCl/UbAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAA3Idu1W+mYdAWxMVgnLNtIwsCXWcHiBp7lvhErvyqUqveDz1JN3yZyeOjQZyrEGbiSqO28eQtsEGSNyJWvTTu8RXDm8qoXyDcW1niwlsgNcC+AeK+qlOqLskJXLKy7FuBOcCw9swPH6FPIXiaq202qyB8n0BdFYt7ceB0c3E+iji/o6PYoBWv7v+nN9aFjFLngTl/VKB9d9BkP1XRePlS5ZAU5oFoxjknaLJZWZ4G1/FCPd3RC/3kdAFiEX+Xd4FOrynLacnBZY2g5QMscylTBWuXZAm1W9ZHBaTrOT3dfUCfmWsIx/ZiAfKso9S9HF6iSGI6/TpXYpf5vejXKlNrs=
759139b7-3d02-4315-8124-bfa1103007b8	139aed27-7f75-4e32-8696-3d97cef1bf3d	keyUse	SIG
a3083f75-e1eb-4c88-945d-64d21d71b1b7	aaa6fc31-3885-4ea2-90f2-c2058f71c4e5	algorithm	RSA-OAEP
ef8a59cc-d894-421c-a2d2-68c09fdebbc8	aaa6fc31-3885-4ea2-90f2-c2058f71c4e5	privateKey	MIIEogIBAAKCAQEAqGh/sct5wwpX5VowIOzfgN97If2yJ1ZifAr/vQvZerBVuUp6ELhnLHB5p6clAYehaRIiLG61pi0wpbWuGal8bRBSNMmFbe//EM49ZGu655u/A99xuUoIZ/Sq8qd1VqywfNa61nKzxlykK8BmUwP13+Pxu286XL0V1ARJ6cOHRCZcrw5QG7AvQbv93fw2yT7kzZ1Tx1BpLWKalq+5s8kVBoeqClOMZr8OYfK1wJnSvK5h4CzzXilXbTmTqrJDAn07C8IRK6akVN8fz/TCCrJLV/Kx3jbG7Ms6a5MyZRQUqCrTFfvHgATrIMaFbODX7fLoXuDrZNM6z+fFezn3SlLdHwIDAQABAoIBAFP2abfYlTf3N7RbH0TDJHmpskfTpxdyu75Rc4iq2D6RnOO5LJuafKIM37KFJG+bUg/DITOa7MjRnf/4UTltJWJw8TNtR690qOwVj0k6ZuCjZ3xEUnxJW2CM/Q/nCprwlTtgiZ1yaYwb0yQXFE0OW+9Iw9Qp0+S5xyDCFKHOQOnqECxgD8HvNeIEioJQWEDCuS8yKaybaF0kvCIz+KNFEXgLgO3+c85vMjSVkNm6MBEsZ0BA0Iv/0QkpmLSL15jUoWAhWiPBb9rptGQZF3IyBycyCfX+bWu0z9eTPtr6A8H/ninoZWEkyKfJ6fj8o90OAAUb5DOgNxqndxyELlliorUCgYEA5zoycyQrPYMp663NTjcwH4Y5pOYc72+qUMLViM1rtbJ7xtDIO9h8IsyS96WJE9bQ4AxQM0+FJeFoQ34bAe9PXaepCDOqA4hAqNapgSaDaeEfphLtXFHAK5ULfmbJYaO/kKThLTXx++eR64BNeVtswTR8P4AdBNAlh2LTv2wUWlMCgYEAunNhUC6wTskT5fgsSYWqxFbdSviudqNZ1EYbcOGefmuIGQHV22fp50ercIfQGxd80FjnzYfbAoSBtUoqw4oiTYh+Kk0eqXA625syjcLChJyNOHncKPfUXsspOR4XL+uhZqqDa0en12Wn7qWpV+xG/OBIttmuUcZPI3v/YwWiUIUCgYAOu9abH6LhuInjSp/abAnU+GiT6VXOq/7eRov0u6IxYb4hXQxlQ9YlIYP748BoUzfcDuzNWDPTxhkus8pkxSr5fMV4kFI1B2mXWJZUdG/LP10U5//X8h2cqVKiK0qJvjVmshrnFpjkxEy4BOTq5rh3VzDTmwY+WEUL63AysmBZoQKBgBKpufPsuHkqZ3N9g/FYD9/XUg9PFSeK8lLtMZH7A4JkARt/s4hivmcIJYD+FzafAz9XptxL3QBDgzhCVEV+bjCUmQxi687KDRouTsEh3ZaolPoyOHdhV0Cl1VqCSI/jZiSArObwJTzKUCTzMCA85l4plR24bFqDHyjOIKIozjaBAoGAN/Mtgq874ePIM89Y3naEpxNcejVTo7jbUCc2f+rNaNTk9jwRuLkV2ZsSzaPDWn/P3x92ALHTRHiVxpOs5gnmVdQbh/xIHiB5QPrCjU0+1wVfbvBlgB5yV9BFoYnVIMhpW/mD1CLje6PYGZ2FMmethAW5FnH6uCag7XhPuyf6t3Y=
77295838-de58-453c-b48a-ae17f8873366	aaa6fc31-3885-4ea2-90f2-c2058f71c4e5	certificate	MIICmzCCAYMCBgGPly9ijDANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjQwNTIwMTgwNTE2WhcNMzQwNTIwMTgwNjU2WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCoaH+xy3nDClflWjAg7N+A33sh/bInVmJ8Cv+9C9l6sFW5SnoQuGcscHmnpyUBh6FpEiIsbrWmLTClta4ZqXxtEFI0yYVt7/8Qzj1ka7rnm78D33G5Sghn9Kryp3VWrLB81rrWcrPGXKQrwGZTA/Xf4/G7bzpcvRXUBEnpw4dEJlyvDlAbsC9Bu/3d/DbJPuTNnVPHUGktYpqWr7mzyRUGh6oKU4xmvw5h8rXAmdK8rmHgLPNeKVdtOZOqskMCfTsLwhErpqRU3x/P9MIKsktX8rHeNsbsyzprkzJlFBSoKtMV+8eABOsgxoVs4Nft8uhe4Otk0zrP58V7OfdKUt0fAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAHyAkl1Z8y3p906+HQFmnc0d4HvougRVUErSQnGyigEqbWineWqvd34iL3WV9hyr0AM+wKF+ZMej8KOf5FeBcLVKZKKBoUBsNvWWoF/cBHRrpNwKCYEooOB3NsMgwZE9VzfNwuEKEi5A1xMbaTjw4Tg3eDoR0+wB8tkozZAcM108jWWO/rAxsl0DDi4Z/HNKG80bnehVBrgrQrHCacRBNkbrgwQJiU7t3lvz84N23q/QIieFR4B1HKGv6x/U9/Grm5DEMMfR1noL55GzvhwWcztEj2xYCEFFeRMjAxrA/LLE0YGkDFuy3zODrcL61wAUm4NLTFdqd5dBLN5fXy6P3L8=
e6e054df-7501-45a6-9982-8b83e566e5ad	aaa6fc31-3885-4ea2-90f2-c2058f71c4e5	priority	100
710b9e9e-e146-42bc-864e-a20b7b2ca2f2	aaa6fc31-3885-4ea2-90f2-c2058f71c4e5	keyUse	ENC
9334df06-9a26-4b3e-bff1-ba58f00c65f3	73bac857-3755-404b-83bc-0141cdc2d465	certificate	MIICnTCCAYUCBgGPly9l3jANBgkqhkiG9w0BAQsFADASMRAwDgYDVQQDDAdvZmZpY2VzMB4XDTI0MDUyMDE4MDUxNloXDTM0MDUyMDE4MDY1NlowEjEQMA4GA1UEAwwHb2ZmaWNlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALwGrgSeCc7lzpNGk+lbRBVY3j+bqKGMsG5L93MavsLWH3DRPa8ckBKOHxb0L5qbEzEGRdXTVIHcSSuoYB2ifiiGCwXvQxmZv9GdVT1Ik/zp1yaOoXcbm3C93RSqRK2WIhZ+Fk4zHS33Ior1osNCteiavdBHqD243jtp+syUAo/SzZ9jjo1zkar91++hj6Nhl1jgIc50mCGjn7bFVNdbJEXFtfnkWDJ4X725Tkw+IV2KkIjkrItELfusDiN1vTzm1Qg+q13cQ6GHNwYirwjFyXKSENyigYIbmfBySlCr6VPN2ofSeczn0BdgyxbBnmIbdr5DhJqEjnL6SSgmsX/xdEcCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEATilrE97HxUdTFaWbTAdOrmWRFByjRCwB+c2vkeD1E4KZldI8ici7oPrnKCWaQWCSQPifc+jSoesk5xttijYFeOLVR5ljmGfd20AD007CesXSEMjUHB/CVav1DhXmzEaG1U+iImQ8h927gbizR7zljwVKKNdcU4TjwhMGklkMBIWEDV3wFfGtYcMKX1mqM/Z5jCcjTtkOJTylAzpyQjJf/TPd7S6+hrAk4lWIQ31ibuQB4QicCg3IQaG39+zsau5zdod95/pOA4RAEVMJI1roBkS5i2neuK+ITNta/+zU5MI+wUtnw6Y85biBWgEIgxEj06JlROxGr3+omuGOsG6JpQ==
314329b5-b0cd-4d2f-b649-3c6cf13684db	73bac857-3755-404b-83bc-0141cdc2d465	privateKey	MIIEpAIBAAKCAQEAvAauBJ4JzuXOk0aT6VtEFVjeP5uooYywbkv3cxq+wtYfcNE9rxyQEo4fFvQvmpsTMQZF1dNUgdxJK6hgHaJ+KIYLBe9DGZm/0Z1VPUiT/OnXJo6hdxubcL3dFKpErZYiFn4WTjMdLfciivWiw0K16Jq90EeoPbjeO2n6zJQCj9LNn2OOjXORqv3X76GPo2GXWOAhznSYIaOftsVU11skRcW1+eRYMnhfvblOTD4hXYqQiOSsi0Qt+6wOI3W9PObVCD6rXdxDoYc3BiKvCMXJcpIQ3KKBghuZ8HJKUKvpU83ah9J5zOfQF2DLFsGeYht2vkOEmoSOcvpJKCaxf/F0RwIDAQABAoIBAFTbqObhkmijc5cpN7EOJQyDVo6biEAcuDWXKF7095oEPB1U+cNRnz4YkTRxURi0GzW5cIQfw9h13DoNXA+T2d8dG9V6Vay0pIsMOD+XxV5UBOtcXMfeGEmKDsB4VdWH1+uRzSxOykEH87mGQYZhUargR4E8DdSJXhavbmas9/kDMlXF7Wy3RFmFYK6yS41m+9wEUbmgqbWnaqAKux4vAfEIndLZcI3Oj4nYTvfp66o5RRz3tZEx3huolGniKmR8r3aihIkIgw/qGag8IMy1nKeXegFCm7g59QFUn3wOJrCIiWVOx3SI4wwQrcRjSCa63qRPbVhghm20f6xLIjCoGl0CgYEA7s5c4XMyc38T5DJTkmdea0pLjMrNhNkFJZLzExCpou3uHlGTVqLDAa7E/N1HZ4oAe65xW8AUf3laQBGzP2DRw5je2mz1lWSxlZM9AErrwLA9+SfsY7c2KMKwyLBR9p7W2Dsz2oi69G1LA7ep0KwJHLztwq4w+MT0WFjhwh3F9tsCgYEAyZBY/XGHFymitYvz5iu9gP/VrQvEk/0NscI/cy01iidfVEoxYFwk2jft9mMeu+b/NJXttXjd8GfJCwdJRdVFHAAUyW++OI62J8H7W/tSZ1U/9a86MgEC9FVPJXxQa76McBIQw9cwoYuCLsHwiNHgXUrqtDgjhh2dna2QK7mnhgUCgYAXxMxz2B5uZniZXvT4fndkYGmyosDf9yXO/phZDnCD+gCYXfA3UE3ujfGnZXLk+FRh+xPnWO/xXCfCdsCLj1xxhnav8OZkrzgJtjT9IXfjnuccNIAP0L2AQxiLcRlHXbnunb3kg3VwPKyZux8Y2PazOI7FsMbJC/lyDa6yvnnkvwKBgQCigdSdkbhevlzGji14N2+z35AA0moM/orZ9Eh/rcVqu0+qf57Ll77GiS075rJSwGylkvNxyh71wldeouM6gDYV2yLnPUZaBwVpjIYBpODNGvhUNpBu3E3rfBQxnsaf96L2gDowCwDUXcv5srchOETyMoKEBnbtnFcFV3fTKP2dmQKBgQCf5tFgaSf1eLgeMP4jnqWaZnT0fo3Ur9lfTe85b0mchvvBeKbnEpqi/PqERj+VcvW9VNLCG9F3ssS2V61eCX0RDxORJpS4AMAFfCwbPwHNGMbLGyqAw2stpu0iO0f117VyTp/dETV0iO79LOs95lwc2AlRfo2/N6zg0LRUACItSQ==
e35590ab-5a1e-4517-9dc2-8ba731478e86	73bac857-3755-404b-83bc-0141cdc2d465	priority	100
ba5ff96b-e899-4178-9a96-a78d9510962a	d3c89bb0-a2fd-473e-8e68-f98d354f9bde	host-sending-registration-request-must-match	true
29a2bb76-6bc0-4d46-8226-7774263929ab	d3c89bb0-a2fd-473e-8e68-f98d354f9bde	client-uris-must-match	true
09e59f9f-f73a-4bc2-8d91-57cc8d0c379e	7fd452e6-9b18-4e04-9c8c-0fa572aa2436	certificate	MIICnTCCAYUCBgGPly9mNTANBgkqhkiG9w0BAQsFADASMRAwDgYDVQQDDAdvZmZpY2VzMB4XDTI0MDUyMDE4MDUxN1oXDTM0MDUyMDE4MDY1N1owEjEQMA4GA1UEAwwHb2ZmaWNlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALObFlwpn8iARiOOnf5NHaWNO0P8l6Ll+O4vT5QpGAynlx7tkGPyXk1ItIhsxCOWvc/1ODUKmqFdgi1wum9xGOcIRDWY2N3Ydjfi6WlOlQETZkRrhtWndg9szMZjp/nm7mjpINsgBzlPbPyU0T4bYxP/Pehis86YIa19OTfUjYROQIepAspnZP9IUSZk6YibUNbXyeO6j6VnyTk/N1ubblreVu64pRGEJbk55wBkmx/9x9B+vd/OzKTaaySTAyNQggINEdctUC1fK1uEP8tgHSSkIybPyeoMmK7c6ba0RYZtnMJJkNXIUzU72E6/vtDTJo+HX4ThKVgdCuvN3TU65MECAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAgEh9+lJbbfoVMzkknV2F0FjaMeDdgFX7uuGyZ5xJUpYSoXRphMkV48PBjNuxJoYc2B7u0TLsnAYWD8WwoJeeoqKnM4257UXCUXUw+f92nvBiYWj6p6EE4yBHe72C8zqm1aYmruGubLNwPZAItfJyaVyZz+SJusvYejW9g1XzGo+tJD+eb+scb649p0gQ7kkp5FqFAnMwxh6nZgnx+yi4TVDC+LXytWd00erhDMDxVOjjdlTEW5okl8gxfm82RtwRGuvLUVapeuyJBlYeTQwlu98cvaDD4YNZOPk2ZJ79+sExyu8x7HlejGtdDPLevZk5mlyJw/X+mx/kjIu1QBtQAw==
3784500c-8072-41c3-98e7-e722685d0927	7fd452e6-9b18-4e04-9c8c-0fa572aa2436	priority	100
2c2e72aa-28e0-4406-9aa8-7c421eca1ad1	7fd452e6-9b18-4e04-9c8c-0fa572aa2436	algorithm	RSA-OAEP
da017952-4970-4454-aea1-dd0a23bb28ce	7fd452e6-9b18-4e04-9c8c-0fa572aa2436	privateKey	MIIEpAIBAAKCAQEAs5sWXCmfyIBGI46d/k0dpY07Q/yXouX47i9PlCkYDKeXHu2QY/JeTUi0iGzEI5a9z/U4NQqaoV2CLXC6b3EY5whENZjY3dh2N+LpaU6VARNmRGuG1ad2D2zMxmOn+ebuaOkg2yAHOU9s/JTRPhtjE/896GKzzpghrX05N9SNhE5Ah6kCymdk/0hRJmTpiJtQ1tfJ47qPpWfJOT83W5tuWt5W7rilEYQluTnnAGSbH/3H0H69387MpNprJJMDI1CCAg0R1y1QLV8rW4Q/y2AdJKQjJs/J6gyYrtzptrRFhm2cwkmQ1chTNTvYTr++0NMmj4dfhOEpWB0K683dNTrkwQIDAQABAoIBACo0P0TY4xsSSWkBkk63gEfusAaBzIAS2jPeGi0OmwAeQXybBlr2EQLIGuQT6uMSAPhk/xg3ra5NctGKs8SMJvXjE2QkzpES1HS9dWuxc4IVNOrO+ZgrCasGPfhAYrBue4dbgMT8+bWV3F5d+e1GMjn4uGtrBiV9yiwiSNe9sqNr+x8xMnKqGFDxlDh3OOQyi1wjoQX3CZgDI7/BpN4/tIJ0NlTSCP3w8MosZUDpTvViYUwy9eR5jE4GAYYe3VSD59Z55ysN/fgRRxxRH3GP+U/NWElWjbxbiT+AAyyi6+AqSjEDl2TETuiYUuJTZs0Dqr7b816Q5EngABOBldq7x4ECgYEA2/l2spUeoHicxLCCp3emQWqu9tOM97Cb5J0gi0PJZw0o7I9uZpIE1/vug5n1p55s4xDsFNmPzzLey50dsFnrslyBlR/Kx8uB6IegashaAgzUsisORAYGdS9xAlTKM38ZWIiPVPjNcOOqdVwnQnsGuPn/UhAOQi1LvQ8SVP9KOcUCgYEA0QUl6xLl6KXj+3h8gB1EmAWkrrsyyZOBF37n8A0a/hdwHcEpkNFAjg2qWbyiBTcSLcglcXH5js6i7agqqQoBQ7RpFSuHnn2JwkTs0Avxk/tfmQjO1kyp4q6+cb6jUBUOrNTTwrTBo3edbjUeHnB85+Ph6ixGa9ehIWLjid4kOs0CgYEAwhexdg1BgtIpcRtVjTJzjdD2JG+xOHOqeeNyba8YLEdeTqyX+wToJTLz10anjIirBwdNZ3A4Bdia4Qn2wj31S+F3rP7qS7PzIhtZnh693IU5vyNiaP7v/8Imcqoh56JD2OxVm+IUU4FuTDNNqMkou1pKwDvOePHCnESKJllDQwkCgYEAkJ7wQnsb6mHFoXwXIImfqVPWQzOxCzntCvW6wyQ+Neq/n0bEXLf7443e/SIANH2LLXQbPCgxFLcykh9WDQmoIFFWl9g7iNSxmWIZPEXXS52U4ozul+YJcZeYm5jc5I79TWYgcsqgZFth6RwFj+gi9Et/R4iE3R8gFLqYVw8FoE0CgYAzf8vpOwyewJ/Q7BcBhcHEk9aT1SHcbFbtjQr1e7w+InRnw4aIHLxZmsUGB383g+0QACUiXJRihqNzuK+dVamBmxCnA/CdezqTsLnW89teWmsRqCCwVq80gMlyvVMOyt0CnMUxOmPmb0kRdmJud7Upd6kWQGLP0nmu1ZXK3oE0zQ==
f62a4071-9d59-4261-a976-42d443bfdbb2	1f6b223c-9400-46e6-8351-71707c2cfe5e	allowed-protocol-mapper-types	saml-user-property-mapper
d4a239e7-54ca-4911-aba2-8dabe055f4ef	1f6b223c-9400-46e6-8351-71707c2cfe5e	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
fedbdc95-67dd-4852-999d-143713f09746	1f6b223c-9400-46e6-8351-71707c2cfe5e	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
dcbebc88-3ba1-4657-b5c2-cf18f1f80d98	1f6b223c-9400-46e6-8351-71707c2cfe5e	allowed-protocol-mapper-types	oidc-address-mapper
293fc2a1-2cad-4f38-8b4a-868790ded33d	1f6b223c-9400-46e6-8351-71707c2cfe5e	allowed-protocol-mapper-types	oidc-full-name-mapper
fab09ca0-abaf-4fa9-9b72-31122ca4339b	1f6b223c-9400-46e6-8351-71707c2cfe5e	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
3c95a7cb-bb33-49ff-868e-cb439c265e5e	1f6b223c-9400-46e6-8351-71707c2cfe5e	allowed-protocol-mapper-types	saml-role-list-mapper
20112558-7c80-43d1-8e40-f50fe66b2570	1f6b223c-9400-46e6-8351-71707c2cfe5e	allowed-protocol-mapper-types	saml-user-attribute-mapper
76096795-81c4-40c4-88a9-d52b91c4f793	6b7b2ec9-6d49-4fb8-98cc-f0cc49b8accf	allow-default-scopes	true
5980ffbe-0965-434b-b37b-38797812db71	f3c69618-b6db-4a1b-a8e7-9d7a82800512	max-clients	200
7024ed77-5c72-4371-90a1-0b97c5352ef7	f7dc561f-3101-45e3-b272-1316d9fa6fdf	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
5d0d5958-48d3-432b-b2bc-38a019bfac26	f7dc561f-3101-45e3-b272-1316d9fa6fdf	allowed-protocol-mapper-types	saml-role-list-mapper
e97b8e04-b6a5-41e9-8434-4f274151a89f	f7dc561f-3101-45e3-b272-1316d9fa6fdf	allowed-protocol-mapper-types	saml-user-attribute-mapper
ec918bcd-4aa0-45f7-8d7d-8c202013b176	f7dc561f-3101-45e3-b272-1316d9fa6fdf	allowed-protocol-mapper-types	oidc-full-name-mapper
a51781f0-ecc2-4d68-a0be-f9a9f1c84af7	f7dc561f-3101-45e3-b272-1316d9fa6fdf	allowed-protocol-mapper-types	saml-user-property-mapper
09a22371-4e64-457c-a743-9ced981024b5	f7dc561f-3101-45e3-b272-1316d9fa6fdf	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
3e1caa50-fa2d-43cc-bba8-626e07058ee9	f7dc561f-3101-45e3-b272-1316d9fa6fdf	allowed-protocol-mapper-types	oidc-address-mapper
739b0425-b9ba-48fb-872c-b1739c72cb17	f7dc561f-3101-45e3-b272-1316d9fa6fdf	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
c4c94cad-5b50-40f8-a077-7d2b21d6c525	632339c1-4b27-4b61-87c1-b26196d1087c	allow-default-scopes	true
ae4c4285-6031-4302-9a6e-094ef8d80968	b5b254bb-d22d-451d-bde7-65a580291f50	kid	9600b751-b013-4b3d-96a3-1d207a1dfda2
612114ef-3cf3-41d2-8a45-f0bbbbf0da87	b5b254bb-d22d-451d-bde7-65a580291f50	secret	PJXESgAvoUIXQY5Ocjx2mA
4865e743-c90a-48fb-bc2f-18a79d9ce5c7	b5b254bb-d22d-451d-bde7-65a580291f50	priority	100
2c231fa7-9be1-4707-af33-d25cb1aeda7c	4156d10b-20f9-4207-81de-e87528aa637b	secret	jevhQdrzGl5yE8GMrtZSANCgu-rfsQTsEFXhvo29UpF7aa0PzatMiQ-ykV_xC4kWj2kKReedEHDtPZhP1M5pqQ
9dbbbd43-d16c-4e4a-9a6f-921a62082a43	4156d10b-20f9-4207-81de-e87528aa637b	priority	100
39151d7a-4fc5-4f85-bcc9-0b44791fb53b	4156d10b-20f9-4207-81de-e87528aa637b	algorithm	HS256
522d34cd-f119-480a-a942-0914256bdfa3	4156d10b-20f9-4207-81de-e87528aa637b	kid	0be5cd45-6885-40a3-9165-d666de9b8649
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.composite_role (composite, child_role) FROM stdin;
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	bf245e41-9814-4686-beca-ab0a63eb43c8
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	d9fd4479-6641-449e-97a3-5c8c42a414e2
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	76c6b6d6-001d-4b27-aaa2-0680ff08b38b
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	132b8e8a-576f-431c-abaa-480f515f399e
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	60fec3d0-518c-4e51-b0fa-dd3a160a158e
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	889c672e-8f44-46e1-9c99-cb260879272c
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	577a1e56-0260-4aca-bcad-7215865da4b4
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	430f90cb-c450-46ff-b37f-190e482c19c4
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	625810f4-4124-4135-87a5-edabcaeadea8
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	4f16ba6c-1f45-4101-980e-ce427ecd0e50
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	e1c897a7-1a24-47ad-8257-3fc3f88e0204
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	0164bfbf-94b4-482f-ab4a-501a6132e592
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	c93a26fd-c51b-49e3-95f8-3e90ca059816
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	85e16d9a-57df-4cf1-b9de-22688a6b7b94
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	07a28fb6-df7f-4eb1-940d-c5335da5f918
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	40144513-d08b-420a-9c82-7052de88ff79
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	565c1deb-a128-4562-ad8a-f0a31b99815a
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	f81aa07d-98b3-4b83-a767-997e52031a86
132b8e8a-576f-431c-abaa-480f515f399e	07a28fb6-df7f-4eb1-940d-c5335da5f918
132b8e8a-576f-431c-abaa-480f515f399e	f81aa07d-98b3-4b83-a767-997e52031a86
60fec3d0-518c-4e51-b0fa-dd3a160a158e	40144513-d08b-420a-9c82-7052de88ff79
ebfdfecb-dbee-412b-8fe5-d40584b91632	635e98b7-3d02-48a5-85a8-beefe16e146c
ebfdfecb-dbee-412b-8fe5-d40584b91632	44296b4e-180b-4c84-a77e-a4b40ceb8722
44296b4e-180b-4c84-a77e-a4b40ceb8722	7645b6e4-cb5e-47e5-b70e-0d68991c3a60
6bd0903e-f066-4987-b8c1-c73ec9132d69	9220f7d1-a64d-493b-9385-a175a47152ad
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	011e6874-7523-45f8-a67f-0bf4385b963c
ebfdfecb-dbee-412b-8fe5-d40584b91632	6d5c982e-60c8-4a7c-8cbf-0c1c8bc23a84
ebfdfecb-dbee-412b-8fe5-d40584b91632	ed502f84-577b-4c2c-85ec-a66dfd0d0ed9
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	8b79a9cb-9f90-483b-b90f-aa6f388803ec
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	6173522b-f397-4cd8-b3f2-8d94df8efc4b
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	ae4aff55-fca5-4972-a7a9-0ac7e75e7bb7
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	1505045d-5d89-4dcc-b134-03316c5bc2e9
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	70c1c8ed-8d7d-4827-b4a0-37fc8a6f31d7
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	47844524-f903-45cc-ba9b-36d1e77f281f
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	0176c677-f9da-4834-a9fa-3dd4f2a05d71
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	08b79176-10db-4167-9853-caa819dfc751
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	b753a528-b7c0-4ccc-ace2-9320a74302fa
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	d01ac481-532e-4ffb-80cf-369e1222acf4
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	706f3d0b-d1b7-4177-a831-2bc60dd3f1e4
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	5ede22bd-4b07-4d7d-a9ec-500463408741
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	2d337072-95e4-4021-94f3-284867e77df1
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	ba799e64-216c-404b-b624-7225b6d3d2a2
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	3c9f314c-3bc1-499a-ad2e-f23972af1b7d
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	20732c36-1814-409c-876a-68fdb62f1e41
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	b8267090-8314-4ae6-92c7-9fd6b4b716e4
1505045d-5d89-4dcc-b134-03316c5bc2e9	3c9f314c-3bc1-499a-ad2e-f23972af1b7d
ae4aff55-fca5-4972-a7a9-0ac7e75e7bb7	b8267090-8314-4ae6-92c7-9fd6b4b716e4
ae4aff55-fca5-4972-a7a9-0ac7e75e7bb7	ba799e64-216c-404b-b624-7225b6d3d2a2
00870bc8-bee9-4bd2-9c2d-10c4146df2bd	97513d29-f1d7-4820-9fd0-dd7771d7f59b
0a06f480-a9b9-4180-a74b-c4947189909f	80c8ef9a-f4a2-4847-a04a-08869e7defa6
9039b1a0-c01c-43eb-8137-dd05612a071b	b6c86baa-5355-418a-87da-12fe0a5db8b1
9039b1a0-c01c-43eb-8137-dd05612a071b	ff479e28-a640-409b-ba4e-a7a43eb96565
9039b1a0-c01c-43eb-8137-dd05612a071b	0a06f480-a9b9-4180-a74b-c4947189909f
9039b1a0-c01c-43eb-8137-dd05612a071b	c437bd4a-5045-4cfc-80be-18bf480a91d0
a9bf5028-203b-4903-bb01-576a6b6c01b6	b47faa1a-dcd8-4daf-99be-2485dfdbea4b
c0e3b0df-cb88-476f-9049-99c3a83db555	cc85df01-be92-4c3a-a0ba-36d0c173fe5e
c0e3b0df-cb88-476f-9049-99c3a83db555	3c003097-4764-45fd-85b8-8deec86528da
c0e3b0df-cb88-476f-9049-99c3a83db555	d63df527-487e-40bc-ad4d-310e1a589577
c0e3b0df-cb88-476f-9049-99c3a83db555	00870bc8-bee9-4bd2-9c2d-10c4146df2bd
c0e3b0df-cb88-476f-9049-99c3a83db555	92c60368-eed1-4dc4-8287-42f751c398c6
c0e3b0df-cb88-476f-9049-99c3a83db555	31bd48fb-a922-4782-82ea-612b7462905b
c0e3b0df-cb88-476f-9049-99c3a83db555	85076455-56ff-4ff5-bf31-89a111873697
c0e3b0df-cb88-476f-9049-99c3a83db555	d47f0ea7-1c80-4912-88ff-18f529f4fa5e
c0e3b0df-cb88-476f-9049-99c3a83db555	76a9be04-8124-41af-9dd6-17951d6a5bc8
c0e3b0df-cb88-476f-9049-99c3a83db555	61fd79d2-59a6-4a2e-8265-5f1294d79341
c0e3b0df-cb88-476f-9049-99c3a83db555	7ddcaa9f-bea0-42c0-a4c7-6ed9e3abf722
c0e3b0df-cb88-476f-9049-99c3a83db555	00145345-ad58-4ea1-a65c-1325ba823281
c0e3b0df-cb88-476f-9049-99c3a83db555	3a6a03ec-32de-41ff-9dbf-0d69887e26e0
c0e3b0df-cb88-476f-9049-99c3a83db555	eaaf701d-52c6-43ac-becf-02da63a6ee23
c0e3b0df-cb88-476f-9049-99c3a83db555	97513d29-f1d7-4820-9fd0-dd7771d7f59b
c0e3b0df-cb88-476f-9049-99c3a83db555	504a3b79-75e2-455e-95fe-6a48d29d5acd
c0e3b0df-cb88-476f-9049-99c3a83db555	1d73992b-2f5c-4eb1-b740-b263212bab00
c0e3b0df-cb88-476f-9049-99c3a83db555	7f9a53d6-00b2-4eda-a533-4022e63c9d3b
eaaf701d-52c6-43ac-becf-02da63a6ee23	d47f0ea7-1c80-4912-88ff-18f529f4fa5e
eaaf701d-52c6-43ac-becf-02da63a6ee23	3c003097-4764-45fd-85b8-8deec86528da
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	dc8abe84-20c8-479c-8d28-2054f4484e15
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
192e2e23-253b-4c63-8a8b-df2e4e0ad16e	\N	password	91da198a-364c-4f0c-b87c-4deaa31d184d	1716228417335	\N	{"value":"c2uTA+KmjflayCgp8yy8u1ub0usfiQN4a06N06u9NHA=","salt":"LjNICNMMX5xcg1vguo90fQ==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
4acce149-3292-4388-b70a-355e7bbd3da8	\N	password	705050f8-38b5-4348-99cf-cb2b76d0e887	1716228754065	\N	{"value":"2HWtMivPV1uHdsejnlVinqqomx2MT/r5MqrqP2QqGY0=","salt":"LIEx0D4vyrY9AtycoJINTA==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
7142c401-95d5-487b-9e5c-11f2a8462827	\N	password	4ad9a9e3-429f-4663-af24-b1a8e2d0fde2	1716228754066	\N	{"value":"uBZ+Mt1lxSdJ0OesYhjmEiRHAIU/IUdVnYBi/jibLGs=","salt":"4pxdy+E0aWtLSkuisrmzWQ==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
ac3c2489-a0bf-4907-a5d4-06d7b2b3b1bb	\N	password	c4330233-c295-4022-a5d8-68b30063b191	1718633997890	\N	{"value":"e344GKBaGReO16r/HXxjyf/gD5NqUnDtEDhsohXQhgk=","salt":"TtJ3mGkZ8uPyKNhrVlYJpQ==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2024-05-20 18:06:54.508367	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.23.2	\N	\N	6228414141
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2024-05-20 18:06:54.534267	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.23.2	\N	\N	6228414141
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2024-05-20 18:06:54.55099	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.23.2	\N	\N	6228414141
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2024-05-20 18:06:54.552391	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.23.2	\N	\N	6228414141
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2024-05-20 18:06:54.590308	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.23.2	\N	\N	6228414141
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2024-05-20 18:06:54.598939	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.23.2	\N	\N	6228414141
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2024-05-20 18:06:54.634562	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.23.2	\N	\N	6228414141
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2024-05-20 18:06:54.645145	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.23.2	\N	\N	6228414141
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2024-05-20 18:06:54.648342	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.23.2	\N	\N	6228414141
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2024-05-20 18:06:54.682894	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.23.2	\N	\N	6228414141
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2024-05-20 18:06:54.703026	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.23.2	\N	\N	6228414141
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2024-05-20 18:06:54.707785	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.23.2	\N	\N	6228414141
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2024-05-20 18:06:54.715083	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.23.2	\N	\N	6228414141
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-05-20 18:06:54.722895	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.23.2	\N	\N	6228414141
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-05-20 18:06:54.723556	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.23.2	\N	\N	6228414141
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-05-20 18:06:54.725055	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.23.2	\N	\N	6228414141
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-05-20 18:06:54.726238	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.23.2	\N	\N	6228414141
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2024-05-20 18:06:54.744171	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.23.2	\N	\N	6228414141
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2024-05-20 18:06:54.761405	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.23.2	\N	\N	6228414141
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2024-05-20 18:06:54.763199	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.23.2	\N	\N	6228414141
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2024-05-20 18:06:54.768319	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.23.2	\N	\N	6228414141
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2024-05-20 18:06:54.769964	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.23.2	\N	\N	6228414141
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2024-05-20 18:06:54.777572	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.23.2	\N	\N	6228414141
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2024-05-20 18:06:54.779086	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.23.2	\N	\N	6228414141
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2024-05-20 18:06:54.779571	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.23.2	\N	\N	6228414141
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2024-05-20 18:06:54.792519	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.23.2	\N	\N	6228414141
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2024-05-20 18:06:54.823101	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.23.2	\N	\N	6228414141
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2024-05-20 18:06:54.824772	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.23.2	\N	\N	6228414141
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2024-05-20 18:06:54.850336	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.23.2	\N	\N	6228414141
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2024-05-20 18:06:54.855321	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.23.2	\N	\N	6228414141
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2024-05-20 18:06:54.861242	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.23.2	\N	\N	6228414141
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2024-05-20 18:06:54.862826	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.23.2	\N	\N	6228414141
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-05-20 18:06:54.864421	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.23.2	\N	\N	6228414141
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-05-20 18:06:54.865842	34	MARK_RAN	9:3a32bace77c84d7678d035a7f5a8084e	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.23.2	\N	\N	6228414141
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-05-20 18:06:54.876961	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.23.2	\N	\N	6228414141
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2024-05-20 18:06:54.878511	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.23.2	\N	\N	6228414141
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-05-20 18:06:54.880347	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.23.2	\N	\N	6228414141
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2024-05-20 18:06:54.881264	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.23.2	\N	\N	6228414141
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2024-05-20 18:06:54.882128	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.23.2	\N	\N	6228414141
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-05-20 18:06:54.882589	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.23.2	\N	\N	6228414141
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-05-20 18:06:54.883328	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.23.2	\N	\N	6228414141
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2024-05-20 18:06:54.884717	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.23.2	\N	\N	6228414141
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-05-20 18:06:54.93405	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.23.2	\N	\N	6228414141
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2024-05-20 18:06:54.935812	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.23.2	\N	\N	6228414141
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-05-20 18:06:54.937289	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.23.2	\N	\N	6228414141
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-05-20 18:06:54.93874	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.23.2	\N	\N	6228414141
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-05-20 18:06:54.939234	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.23.2	\N	\N	6228414141
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-05-20 18:06:54.953557	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.23.2	\N	\N	6228414141
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-05-20 18:06:54.95491	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.23.2	\N	\N	6228414141
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2024-05-20 18:06:54.971106	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.23.2	\N	\N	6228414141
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2024-05-20 18:06:54.982799	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.23.2	\N	\N	6228414141
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2024-05-20 18:06:54.984013	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	6228414141
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2024-05-20 18:06:54.984883	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.23.2	\N	\N	6228414141
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2024-05-20 18:06:54.985663	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.23.2	\N	\N	6228414141
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-05-20 18:06:54.987777	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.23.2	\N	\N	6228414141
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-05-20 18:06:54.989123	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.23.2	\N	\N	6228414141
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-05-20 18:06:54.996425	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.23.2	\N	\N	6228414141
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-05-20 18:06:55.030876	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.23.2	\N	\N	6228414141
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2024-05-20 18:06:55.040635	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.23.2	\N	\N	6228414141
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2024-05-20 18:06:55.042571	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.23.2	\N	\N	6228414141
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2024-05-20 18:06:55.045589	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.23.2	\N	\N	6228414141
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2024-05-20 18:06:55.047639	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.23.2	\N	\N	6228414141
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2024-05-20 18:06:55.048522	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.23.2	\N	\N	6228414141
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2024-05-20 18:06:55.049453	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.23.2	\N	\N	6228414141
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2024-05-20 18:06:55.050375	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.23.2	\N	\N	6228414141
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2024-05-20 18:06:55.054821	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.23.2	\N	\N	6228414141
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2024-05-20 18:06:55.056941	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.23.2	\N	\N	6228414141
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2024-05-20 18:06:55.058065	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.23.2	\N	\N	6228414141
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2024-05-20 18:06:55.061781	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.23.2	\N	\N	6228414141
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2024-05-20 18:06:55.063195	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.23.2	\N	\N	6228414141
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2024-05-20 18:06:55.064298	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.23.2	\N	\N	6228414141
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-05-20 18:06:55.06592	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.23.2	\N	\N	6228414141
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-05-20 18:06:55.068099	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.23.2	\N	\N	6228414141
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-05-20 18:06:55.068953	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.23.2	\N	\N	6228414141
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-05-20 18:06:55.075375	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.23.2	\N	\N	6228414141
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-05-20 18:06:55.077431	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.23.2	\N	\N	6228414141
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-05-20 18:06:55.078373	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.23.2	\N	\N	6228414141
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-05-20 18:06:55.078954	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.23.2	\N	\N	6228414141
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-05-20 18:06:55.084768	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.23.2	\N	\N	6228414141
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-05-20 18:06:55.086302	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.23.2	\N	\N	6228414141
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-05-20 18:06:55.088447	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.23.2	\N	\N	6228414141
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-05-20 18:06:55.088864	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.23.2	\N	\N	6228414141
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-05-20 18:06:55.090329	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.23.2	\N	\N	6228414141
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-05-20 18:06:55.090922	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.23.2	\N	\N	6228414141
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-05-20 18:06:55.092574	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.23.2	\N	\N	6228414141
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2024-05-20 18:06:55.093847	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.23.2	\N	\N	6228414141
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2024-05-20 18:06:55.095747	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.23.2	\N	\N	6228414141
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2024-05-20 18:06:55.098909	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.23.2	\N	\N	6228414141
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-05-20 18:06:55.100541	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.23.2	\N	\N	6228414141
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-05-20 18:06:55.102154	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.23.2	\N	\N	6228414141
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-05-20 18:06:55.103865	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.23.2	\N	\N	6228414141
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-05-20 18:06:55.105992	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.23.2	\N	\N	6228414141
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-05-20 18:06:55.106486	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.23.2	\N	\N	6228414141
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-05-20 18:06:55.108678	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.23.2	\N	\N	6228414141
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-05-20 18:06:55.109562	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.23.2	\N	\N	6228414141
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-05-20 18:06:55.111337	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.23.2	\N	\N	6228414141
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-05-20 18:06:55.11442	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.23.2	\N	\N	6228414141
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-05-20 18:06:55.114903	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	6228414141
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-05-20 18:06:55.117525	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	6228414141
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-05-20 18:06:55.119334	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	6228414141
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-05-20 18:06:55.11988	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	6228414141
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-05-20 18:06:55.12189	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.23.2	\N	\N	6228414141
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-05-20 18:06:55.123245	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.23.2	\N	\N	6228414141
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2024-05-20 18:06:55.125566	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.23.2	\N	\N	6228414141
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2024-05-20 18:06:55.12714	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.23.2	\N	\N	6228414141
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2024-05-20 18:06:55.128633	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.23.2	\N	\N	6228414141
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2024-05-20 18:06:55.129865	107	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.23.2	\N	\N	6228414141
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-05-20 18:06:55.131406	108	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.23.2	\N	\N	6228414141
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-05-20 18:06:55.131887	109	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.23.2	\N	\N	6228414141
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-05-20 18:06:55.133529	110	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	6228414141
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2024-05-20 18:06:55.134713	111	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.23.2	\N	\N	6228414141
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2024-05-20 18:06:55.142362	112	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.23.2	\N	\N	6228414141
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2024-05-20 18:06:55.143513	113	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.23.2	\N	\N	6228414141
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2024-05-20 18:06:55.145083	114	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.23.2	\N	\N	6228414141
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2024-05-20 18:06:55.145503	115	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.23.2	\N	\N	6228414141
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2024-05-20 18:06:55.147072	116	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.23.2	\N	\N	6228414141
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2024-05-20 18:06:55.14791	117	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.23.2	\N	\N	6228414141
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	5b6c81d6-c5e0-4c93-926d-761083cfdbed	f
147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	f8863ef8-9e11-47c1-9b04-3cc0871da801	t
147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	1a42cc09-1765-49e8-b48a-2f2bfedb3628	t
147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	c2a1ec5e-eb3d-40a9-bd36-b0e655854a89	t
147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	bedf7e65-53b3-4def-a774-a5af7cd8f9ab	f
147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b4c362cf-f726-41fb-94df-7ef238c6f75f	f
147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	f3cecf35-5911-4f03-a645-d88de62bd0a7	t
147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	feddf322-903f-4301-97ee-d95a1888d17b	t
147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	993ef9f2-6f48-48cb-8a4d-ec7ecfa188e6	f
147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b494f1a3-5ca5-42e7-a0a9-402cb80e3674	t
offices	b3cc20a5-c599-40db-aacd-6d0888f40165	t
offices	040a3ca9-1518-4d62-8635-889a6bd64f1b	t
offices	da2ab094-2b69-4691-9ed4-7768f0ecb4d5	t
offices	21813b6a-fd67-47ac-976f-cba52022d485	t
offices	63b63fac-108c-444c-8c32-925078761f37	t
offices	81cffda0-096b-4ec5-b9bf-f708f2adf5cc	t
offices	ac79bdd9-5fc8-439d-b854-6db86e4e421d	f
offices	ea7408db-2fc3-4dd2-a477-3d80ed750535	f
offices	c03ecd61-ea09-43aa-8e7b-d623ef2ca9be	f
offices	31a08250-f1a5-449a-be71-3541ed2f0a55	f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
ebfdfecb-dbee-412b-8fe5-d40584b91632	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	f	${role_default-roles}	default-roles-master	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	\N	\N
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	f	${role_admin}	admin	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	\N	\N
bf245e41-9814-4686-beca-ab0a63eb43c8	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	f	${role_create-realm}	create-realm	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	\N	\N
d9fd4479-6641-449e-97a3-5c8c42a414e2	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_create-client}	create-client	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
76c6b6d6-001d-4b27-aaa2-0680ff08b38b	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_view-realm}	view-realm	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
132b8e8a-576f-431c-abaa-480f515f399e	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_view-users}	view-users	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
60fec3d0-518c-4e51-b0fa-dd3a160a158e	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_view-clients}	view-clients	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
889c672e-8f44-46e1-9c99-cb260879272c	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_view-events}	view-events	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
577a1e56-0260-4aca-bcad-7215865da4b4	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_view-identity-providers}	view-identity-providers	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
430f90cb-c450-46ff-b37f-190e482c19c4	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_view-authorization}	view-authorization	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
625810f4-4124-4135-87a5-edabcaeadea8	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_manage-realm}	manage-realm	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
4f16ba6c-1f45-4101-980e-ce427ecd0e50	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_manage-users}	manage-users	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
e1c897a7-1a24-47ad-8257-3fc3f88e0204	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_manage-clients}	manage-clients	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
0164bfbf-94b4-482f-ab4a-501a6132e592	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_manage-events}	manage-events	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
c93a26fd-c51b-49e3-95f8-3e90ca059816	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_manage-identity-providers}	manage-identity-providers	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
85e16d9a-57df-4cf1-b9de-22688a6b7b94	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_manage-authorization}	manage-authorization	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
07a28fb6-df7f-4eb1-940d-c5335da5f918	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_query-users}	query-users	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
40144513-d08b-420a-9c82-7052de88ff79	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_query-clients}	query-clients	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
565c1deb-a128-4562-ad8a-f0a31b99815a	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_query-realms}	query-realms	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
f81aa07d-98b3-4b83-a767-997e52031a86	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_query-groups}	query-groups	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
635e98b7-3d02-48a5-85a8-beefe16e146c	b81fb2f6-6d68-47c7-a8c9-05749088eb42	t	${role_view-profile}	view-profile	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b81fb2f6-6d68-47c7-a8c9-05749088eb42	\N
44296b4e-180b-4c84-a77e-a4b40ceb8722	b81fb2f6-6d68-47c7-a8c9-05749088eb42	t	${role_manage-account}	manage-account	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b81fb2f6-6d68-47c7-a8c9-05749088eb42	\N
7645b6e4-cb5e-47e5-b70e-0d68991c3a60	b81fb2f6-6d68-47c7-a8c9-05749088eb42	t	${role_manage-account-links}	manage-account-links	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b81fb2f6-6d68-47c7-a8c9-05749088eb42	\N
4583ad1a-e2b2-4dd5-88e8-f0426091e779	b81fb2f6-6d68-47c7-a8c9-05749088eb42	t	${role_view-applications}	view-applications	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b81fb2f6-6d68-47c7-a8c9-05749088eb42	\N
9220f7d1-a64d-493b-9385-a175a47152ad	b81fb2f6-6d68-47c7-a8c9-05749088eb42	t	${role_view-consent}	view-consent	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b81fb2f6-6d68-47c7-a8c9-05749088eb42	\N
6bd0903e-f066-4987-b8c1-c73ec9132d69	b81fb2f6-6d68-47c7-a8c9-05749088eb42	t	${role_manage-consent}	manage-consent	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b81fb2f6-6d68-47c7-a8c9-05749088eb42	\N
2a602f42-f1da-4c55-8802-672a9007deda	b81fb2f6-6d68-47c7-a8c9-05749088eb42	t	${role_view-groups}	view-groups	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b81fb2f6-6d68-47c7-a8c9-05749088eb42	\N
fdeddaae-5ae4-4105-9933-1ce170953842	b81fb2f6-6d68-47c7-a8c9-05749088eb42	t	${role_delete-account}	delete-account	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	b81fb2f6-6d68-47c7-a8c9-05749088eb42	\N
fa5c3341-4fe0-4579-b29d-e48b3ac3058a	9be8d753-9a0d-4da4-a9e4-3bba031c410a	t	${role_read-token}	read-token	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	9be8d753-9a0d-4da4-a9e4-3bba031c410a	\N
011e6874-7523-45f8-a67f-0bf4385b963c	2a9d8d7d-0632-45ba-81e5-d3004f154c05	t	${role_impersonation}	impersonation	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	2a9d8d7d-0632-45ba-81e5-d3004f154c05	\N
6d5c982e-60c8-4a7c-8cbf-0c1c8bc23a84	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	f	${role_offline-access}	offline_access	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	\N	\N
ed502f84-577b-4c2c-85ec-a66dfd0d0ed9	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	f	${role_uma_authorization}	uma_authorization	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	\N	\N
9039b1a0-c01c-43eb-8137-dd05612a071b	offices	f	${role_default-roles}	default-roles-offices	offices	\N	\N
8b79a9cb-9f90-483b-b90f-aa6f388803ec	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_create-client}	create-client	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
6173522b-f397-4cd8-b3f2-8d94df8efc4b	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_view-realm}	view-realm	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
ae4aff55-fca5-4972-a7a9-0ac7e75e7bb7	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_view-users}	view-users	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
1505045d-5d89-4dcc-b134-03316c5bc2e9	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_view-clients}	view-clients	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
70c1c8ed-8d7d-4827-b4a0-37fc8a6f31d7	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_view-events}	view-events	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
47844524-f903-45cc-ba9b-36d1e77f281f	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_view-identity-providers}	view-identity-providers	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
0176c677-f9da-4834-a9fa-3dd4f2a05d71	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_view-authorization}	view-authorization	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
08b79176-10db-4167-9853-caa819dfc751	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_manage-realm}	manage-realm	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
b753a528-b7c0-4ccc-ace2-9320a74302fa	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_manage-users}	manage-users	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
d01ac481-532e-4ffb-80cf-369e1222acf4	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_manage-clients}	manage-clients	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
706f3d0b-d1b7-4177-a831-2bc60dd3f1e4	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_manage-events}	manage-events	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
5ede22bd-4b07-4d7d-a9ec-500463408741	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_manage-identity-providers}	manage-identity-providers	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
2d337072-95e4-4021-94f3-284867e77df1	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_manage-authorization}	manage-authorization	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
ba799e64-216c-404b-b624-7225b6d3d2a2	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_query-users}	query-users	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
3c9f314c-3bc1-499a-ad2e-f23972af1b7d	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_query-clients}	query-clients	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
20732c36-1814-409c-876a-68fdb62f1e41	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_query-realms}	query-realms	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
b8267090-8314-4ae6-92c7-9fd6b4b716e4	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_query-groups}	query-groups	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
b6c86baa-5355-418a-87da-12fe0a5db8b1	offices	f	${role_offline-access}	offline_access	offices	\N	\N
c437bd4a-5045-4cfc-80be-18bf480a91d0	offices	f	${role_uma_authorization}	uma_authorization	offices	\N	\N
cc85df01-be92-4c3a-a0ba-36d0c173fe5e	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_manage-identity-providers}	manage-identity-providers	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
3c003097-4764-45fd-85b8-8deec86528da	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_query-groups}	query-groups	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
d63df527-487e-40bc-ad4d-310e1a589577	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_manage-events}	manage-events	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
c0e3b0df-cb88-476f-9049-99c3a83db555	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_realm-admin}	realm-admin	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
00870bc8-bee9-4bd2-9c2d-10c4146df2bd	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_view-clients}	view-clients	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
92c60368-eed1-4dc4-8287-42f751c398c6	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_impersonation}	impersonation	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
31bd48fb-a922-4782-82ea-612b7462905b	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_manage-clients}	manage-clients	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
85076455-56ff-4ff5-bf31-89a111873697	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_view-realm}	view-realm	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
d47f0ea7-1c80-4912-88ff-18f529f4fa5e	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_query-users}	query-users	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
76a9be04-8124-41af-9dd6-17951d6a5bc8	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_create-client}	create-client	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
61fd79d2-59a6-4a2e-8265-5f1294d79341	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_view-identity-providers}	view-identity-providers	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
7ddcaa9f-bea0-42c0-a4c7-6ed9e3abf722	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_manage-users}	manage-users	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
00145345-ad58-4ea1-a65c-1325ba823281	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_query-realms}	query-realms	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
3a6a03ec-32de-41ff-9dbf-0d69887e26e0	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_manage-authorization}	manage-authorization	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
eaaf701d-52c6-43ac-becf-02da63a6ee23	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_view-users}	view-users	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
97513d29-f1d7-4820-9fd0-dd7771d7f59b	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_query-clients}	query-clients	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
504a3b79-75e2-455e-95fe-6a48d29d5acd	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_view-authorization}	view-authorization	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
1d73992b-2f5c-4eb1-b740-b263212bab00	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_view-events}	view-events	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
7f9a53d6-00b2-4eda-a533-4022e63c9d3b	62c71480-d212-4dea-aa42-a88bc8efb235	t	${role_manage-realm}	manage-realm	offices	62c71480-d212-4dea-aa42-a88bc8efb235	\N
f3c79c99-2e0b-48b5-96d0-22dc2f5cb319	391be89f-580a-4833-b48a-459ae57059f3	t	${role_read-token}	read-token	offices	391be89f-580a-4833-b48a-459ae57059f3	\N
ff479e28-a640-409b-ba4e-a7a43eb96565	68e03bd4-6a95-4b73-98ff-2689bafac727	t	${role_view-profile}	view-profile	offices	68e03bd4-6a95-4b73-98ff-2689bafac727	\N
fd4cdf90-8a71-4234-bf9f-5a8a1a11ef28	68e03bd4-6a95-4b73-98ff-2689bafac727	t	${role_delete-account}	delete-account	offices	68e03bd4-6a95-4b73-98ff-2689bafac727	\N
a9bf5028-203b-4903-bb01-576a6b6c01b6	68e03bd4-6a95-4b73-98ff-2689bafac727	t	${role_manage-consent}	manage-consent	offices	68e03bd4-6a95-4b73-98ff-2689bafac727	\N
1ceca93d-eca8-4cfc-b820-26b87f80b5ad	68e03bd4-6a95-4b73-98ff-2689bafac727	t	${role_view-applications}	view-applications	offices	68e03bd4-6a95-4b73-98ff-2689bafac727	\N
0a06f480-a9b9-4180-a74b-c4947189909f	68e03bd4-6a95-4b73-98ff-2689bafac727	t	${role_manage-account}	manage-account	offices	68e03bd4-6a95-4b73-98ff-2689bafac727	\N
80c8ef9a-f4a2-4847-a04a-08869e7defa6	68e03bd4-6a95-4b73-98ff-2689bafac727	t	${role_manage-account-links}	manage-account-links	offices	68e03bd4-6a95-4b73-98ff-2689bafac727	\N
b47faa1a-dcd8-4daf-99be-2485dfdbea4b	68e03bd4-6a95-4b73-98ff-2689bafac727	t	${role_view-consent}	view-consent	offices	68e03bd4-6a95-4b73-98ff-2689bafac727	\N
f570dcaa-d58d-42a7-9f61-593b363393a2	68e03bd4-6a95-4b73-98ff-2689bafac727	t	${role_view-groups}	view-groups	offices	68e03bd4-6a95-4b73-98ff-2689bafac727	\N
dc8abe84-20c8-479c-8d28-2054f4484e15	a3e25a70-28ee-4897-ada2-4d9921fe2e25	t	${role_impersonation}	impersonation	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	a3e25a70-28ee-4897-ada2-4d9921fe2e25	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.migration_model (id, version, update_time) FROM stdin;
xx199	23.0.6	1716228415
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
0bd768ca-d6dc-4e55-840a-d8d22a60b890	audience resolve	openid-connect	oidc-audience-resolve-mapper	b6622bd7-bbb6-4199-9ed3-d13f60ad8695	\N
4d61a553-4a93-48ec-beec-919317662800	locale	openid-connect	oidc-usermodel-attribute-mapper	74dca843-fbea-4237-bbe3-98c0804778dc	\N
f91c2d0a-76a2-493c-87a8-8722aa43eed3	role list	saml	saml-role-list-mapper	\N	f8863ef8-9e11-47c1-9b04-3cc0871da801
2e9038c8-c64c-4662-bdd7-a7e067659c0f	full name	openid-connect	oidc-full-name-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
64b0faf3-6949-4593-a935-a80800d72fd7	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
d79a84a7-ab1f-4283-869a-96bd98a2c291	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
07166477-41c5-4f97-9b92-c32a78e11b97	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
d4545c08-8417-4f9c-8dfe-b8a68b43f0fd	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
454e722d-175f-448e-8d67-6bb8c84eab3b	username	openid-connect	oidc-usermodel-attribute-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
c45cfa9c-d834-4085-969a-192128de162f	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
0b440cca-0404-4b0b-a420-243500cb4003	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
ec6c9986-38e2-40bc-9ca7-3fc2a282c503	website	openid-connect	oidc-usermodel-attribute-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
d3f1b73d-d6b5-4381-8390-c21413dc8baf	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
4427ba57-ee1a-4bef-ad86-ad30a22e923a	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
0cac1e2e-0d9b-4b33-86f5-7c128224e944	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
6302a496-5669-40c9-b938-e44ec9a0598e	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
c06f662e-91ab-408f-aebb-000d1e658d76	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	1a42cc09-1765-49e8-b48a-2f2bfedb3628
9277c4b4-7b8b-4c30-9f7b-696ed19e54e7	email	openid-connect	oidc-usermodel-attribute-mapper	\N	c2a1ec5e-eb3d-40a9-bd36-b0e655854a89
bc99fe05-4449-4d9f-aec1-94bf662c1ef6	email verified	openid-connect	oidc-usermodel-property-mapper	\N	c2a1ec5e-eb3d-40a9-bd36-b0e655854a89
59e3eba0-ce68-4d6c-892d-730d26a06f96	address	openid-connect	oidc-address-mapper	\N	bedf7e65-53b3-4def-a774-a5af7cd8f9ab
d19f9c13-27cb-421f-9854-287fc42e8073	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	b4c362cf-f726-41fb-94df-7ef238c6f75f
6da3f47e-21b1-417a-b436-6d9df2e781a5	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	b4c362cf-f726-41fb-94df-7ef238c6f75f
69596cf9-2f40-4373-b20f-e3a5fc351bf8	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	f3cecf35-5911-4f03-a645-d88de62bd0a7
4c1a53bf-8bc2-4ddb-a73b-abc5ee8a18ef	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	f3cecf35-5911-4f03-a645-d88de62bd0a7
dccf4f54-524c-486d-acbe-363741417507	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	f3cecf35-5911-4f03-a645-d88de62bd0a7
b27166b9-5fd0-426b-8782-bff862774509	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	feddf322-903f-4301-97ee-d95a1888d17b
f2abe6a0-cd19-4871-b1b6-e366080a5ce0	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	993ef9f2-6f48-48cb-8a4d-ec7ecfa188e6
b15021bd-1220-4f78-a187-d8f29a8bb395	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	993ef9f2-6f48-48cb-8a4d-ec7ecfa188e6
0b83c2a7-35a8-4950-bc84-b7de72f97f7c	acr loa level	openid-connect	oidc-acr-mapper	\N	b494f1a3-5ca5-42e7-a0a9-402cb80e3674
8baa457c-c898-4bff-a9e0-e0dd9958a108	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	21813b6a-fd67-47ac-976f-cba52022d485
4f24f350-e1d8-4915-9219-de743f903af8	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	21813b6a-fd67-47ac-976f-cba52022d485
3f04ab86-cca3-4266-954d-ba4410da6e90	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	21813b6a-fd67-47ac-976f-cba52022d485
7cf93890-96af-4aab-8554-ccd39cdeffb2	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	c03ecd61-ea09-43aa-8e7b-d623ef2ca9be
84e511ee-50d3-4c86-8753-1f6ad69b9587	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	c03ecd61-ea09-43aa-8e7b-d623ef2ca9be
94793318-36f1-46ca-ab83-da7543404f08	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	31a08250-f1a5-449a-be71-3541ed2f0a55
f27843cf-a7cf-41fc-82ba-d35423594af8	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	31a08250-f1a5-449a-be71-3541ed2f0a55
faaf70b0-b964-44f1-a1a2-3f32da239f12	role list	saml	saml-role-list-mapper	\N	b3cc20a5-c599-40db-aacd-6d0888f40165
4af5c4b7-61d2-4e6e-a9fd-3b13d991c8aa	address	openid-connect	oidc-address-mapper	\N	ea7408db-2fc3-4dd2-a477-3d80ed750535
fe4bb4c7-30fb-4c33-af22-c9a39a81b461	username	openid-connect	oidc-usermodel-attribute-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
d8511fda-b96b-4e0d-a41a-bce0b48dd45e	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
46228b8a-25e1-4c52-a028-715819a7a89b	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
539c8e37-24a8-407d-9d16-d1fd2303fd9b	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
7e75d078-ee35-4795-adcb-3fe6ca974158	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
55509656-7b31-4dda-b616-e429ba1e78a8	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
0ef2fdcb-10e2-4729-b1f0-e86dfc80bf77	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
5938e90f-ca2c-4930-8745-5b12a33cb8b5	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
59441b33-ec8b-4587-ae24-b34aeb4161cc	full name	openid-connect	oidc-full-name-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
9d16a06b-db1f-4271-9998-8597d9f051bd	website	openid-connect	oidc-usermodel-attribute-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
8464b464-4b84-48ae-9f56-b64086de3d03	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
a0fd209d-9e92-4e36-986e-eae2567da487	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
21ed3f41-8eaa-4498-9cae-26201a1ae641	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
582f2db6-5c03-4ada-a261-94029788b65b	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	040a3ca9-1518-4d62-8635-889a6bd64f1b
8dd687ec-2e8d-4e06-9170-6c57887c9c4e	email	openid-connect	oidc-usermodel-attribute-mapper	\N	da2ab094-2b69-4691-9ed4-7768f0ecb4d5
74281cad-a98b-4207-b5a0-ee1ff74c10ed	email verified	openid-connect	oidc-usermodel-property-mapper	\N	da2ab094-2b69-4691-9ed4-7768f0ecb4d5
9cb1d336-db72-47df-96f1-139e8a8dacf5	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	63b63fac-108c-444c-8c32-925078761f37
26231f7f-8291-4afc-8978-4af5b78a946c	acr loa level	openid-connect	oidc-acr-mapper	\N	81cffda0-096b-4ec5-b9bf-f708f2adf5cc
8dceee30-d983-4a3e-92e2-c50da5775221	audience resolve	openid-connect	oidc-audience-resolve-mapper	20dfbc67-fe4d-4b10-9f61-ad32477c50c2	\N
0a290c5e-8ba9-43c6-83c2-62c66985dcab	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	6bd58108-7661-4b77-a966-0c820613deef	\N
4daca983-97ab-463a-8855-de18cf6a889a	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	6bd58108-7661-4b77-a966-0c820613deef	\N
ba11d7ec-d170-4d11-b1ab-a484f50f36c8	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	6bd58108-7661-4b77-a966-0c820613deef	\N
9a6197a4-172d-4b95-9d66-e0a1a3512408	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	e19f251d-902a-4d0b-92ce-a1c7f2eb5008	\N
de6c6136-509c-449d-b033-2f9cf3139128	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	e19f251d-902a-4d0b-92ce-a1c7f2eb5008	\N
2ecc1714-2948-424d-9a83-2ee377299648	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	e19f251d-902a-4d0b-92ce-a1c7f2eb5008	\N
a26df5ce-dd43-4898-9fff-ab57d5f6722b	locale	openid-connect	oidc-usermodel-attribute-mapper	7ea9781f-d754-49b5-8e4d-27881873d893	\N
88ca6477-af04-40ca-b4ea-fc40c14896fd	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	48daad2a-6675-4d49-967d-13b861c8bc6c	\N
8ba05efe-b1b0-48cd-b08c-146676659a48	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	48daad2a-6675-4d49-967d-13b861c8bc6c	\N
8247a0e6-a0cd-488f-9078-a297aa90b72d	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	48daad2a-6675-4d49-967d-13b861c8bc6c	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
4d61a553-4a93-48ec-beec-919317662800	true	introspection.token.claim
4d61a553-4a93-48ec-beec-919317662800	true	userinfo.token.claim
4d61a553-4a93-48ec-beec-919317662800	locale	user.attribute
4d61a553-4a93-48ec-beec-919317662800	true	id.token.claim
4d61a553-4a93-48ec-beec-919317662800	true	access.token.claim
4d61a553-4a93-48ec-beec-919317662800	locale	claim.name
4d61a553-4a93-48ec-beec-919317662800	String	jsonType.label
f91c2d0a-76a2-493c-87a8-8722aa43eed3	false	single
f91c2d0a-76a2-493c-87a8-8722aa43eed3	Basic	attribute.nameformat
f91c2d0a-76a2-493c-87a8-8722aa43eed3	Role	attribute.name
07166477-41c5-4f97-9b92-c32a78e11b97	true	introspection.token.claim
07166477-41c5-4f97-9b92-c32a78e11b97	true	userinfo.token.claim
07166477-41c5-4f97-9b92-c32a78e11b97	middleName	user.attribute
07166477-41c5-4f97-9b92-c32a78e11b97	true	id.token.claim
07166477-41c5-4f97-9b92-c32a78e11b97	true	access.token.claim
07166477-41c5-4f97-9b92-c32a78e11b97	middle_name	claim.name
07166477-41c5-4f97-9b92-c32a78e11b97	String	jsonType.label
0b440cca-0404-4b0b-a420-243500cb4003	true	introspection.token.claim
0b440cca-0404-4b0b-a420-243500cb4003	true	userinfo.token.claim
0b440cca-0404-4b0b-a420-243500cb4003	picture	user.attribute
0b440cca-0404-4b0b-a420-243500cb4003	true	id.token.claim
0b440cca-0404-4b0b-a420-243500cb4003	true	access.token.claim
0b440cca-0404-4b0b-a420-243500cb4003	picture	claim.name
0b440cca-0404-4b0b-a420-243500cb4003	String	jsonType.label
0cac1e2e-0d9b-4b33-86f5-7c128224e944	true	introspection.token.claim
0cac1e2e-0d9b-4b33-86f5-7c128224e944	true	userinfo.token.claim
0cac1e2e-0d9b-4b33-86f5-7c128224e944	zoneinfo	user.attribute
0cac1e2e-0d9b-4b33-86f5-7c128224e944	true	id.token.claim
0cac1e2e-0d9b-4b33-86f5-7c128224e944	true	access.token.claim
0cac1e2e-0d9b-4b33-86f5-7c128224e944	zoneinfo	claim.name
0cac1e2e-0d9b-4b33-86f5-7c128224e944	String	jsonType.label
2e9038c8-c64c-4662-bdd7-a7e067659c0f	true	introspection.token.claim
2e9038c8-c64c-4662-bdd7-a7e067659c0f	true	userinfo.token.claim
2e9038c8-c64c-4662-bdd7-a7e067659c0f	true	id.token.claim
2e9038c8-c64c-4662-bdd7-a7e067659c0f	true	access.token.claim
4427ba57-ee1a-4bef-ad86-ad30a22e923a	true	introspection.token.claim
4427ba57-ee1a-4bef-ad86-ad30a22e923a	true	userinfo.token.claim
4427ba57-ee1a-4bef-ad86-ad30a22e923a	birthdate	user.attribute
4427ba57-ee1a-4bef-ad86-ad30a22e923a	true	id.token.claim
4427ba57-ee1a-4bef-ad86-ad30a22e923a	true	access.token.claim
4427ba57-ee1a-4bef-ad86-ad30a22e923a	birthdate	claim.name
4427ba57-ee1a-4bef-ad86-ad30a22e923a	String	jsonType.label
454e722d-175f-448e-8d67-6bb8c84eab3b	true	introspection.token.claim
454e722d-175f-448e-8d67-6bb8c84eab3b	true	userinfo.token.claim
454e722d-175f-448e-8d67-6bb8c84eab3b	username	user.attribute
454e722d-175f-448e-8d67-6bb8c84eab3b	true	id.token.claim
454e722d-175f-448e-8d67-6bb8c84eab3b	true	access.token.claim
454e722d-175f-448e-8d67-6bb8c84eab3b	preferred_username	claim.name
454e722d-175f-448e-8d67-6bb8c84eab3b	String	jsonType.label
6302a496-5669-40c9-b938-e44ec9a0598e	true	introspection.token.claim
6302a496-5669-40c9-b938-e44ec9a0598e	true	userinfo.token.claim
6302a496-5669-40c9-b938-e44ec9a0598e	locale	user.attribute
6302a496-5669-40c9-b938-e44ec9a0598e	true	id.token.claim
6302a496-5669-40c9-b938-e44ec9a0598e	true	access.token.claim
6302a496-5669-40c9-b938-e44ec9a0598e	locale	claim.name
6302a496-5669-40c9-b938-e44ec9a0598e	String	jsonType.label
64b0faf3-6949-4593-a935-a80800d72fd7	true	introspection.token.claim
64b0faf3-6949-4593-a935-a80800d72fd7	true	userinfo.token.claim
64b0faf3-6949-4593-a935-a80800d72fd7	lastName	user.attribute
64b0faf3-6949-4593-a935-a80800d72fd7	true	id.token.claim
64b0faf3-6949-4593-a935-a80800d72fd7	true	access.token.claim
64b0faf3-6949-4593-a935-a80800d72fd7	family_name	claim.name
64b0faf3-6949-4593-a935-a80800d72fd7	String	jsonType.label
c06f662e-91ab-408f-aebb-000d1e658d76	true	introspection.token.claim
c06f662e-91ab-408f-aebb-000d1e658d76	true	userinfo.token.claim
c06f662e-91ab-408f-aebb-000d1e658d76	updatedAt	user.attribute
c06f662e-91ab-408f-aebb-000d1e658d76	true	id.token.claim
c06f662e-91ab-408f-aebb-000d1e658d76	true	access.token.claim
c06f662e-91ab-408f-aebb-000d1e658d76	updated_at	claim.name
c06f662e-91ab-408f-aebb-000d1e658d76	long	jsonType.label
c45cfa9c-d834-4085-969a-192128de162f	true	introspection.token.claim
c45cfa9c-d834-4085-969a-192128de162f	true	userinfo.token.claim
c45cfa9c-d834-4085-969a-192128de162f	profile	user.attribute
c45cfa9c-d834-4085-969a-192128de162f	true	id.token.claim
c45cfa9c-d834-4085-969a-192128de162f	true	access.token.claim
c45cfa9c-d834-4085-969a-192128de162f	profile	claim.name
c45cfa9c-d834-4085-969a-192128de162f	String	jsonType.label
d3f1b73d-d6b5-4381-8390-c21413dc8baf	true	introspection.token.claim
d3f1b73d-d6b5-4381-8390-c21413dc8baf	true	userinfo.token.claim
d3f1b73d-d6b5-4381-8390-c21413dc8baf	gender	user.attribute
d3f1b73d-d6b5-4381-8390-c21413dc8baf	true	id.token.claim
d3f1b73d-d6b5-4381-8390-c21413dc8baf	true	access.token.claim
d3f1b73d-d6b5-4381-8390-c21413dc8baf	gender	claim.name
d3f1b73d-d6b5-4381-8390-c21413dc8baf	String	jsonType.label
d4545c08-8417-4f9c-8dfe-b8a68b43f0fd	true	introspection.token.claim
d4545c08-8417-4f9c-8dfe-b8a68b43f0fd	true	userinfo.token.claim
d4545c08-8417-4f9c-8dfe-b8a68b43f0fd	nickname	user.attribute
d4545c08-8417-4f9c-8dfe-b8a68b43f0fd	true	id.token.claim
d4545c08-8417-4f9c-8dfe-b8a68b43f0fd	true	access.token.claim
d4545c08-8417-4f9c-8dfe-b8a68b43f0fd	nickname	claim.name
d4545c08-8417-4f9c-8dfe-b8a68b43f0fd	String	jsonType.label
d79a84a7-ab1f-4283-869a-96bd98a2c291	true	introspection.token.claim
d79a84a7-ab1f-4283-869a-96bd98a2c291	true	userinfo.token.claim
d79a84a7-ab1f-4283-869a-96bd98a2c291	firstName	user.attribute
d79a84a7-ab1f-4283-869a-96bd98a2c291	true	id.token.claim
d79a84a7-ab1f-4283-869a-96bd98a2c291	true	access.token.claim
d79a84a7-ab1f-4283-869a-96bd98a2c291	given_name	claim.name
d79a84a7-ab1f-4283-869a-96bd98a2c291	String	jsonType.label
ec6c9986-38e2-40bc-9ca7-3fc2a282c503	true	introspection.token.claim
ec6c9986-38e2-40bc-9ca7-3fc2a282c503	true	userinfo.token.claim
ec6c9986-38e2-40bc-9ca7-3fc2a282c503	website	user.attribute
ec6c9986-38e2-40bc-9ca7-3fc2a282c503	true	id.token.claim
ec6c9986-38e2-40bc-9ca7-3fc2a282c503	true	access.token.claim
ec6c9986-38e2-40bc-9ca7-3fc2a282c503	website	claim.name
ec6c9986-38e2-40bc-9ca7-3fc2a282c503	String	jsonType.label
9277c4b4-7b8b-4c30-9f7b-696ed19e54e7	true	introspection.token.claim
9277c4b4-7b8b-4c30-9f7b-696ed19e54e7	true	userinfo.token.claim
9277c4b4-7b8b-4c30-9f7b-696ed19e54e7	email	user.attribute
9277c4b4-7b8b-4c30-9f7b-696ed19e54e7	true	id.token.claim
9277c4b4-7b8b-4c30-9f7b-696ed19e54e7	true	access.token.claim
9277c4b4-7b8b-4c30-9f7b-696ed19e54e7	email	claim.name
9277c4b4-7b8b-4c30-9f7b-696ed19e54e7	String	jsonType.label
bc99fe05-4449-4d9f-aec1-94bf662c1ef6	true	introspection.token.claim
bc99fe05-4449-4d9f-aec1-94bf662c1ef6	true	userinfo.token.claim
bc99fe05-4449-4d9f-aec1-94bf662c1ef6	emailVerified	user.attribute
bc99fe05-4449-4d9f-aec1-94bf662c1ef6	true	id.token.claim
bc99fe05-4449-4d9f-aec1-94bf662c1ef6	true	access.token.claim
bc99fe05-4449-4d9f-aec1-94bf662c1ef6	email_verified	claim.name
bc99fe05-4449-4d9f-aec1-94bf662c1ef6	boolean	jsonType.label
59e3eba0-ce68-4d6c-892d-730d26a06f96	formatted	user.attribute.formatted
59e3eba0-ce68-4d6c-892d-730d26a06f96	country	user.attribute.country
59e3eba0-ce68-4d6c-892d-730d26a06f96	true	introspection.token.claim
59e3eba0-ce68-4d6c-892d-730d26a06f96	postal_code	user.attribute.postal_code
59e3eba0-ce68-4d6c-892d-730d26a06f96	true	userinfo.token.claim
59e3eba0-ce68-4d6c-892d-730d26a06f96	street	user.attribute.street
59e3eba0-ce68-4d6c-892d-730d26a06f96	true	id.token.claim
59e3eba0-ce68-4d6c-892d-730d26a06f96	region	user.attribute.region
59e3eba0-ce68-4d6c-892d-730d26a06f96	true	access.token.claim
59e3eba0-ce68-4d6c-892d-730d26a06f96	locality	user.attribute.locality
6da3f47e-21b1-417a-b436-6d9df2e781a5	true	introspection.token.claim
6da3f47e-21b1-417a-b436-6d9df2e781a5	true	userinfo.token.claim
6da3f47e-21b1-417a-b436-6d9df2e781a5	phoneNumberVerified	user.attribute
6da3f47e-21b1-417a-b436-6d9df2e781a5	true	id.token.claim
6da3f47e-21b1-417a-b436-6d9df2e781a5	true	access.token.claim
6da3f47e-21b1-417a-b436-6d9df2e781a5	phone_number_verified	claim.name
6da3f47e-21b1-417a-b436-6d9df2e781a5	boolean	jsonType.label
d19f9c13-27cb-421f-9854-287fc42e8073	true	introspection.token.claim
d19f9c13-27cb-421f-9854-287fc42e8073	true	userinfo.token.claim
d19f9c13-27cb-421f-9854-287fc42e8073	phoneNumber	user.attribute
d19f9c13-27cb-421f-9854-287fc42e8073	true	id.token.claim
d19f9c13-27cb-421f-9854-287fc42e8073	true	access.token.claim
d19f9c13-27cb-421f-9854-287fc42e8073	phone_number	claim.name
d19f9c13-27cb-421f-9854-287fc42e8073	String	jsonType.label
4c1a53bf-8bc2-4ddb-a73b-abc5ee8a18ef	true	introspection.token.claim
4c1a53bf-8bc2-4ddb-a73b-abc5ee8a18ef	true	multivalued
4c1a53bf-8bc2-4ddb-a73b-abc5ee8a18ef	foo	user.attribute
4c1a53bf-8bc2-4ddb-a73b-abc5ee8a18ef	true	access.token.claim
4c1a53bf-8bc2-4ddb-a73b-abc5ee8a18ef	resource_access.${client_id}.roles	claim.name
4c1a53bf-8bc2-4ddb-a73b-abc5ee8a18ef	String	jsonType.label
69596cf9-2f40-4373-b20f-e3a5fc351bf8	true	introspection.token.claim
69596cf9-2f40-4373-b20f-e3a5fc351bf8	true	multivalued
69596cf9-2f40-4373-b20f-e3a5fc351bf8	foo	user.attribute
69596cf9-2f40-4373-b20f-e3a5fc351bf8	true	access.token.claim
69596cf9-2f40-4373-b20f-e3a5fc351bf8	realm_access.roles	claim.name
69596cf9-2f40-4373-b20f-e3a5fc351bf8	String	jsonType.label
dccf4f54-524c-486d-acbe-363741417507	true	introspection.token.claim
dccf4f54-524c-486d-acbe-363741417507	true	access.token.claim
b27166b9-5fd0-426b-8782-bff862774509	true	introspection.token.claim
b27166b9-5fd0-426b-8782-bff862774509	true	access.token.claim
b15021bd-1220-4f78-a187-d8f29a8bb395	true	introspection.token.claim
b15021bd-1220-4f78-a187-d8f29a8bb395	true	multivalued
b15021bd-1220-4f78-a187-d8f29a8bb395	foo	user.attribute
b15021bd-1220-4f78-a187-d8f29a8bb395	true	id.token.claim
b15021bd-1220-4f78-a187-d8f29a8bb395	true	access.token.claim
b15021bd-1220-4f78-a187-d8f29a8bb395	groups	claim.name
b15021bd-1220-4f78-a187-d8f29a8bb395	String	jsonType.label
f2abe6a0-cd19-4871-b1b6-e366080a5ce0	true	introspection.token.claim
f2abe6a0-cd19-4871-b1b6-e366080a5ce0	true	userinfo.token.claim
f2abe6a0-cd19-4871-b1b6-e366080a5ce0	username	user.attribute
f2abe6a0-cd19-4871-b1b6-e366080a5ce0	true	id.token.claim
f2abe6a0-cd19-4871-b1b6-e366080a5ce0	true	access.token.claim
f2abe6a0-cd19-4871-b1b6-e366080a5ce0	upn	claim.name
f2abe6a0-cd19-4871-b1b6-e366080a5ce0	String	jsonType.label
0b83c2a7-35a8-4950-bc84-b7de72f97f7c	true	introspection.token.claim
0b83c2a7-35a8-4950-bc84-b7de72f97f7c	true	id.token.claim
0b83c2a7-35a8-4950-bc84-b7de72f97f7c	true	access.token.claim
3f04ab86-cca3-4266-954d-ba4410da6e90	true	introspection.token.claim
3f04ab86-cca3-4266-954d-ba4410da6e90	true	multivalued
3f04ab86-cca3-4266-954d-ba4410da6e90	foo	user.attribute
3f04ab86-cca3-4266-954d-ba4410da6e90	true	access.token.claim
3f04ab86-cca3-4266-954d-ba4410da6e90	resource_access.${client_id}.roles	claim.name
3f04ab86-cca3-4266-954d-ba4410da6e90	String	jsonType.label
4f24f350-e1d8-4915-9219-de743f903af8	true	introspection.token.claim
4f24f350-e1d8-4915-9219-de743f903af8	true	access.token.claim
8baa457c-c898-4bff-a9e0-e0dd9958a108	true	introspection.token.claim
8baa457c-c898-4bff-a9e0-e0dd9958a108	true	multivalued
8baa457c-c898-4bff-a9e0-e0dd9958a108	foo	user.attribute
8baa457c-c898-4bff-a9e0-e0dd9958a108	true	access.token.claim
8baa457c-c898-4bff-a9e0-e0dd9958a108	realm_access.roles	claim.name
8baa457c-c898-4bff-a9e0-e0dd9958a108	String	jsonType.label
7cf93890-96af-4aab-8554-ccd39cdeffb2	true	introspection.token.claim
7cf93890-96af-4aab-8554-ccd39cdeffb2	true	userinfo.token.claim
7cf93890-96af-4aab-8554-ccd39cdeffb2	phoneNumber	user.attribute
7cf93890-96af-4aab-8554-ccd39cdeffb2	true	id.token.claim
7cf93890-96af-4aab-8554-ccd39cdeffb2	true	access.token.claim
7cf93890-96af-4aab-8554-ccd39cdeffb2	phone_number	claim.name
7cf93890-96af-4aab-8554-ccd39cdeffb2	String	jsonType.label
84e511ee-50d3-4c86-8753-1f6ad69b9587	true	introspection.token.claim
84e511ee-50d3-4c86-8753-1f6ad69b9587	true	userinfo.token.claim
84e511ee-50d3-4c86-8753-1f6ad69b9587	phoneNumberVerified	user.attribute
84e511ee-50d3-4c86-8753-1f6ad69b9587	true	id.token.claim
84e511ee-50d3-4c86-8753-1f6ad69b9587	true	access.token.claim
84e511ee-50d3-4c86-8753-1f6ad69b9587	phone_number_verified	claim.name
84e511ee-50d3-4c86-8753-1f6ad69b9587	boolean	jsonType.label
94793318-36f1-46ca-ab83-da7543404f08	true	introspection.token.claim
94793318-36f1-46ca-ab83-da7543404f08	true	userinfo.token.claim
94793318-36f1-46ca-ab83-da7543404f08	username	user.attribute
94793318-36f1-46ca-ab83-da7543404f08	true	id.token.claim
94793318-36f1-46ca-ab83-da7543404f08	true	access.token.claim
94793318-36f1-46ca-ab83-da7543404f08	upn	claim.name
94793318-36f1-46ca-ab83-da7543404f08	String	jsonType.label
f27843cf-a7cf-41fc-82ba-d35423594af8	true	introspection.token.claim
f27843cf-a7cf-41fc-82ba-d35423594af8	true	multivalued
f27843cf-a7cf-41fc-82ba-d35423594af8	true	userinfo.token.claim
f27843cf-a7cf-41fc-82ba-d35423594af8	foo	user.attribute
f27843cf-a7cf-41fc-82ba-d35423594af8	true	id.token.claim
f27843cf-a7cf-41fc-82ba-d35423594af8	true	access.token.claim
f27843cf-a7cf-41fc-82ba-d35423594af8	groups	claim.name
f27843cf-a7cf-41fc-82ba-d35423594af8	String	jsonType.label
faaf70b0-b964-44f1-a1a2-3f32da239f12	false	single
faaf70b0-b964-44f1-a1a2-3f32da239f12	Basic	attribute.nameformat
faaf70b0-b964-44f1-a1a2-3f32da239f12	Role	attribute.name
4af5c4b7-61d2-4e6e-a9fd-3b13d991c8aa	formatted	user.attribute.formatted
4af5c4b7-61d2-4e6e-a9fd-3b13d991c8aa	country	user.attribute.country
4af5c4b7-61d2-4e6e-a9fd-3b13d991c8aa	true	introspection.token.claim
4af5c4b7-61d2-4e6e-a9fd-3b13d991c8aa	postal_code	user.attribute.postal_code
4af5c4b7-61d2-4e6e-a9fd-3b13d991c8aa	true	userinfo.token.claim
4af5c4b7-61d2-4e6e-a9fd-3b13d991c8aa	street	user.attribute.street
4af5c4b7-61d2-4e6e-a9fd-3b13d991c8aa	true	id.token.claim
4af5c4b7-61d2-4e6e-a9fd-3b13d991c8aa	region	user.attribute.region
4af5c4b7-61d2-4e6e-a9fd-3b13d991c8aa	true	access.token.claim
4af5c4b7-61d2-4e6e-a9fd-3b13d991c8aa	locality	user.attribute.locality
0ef2fdcb-10e2-4729-b1f0-e86dfc80bf77	true	introspection.token.claim
0ef2fdcb-10e2-4729-b1f0-e86dfc80bf77	true	userinfo.token.claim
0ef2fdcb-10e2-4729-b1f0-e86dfc80bf77	locale	user.attribute
0ef2fdcb-10e2-4729-b1f0-e86dfc80bf77	true	id.token.claim
0ef2fdcb-10e2-4729-b1f0-e86dfc80bf77	true	access.token.claim
0ef2fdcb-10e2-4729-b1f0-e86dfc80bf77	locale	claim.name
0ef2fdcb-10e2-4729-b1f0-e86dfc80bf77	String	jsonType.label
21ed3f41-8eaa-4498-9cae-26201a1ae641	true	introspection.token.claim
21ed3f41-8eaa-4498-9cae-26201a1ae641	true	userinfo.token.claim
21ed3f41-8eaa-4498-9cae-26201a1ae641	nickname	user.attribute
21ed3f41-8eaa-4498-9cae-26201a1ae641	true	id.token.claim
21ed3f41-8eaa-4498-9cae-26201a1ae641	true	access.token.claim
21ed3f41-8eaa-4498-9cae-26201a1ae641	nickname	claim.name
21ed3f41-8eaa-4498-9cae-26201a1ae641	String	jsonType.label
46228b8a-25e1-4c52-a028-715819a7a89b	true	introspection.token.claim
46228b8a-25e1-4c52-a028-715819a7a89b	true	userinfo.token.claim
46228b8a-25e1-4c52-a028-715819a7a89b	zoneinfo	user.attribute
46228b8a-25e1-4c52-a028-715819a7a89b	true	id.token.claim
46228b8a-25e1-4c52-a028-715819a7a89b	true	access.token.claim
46228b8a-25e1-4c52-a028-715819a7a89b	zoneinfo	claim.name
46228b8a-25e1-4c52-a028-715819a7a89b	String	jsonType.label
539c8e37-24a8-407d-9d16-d1fd2303fd9b	true	introspection.token.claim
539c8e37-24a8-407d-9d16-d1fd2303fd9b	true	userinfo.token.claim
539c8e37-24a8-407d-9d16-d1fd2303fd9b	lastName	user.attribute
539c8e37-24a8-407d-9d16-d1fd2303fd9b	true	id.token.claim
539c8e37-24a8-407d-9d16-d1fd2303fd9b	true	access.token.claim
539c8e37-24a8-407d-9d16-d1fd2303fd9b	family_name	claim.name
539c8e37-24a8-407d-9d16-d1fd2303fd9b	String	jsonType.label
55509656-7b31-4dda-b616-e429ba1e78a8	true	introspection.token.claim
55509656-7b31-4dda-b616-e429ba1e78a8	true	userinfo.token.claim
55509656-7b31-4dda-b616-e429ba1e78a8	picture	user.attribute
55509656-7b31-4dda-b616-e429ba1e78a8	true	id.token.claim
55509656-7b31-4dda-b616-e429ba1e78a8	true	access.token.claim
55509656-7b31-4dda-b616-e429ba1e78a8	picture	claim.name
55509656-7b31-4dda-b616-e429ba1e78a8	String	jsonType.label
582f2db6-5c03-4ada-a261-94029788b65b	true	introspection.token.claim
582f2db6-5c03-4ada-a261-94029788b65b	true	userinfo.token.claim
582f2db6-5c03-4ada-a261-94029788b65b	updatedAt	user.attribute
582f2db6-5c03-4ada-a261-94029788b65b	true	id.token.claim
582f2db6-5c03-4ada-a261-94029788b65b	true	access.token.claim
582f2db6-5c03-4ada-a261-94029788b65b	updated_at	claim.name
582f2db6-5c03-4ada-a261-94029788b65b	long	jsonType.label
5938e90f-ca2c-4930-8745-5b12a33cb8b5	true	introspection.token.claim
5938e90f-ca2c-4930-8745-5b12a33cb8b5	true	userinfo.token.claim
5938e90f-ca2c-4930-8745-5b12a33cb8b5	firstName	user.attribute
5938e90f-ca2c-4930-8745-5b12a33cb8b5	true	id.token.claim
5938e90f-ca2c-4930-8745-5b12a33cb8b5	true	access.token.claim
5938e90f-ca2c-4930-8745-5b12a33cb8b5	given_name	claim.name
5938e90f-ca2c-4930-8745-5b12a33cb8b5	String	jsonType.label
59441b33-ec8b-4587-ae24-b34aeb4161cc	true	id.token.claim
59441b33-ec8b-4587-ae24-b34aeb4161cc	true	introspection.token.claim
59441b33-ec8b-4587-ae24-b34aeb4161cc	true	access.token.claim
59441b33-ec8b-4587-ae24-b34aeb4161cc	true	userinfo.token.claim
7e75d078-ee35-4795-adcb-3fe6ca974158	true	introspection.token.claim
7e75d078-ee35-4795-adcb-3fe6ca974158	true	userinfo.token.claim
7e75d078-ee35-4795-adcb-3fe6ca974158	birthdate	user.attribute
7e75d078-ee35-4795-adcb-3fe6ca974158	true	id.token.claim
7e75d078-ee35-4795-adcb-3fe6ca974158	true	access.token.claim
7e75d078-ee35-4795-adcb-3fe6ca974158	birthdate	claim.name
7e75d078-ee35-4795-adcb-3fe6ca974158	String	jsonType.label
8464b464-4b84-48ae-9f56-b64086de3d03	true	introspection.token.claim
8464b464-4b84-48ae-9f56-b64086de3d03	true	userinfo.token.claim
8464b464-4b84-48ae-9f56-b64086de3d03	profile	user.attribute
8464b464-4b84-48ae-9f56-b64086de3d03	true	id.token.claim
8464b464-4b84-48ae-9f56-b64086de3d03	true	access.token.claim
8464b464-4b84-48ae-9f56-b64086de3d03	profile	claim.name
8464b464-4b84-48ae-9f56-b64086de3d03	String	jsonType.label
9d16a06b-db1f-4271-9998-8597d9f051bd	true	introspection.token.claim
9d16a06b-db1f-4271-9998-8597d9f051bd	true	userinfo.token.claim
9d16a06b-db1f-4271-9998-8597d9f051bd	website	user.attribute
9d16a06b-db1f-4271-9998-8597d9f051bd	true	id.token.claim
9d16a06b-db1f-4271-9998-8597d9f051bd	true	access.token.claim
9d16a06b-db1f-4271-9998-8597d9f051bd	website	claim.name
9d16a06b-db1f-4271-9998-8597d9f051bd	String	jsonType.label
a0fd209d-9e92-4e36-986e-eae2567da487	true	introspection.token.claim
a0fd209d-9e92-4e36-986e-eae2567da487	true	userinfo.token.claim
a0fd209d-9e92-4e36-986e-eae2567da487	middleName	user.attribute
a0fd209d-9e92-4e36-986e-eae2567da487	true	id.token.claim
a0fd209d-9e92-4e36-986e-eae2567da487	true	access.token.claim
a0fd209d-9e92-4e36-986e-eae2567da487	middle_name	claim.name
a0fd209d-9e92-4e36-986e-eae2567da487	String	jsonType.label
d8511fda-b96b-4e0d-a41a-bce0b48dd45e	true	introspection.token.claim
d8511fda-b96b-4e0d-a41a-bce0b48dd45e	true	userinfo.token.claim
d8511fda-b96b-4e0d-a41a-bce0b48dd45e	gender	user.attribute
d8511fda-b96b-4e0d-a41a-bce0b48dd45e	true	id.token.claim
d8511fda-b96b-4e0d-a41a-bce0b48dd45e	true	access.token.claim
d8511fda-b96b-4e0d-a41a-bce0b48dd45e	gender	claim.name
d8511fda-b96b-4e0d-a41a-bce0b48dd45e	String	jsonType.label
fe4bb4c7-30fb-4c33-af22-c9a39a81b461	true	introspection.token.claim
fe4bb4c7-30fb-4c33-af22-c9a39a81b461	true	userinfo.token.claim
fe4bb4c7-30fb-4c33-af22-c9a39a81b461	username	user.attribute
fe4bb4c7-30fb-4c33-af22-c9a39a81b461	true	id.token.claim
fe4bb4c7-30fb-4c33-af22-c9a39a81b461	true	access.token.claim
fe4bb4c7-30fb-4c33-af22-c9a39a81b461	preferred_username	claim.name
fe4bb4c7-30fb-4c33-af22-c9a39a81b461	String	jsonType.label
74281cad-a98b-4207-b5a0-ee1ff74c10ed	true	introspection.token.claim
74281cad-a98b-4207-b5a0-ee1ff74c10ed	true	userinfo.token.claim
74281cad-a98b-4207-b5a0-ee1ff74c10ed	emailVerified	user.attribute
74281cad-a98b-4207-b5a0-ee1ff74c10ed	true	id.token.claim
74281cad-a98b-4207-b5a0-ee1ff74c10ed	true	access.token.claim
74281cad-a98b-4207-b5a0-ee1ff74c10ed	email_verified	claim.name
74281cad-a98b-4207-b5a0-ee1ff74c10ed	boolean	jsonType.label
8dd687ec-2e8d-4e06-9170-6c57887c9c4e	true	introspection.token.claim
8dd687ec-2e8d-4e06-9170-6c57887c9c4e	true	userinfo.token.claim
8dd687ec-2e8d-4e06-9170-6c57887c9c4e	email	user.attribute
8dd687ec-2e8d-4e06-9170-6c57887c9c4e	true	id.token.claim
8dd687ec-2e8d-4e06-9170-6c57887c9c4e	true	access.token.claim
8dd687ec-2e8d-4e06-9170-6c57887c9c4e	email	claim.name
8dd687ec-2e8d-4e06-9170-6c57887c9c4e	String	jsonType.label
9cb1d336-db72-47df-96f1-139e8a8dacf5	true	introspection.token.claim
9cb1d336-db72-47df-96f1-139e8a8dacf5	true	access.token.claim
26231f7f-8291-4afc-8978-4af5b78a946c	true	id.token.claim
26231f7f-8291-4afc-8978-4af5b78a946c	true	introspection.token.claim
26231f7f-8291-4afc-8978-4af5b78a946c	true	access.token.claim
26231f7f-8291-4afc-8978-4af5b78a946c	true	userinfo.token.claim
0a290c5e-8ba9-43c6-83c2-62c66985dcab	clientHost	user.session.note
0a290c5e-8ba9-43c6-83c2-62c66985dcab	true	introspection.token.claim
0a290c5e-8ba9-43c6-83c2-62c66985dcab	true	userinfo.token.claim
0a290c5e-8ba9-43c6-83c2-62c66985dcab	true	id.token.claim
0a290c5e-8ba9-43c6-83c2-62c66985dcab	true	access.token.claim
0a290c5e-8ba9-43c6-83c2-62c66985dcab	clientHost	claim.name
0a290c5e-8ba9-43c6-83c2-62c66985dcab	String	jsonType.label
4daca983-97ab-463a-8855-de18cf6a889a	client_id	user.session.note
4daca983-97ab-463a-8855-de18cf6a889a	true	introspection.token.claim
4daca983-97ab-463a-8855-de18cf6a889a	true	id.token.claim
4daca983-97ab-463a-8855-de18cf6a889a	true	access.token.claim
4daca983-97ab-463a-8855-de18cf6a889a	client_id	claim.name
4daca983-97ab-463a-8855-de18cf6a889a	String	jsonType.label
ba11d7ec-d170-4d11-b1ab-a484f50f36c8	clientAddress	user.session.note
ba11d7ec-d170-4d11-b1ab-a484f50f36c8	true	introspection.token.claim
ba11d7ec-d170-4d11-b1ab-a484f50f36c8	true	id.token.claim
ba11d7ec-d170-4d11-b1ab-a484f50f36c8	true	access.token.claim
ba11d7ec-d170-4d11-b1ab-a484f50f36c8	clientAddress	claim.name
ba11d7ec-d170-4d11-b1ab-a484f50f36c8	String	jsonType.label
4daca983-97ab-463a-8855-de18cf6a889a	true	userinfo.token.claim
ba11d7ec-d170-4d11-b1ab-a484f50f36c8	true	userinfo.token.claim
2ecc1714-2948-424d-9a83-2ee377299648	clientHost	user.session.note
2ecc1714-2948-424d-9a83-2ee377299648	true	userinfo.token.claim
2ecc1714-2948-424d-9a83-2ee377299648	true	id.token.claim
2ecc1714-2948-424d-9a83-2ee377299648	true	access.token.claim
2ecc1714-2948-424d-9a83-2ee377299648	clientHost	claim.name
2ecc1714-2948-424d-9a83-2ee377299648	String	jsonType.label
9a6197a4-172d-4b95-9d66-e0a1a3512408	clientAddress	user.session.note
9a6197a4-172d-4b95-9d66-e0a1a3512408	true	userinfo.token.claim
9a6197a4-172d-4b95-9d66-e0a1a3512408	true	id.token.claim
9a6197a4-172d-4b95-9d66-e0a1a3512408	true	access.token.claim
9a6197a4-172d-4b95-9d66-e0a1a3512408	clientAddress	claim.name
9a6197a4-172d-4b95-9d66-e0a1a3512408	String	jsonType.label
de6c6136-509c-449d-b033-2f9cf3139128	client_id	user.session.note
de6c6136-509c-449d-b033-2f9cf3139128	true	userinfo.token.claim
de6c6136-509c-449d-b033-2f9cf3139128	true	id.token.claim
de6c6136-509c-449d-b033-2f9cf3139128	true	access.token.claim
de6c6136-509c-449d-b033-2f9cf3139128	client_id	claim.name
de6c6136-509c-449d-b033-2f9cf3139128	String	jsonType.label
a26df5ce-dd43-4898-9fff-ab57d5f6722b	true	introspection.token.claim
a26df5ce-dd43-4898-9fff-ab57d5f6722b	true	userinfo.token.claim
a26df5ce-dd43-4898-9fff-ab57d5f6722b	locale	user.attribute
a26df5ce-dd43-4898-9fff-ab57d5f6722b	true	id.token.claim
a26df5ce-dd43-4898-9fff-ab57d5f6722b	true	access.token.claim
a26df5ce-dd43-4898-9fff-ab57d5f6722b	locale	claim.name
a26df5ce-dd43-4898-9fff-ab57d5f6722b	String	jsonType.label
8247a0e6-a0cd-488f-9078-a297aa90b72d	clientAddress	user.session.note
8247a0e6-a0cd-488f-9078-a297aa90b72d	true	introspection.token.claim
8247a0e6-a0cd-488f-9078-a297aa90b72d	true	id.token.claim
8247a0e6-a0cd-488f-9078-a297aa90b72d	true	access.token.claim
8247a0e6-a0cd-488f-9078-a297aa90b72d	clientAddress	claim.name
8247a0e6-a0cd-488f-9078-a297aa90b72d	String	jsonType.label
88ca6477-af04-40ca-b4ea-fc40c14896fd	client_id	user.session.note
88ca6477-af04-40ca-b4ea-fc40c14896fd	true	introspection.token.claim
88ca6477-af04-40ca-b4ea-fc40c14896fd	true	id.token.claim
88ca6477-af04-40ca-b4ea-fc40c14896fd	true	access.token.claim
88ca6477-af04-40ca-b4ea-fc40c14896fd	client_id	claim.name
88ca6477-af04-40ca-b4ea-fc40c14896fd	String	jsonType.label
8ba05efe-b1b0-48cd-b08c-146676659a48	clientHost	user.session.note
8ba05efe-b1b0-48cd-b08c-146676659a48	true	introspection.token.claim
8ba05efe-b1b0-48cd-b08c-146676659a48	true	id.token.claim
8ba05efe-b1b0-48cd-b08c-146676659a48	true	access.token.claim
8ba05efe-b1b0-48cd-b08c-146676659a48	clientHost	claim.name
8ba05efe-b1b0-48cd-b08c-146676659a48	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	2a9d8d7d-0632-45ba-81e5-d3004f154c05	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	b662bb52-8752-4436-9830-66c58bd9bd1e	f2dc4d8d-c82b-4307-8812-a9dfc2e42693	104bf34e-4bb0-4433-b099-35787b0ef7c4	73ede839-e1d9-43a1-a45f-911106608732	2f752cb8-e355-41c9-ab43-19aeea0f7a2d	2592000	f	900	t	f	7d9b6ac1-d0dc-4cbd-8ff9-846b268bbd89	0	f	0	0	ebfdfecb-dbee-412b-8fe5-d40584b91632
offices	60	300	300	\N	\N	\N	t	f	0	keycloak	offices	0	\N	f	f	f	f	NONE	1800	36000	f	f	a3e25a70-28ee-4897-ada2-4d9921fe2e25	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	37675020-4b7c-42ba-a54d-959a5a8734db	76cb6cb9-165e-4993-9ef5-e85b0d07a96c	a65dcfc2-812a-4ef5-917b-75cfdae3bee8	d61d4b2d-c9f7-4d93-8ff2-60af08a39298	c93ad727-b757-4078-b220-369010d91f47	2592000	f	900	t	f	38266e43-4444-404e-ab34-48053725042c	0	f	0	0	9039b1a0-c01c-43eb-8137-dd05612a071b
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	
_browser_header.xContentTypeOptions	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	nosniff
_browser_header.referrerPolicy	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	no-referrer
_browser_header.xRobotsTag	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	none
_browser_header.xFrameOptions	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	SAMEORIGIN
_browser_header.contentSecurityPolicy	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	1; mode=block
_browser_header.strictTransportSecurity	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	max-age=31536000; includeSubDomains
bruteForceProtected	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	false
permanentLockout	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	false
maxFailureWaitSeconds	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	900
minimumQuickLoginWaitSeconds	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	60
waitIncrementSeconds	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	60
quickLoginCheckMilliSeconds	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	1000
maxDeltaTimeSeconds	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	43200
failureFactor	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	30
realmReusableOtpCode	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	false
displayName	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	Keycloak
displayNameHtml	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	RS256
offlineSessionMaxLifespanEnabled	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	false
offlineSessionMaxLifespan	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	5184000
_browser_header.contentSecurityPolicyReportOnly	offices	
_browser_header.xContentTypeOptions	offices	nosniff
_browser_header.referrerPolicy	offices	no-referrer
_browser_header.xRobotsTag	offices	none
_browser_header.xFrameOptions	offices	SAMEORIGIN
_browser_header.contentSecurityPolicy	offices	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	offices	1; mode=block
_browser_header.strictTransportSecurity	offices	max-age=31536000; includeSubDomains
permanentLockout	offices	false
maxFailureWaitSeconds	offices	900
minimumQuickLoginWaitSeconds	offices	60
waitIncrementSeconds	offices	60
quickLoginCheckMilliSeconds	offices	1000
maxDeltaTimeSeconds	offices	43200
failureFactor	offices	30
realmReusableOtpCode	offices	false
bruteForceProtected	offices	true
defaultSignatureAlgorithm	offices	RS256
offlineSessionMaxLifespanEnabled	offices	false
offlineSessionMaxLifespan	offices	5184000
clientSessionIdleTimeout	offices	0
clientSessionMaxLifespan	offices	0
clientOfflineSessionIdleTimeout	offices	0
clientOfflineSessionMaxLifespan	offices	0
actionTokenGeneratedByAdminLifespan	offices	43200
actionTokenGeneratedByUserLifespan	offices	300
oauth2DeviceCodeLifespan	offices	600
oauth2DevicePollingInterval	offices	5
webAuthnPolicyRpEntityName	offices	keycloak
webAuthnPolicySignatureAlgorithms	offices	ES256
webAuthnPolicyRpId	offices	
webAuthnPolicyAttestationConveyancePreference	offices	not specified
webAuthnPolicyAuthenticatorAttachment	offices	not specified
webAuthnPolicyRequireResidentKey	offices	not specified
webAuthnPolicyUserVerificationRequirement	offices	not specified
webAuthnPolicyCreateTimeout	offices	0
webAuthnPolicyAvoidSameAuthenticatorRegister	offices	false
webAuthnPolicyRpEntityNamePasswordless	offices	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	offices	ES256
webAuthnPolicyRpIdPasswordless	offices	
webAuthnPolicyAttestationConveyancePreferencePasswordless	offices	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	offices	not specified
webAuthnPolicyRequireResidentKeyPasswordless	offices	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	offices	not specified
webAuthnPolicyCreateTimeoutPasswordless	offices	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	offices	false
cibaBackchannelTokenDeliveryMode	offices	poll
cibaExpiresIn	offices	120
cibaInterval	offices	5
cibaAuthRequestedUserHint	offices	login_hint
parRequestUriLifespan	offices	60
client-policies.profiles	offices	{"profiles":[]}
client-policies.policies	offices	{"policies":[]}
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	jboss-logging
offices	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3
password	password	t	t	offices
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.redirect_uris (client_id, value) FROM stdin;
b81fb2f6-6d68-47c7-a8c9-05749088eb42	/realms/master/account/*
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	/realms/master/account/*
74dca843-fbea-4237-bbe3-98c0804778dc	/admin/master/console/*
68e03bd4-6a95-4b73-98ff-2689bafac727	/realms/offices/account/*
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	/realms/offices/account/*
7ea9781f-d754-49b5-8e4d-27881873d893	/admin/offices/console/*
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
76b04810-3e42-494a-9e6c-d3ecc0c84fac	VERIFY_EMAIL	Verify Email	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	t	f	VERIFY_EMAIL	50
aa8163ba-e791-44f1-8f25-71eb56efc068	UPDATE_PROFILE	Update Profile	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	t	f	UPDATE_PROFILE	40
86e0fff5-4bd8-4199-aa5c-ab46aad6d7db	CONFIGURE_TOTP	Configure OTP	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	t	f	CONFIGURE_TOTP	10
81ccf05d-2660-4c58-a72d-bd3e42ea2506	UPDATE_PASSWORD	Update Password	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	t	f	UPDATE_PASSWORD	30
8913a18e-6c78-4b7d-b43e-64632e2e4101	TERMS_AND_CONDITIONS	Terms and Conditions	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	f	f	TERMS_AND_CONDITIONS	20
b48c1d44-e9cc-4aad-8a16-3e75e3ab627a	delete_account	Delete Account	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	f	f	delete_account	60
1b6900dd-acc6-431a-a231-e2b972af1d24	update_user_locale	Update User Locale	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	t	f	update_user_locale	1000
cef377a5-0da0-4303-a294-2185c9d2818c	webauthn-register	Webauthn Register	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	t	f	webauthn-register	70
d16d09e2-e8e3-4138-b34d-70689193c864	webauthn-register-passwordless	Webauthn Register Passwordless	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	t	f	webauthn-register-passwordless	80
9b194899-446d-41b8-a130-7c9a58df05cb	CONFIGURE_TOTP	Configure OTP	offices	t	f	CONFIGURE_TOTP	10
75a697f7-97d4-44f9-ad5c-6604328f7bdc	TERMS_AND_CONDITIONS	Terms and Conditions	offices	f	f	TERMS_AND_CONDITIONS	20
bac4db53-97c2-4d68-a257-fb211d3cdc46	UPDATE_PASSWORD	Update Password	offices	t	f	UPDATE_PASSWORD	30
e54b5cd3-a0a9-4e2e-b665-d88b254dc544	UPDATE_PROFILE	Update Profile	offices	t	f	UPDATE_PROFILE	40
8340ba19-a0bb-4a6c-8c2a-b48605c9fc22	VERIFY_EMAIL	Verify Email	offices	t	f	VERIFY_EMAIL	50
758a69eb-be08-4fea-b2fc-64bbb6579100	delete_account	Delete Account	offices	f	f	delete_account	60
7450ea62-847b-4bf7-997a-248ad587d38f	webauthn-register	Webauthn Register	offices	t	f	webauthn-register	70
428b3e4a-6ce8-4640-9203-cd7af17d4f0d	webauthn-register-passwordless	Webauthn Register Passwordless	offices	t	f	webauthn-register-passwordless	80
bfb392eb-6339-4508-ad8c-bce9223dcf65	update_user_locale	Update User Locale	offices	t	f	update_user_locale	1000
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	44296b4e-180b-4c84-a77e-a4b40ceb8722
b6622bd7-bbb6-4199-9ed3-d13f60ad8695	2a602f42-f1da-4c55-8802-672a9007deda
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	0a06f480-a9b9-4180-a74b-c4947189909f
20dfbc67-fe4d-4b10-9f61-ad32477c50c2	f570dcaa-d58d-42a7-9f61-593b363393a2
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_attribute (name, value, user_id, id) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
75b541da-6555-42d7-89ce-c91db770f891	\N	ade9b459-ff59-49ec-9463-45bf05475421	f	t	\N	\N	\N	offices	service-account-admin-cli	1715889436129	6bd58108-7661-4b77-a966-0c820613deef	0
91da198a-364c-4f0c-b87c-4deaa31d184d	\N	bee864ce-8982-4026-8549-f2c6ef9d639a	f	t	\N	\N	\N	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	admin	1716228417280	\N	0
6332ed27-f4f3-4b16-92ac-b07fd0f89052	\N	4080bcdf-d536-43a1-84d7-7244949e6caa	f	t	\N	\N	\N	147fb5d8-1c48-45bf-b0fe-f7af521e2dc3	service-account-admin-cli	1716228516487	48daad2a-6675-4d49-967d-13b861c8bc6c	0
705050f8-38b5-4348-99cf-cb2b76d0e887	user@cc.com	user@cc.com	t	t	\N	\N	\N	offices	user@cc.com	1716228754015	\N	0
4ad9a9e3-429f-4663-af24-b1a8e2d0fde2	admin@cc.com	admin@cc.com	t	t	\N	\N	\N	offices	admin@cc.com	1716228754015	\N	0
c4330233-c295-4022-a5d8-68b30063b191	\N	960044b6-27d8-4469-8bdf-7f541583b9cc	f	t	\N	\N	\N	offices	service-account-offices	1718633997845	\N	0
2f2d5c86-8573-467f-94dd-d83642e5fdd3	admin.bart@cc.com	admin.bart@cc.com	t	t	\N	bart	simpson	offices	admin.bart@cc.com	1718633998056	\N	0
dcae3b6a-42c5-4b70-b4fa-b2c59fca2290	user.lisa@cc.com	user.lisa@cc.com	t	t	\N	lisa	simpson	offices	user.lisa@cc.com	1718633998090	\N	0
b521d35c-170b-4abf-ba56-e7e24cfda52e	user.maggy@cc.com	user.maggy@cc.com	t	t	\N	maggy	simpson	offices	user.maggy@cc.com	1718633998104	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
9039b1a0-c01c-43eb-8137-dd05612a071b	75b541da-6555-42d7-89ce-c91db770f891
ebfdfecb-dbee-412b-8fe5-d40584b91632	91da198a-364c-4f0c-b87c-4deaa31d184d
502c6d7c-71f7-4ffb-adf5-4b4264a487a2	91da198a-364c-4f0c-b87c-4deaa31d184d
ebfdfecb-dbee-412b-8fe5-d40584b91632	6332ed27-f4f3-4b16-92ac-b07fd0f89052
ae4aff55-fca5-4972-a7a9-0ac7e75e7bb7	6332ed27-f4f3-4b16-92ac-b07fd0f89052
47844524-f903-45cc-ba9b-36d1e77f281f	6332ed27-f4f3-4b16-92ac-b07fd0f89052
70c1c8ed-8d7d-4827-b4a0-37fc8a6f31d7	6332ed27-f4f3-4b16-92ac-b07fd0f89052
20732c36-1814-409c-876a-68fdb62f1e41	6332ed27-f4f3-4b16-92ac-b07fd0f89052
6173522b-f397-4cd8-b3f2-8d94df8efc4b	6332ed27-f4f3-4b16-92ac-b07fd0f89052
b8267090-8314-4ae6-92c7-9fd6b4b716e4	6332ed27-f4f3-4b16-92ac-b07fd0f89052
ba799e64-216c-404b-b624-7225b6d3d2a2	6332ed27-f4f3-4b16-92ac-b07fd0f89052
1505045d-5d89-4dcc-b134-03316c5bc2e9	6332ed27-f4f3-4b16-92ac-b07fd0f89052
b753a528-b7c0-4ccc-ace2-9320a74302fa	6332ed27-f4f3-4b16-92ac-b07fd0f89052
3c9f314c-3bc1-499a-ad2e-f23972af1b7d	6332ed27-f4f3-4b16-92ac-b07fd0f89052
08b79176-10db-4167-9853-caa819dfc751	6332ed27-f4f3-4b16-92ac-b07fd0f89052
5ede22bd-4b07-4d7d-a9ec-500463408741	6332ed27-f4f3-4b16-92ac-b07fd0f89052
0176c677-f9da-4834-a9fa-3dd4f2a05d71	6332ed27-f4f3-4b16-92ac-b07fd0f89052
dc8abe84-20c8-479c-8d28-2054f4484e15	6332ed27-f4f3-4b16-92ac-b07fd0f89052
d01ac481-532e-4ffb-80cf-369e1222acf4	6332ed27-f4f3-4b16-92ac-b07fd0f89052
706f3d0b-d1b7-4177-a831-2bc60dd3f1e4	6332ed27-f4f3-4b16-92ac-b07fd0f89052
2d337072-95e4-4021-94f3-284867e77df1	6332ed27-f4f3-4b16-92ac-b07fd0f89052
8b79a9cb-9f90-483b-b90f-aa6f388803ec	6332ed27-f4f3-4b16-92ac-b07fd0f89052
132b8e8a-576f-431c-abaa-480f515f399e	6332ed27-f4f3-4b16-92ac-b07fd0f89052
76c6b6d6-001d-4b27-aaa2-0680ff08b38b	6332ed27-f4f3-4b16-92ac-b07fd0f89052
577a1e56-0260-4aca-bcad-7215865da4b4	6332ed27-f4f3-4b16-92ac-b07fd0f89052
889c672e-8f44-46e1-9c99-cb260879272c	6332ed27-f4f3-4b16-92ac-b07fd0f89052
60fec3d0-518c-4e51-b0fa-dd3a160a158e	6332ed27-f4f3-4b16-92ac-b07fd0f89052
430f90cb-c450-46ff-b37f-190e482c19c4	6332ed27-f4f3-4b16-92ac-b07fd0f89052
565c1deb-a128-4562-ad8a-f0a31b99815a	6332ed27-f4f3-4b16-92ac-b07fd0f89052
40144513-d08b-420a-9c82-7052de88ff79	6332ed27-f4f3-4b16-92ac-b07fd0f89052
07a28fb6-df7f-4eb1-940d-c5335da5f918	6332ed27-f4f3-4b16-92ac-b07fd0f89052
4f16ba6c-1f45-4101-980e-ce427ecd0e50	6332ed27-f4f3-4b16-92ac-b07fd0f89052
f81aa07d-98b3-4b83-a767-997e52031a86	6332ed27-f4f3-4b16-92ac-b07fd0f89052
625810f4-4124-4135-87a5-edabcaeadea8	6332ed27-f4f3-4b16-92ac-b07fd0f89052
e1c897a7-1a24-47ad-8257-3fc3f88e0204	6332ed27-f4f3-4b16-92ac-b07fd0f89052
85e16d9a-57df-4cf1-b9de-22688a6b7b94	6332ed27-f4f3-4b16-92ac-b07fd0f89052
c93a26fd-c51b-49e3-95f8-3e90ca059816	6332ed27-f4f3-4b16-92ac-b07fd0f89052
0164bfbf-94b4-482f-ab4a-501a6132e592	6332ed27-f4f3-4b16-92ac-b07fd0f89052
011e6874-7523-45f8-a67f-0bf4385b963c	6332ed27-f4f3-4b16-92ac-b07fd0f89052
d9fd4479-6641-449e-97a3-5c8c42a414e2	6332ed27-f4f3-4b16-92ac-b07fd0f89052
635e98b7-3d02-48a5-85a8-beefe16e146c	6332ed27-f4f3-4b16-92ac-b07fd0f89052
2a602f42-f1da-4c55-8802-672a9007deda	6332ed27-f4f3-4b16-92ac-b07fd0f89052
fa5c3341-4fe0-4579-b29d-e48b3ac3058a	6332ed27-f4f3-4b16-92ac-b07fd0f89052
9220f7d1-a64d-493b-9385-a175a47152ad	6332ed27-f4f3-4b16-92ac-b07fd0f89052
4583ad1a-e2b2-4dd5-88e8-f0426091e779	6332ed27-f4f3-4b16-92ac-b07fd0f89052
6bd0903e-f066-4987-b8c1-c73ec9132d69	6332ed27-f4f3-4b16-92ac-b07fd0f89052
7645b6e4-cb5e-47e5-b70e-0d68991c3a60	6332ed27-f4f3-4b16-92ac-b07fd0f89052
44296b4e-180b-4c84-a77e-a4b40ceb8722	6332ed27-f4f3-4b16-92ac-b07fd0f89052
fdeddaae-5ae4-4105-9933-1ce170953842	6332ed27-f4f3-4b16-92ac-b07fd0f89052
9039b1a0-c01c-43eb-8137-dd05612a071b	705050f8-38b5-4348-99cf-cb2b76d0e887
9039b1a0-c01c-43eb-8137-dd05612a071b	4ad9a9e3-429f-4663-af24-b1a8e2d0fde2
9039b1a0-c01c-43eb-8137-dd05612a071b	c4330233-c295-4022-a5d8-68b30063b191
9039b1a0-c01c-43eb-8137-dd05612a071b	2f2d5c86-8573-467f-94dd-d83642e5fdd3
9039b1a0-c01c-43eb-8137-dd05612a071b	dcae3b6a-42c5-4b70-b4fa-b2c59fca2290
9039b1a0-c01c-43eb-8137-dd05612a071b	b521d35c-170b-4abf-ba56-e7e24cfda52e
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.web_origins (client_id, value) FROM stdin;
74dca843-fbea-4237-bbe3-98c0804778dc	+
7ea9781f-d754-49b5-8e4d-27881873d893	+
e19f251d-902a-4d0b-92ce-a1c7f2eb5008	/*
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_jkuwuvd56ontgsuhogm8uewrt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_css_preload; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_css_preload ON public.offline_client_session USING btree (client_id, offline_flag);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_offline_uss_by_usersess; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_usersess ON public.offline_user_session USING btree (realm_id, offline_flag, user_session_id);


--
-- Name: idx_offline_uss_createdon; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_createdon ON public.offline_user_session USING btree (created_on);


--
-- Name: idx_offline_uss_preload; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_preload ON public.offline_user_session USING btree (offline_flag, created_on, user_session_id);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

