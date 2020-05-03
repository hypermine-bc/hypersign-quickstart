#!/bin/bash
###
# KEYCLOAK CONFIGURATION SCRIPT
# -----------------------------
# This script configures Hypersign authenticator (provided Hypersign plugin is already deployed using) 
# and creates client 'hs-api' in Keycloak
# Author: Vishwas Anand Bhushan
# Ref: https://github.com/keycloak/keycloak-documentation/blob/master/server_admin/topics/admin-cli.adoc
###
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BLUE_BG='\033[44m'
GREEN='\033[0;33m'  
YELLOW='\033[1;33m' 
NC='\033[0m' # No Color
GRAY='\033[0;37m'

KC_USERNAME="admin"
KC_PASSWORD="admin"
AUTH_FLOW_NAME="hs-auth-flow"
KCBASE="/opt/jboss/keycloak"
CONFIGPATH="/opt/jboss"

REDIRECT_URI=$1
CLIENT_ALIAS=$2
NO_PASSWORDLESS=$3

# set -e
echo -e "${BLUE_BG}KC-configuration setting script starts${NC}"

## Loging to keycloak
${KCBASE}/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user $KC_USERNAME --password $KC_PASSWORD
echo -e "${BLUE_BG}After log in${NC}"

if [ ${NO_PASSWORDLESS} -eq 0 ]
then
    ######################### HS Authenticator flow setting
    IF_HS_FLOW_NOT_PRESENT=$(${KCBASE}/kcadm.sh get authentication/flows --fields alias --format csv --noquotes  -r master 2>&1 | grep ${AUTH_FLOW_NAME})
    if [ -z "$IF_HS_FLOW_NOT_PRESENT" ]
    then
        echo -e "${GRAY}Creating flow: ${AUTH_FLOW_NAME} ${NC}"
        FLOW_ID=$(${KCBASE}/bin/kcadm.sh create authentication/flows -s alias=$AUTH_FLOW_NAME -s providerId=basic-flow -s  description=$AUTH_FLOW_NAME -s  topLevel=true  -s builtIn=false -r master 2>&1 | sed -n "s/^.*'\(.*\)'.*$/\1/ p")
        echo -e "${GREEN}Creation success: flowid = $FLOW_ID ${NC}"
    else
        echo -e "${YELLOW}hs-flow is already createad. so skipping...${NC}"
    fi  
    echo -e "${BLUE_BG}Done HS Authenticator ${NC}"
    ##################################################

    ######################### HS Authenticator flow execution setting
    IF_HSEXECUTION_NOT_PRESENT=$(${KCBASE}/bin/kcadm.sh get authentication/flows/$AUTH_FLOW_NAME/executions --fields displayName --format csv --noquotes -r master 2>&1 | grep -w  "HyperSign QRCode")
    if [ -z "$IF_HSEXECUTION_NOT_PRESENT" ]
    then
        echo -e "${GRAY}Creating execution: Hypersign QRCode in flow: ${AUTH_FLOW_NAME} ${NC}"
        EXECUTION_ID=$(${KCBASE}/bin/kcadm.sh create authentication/flows/$AUTH_FLOW_NAME/executions/execution -r master -s provider=hyerpsign-qrocde-authenticator -s requirement=REQUIRED  2>&1 | sed -n "s/^.*'\(.*\)'.*$/\1/ p")
        echo -e "${GREEN}Creation success: execid = $EXECUTION_ID ${NC}"

        echo -e "${GRAY}Updating execution: Hypersign QRCode${NC}"
        sed -i "s/EXECUTION_ID/$EXECUTION_ID/g" $CONFIGPATH/authenticator-flow-update.json
        ${KCBASE}/bin/kcadm.sh update authentication/flows/$AUTH_FLOW_NAME/executions -r master  -f $CONFIGPATH/authenticator-flow-update.json
    else
        echo -e "${YELLOW}Hypersign execution is already configured with $AUTH_FLOW_NAME authenticator flow. So skipping...${NC}"
    fi
    echo -e "${BLUE_BG}Done HS Authenticator flow execution ${NC}"
    echo -e "${BLUE_BG}Create/Update client start ${NC}"
    ##################################################

    cp $CONFIGPATH/client-create.json $CONFIGPATH/client-create-api.json
    cp $CONFIGPATH/client-update.json $CONFIGPATH/client-update-api.json

    ########################### Registering hs-api client
    (
        API_CLIENT_ALIAS="hs-api"
        sed -i "s/CLIENT_ALIAS/${API_CLIENT_ALIAS}/g" $CONFIGPATH/client-create-api.json
        IF_CLIENT_NOT_PRESENT=$(${KCBASE}/bin/kcadm.sh get clients -r master --fields clientId --format csv --noquotes 2>&1 | grep -w ${API_CLIENT_ALIAS})
        if [ -z "$IF_CLIENT_NOT_PRESENT" ]
        then
            echo -e "${GRAY}Creating client ${API_CLIENT_ALIAS} ${NC}"
            CLIENT_ID=$(${KCBASE}/bin/kcadm.sh create clients -r master -f $CONFIGPATH/client-create-api.json  2>&1 | sed -n "s/^.*'\(.*\)'.*$/\1/ p")
            echo -e "${GREEN}Client ${API_CLIENT_ALIAS} creation success: clientid = $CLIENT_ID ${NC}"

            echo -e "${YELLOW}Updating client ${API_CLIENT_ALIAS} ...${NC}"
            sed -i "s/CLIENT_ID/$CLIENT_ID/g" $CONFIGPATH/client-update-api.json
            sed -i "s/FLOW_ID/$FLOW_ID/g" $CONFIGPATH/client-update-api.json
            sed -i "s/CLIENT_ALIAS/$API_CLIENT_ALIAS/g" $CONFIGPATH/client-update-api.json
            sed -i 's,VALID_REDIRECT_URI,/*,g' $CONFIGPATH/client-update-api.json
            ${KCBASE}/bin/kcadm.sh update clients/$CLIENT_ID -r master -f $CONFIGPATH/client-update-api.json
            echo -e "${YELLOW}Updating client ${API_CLIENT_ALIAS} ${NC}...${GREEN}done${NC}"
        else
            echo -e "${YELLOW}Client $API_CLIENT_ALIAS execution is already configured. So skipping...${NC}"
        fi   
    )
    ##################################################

