# Hypersign Quickstart

This project help developers to setup and use **Hypersign** as authentication and authorisation module for their projects quickly, efficiently and securely provided that they use docker. 

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

### Run

Note*:- Please install [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu) before proceeding otherwise the script will exit with error.

```sh
git clone https://github.com/hypermine-bc/hypersign-quickstart.git 
cd hypersign-quickstart 
./hypersign-setup.sh -r <REDIRECT_URI> -a <CLIENT_ALIAS>
```

### Command line arguments

Explanation of arguments can be viewed using `./hypersign-setup.sh --help` command.

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

Do you wish to continue with default paramaters? (y|n) 
```

### Blocked ports

On successfully execution of the script, you should be able to see (use `docker ps`) three containers running in your machine. 
- A keycloak server at port `8080`
- A postgres database server at port `5432`
- A hs-auth server at port `3000`

You can change these ports as per your convenience in docker-compose file. In future versions you shall be able to do that using the cli itself.

### No-password-less option

Password less authentication is default feature of Hypersign. However, one can still use legacy credential methodology (i.e username/password) by using option `--no-password-less` with `hypersign-setup` script. On enabling this option, `hypersign plugin` will not be deployed in keycloak server and user will be able to see `username/password` form instead of `QR code` on the login page.


## Usage



