KC_USERNAME="admin"
KC_PASSWORD="admin"
AUTH_FLOW_NAME="hs-auth-flow"
KCBASE="/opt/jboss/keycloak"
CLIENT_ALIAS="sample-node-js-client"


REDIRECT_URI="http://localhost:8000/*" 

docker-compose exec keycloak  cat /client-update.json  
docker-compose exec --user root keycloak  sed -i "s,VALID_REDIRECT_URI,${REDIRECT_URI},g" /client-update.json

exit

docker-compose exec keycloak sh .${KCBASE}/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user $KC_USERNAME --password $KC_PASSWORD
docker-compose exec keycloak sh .${KCBASE}/bin/kcadm.sh get clients -r master --fields clientId --format csv --noquotes 2>&1 | grep -w ${CLIENT_ALIAS}


docker-compose exec keycloak sh  sed -i "s/VALID_REDIRECT_URI/"${REDIRECT_URI}"/g" /client-update.json

docker-compose exec keycloak sh .${KCBASE}/bin/kcadm.sh create clients -r master -f /client-create.json  2>&1