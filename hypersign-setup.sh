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

wget https://github.com/hypermine-bc/hs-authenticator/releases/download/v1.0.1/hs-authenticator.tar.gz -O dist/hs-authenticator.tar.gz
docker cp dist/hs-authenticator.tar.gz "$(docker-compose -f docker-compose.yml ps -q keycloak)":/hs-authenticator.tar.gz

# echo -e "${BLUE_BG}Running keycloak web context script${NC}"
# docker-compose -f docker-compose.yml exec --user root keycloak sh /kc-webcontext.sh

echo -e "${BLUE_BG}Running hypersign keycloak setup script${NC}"
docker-compose -f docker-compose.yml exec --user root keycloak sh /hs-plugin-install.sh

echo -e "${BLUE_BG}Restarting keycloak server to apply changes${NC}"
docker-compose -f docker-compose.yml restart keycloak
docker ps

sleep 50

echo -e "${BLUE_BG}Running hypersign keycloak setting script${NC}"
docker-compose -f docker-compose.yml exec --user root keycloak sh /kc-configuration.sh

echo -e "${BLUE_BG}Cleanup${NC}"
docker-compose -f docker-compose.yml exec --user root keycloak rm -rf hs-authenticator*
# rm -rf dist
exit


