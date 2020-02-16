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

Do you wish to continue with default paramaters? (y|n) 
```

### No-password-less option

Password less authentication is default feature of Hypersign. However, one can still use legacy credential methodology (i.e username/password) by using option `--no-password-less` with `hypersign-setup` script. On enabling this option, `hypersign plugin` will not be deployed in keycloak server and user will be able to see `username/password` form instead of `QR code` on the login page.


### On successful execution

**Occupied ports**

On successfully execution of the script, you should be able to see (use `docker ps`) three containers running in your machine. 
- A keycloak server at port `8080`
- A postgres database server at port `5432`
- A hs-auth server at port `3000`


**Management portal**

Although, the basic configurations for identity and access management is already done once all containers run successfully, you (the admin) will get a *Management portal* at `http://localhost:8080` for managing advance identity related configurations like groups, users, roles, scope etc. The default credentials for admin user is: Username: `admin`, Password: `admin`.


---

*Note* : You can configure ports and credentials for management portal as per your convenience in the docker-compose file, present in the root directory of this repository. In future versions you shall be able to do that using the cli itself.

## Usage


Now that every thing is setup and installed, let's learn how to use hypersign in your project. I will take example 




