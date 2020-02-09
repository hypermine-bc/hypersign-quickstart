// Ref: https://github.com/keycloak/keycloak-nodejs-admin-client

const config = {
    HOSTURL : "http://localhost:8080",
    BASEPATH : "auth",
}

const hs_auth_flow = 'Hypersign-browser-flow'
const realm = '${realm}'
const AUTHENTICATION_EP = {
    flow :{
        create: {
            METHOD: `POST`,
            URL: `${config.HOSTURL}/${config.BASEPATH}/admin/realms/${realm}/authentication/flows`,
            PAY_LOAD: `{"alias":"${hs_auth_flow}","providerId":"basic-flow","description":"${hs_auth_flow}","topLevel":true,"builtIn":false}`
        },
        copy: {
            METHOD:`POST`,
            URL:`${config.HOSTURL}/${config.BASEPATH}/admin/realms/${realm}/authentication/flows/browser/copy`,
            PAY_LOAD:`{"newName":"${hs_auth_flow}"}`
        },
        get: {
            METHOD:`GET`,
            URL:`${config.HOSTURL}/${config.BASEPATH}/admin/realms/${realm}/authentication/flows/${hs_auth_flow}/executions`,
            RESP:`[{"id":"57d25c63-9af3-42c1-9123-5139ba5ea007","requirement":"ALTERNATIVE","displayName":"Cookie","requirementChoices":["REQUIRED","ALTERNATIVE","DISABLED"],"configurable":false,"providerId":"auth-cookie","level":0,"index":0},{"id":"11b9106c-07e2-4fdf-845e-6a435159e6d2","requirement":"DISABLED","displayName":"Kerberos","requirementChoices":["REQUIRED","ALTERNATIVE","DISABLED"],"configurable":false,"providerId":"auth-spnego","level":0,"index":1},{"id":"1a1b14e6-7df9-4370-9b51-68081eb6594b","requirement":"ALTERNATIVE","displayName":"Identity Provider Redirector","requirementChoices":["REQUIRED","ALTERNATIVE","DISABLED"],"configurable":true,"providerId":"identity-provider-redirector","level":0,"index":2},{"id":"50fd3847-5416-4e1d-877d-70ebbc2ecd74","requirement":"ALTERNATIVE","displayName":"Copy of browser1231313213 forms","requirementChoices":["REQUIRED","ALTERNATIVE","DISABLED","CONDITIONAL"],"configurable":false,"authenticationFlow":true,"flowId":"1112d7ac-d08c-4048-be09-bcf06bc6f3a7","level":0,"index":3},{"id":"14760402-f519-4b7b-bd5a-e4629c62bfe6","requirement":"REQUIRED","displayName":"Username Password Form","requirementChoices":["REQUIRED"],"configurable":false,"providerId":"auth-username-password-form","level":1,"index":0},{"id":"15b5352b-93cf-42d7-a7ba-0af775ac6797","requirement":"CONDITIONAL","displayName":"Copy of browser1231313213 Browser - Conditional OTP","requirementChoices":["REQUIRED","ALTERNATIVE","DISABLED","CONDITIONAL"],"configurable":false,"authenticationFlow":true,"flowId":"24c0ff3a-b962-446e-b643-0e48def8d312","level":1,"index":1},{"id":"5fafd804-7ac4-4640-b448-1712f08ba881","requirement":"REQUIRED","displayName":"Condition - user configured","requirementChoices":["REQUIRED","DISABLED"],"configurable":false,"providerId":"conditional-user-configured","level":2,"index":0},{"id":"d52ec40b-137e-4823-9b6b-9b2bf2ef2bfb","requirement":"REQUIRED","displayName":"OTP Form","requirementChoices":["REQUIRED","ALTERNATIVE","DISABLED"],"configurable":false,"providerId":"auth-otp-form","level":2,"index":1}]`
        },
    },
    execution: {
        delete: {
            METHOD:`DELETE`,
            URL:`${config.HOSTURL}/${config.BASEPATH}/admin/realms/${realm}/authentication/executions/b6692ca8-e19e-4e74-a73c-3d0d7ccb0948`
        },
        create: {
            METHOD:`POST`,
            URL:`${config.HOSTURL}/${config.BASEPATH}/admin/realms/${realm}/authentication/flows/${hs_auth_flow}/executions/execution`,
            PAY_LOAD:`{"provider":"hyerpsign-qrocde-authenticator"}`
        },        
        add: {
            METHOD: `POST`,
            URL: `${config.HOSTURL}/${config.BASEPATH}/admin/realms/${realm}/authentication/flows/${hs_auth_flow}/executions/execution`,
            PAY_LOAD: `{"provider":"hyerpsign-qrocde-authenticator"}`
        },
        update: {
            METHOD: `PUT`,
            URL: `${config.HOSTURL}/${config.BASEPATH}/admin/realms/${realm}/authentication/flows/${hs_auth_flow}/executions`,
            PAY_LOAD: `{"id":"e9c72065-7cb5-4b49-903f-49341c8931b5","requirement":"REQUIRED","displayName":"HyperSign QRCode","requirementChoices":["REQUIRED","DISABLED","ALTERNATIVE"],"configurable":true,"providerId":"hyerpsign-qrocde-authenticator","level":0,"index":0}`
        }
    } 
}

