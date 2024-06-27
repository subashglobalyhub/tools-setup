#!/bin/bash

# global variables
base_dir="/etc/openvpn/easy-rsa"
pki_dir="/etc/openvpn/easy-rsa/pki"
vars_dir="/etc/openvpn/easy-rsa"

function print_separator {
    printf "\n%s\n" "--------------------------------------------------------------------------------"
}

function print_header {
    figlet -c -f slant "$1"
    print_separator
}

# Detection in Yellow color
function print_init {
    local message="$1"
    printf "\e[33m%s\e[0m\n" "$message"
}

# Intermediate in Blue color
function print_intermediate {
    local message="$1"
    printf "\e[34m%s\e[0m\n" "$message"
}

# Completion in Green color
function print_success {
    local message="$1"
    printf "\e[1m\e[32m%s\e[0m\n" "$message"
    print_separator
}

# Failures in Red color
function print_fail {
    local message="$1"
    printf "\e[1m\e[31m%s\e[0m\n" "$message"
    print_separator
}

check_openvpn_installed() {
    print_separator
    print_header "1 - OpenVPN"
    print_separator
    sleep 2
    if command -v openvpn &>/dev/null; then
        print_success "OpenVPN is already installed"
        return 0
    else
        print_fail "OpenVPN is not found in system"
        return 1
    fi
}

check_easy_rsa_installed() {
    print_separator
    print_header "2 - Easy-RSA"
    print_separator
    sleep 2
    if command -v easyrsa &>/dev/null; then
        print_success "Easy-RSA is already installed"
        return 0
    else
        print_fail "Easy-RSA is not found in system"
        return 1
    fi
}

install_openvpn() {
    if check_openvpn_installed; then
        return
    fi

    os_description=$(lsb_release -d 2>/dev/null | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"

    if grep -q 'Ubuntu' /etc/os-release; then
        print_init "Initializing OpenVPN installation process"
        sudo apt-get update
        sudo apt-get install -y openvpn
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi

    print_separator
}

install_easy_rsa() {
    if check_easy_rsa_installed; then
        return
    fi

    os_description=$(lsb_release -d 2>/dev/null | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"

    if grep -q 'Ubuntu' /etc/os-release; then
        print_init "Initializing Easy-RSA installation process"
        print_separator
        echo "Installing Easy-RSA for Ubuntu"
        sudo apt-get update
        sudo apt-get install -y easy-rsa
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi

    print_separator
}

directory_setup() {
    print_header "3 - Directory Setup"
    # Checking if ca.crt is initially present, indicating setup has been done
    if [ -f "/etc/openvpn/easy-rsa/pki/ca.crt" ]; then
        print_success "CA certificate (ca.crt) found at /etc/openvpn/easy-rsa/pki/ca.crt. No action needed."
        return
    fi

    echo "ca.crt not found. Setting up OpenVPN Setup"

    if [ ! -d "$base_dir" ]; then
        print_fail "CA-Directory: $base_dir Not found. Creating ..."
        sudo mkdir -p $base_dir
    else
        print_success "CA-Directory $base_dir already exists"
    fi

    echo "Changing directory to: $base_dir"
    sudo su
    cd $base_dir 

    # Initialize PKI if not already initialized
    if [ ! -d "$pki_dir" ]; then
        print_fail "PKI and VAR Directory at $rsa_dir missing"
        print_init "Creating $rsa_dir and $vars_dir ..."
        sudo easyrsa init-pki
    fi

    # Build CA if not already exists
    if [ ! -f "$rsa_dir/ca.crt" ]; then
        print_fail "certificate file is missing"
        print_init "Creating certificate file"
        sudo easyrsa build-ca
    else
        echo "CA certificate (ca.crt) already exists."
    fi
}

main() {
    install_openvpn
    install_easy_rsa
    directory_setup
    unset base_dir rsa_dir pki_dir
}

main
