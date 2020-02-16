
VERSION="v0.0.1"
REDIRECT_URI="http://localhost:8000/*"
CLIENT_ALIAS="sample-node-js-client"

usage() {
    echo "Hypersign-setup run and configure up all required docker containers for integrating with Hypersign authenticaion module"
    echo  
    echo "Syntax: hypersign-setup.sh -r <REDIRECT_URI> -a <CLIENT_ALIAS>"
    echo "Command line options:"
    echo "    -r | --redirect-uri  URI     Redirect URI once the user is authenticated"
    echo "    -a | --client-alias  ALIAS   Name of client you want to configure"
    echo "    -h | --help                  Print this help menu"
    echo "    -V | --version               Print current version"
    echo 
    echo "Example:"
    echo "    Configure Hypersign for client a my-demo-client running on localhost at port 8000"
    echo "        `basename $0` -r http://localhost:8000/* -a my-demo-client"
    echo 
}

## Warning for default parameters
## Warning for default parameters
if [ $# -eq 0 ]
then
    echo "Warning: No arguments passed"
    echo "      Default parameters:"
    echo "          REDIRECT_URI: ${REDIRECT_URI}"
    echo "          CLIENT_ALIAS: ${CLIENT_ALIAS}"
    echo

    while true; do
        read -p "Do you wish to continue with default paramaters? (y|n) " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -V | --version )
    echo "hypersign-setup ${VERSION}"
    exit
    ;;
  -h | --help )
    usage
    exit
    ;;
  -r | --redirect-uri )
    shift; REDIRECT_URI=$1
    ;;
  -a | --client-alias )
    shift; CLIENT_ALIAS=$1
    ;;
  *) # incorrect option
    echo "Error: Invalid option"
    exit;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi

echo "###################################"
echo "  Saying hello from help.sh script"
echo "###################################"


sh ./test.sh ${REDIRECT_URI} ${CLIENT_ALIAS}

exit