const CLIENT_EP = {
    get: {
        METHOD: 'GET',
        URL: `${config.HOSTURL}/${config.BASEPATH}/admin/realms/${realm}/clients`,
        RESP: '[{"id":"178f61ef-8001-401b-8317-e6bcf4dc827e","clientId":"hs-api","rootUrl":"/keycloak/auth/realms/${realm}/hypersign","surrogateAuthRequired":false,"enabled":true,"clientAuthenticatorType":"client-secret","redirectUris":["/"],"webOrigins":[],"notBefore":0,"bearerOnly":false,"consentRequired":false,"standardFlowEnabled":true,"implicitFlowEnabled":false,"directAccessGrantsEnabled":true,"serviceAccountsEnabled":false,"publicClient":true,"frontchannelLogout":false,"protocol":"openid-connect","attributes":{"saml.assertion.signature":"false","saml.force.post.binding":"false","saml.multivalued.roles":"false","saml.encrypt":"false","saml.server.signature":"false","saml.server.signature.keyinfo.ext":"false","exclude.session.state.from.auth.response":"false","saml_force_name_id_format":"false","saml.client.signature":"false","tls.client.certificate.bound.access.tokens":"false","saml.authnstatement":"false","display.on.consent.screen":"false","saml.onetimeuse.condition":"false"},"authenticationFlowBindingOverrides":{"direct_grant":"381263e3-c466-4992-ab10-b31f3ed8a9ae","browser":"381263e3-c466-4992-ab10-b31f3ed8a9ae"},"fullScopeAllowed":true,"nodeReRegistrationTimeout":-1,"defaultClientScopes":["web-origins","role_list","profile","roles","email"],"optionalClientScopes":["address","phone","offline_access","microprofile-jwt"],"access":{"view":true,"configure":true,"manage":true}},{"id":"e986aacd-5531-408c-a0fd-0c90bd38d2ff","clientId":"account","name":"${client_account}","rootUrl":"${authBaseUrl}","baseUrl":"/realms/${realm}/account/","surrogateAuthRequired":false,"enabled":true,"clientAuthenticatorType":"client-secret","defaultRoles":["view-profile","manage-account"],"redirectUris":["/realms/${realm}/account/*"],"webOrigins":[],"notBefore":0,"bearerOnly":false,"consentRequired":false,"standardFlowEnabled":true,"implicitFlowEnabled":false,"directAccessGrantsEnabled":false,"serviceAccountsEnabled":false,"publicClient":false,"frontchannelLogout":false,"protocol":"openid-connect","attributes":{},"authenticationFlowBindingOverrides":{},"fullScopeAllowed":false,"nodeReRegistrationTimeout":0,"defaultClientScopes":["web-origins","role_list","profile","roles","email"],"optionalClientScopes":["address","phone","offline_access","microprofile-jwt"],"access":{"view":true,"configure":true,"manage":true}},{"id":"e9915c2f-eb75-42aa-8aed-8da8c022fa57","clientId":"admin-cli","name":"${client_admin-cli}","surrogateAuthRequired":false,"enabled":true,"clientAuthenticatorType":"client-secret","redirectUris":[],"webOrigins":[],"notBefore":0,"bearerOnly":false,"consentRequired":false,"standardFlowEnabled":false,"implicitFlowEnabled":false,"directAccessGrantsEnabled":true,"serviceAccountsEnabled":false,"publicClient":true,"frontchannelLogout":false,"protocol":"openid-connect","attributes":{},"authenticationFlowBindingOverrides":{},"fullScopeAllowed":false,"nodeReRegistrationTimeout":0,"defaultClientScopes":["web-origins","role_list","profile","roles","email"],"optionalClientScopes":["address","phone","offline_access","microprofile-jwt"],"access":{"view":true,"configure":true,"manage":true}},{"id":"ecbe54ac-25b0-4a81-8cee-3349a8349c18","clientId":"${realm}-realm","name":"${realm} Realm","surrogateAuthRequired":false,"enabled":true,"clientAuthenticatorType":"client-secret","redirectUris":[],"webOrigins":[],"notBefore":0,"bearerOnly":true,"consentRequired":false,"standardFlowEnabled":true,"implicitFlowEnabled":false,"directAccessGrantsEnabled":false,"serviceAccountsEnabled":false,"publicClient":false,"frontchannelLogout":false,"attributes":{},"authenticationFlowBindingOverrides":{},"fullScopeAllowed":true,"nodeReRegistrationTimeout":0,"defaultClientScopes":["web-origins","role_list","profile","roles","email"],"optionalClientScopes":["address","phone","offline_access","microprofile-jwt"],"access":{"view":true,"configure":true,"manage":true}},{"id":"0c495f6f-53cf-4865-904d-b46baae1150b","clientId":"security-admin-console","name":"${client_security-admin-console}","rootUrl":"${authAdminUrl}","baseUrl":"/admin/${realm}/console/","surrogateAuthRequired":false,"enabled":true,"clientAuthenticatorType":"client-secret","redirectUris":["/admin/${realm}/console/*"],"webOrigins":["+"],"notBefore":0,"bearerOnly":false,"consentRequired":false,"standardFlowEnabled":true,"implicitFlowEnabled":false,"directAccessGrantsEnabled":false,"serviceAccountsEnabled":false,"publicClient":true,"frontchannelLogout":false,"protocol":"openid-connect","attributes":{},"authenticationFlowBindingOverrides":{},"fullScopeAllowed":false,"nodeReRegistrationTimeout":0,"protocolMappers":[{"id":"6c6d523e-d885-4461-a041-80ec2b3d5eb3","name":"locale","protocol":"openid-connect","protocolMapper":"oidc-usermodel-attribute-mapper","consentRequired":false,"config":{"userinfo.token.claim":"true","user.attribute":"locale","id.token.claim":"true","access.token.claim":"true","claim.name":"locale","jsonType.label":"String"}}],"defaultClientScopes":["web-origins","role_list","profile","roles","email"],"optionalClientScopes":["address","phone","offline_access","microprofile-jwt"],"access":{"view":true,"configure":true,"manage":true}},{"id":"eb68494e-4d5a-46ab-8ee4-a651029955b8","clientId":"broker","name":"${client_broker}","surrogateAuthRequired":false,"enabled":true,"clientAuthenticatorType":"client-secret","redirectUris":[],"webOrigins":[],"notBefore":0,"bearerOnly":false,"consentRequired":false,"standardFlowEnabled":true,"implicitFlowEnabled":false,"directAccessGrantsEnabled":false,"serviceAccountsEnabled":false,"publicClient":false,"frontchannelLogout":false,"protocol":"openid-connect","attributes":{},"authenticationFlowBindingOverrides":{},"fullScopeAllowed":false,"nodeReRegistrationTimeout":0,"defaultClientScopes":["web-origins","role_list","profile","roles","email"],"optionalClientScopes":["address","phone","offline_access","microprofile-jwt"],"access":{"view":true,"configure":true,"manage":true}}]'
    },
    create: {
        METHOD : 'POST',
        URL: `${config.HOSTURL}/${config.BASEPATH}/admin/realms/${realm}/clients`,
        PAY_LOAD: `{"enabled":true,"attributes":{},"redirectUris":[],"clientId":"hs-api","protocol":"openid-connect"}`
    },
    update: {
        METHOD:'PUT',
        URL: `${config.HOSTURL}/${config.BASEPATH}/admin/realms/${realm}/clients/178f61ef-8001-401b-8317-e6bcf4dc827e`,
        PAY_LOAD: `{"id":"178f61ef-8001-401b-8317-e6bcf4dc827e","clientId":"hs-api","rootUrl":"/keycloak/auth/realms/${realm}/hypersign","surrogateAuthRequired":false,"enabled":true,"clientAuthenticatorType":"client-secret","redirectUris":["/"],"webOrigins":[],"notBefore":0,"bearerOnly":false,"consentRequired":false,"standardFlowEnabled":true,"implicitFlowEnabled":false,"directAccessGrantsEnabled":true,"serviceAccountsEnabled":false,"publicClient":true,"frontchannelLogout":false,"protocol":"openid-connect","attributes":{"saml.assertion.signature":"false","saml.force.post.binding":"false","saml.multivalued.roles":"false","saml.encrypt":"false","saml.server.signature":"false","saml.server.signature.keyinfo.ext":"false","exclude.session.state.from.auth.response":"false","saml_force_name_id_format":"false","saml.client.signature":"false","tls.client.certificate.bound.access.tokens":"false","saml.authnstatement":"false","display.on.consent.screen":"false","saml.onetimeuse.condition":"false"},"authenticationFlowBindingOverrides":{"direct_grant":"381263e3-c466-4992-ab10-b31f3ed8a9ae","browser":"381263e3-c466-4992-ab10-b31f3ed8a9ae"},"fullScopeAllowed":true,"nodeReRegistrationTimeout":-1,"defaultClientScopes":["web-origins","role_list","profile","roles","email"],"optionalClientScopes":["address","phone","offline_access","microprofile-jwt"],"access":{"view":true,"configure":true,"manage":true},"authorizationServicesEnabled":""}`
    }
}

// https://github.com/keycloak/keycloak-nodejs-admin-client/blob/master/test/clients.spec.ts

