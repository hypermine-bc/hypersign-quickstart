https://github.com/keycloak/keycloak-documentation/blob/master/server_admin/topics/admin-cli.adoc

# Command line tool for keycloak

## Authenticate

- [Ref](https://github.com/keycloak/keycloak-documentation/blob/master/server_admin/topics/admin-cli.adoc#authenticating)

```sh
## authenticate
./opt/jboss/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user admin --password admin

## get users examle
./opt/jboss/keycloak/bin/kcadm.sh get http://localhost:8080/auth/admin/realms/master/users
./opt/jboss/keycloak/bin/kcadm.sh get realms

./opt/jboss/keycloak/bin/kcadm.sh create realms -s realm=demorealm -s enabled=true


./opt/jboss/keycloak/bin/kcadm.sh create authentication/flows -s alias=hs-auth-flow-1234 -s providerId=basic-flow -s  description=hs-auth-flow-1234 -s  topLevel=true  -s builtIn=false -r master

./opt/jboss/keycloak/bin/kcadm.sh create authentication/flows/browser/copy -s newName=hs-copy-browser-flow-1 -r master

./opt/jboss/keycloak/bin/kcadm.sh get authentication/flows/hs-copy-browser-flow-1/executions --fields id -r master


./opt/jboss/keycloak/bin/kcadm.sh create authentication/flows/hs-copy-browser-flow-1/executions/execution -r master -s provider=hyerpsign-qrocde-authenticator -s requirement=REQUIRED


docker cp param.json hypersign-deployment_keycloak_1:/

./opt/jboss/keycloak/bin/kcadm.sh update authentication/flows/hs-copy-browser-flow-1/executions -r master  -f /param.json






```

-----------------------------------------------

## Client
http://localhost:8080/auth/admin/realms/master/clients
{"enabled":true,"attributes":{},"redirectUris":[],"clientId":"hs-api","rootUrl":"","protocol":"openid-connect"}

### create 

```
docker cp client-create.json hypersign-deployment_keycloak_1:/
./opt/jboss/keycloak/bin/kcadm.sh create clients -r master -f client-create.json
```

### update

```
docker cp client-update.json hypersign-deployment_keycloak_1:/
./opt/jboss/keycloak/bin/kcadm.sh update clients/c9fefd7b-d604-43b0-894d-10d02c5d7603 -r master -f client-update.json
```















./opt/jboss/keycloak/bin/jboss-cli.sh -c --command='/subsystem=keycloak-server/:write-attribute(name=providers,value=["classpath:${jboss.home.dir}/providers/* -s module:hs-plugin-keycloak-ejb"])'