else
  echo "--no-password-less option is set. So skipping hypersign plugin installation"
fi

########################### Registering your client
(
    sed -i "s/CLIENT_ALIAS/$CLIENT_ALIAS/g" $CONFIGPATH/client-create.json
    IF_CLIENT_NOT_PRESENT=$(${KCBASE}/bin/kcadm.sh get clients -r master --fields clientId --format csv --noquotes 2>&1 | grep -w ${CLIENT_ALIAS})
    if [ -z "$IF_CLIENT_NOT_PRESENT" ]
    then
        echo -e "Creating client ${CLIENT_ALIAS}... ${NC}"
        CLIENT_ID=$(${KCBASE}/bin/kcadm.sh create clients -r master -f $CONFIGPATH/client-create.json  2>&1 | sed -n "s/^.*'\(.*\)'.*$/\1/ p")
        echo -e "${GREEN}Client ${CLIENT_ALIAS} creation success: clientid = $CLIENT_ID ${NC}"

        echo -e "${YELLOW}Updating client ${CLIENT_ALIAS}...${NC}"
        sed -i "s/CLIENT_ID/$CLIENT_ID/g" $CONFIGPATH/client-update.json

        if [ ${NO_PASSWORDLESS} -eq 0 ] 
        then 
            FLOW_ID=$FLOW_ID
        else
            FLOW_ID=""
        fi
        sed -i "s/FLOW_ID/$FLOW_ID/g" $CONFIGPATH/client-update.json
        sed -i "s/CLIENT_ALIAS/$CLIENT_ALIAS/g" $CONFIGPATH/client-update.json
        sed -i "s,VALID_REDIRECT_URI,${REDIRECT_URI},g" $CONFIGPATH/client-update.json
        ${KCBASE}/bin/kcadm.sh update clients/$CLIENT_ID -r master -f $CONFIGPATH/client-update.json
        echo -e "${YELLOW}Updating client ${CLIENT_ALIAS} ${NC}...${GREEN}done${NC}"
    else
        echo -e "${YELLOW}Client $CLIENT_ALIAS execution is already configured. So skipping...${NC}"
    fi
    
)
##################################################
echo -e "${BLUE_BG}Create/Update client done ${NC}"


echo -e "${BLUE_BG}KC-configuration setting script finish${NC}"
exit



