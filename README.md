# Hypersign Quickstart

This project help developers to setup and use **Hypersign** as authentication and authorisation module for their projects quickly, efficiently and securely provided that they use docker. 

## Why should I use it?

Implementing authentication and authorisation module in your applications is quite challenging. It has a steep learning curve which then translates into hours and hours of development effort, just to figure out how a user will get into the system efficiently and securely.  The process is even more challenging when it comes to implement cryptography based authentication for better security. 

> **Hypersign** takes away all of these pain and let you focus on your business requirement and hence saves a lot of development effort. 

## Features  

- Out of the box authentication and authorisation module.
- Password less authentication.
- On-premise authentication server.
- Runs on light weight docker containers and hence consumes less resources (CPU and RAM).
- Support for mobile as well as web apps.

Detailed feature list can be found [here](https://github.com/hypermine-bc/hypersign/blob/master/docs/overview.md#features).


## Installation

Note*:- Please install [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu) before proceeding.

```sh
git clone https://github.com/hypermine-bc/hypersign-quickstart.git 
cd hypersign-quickstart 
./hypersign-setup.sh
```

On successfully execution of the script, you should be able to see (use `docker ps`) three containers running in your machine. 
- A keycloak server at port `8080`
- A postgres database server at port `5432`
- A hs-auth server at port `3000`

If no parameter is given to `hypersign-setup.sh` script, then default parameters will be taken.

## 
