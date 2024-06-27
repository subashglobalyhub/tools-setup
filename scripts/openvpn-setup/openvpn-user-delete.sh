#!/bin/bash

# Global variables
client_dir="/etc/openvpn/client"
config_dir="/etc/openvpn/easy-rsa"
dest_dir="$HOME/openvpn-clients"



# Function to print header with figlet
function print_header {
    local header_text="$1"
    if command -v figlet &> /dev/null; then
        figlet -c -f slant "$header_text"
    else
        echo "$header_text"
    fi
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
}

# Function to print failure messages in red
function print_fail {
    local message="$1"
    printf "\e[1m\e[31m%s\e[0m\n" "$message"
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
deleting_client_dir_config() {
    print_header "Removing COnfiguration"
    print_init "1. Deleting main configuration files for user '$USERNAME' from '$client_dir'. Please wait."
    cd "$client_dir" || exit
    sudo rm $USERNAME.crt
    sudo rm $USERNAME.key
    

    print_separator
    print_init "2. Cleaning up initialization configuration after generating user '$USERNAME' in '$config_dir'. Please wait."
    cd $config_dir
    sudo rm pki/issued/$USERNAME.crt
    sudo rm pki/private/$USERNAME.key
    sudo rm pki/reqs/$USERNAME.req
    print_separator

    print_init "3. Removing client configuration file '$USERNAME.ovpn' from '$DESTINATION'. Please wait."
    if [[ -f "$DESTINATION/$USERNAME.ovpn" ]]; then
        sudo rm -f "$DESTINATION/$USERNAME.ovpn"
        print_success "Configuration file '$USERNAME.ovpn' deleted successfully."
    else
        print_fail "Configuration file '$USERNAME.ovpn' not found or already deleted."
    fi
}


display() {
    print_header "3 - Displaying Result"

    print_success "Output directory: $DESTINATION"
    print_success "Client .ovpn file: ${DESTINATION}/${USERNAME}.ovpn"

    echo -n  "File Deletion summary            :       "
    echo -n  "Main config        :       "
    print_success "$client_dir/$USERNAME.crt"
    echo -n  "              :       "
    print_success "$client_dir/$USERNAME.key"

    print_separator
    echo -n  "Initial config      :       "
    print_success "$config_dir/pki/issued/$USERNAME.crt"
    echo -n  "              :       "
    print_success "$config_dir/pki/private/$USERNAME.key"
    echo -n  "              :       "
    print_success "$config_dir/pki/reqs/$USERNAME.req"

    print_separator
    echo -n  "client ovpn      :       "
    print_success "$DESTINATION/$USERNAME.ovpn"
}

# Main function to orchestrate the process
main() {
    taking_input "$@"
    deleting_client_dir_config
    display
}

main "$@"
