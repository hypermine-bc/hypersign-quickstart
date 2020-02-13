###
# KEYCLOAK CONFIGURATION SCRIPT
# -----------------------------
# This script configures Hypersign authenticator (provided Hypersign plugin is already deployed using) 
# and creates client 'hs-api' in Keycloak
# Author: Vishwas Anand Bhushan
# Ref: https://github.com/keycloak/keycloak-documentation/blob/master/server_admin/topics/admin-cli.adoc
###

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly BLUE='\033[0;34m'
readonly BLUE_BG='\033[44m'
readonly Yellow='\033[0;33m'  # Yellow
readonly NC='\033[0m' # No Color

readonly KC_USERNAME=admin
readonly KC_PASSWORD=admin
readonly AUTH_FLOW_NAME=hs-auth-flow
readonly CLIENT_ALIAS=hs-api
readonly KCBASE='/opt/jboss/keycloak'

set -e
echo -e "${BLUE_BG}KC-configuration setting script starts${NC}"


(
    .${KCBASE}/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user ${KC_USERNAME} --password ${KC_PASSWORD}
)

## HS Authenticator flow setting
(
    IF_HS_FLOW_NOT_PRESENT=$(./opt/jboss/keycloak/bin/kcadm.sh get authentication/flows --fields alias --format csv --noquotes  -r master 2>&1 | grep hs1-auth-flow)
    if [ -z "${IF_HS_FLOW_NOT_PRESENT}" ]
    then
        echo -e "${GREEN}Creating flow: ${AUTH_FLOW_NAME} ${NC}"
        FLOW_ID=$(.${KCBASE}/bin/kcadm.sh create authentication/flows -s alias=${AUTH_FLOW_NAME} -s providerId=basic-flow -s  description=${AUTH_FLOW_NAME} -s  topLevel=true  -s builtIn=false -r master 2>&1 | sed -n "s/^.*'\(.*\)'.*$/\1/ p")
        echo -e "${GREEN}Creation success: flowid = ${FLOW_ID} ${NC}"
    else
        echo -e "${YELLOW}hs-flow is already createad. so skipping...${NC}"
    fi  
)

(
    ## HS Authenticator flow execution setting
    IF_HSEXECUTION_NOT_PRESENT=$(.${KCBASE}/bin/kcadm.sh get authentication/flows/${AUTH_FLOW_NAME}/executions --fields displayName --format csv --noquotes -r master 2>&1 | grep -w  "HyperSign QRCode")
    if [ -z "${IF_HSEXECUTION_NOT_PRESENT}" ]
    then
        echo -e "${GREEN}Creating execution: Hypersign QRCode in flow: ${AUTH_FLOW_NAME} ${NC}"
        EXECUTION_ID=$(.${KCBASE}/bin/kcadm.sh create authentication/flows/${AUTH_FLOW_NAME}/executions/execution -r master -s provider=hyerpsign-qrocde-authenticator -s requirement=REQUIRED  2>&1 | sed -n "s/^.*'\(.*\)'.*$/\1/ p")
        echo -e "${GREEN}Creation success: execid = ${EXECUTION_ID} ${NC}"

        echo -e "${GREEN}Updating execution: Hypersign QRCode${NC}"
        sed -i "s/EXECUTION_ID/${EXECUTION_ID}/g" /authenticator-flow-update.json
        .${KCBASE}/bin/kcadm.sh update authentication/flows/${AUTH_FLOW_NAME}/executions -r master  -f /authenticator-flow-update.json
    else
        echo -e "${YELLOW}Hypersign execution is already configured with ${AUTH_FLOW_NAME} authenticator flow. So skipping...${NC}"
    fi
)

(
    ## HS-API client setting
    IF_CLIENT_NOT_PRESENT=$(.${KCBASE}/bin/kcadm.sh get clients -r master --fields clientId --format csv --noquotes 2>&1 | grep -w ${CLIENT_ALIAS})
    if [ -z "${IF_CLIENT_NOT_PRESENT}" ]
    then
        echo -e "${GREEN}Creating client: ${CLIENT_ID} ${NC}"
        CLIENT_ID=$(.${KCBASE}/bin/kcadm.sh create clients -r master -f /client-create.json  2>&1 | sed -n "s/^.*'\(.*\)'.*$/\1/ p")
        echo -e "${GREEN}Creation success: clientid = ${CLIENT_ID} ${NC}"

        sed -i "s/CLIENT_ID/${CLIENT_ID}/g" /client-update.json
        sed -i "s/FLOW_ID/${FLOW_ID}/g" /client-update.json
        sed -i "s/CLIENT_ALIAS/${CLIENT_ALIAS}/g" /client-update.json
        sed -i "s/CLIENT_ALIAS/${CLIENT_ALIAS}/g" /client-update.json
        echo -e "${GREEN}Updating client: ${CLIENT_ID} ${NC}"
        .${KCBASE}/bin/kcadm.sh update clients/${CLIENT_ID} -r master -f /client-update.json
    else
        echo -e "${YELLOW}Client ${CLIENT_ALIAS} execution is already configured. So skipping...${NC}"
    fi
)

echo -e "${BLUE_BG}KC-configuration setting script ends${NC}"

exit



