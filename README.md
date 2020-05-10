# Hypersign Quickstart

This project help developers to setup and use **Hypersign** as authentication and authorisation module for their projects quickly, efficiently and securely provided that they use docker. 

To know more about **Hypersign**, please visit [this](https://github.com/hypermine-bc/hypersign/blob/master/docs/overview.md).

## Why should I use it?

Implementing authentication and authorisation module in your applications is quite challenging. It has a steep learning curve which then translates into hours and hours of development effort, just to figure out how a user will get into the system efficiently and securely.  The process is even more challenging when it comes to implement cryptography based authentication for better security. 

> **Hypersign** takes away all of these pain and let you focus on your business requirement and hence saves a lot of development effort. 

## Features  

- Out of the box authentication and authorisation module.
- Supports password as well as password less (by default) authentication.
- On-premise authentication server.
- Runs on light weight docker containers and hence consumes less resources (CPU and RAM).
- Support for mobile as well as web apps.

Detailed feature list can be found [here](https://github.com/hypermine-bc/hypersign/blob/master/docs/overview.md#features).


## Installation

### Quick Run

*Note* : Please install [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu) before proceeding otherwise the script will exit with error.

```sh
git clone https://github.com/hypermine-bc/hypersign-quickstart.git 
cd hypersign-quickstart 
./hypersign-setup.sh -r <REDIRECT_URI> -a <CLIENT_ALIAS>
```

Where,

- `<CLIENT_ALIAS>` : Name of the client which you want to secure. We suggest you to use `-` separated naming convention e.g. `my-demo-node-server`. The term _client_ is used for application which needs to be secured. It could be a simple static webapp, a node js server or any other application which needs have this authentication module. 
- `<REDIRECT_URI>` : URI pattern, a browser can redirect to after successfull login or logout. Simple wildcards are allowed such as `http://example.com/*`.

### Command line arguments

Explanation of arguments can be viewed using `./hypersign-setup.sh --help` command. Most of these options are self explanatory.

```sh
Hypersign-setup runs and configure all required docker containers for integrating your client project with Hypersign authenticaion module

Syntax: hypersign-setup.sh -r <REDIRECT_URI> -a <CLIENT_ALIAS>
Command line options:
    -r    | --redirect-uri  URI     Redirect URI once the user is authenticated from Hypersign
    -a    | --client-alias  ALIAS   Name of client you want to configure
    -npls | --no-password-less      For legacy authentication method (username/password)
    -h    | --help                  Print this help menu
    -V    | --version               Print current version

Example:
    Configure Hypersign for client 'my-demo-client' running on localhost at port 8000
        hypersign-setup.sh -r http://localhost:8000/* -a my-demo-client
```

### Default parameters

If no parameter is passed with `hypersign-setup.sh` script, then default parameters will be taken. Try running the script without giving any parameter, it shows the default params and asks for confirmation to proceed.

```sh
WARNING: No arguments passed
         Default parameters:
            REDIRECT_URI: http://localhost:8000/*
            CLIENT_ALIAS: sample-node-js-client
            NO-PASSWORD_LESS: false

Do you wish to continue with default paramaters? (y|n) 
```
Even if you run the script with default parameters, you can change them using *Management Portal* later. Will discuss about *Management Portal* in later section of this document.

### No-password-less option

Password less authentication is default feature of Hypersign. However, one can still use legacy credential methodology (i.e username/password) by using option `--no-password-less` with `hypersign-setup` script. On enabling this option, `hypersign plugin` will not be deployed in keycloak server and user will be able to see `username/password` form instead of `QR code` on the login page.


### On successful installation

**Occupied ports**

On successfully execution of the script, you should be able to see (use `docker ps`) three containers running in your machine. 
- A keycloak server at port `8080`
- A postgres database server at port `5432`
- A hs-auth server at port `3000`


**Management portal**

Although, the basic configurations for identity and access management is already done once all containers run successfully, you (the admin) will get a *Management portal* at `http://localhost:8080` for managing advance identity related configurations like groups, users, roles, scope etc. The default credentials for admin user is: Username: `admin`, Password: `admin`.

> You can configure ports and credentials for management portal as per your convenience in the docker-compose file, present in the root directory of this repository. In future versions you shall be able to do that using the cli itself.

## Usage

Now that every thing is installed and setup, let's see how to use Hypersign in your project. We will take example of _securing APIs written in Node js_.

- Make node js project with `express` and copy `keycloak.json` file from `data-template` folder into the root directory of your project.

```json
    {
        "realm": "master",
        "auth-server-url": "http://localhost:8080/auth/",
        "ssl-required": "external",
        "resource": "node-js-client-app",
        "public-client": true,
        "confidential-port": 0
    }
```

- Install `keycloak-connect` and `express-session` libraries from npm
- Add `app.js` with following code:

```js
'use strict';
const Keycloak = require('keycloak-connect');
const express = require('express');
const session = require('express-session');
const app = express();

var memoryStore = new session.MemoryStore();
var keycloak = new Keycloak({ store: memoryStore });

//session
app.use(session({
  secret:'this_should_be_long_text',
  resave: false,
  saveUninitialized: true,
  store: memoryStore
}));

app.use(keycloak.middleware());

//route protected with Keycloak
app.get('/test', keycloak.protect(), function(req, res){
  res.send("This is protected");
});

//unprotected route
app.get('/',function(req,res){
  res.send("This is public");
});

app.use( keycloak.middleware( { logout: '/'} ));

app.listen(8000, function () {
  console.log('Listening at http://localhost:8000');
});

```
- Run the server using `node app.js`. The server (client's) will start running on `http://localhost:8000`

Try accessing `/` endpoint, you will get the response `This is public` immediately. Whereas, when you try to access `/test` endpoint, you will see a login page with QRCode but if `--no-passoword-less` option is set then you will see login form with username and password textboxes. You can either provide username and passoword (in case of `--no-passoword-less`) or scan the QRCode using `Hypersign Mobile app` to authenticate youself [Read the Mobile App configuration below]. Once you are authenticated, you can see access the protected resource i.e `This is protected` in this case. 

The `/test` endpoint is protected using `keycloak.protect()` middleware which authenticates the user using keycloak and hs-auth servers and redirects the call to the provided `REDIRECT_URI`. You can donwload the full node js from [here](https://github.com/keycloak/keycloak-nodejs-connect/tree/master/example).

## Mobile Authenticator

1. Download the mobile authenticator from this [link](https://github.com/hypermine-bc/hypersign-mobile/releases/download/v0.1-demo-app/hypersign-demo-app.apk) 
2. In your mac or linux system open terminal and run `ifconfig`, You will see your wifi IP
  something like `192.168.1.4`
3. In the mobile app you will see `New user` link on th elogin scren click on that, It will take you to registration page.
4. In the Url section add following url  `http://your-local-ip:8080/auth/realms/master/hypersign`
   and pass other details such as user name, email and pin

## Further reading

You can quickly take a glance at ["how does it work?"](https://github.com/hypermine-bc/hypersign/blob/master/docs/overview.md#how-does-it-work) and for understanding complete registration and login flow of this application you can visit [here](https://github.com/hypermine-bc/hypersign/blob/master/docs/registration_%26_login.md#registration). 

## Disclaimer

The software is still in testing phase (specially with cryptographic protocols) so we suggest you to not to use it (for now) in production.





