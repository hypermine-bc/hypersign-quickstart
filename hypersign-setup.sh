
KCBASE='/opt/jboss/keycloak'

docker-compose -f kc-pg-hs.yml config
docker-compose -f kc-pg-hs.yml down
docker-compose -f kc-pg-hs.yml up -d --remove-orphans

docker cp kc-web-cntxt.sh "$(docker-compose -f kc-pg-hs.yml ps -q keycloak)":/kc-web-cntxt.sh
docker-compose -f kc-pg-hs.yml exec --env KCBASE=${KCBASE} keycloak sh /kc-web-cntxt.sh
docker-compose -f kc-pg-hs.yml  exec --user root keycloak  apt-get update  && apt-get install -y wget  && rm -rf /var/lib/apt/lists/*

wget https://github.com/hypermine-bc/hs-authenticator/releases/download/v1.0.1/hs-authenticator.tar.gz -O hs-authenticator.tar.gz


docker cp hs-authenticator.tar.gz "$(docker-compose -f kc-pg-hs.yml ps -q keycloak)":/hs-authenticator.tar.gz
docker-compose -f kc-pg-hs.yml  exec --user root keycloak tar -xvzf /hs-authenticator.tar.gz 
docker-compose -f kc-pg-hs.yml  exec --user root keycloak tar -xvzf /hs-authenticator/hs-theme.tar.gz


echo -e "${BLUE_BG}Coping the plugin..${NC}"
docker-compose -f kc-pg-hs.yml  exec --env KCBASE=${KCBASE} --user root keycloak cp /hs-authenticator/hs-plugin-keycloak-ejb-0.2-SNAPSHOT.jar ${KCBASE}


echo -e "${BLUE_BG}Dploying the hypersign theme..${NC}"
docker-compose -f kc-pg-hs.yml  exec --user root keycloak cp /hs-authenticator/hs-theme/hypersign-config.ftl ${KCBASE}/themes/base/login
docker-compose -f kc-pg-hs.yml  exec --user root keycloak cp /hs-authenticator/hs-theme/hypersign.ftl ${KCBASE}/themes/base/login
docker-compose -f kc-pg-hs.yml  exec --user root keycloak cp /hs-authenticator/hs-theme/hypersign-new.ftl ${KCBASE}/themes/base/login


echo -e "${BLUE_BG}Dploying the hypersign config file..${NC}"
docker-compose -f kc-pg-hs.yml  exec --user root keycloak  cp  /hs-authenticator/hypersign.properties ${KCBASE}/standalone/configuration/


echo -e "${BLUE_BG}Deploying the hypersign plugin..${NC}"
docker-compose -f kc-pg-hs.yml  exec --user root keycloak sh ${KCBASE}/bin/jboss-cli.sh --command="module add --name=hs-plugin-keycloak-ejb --resources=./hs-plugin-keycloak-ejb-0.2-SNAPSHOT.jar --dependencies=org.keycloak.keycloak-common,org.keycloak.keycloak-core,org.keycloak.keycloak-services,org.keycloak.keycloak-model-jpa,org.keycloak.keycloak-server-spi,org.keycloak.keycloak-server-spi-private,javax.ws.rs.api,javax.persistence.api,org.hibernate,org.javassist,org.liquibase,com.fasterxml.jackson.core.jackson-core,com.fasterxml.jackson.core.jackson-databind,com.fasterxml.jackson.core.jackson-annotations,org.jboss.resteasy.resteasy-jaxrs,org.jboss.logging,org.apache.httpcomponents,org.apache.commons.codec,org.keycloak.keycloak-wildfly-adduser"


echo -e "${BLUE_BG}Adding hs module to the keycloak configuration${NC}"
docker-compose -f kc-pg-hs.yml  exec --user root keycloak sed -i 's/<provider>module:hs-plugin-keycloak-ejb<\/provider>/''/g' $KCBASE/standalone/configuration/standalone.xml
docker-compose -f kc-pg-hs.yml  exec --user root keycloak sed -i '/<provider>classpath:\${jboss\.home\.dir}\/providers\/\*<\/provider>/a <provider>module:hs-plugin-keycloak-ejb<\/provider>' $KCBASE/standalone/configuration/standalone.xml


## delete hs-authenticator folder
docker-compose -f kc-pg-hs.yml exec --user root keycloak rm -rf hs-authenticator*
















## 
docker-compose -f kc-pg-hs.yml restart keycloak

#docker-compose -f kc-pg-hs.yml  exec --user root keycloak wget https://github.com/hypermine-bc/hs-authenticator/releases/download/v1.0.1/hs-authenticator.tar.gz -O /hs-authenticator.tar.gz
# docker-compose -f kc-pg-hs.yml exec --user root keycloak ls 
# docker-compose -f kc-pg-hs.yml exec --user root keycloak rm -rf hs-authenticator*






