## reference https://stackoverflow.com/a/28938235/1851064
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BLUE_BG='\033[44m'
NC='\033[0m' # No Color

KCBASE='/opt/jboss/keycloak'

# exit on any error
set -e

echo -e "${BLUE_BG}Uncompressing...${NC}"
tar -xvzf hs-authenticator.tar.gz 
cd hs-authenticator
tar -xvzf hs-theme.tar.gz


echo -e "${BLUE_BG}Cleaning the hypersign plugin..${NC}"
rm -rf ${KCBASE}/hs-plugin-keycloak-ejb-0.2-SNAPSHOT.jar
rm -rf ${KCBASE}/modules/hs-plugin-keycloak-ejb/
rm -rf ${KCBASE}/standalone/configuration/hypersign.properties

echo -e "${BLUE_BG}Coping the plugin..${NC}"
cp hs-plugin-keycloak-ejb-0.2-SNAPSHOT.jar ${KCBASE}


echo -e "${BLUE_BG}Dploying the hypersign theme..${NC}"
cp hs-themes/hypersign-config.ftl ${KCBASE}/themes/base/login
cp hs-themes/hypersign.ftl ${KCBASE}/themes/base/login
cp hs-themes/hypersign-new.ftl ${KCBASE}/themes/base/login


echo -e "${BLUE_BG}Dploying the hypersign config file..${NC}"
cp  hypersign.properties ${KCBASE}/standalone/configuration/


echo -e "${BLUE_BG}Deploying the hypersign plugin..${NC}"
cd ${KCBASE}
sh bin/jboss-cli.sh --command="module add --name=hs-plugin-keycloak-ejb --resources=${KCBASE}/hs-plugin-keycloak-ejb-0.2-SNAPSHOT.jar --dependencies=org.keycloak.keycloak-common,org.keycloak.keycloak-core,org.keycloak.keycloak-services,org.keycloak.keycloak-model-jpa,org.keycloak.keycloak-server-spi,org.keycloak.keycloak-server-spi-private,javax.ws.rs.api,javax.persistence.api,org.hibernate,org.javassist,org.liquibase,com.fasterxml.jackson.core.jackson-core,com.fasterxml.jackson.core.jackson-databind,com.fasterxml.jackson.core.jackson-annotations,org.jboss.resteasy.resteasy-jaxrs,org.jboss.logging,org.apache.httpcomponents,org.apache.commons.codec,org.keycloak.keycloak-wildfly-adduser"

sleep 30

echo -e "${BLUE_BG}Adding hs module to the keycloak configuration${NC}"
sh bin/jboss-cli.sh --connect --controller=localhost:9990 --command='/subsystem=keycloak-server/:write-attribute(name=providers,value=["classpath:${jboss.home.dir}/providers/*","module:hs-plugin-keycloak-ejb"])'

exit