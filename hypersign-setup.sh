#!/bin/bash

## default parameters
VERSION="v0.0.1"
REDIRECT_URI="http://localhost:8000/*"
CLIENT_ALIAS="sample-node-js-client"
NO_PASSWORDLESS=0

usage() {
    echo "Hypersign-setup runs and configure all required docker containers for integrating your client project with Hypersign authenticaion module"
    echo  
    echo "Syntax: hypersign-setup.sh -r <REDIRECT_URI> -a <CLIENT_ALIAS>"
    echo "Command line options:"
    echo "    -r    | --redirect-uri  URI     Redirect URI once the user is authenticated from Hypersign"
    echo "    -a    | --client-alias  ALIAS   Name of client you want to configure"
    echo "    -npls | --no-password-less      For legacy authentication method"
    echo "    -h    | --help                  Print this help menu"
    echo "    -V    | --version               Print current version"
    echo 
    echo "Example:"
    echo "    Configure Hypersign for client 'my-demo-client' running on localhost at port 8000"
    echo "        `basename $0` -r http://localhost:8000/* -a my-demo-client"
    echo 
}

## Warning for default parameters
if [ $# -eq 0 ]
then
    echo "WARNING: No arguments passed"
    echo "      Default parameters:"
    echo "          REDIRECT_URI:     ${REDIRECT_URI}"
    echo "          CLIENT_ALIAS:     ${CLIENT_ALIAS}"
    echo "          NO_PASSWORD_LESS: ${NO_PASSWORDLESS} ( 0 for password less, 1 for password )"
    echo

    while true; do
        read -p "Do you wish to continue with default paramaters? (y|n) " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -V | --version )
    echo "hypersign-setup ${VERSION}"
    exit
    ;;
  -h | --help )
    usage
    exit
    ;;
  -r | --redirect-uri )
    shift; REDIRECT_URI=$1
    ;;
  -a | --client-alias )
    shift; CLIENT_ALIAS=$1
    ;;
  -npls | --no-password-less )
    echo "You have opted for legacy authention mechanism"
    shift; NO_PASSWORDLESS=1
    ;;
  * ) # incorrect option
    echo "Error: Invalid option"
    exit;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi




## check for docker
DOCKER_CHECK=$(docker -v)
if [ -z  "${DOCKER_CHECK}" ]
then
    echo "Error: Docker is not installed. Please install docker before proceeding"
    echo
    exit
fi

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BLUE_BG='\033[44m'
YELLOW='\033[0;33m'  # Yellow
NC='\033[0m' # No Color

mkdir dist

echo -e "${BLUE_BG}Restarting docker containers...${NC}"
docker-compose -f docker-compose.yml config
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml up -d --remove-orphans

echo -e "${BLUE_BG}Copying required files into keycloak container...${NC}"
docker cp hs-script/kc-webcontext.sh "$(docker-compose -f docker-compose.yml ps -q keycloak)":/kc-webcontext.sh
docker cp hs-script/hs-plugin-install.sh "$(docker-compose -f docker-compose.yml ps -q keycloak)":/hs-plugin-install.sh
docker cp hs-script/kc-configuration.sh  "$(docker-compose -f docker-compose.yml ps -q keycloak)":/kc-configuration.sh

docker cp data-template/authenticator-flow-update.json "$(docker-compose -f docker-compose.yml ps -q keycloak)":/authenticator-flow-update.json
docker cp data-template/client-create.json  "$(docker-compose -f docker-compose.yml ps -q keycloak)":/client-create.json
docker cp data-template/client-update.json  "$(docker-compose -f docker-compose.yml ps -q keycloak)":/client-update.json

# echo -e "${BLUE_BG}Running keycloak web context script${NC}"
# docker-compose -f docker-compose.yml exec --user root keycloak sh /kc-webcontext.sh

if [ ${NO_PASSWORDLESS} -eq 0 ]
then
  wget https://github.com/hypermine-bc/hs-authenticator/releases/download/v1.0.2/hs-authenticator.tar.gz -O dist/hs-authenticator.tar.gz
  docker cp dist/hs-authenticator.tar.gz "$(docker-compose -f docker-compose.yml ps -q keycloak)":/hs-authenticator.tar.gz

  echo -e "${BLUE_BG}Running hypersign keycloak setup script${NC}"
  docker-compose -f docker-compose.yml exec --user root keycloak sh /hs-plugin-install.sh

  echo -e "${BLUE_BG}Restarting keycloak server to apply changes${NC}"
  docker-compose -f docker-compose.yml restart keycloak
  docker ps

  sleep 50
else
  echo "--no-password-less option is set. So skipping hypersign plugin installation"
  sleep 30
fi

echo -e "${BLUE_BG}Running hypersign keycloak setting script${NC}"
docker-compose -f docker-compose.yml exec --user root keycloak sh /kc-configuration.sh ${REDIRECT_URI} ${CLIENT_ALIAS} ${NO_PASSWORDLESS}

echo -e "${BLUE_BG}Cleanup${NC}"
docker-compose -f docker-compose.yml exec --user root keycloak rm -rf hs-authenticator* && rm -rf /*.json
# rm -rf dist
exit


