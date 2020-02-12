KC_USERNAME=admin
KC_PASSWORD=admin
AUTH_FLOW_NAME=hs-auth-flow

set -e

## HS Authenticator flow setting
./opt/jboss/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user $KC_USERNAME --password $KC_PASSWORD

FLOW_ID=$(./opt/jboss/keycloak/bin/kcadm.sh create authentication/flows -s alias=$AUTH_FLOW_NAME -s providerId=basic-flow -s  description=$AUTH_FLOW_NAME -s  topLevel=true  -s builtIn=false -r master 2>&1 | sed -n "s/^.*'\(.*\)'.*$/\1/ p")
echo "Printing flowid = $FLOW_ID"

EXECUTION_ID=$(./opt/jboss/keycloak/bin/kcadm.sh create authentication/flows/$AUTH_FLOW_NAME/executions/execution -r master -s provider=hyerpsign-qrocde-authenticator -s requirement=REQUIRED  2>&1 | sed -n "s/^.*'\(.*\)'.*$/\1/ p")
echo "Printing execid = $EXECUTION_ID"

sed -i "s/EXECUTION_ID/$EXECUTION_ID/g" /authenticator-flow-update.json
./opt/jboss/keycloak/bin/kcadm.sh update authentication/flows/$AUTH_FLOW_NAME/executions -r master  -f /authenticator-flow-update.json

## HS-API client setting

CLIENT_ID=$(./opt/jboss/keycloak/bin/kcadm.sh create clients -r master -f /client-create.json  2>&1 | sed -n "s/^.*'\(.*\)'.*$/\1/ p")
echo "Printing clientid = $CLIENT_ID"

sed -i "s/CLIENT_ID/$CLIENT_ID/g" /client-update.json
sed -i "s/FLOW_ID/$FLOW_ID/g" /client-update.json
./opt/jboss/keycloak/bin/kcadm.sh update clients/$CLIENT_ID -r master -f /client-update.json

