#!/bin/bash

# Global variables
BASE_CONFIG="/etc/openvpn/easy-rsa/client.conf"
client_dir="/etc/openvpn/client"
config_dir="/etc/openvpn/easy-rsa"
dest_dir="$HOME/openvpn-clients"

# Function to print separator
function print_separator {
    printf "\n%s\n" "--------------------------------------------------------------------------------"
}

# Function to print header with figlet
function print_header {
    local header_text="$1"
    if command -v figlet &> /dev/null; then
        figlet -c -f slant "$header_text"
    else
        echo "$header_text"
    fi
    print_separator
}

# Function to print in yellow
function print_init {
    local message="$1"
    printf "\e[33m%s\e[0m\n" "$message"
}

# Function to print intermediate messages in blue
function print_intermediate {
    local message="$1"
    printf "\e[34m%s\e[0m\n" "$message"
}

# Function to print success messages in green
function print_success {
    local message="$1"
    printf "\e[1m\e[32m%s\e[0m\n" "$message"
    print_separator
}

# Function to print failure messages in red
function print_fail {
    local message="$1"
    printf "\e[1m\e[31m%s\e[0m\n" "$message"
    print_separator
}

# Function to display usage information
usage() {
    print_header "OpenVPN Client Setup"

    echo "Usage: $0 [-u <username>] [-d <destination_directory>]"
    echo "Options:"
    echo "  -u, --user <username>                   Mega username (required)"
    echo "  -d, --destination <destination_directory>         Complete path of destination directory (optional)"
    echo
    print_intermediate "Examples:"
    print_init "  $0 -u subash"
    print_init "  $0 -u subash -d \"/home/subash\""
    print_fail "For more information, contact us:"
    print_success "  Email: subaschy729@gmail.com, Phone: +977 9823827047"
    exit 1
}

# Function to parse command-line options
taking_input() {
    # Initialize variables with default values
    USERNAME=""
    DESTINATION=""

    # Parse command-line options
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -u|--user)
                USERNAME="$2"
                shift # past argument
                shift # past value
                ;;
            -d|--destination)
                DESTINATION="$2"
                shift # past argument
                shift # past value
                ;;
            *)
                # unknown option
                usage
                ;;
        esac
    done

    # Check if username is provided
    if [[ -z $USERNAME ]]; then
        echo "Error: openvpn username is required."
        usage
    fi

    # Set default destination directory if not provided
    if [[ -z $DESTINATION ]]; then
        DESTINATION="$dest_dir"
    fi
}

# Function to generate client certificate
client_cert_gen() {
    print_header "1 - Generating Certificate"
    

    print_init "Certificate generating is in progress. Please wait"
    cd "$config_dir" || exit
    ./easyrsa gen-req "$USERNAME" nopass
    ./easyrsa sign-req client "$USERNAME"

    print_intermediate "Copying client generated config files to $client_dir ..."
    sudo cp "pki/private/$USERNAME.key" "$client_dir"
    sudo cp "pki/issued/$USERNAME.crt" "$client_dir"
    cd - > /dev/null || exit
    print_separator
}

# Function to generate .ovpn configuration file
client_ovpn_config_gen() {
    print_init "2 - Generating .ovpn File"
    mkdir -p $DESTINATION

    cat "${BASE_CONFIG}" \
    <(echo -e '<ca>') \
    "${client_dir}/ca.crt" \
    <(echo -e '</ca>\n<cert>') \
    "${client_dir}/${USERNAME}.crt" \
    <(echo -e '</cert>\n<key>') \
    "${client_dir}/${USERNAME}.key" \
    <(echo -e '</key>\n<tls-crypt>') \
    "${client_dir}/ta.key" \
    <(echo -e '</tls-crypt>') \
    > "${DESTINATION}/${USERNAME}.ovpn"
    print_separator
}


display() {
    print_header "3 - Displaying Result"
    echo "Configuration files generated successfully."
    echo "Output directory: $DESTINATION"
    echo "Client .ovpn file: ${DESTINATION}/${USERNAME}.ovpn"
}

# Main function to orchestrate the process
main() {
    taking_input "$@"
    client_cert_gen
    client_ovpn_config_gen
    display
}

main "$@"
