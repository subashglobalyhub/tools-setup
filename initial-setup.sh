#!/bin/bash

# ------- LARGE Banner display section start

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
check_figlet_installed() {
    print_separator
    print_header "1 - FIGLET"
    print_separator
    sleep 2
    if command -v figlet &>/dev/null; then
        print_success "Figlet is already installed"  
        return 0
    else
        print_fail "Figlet package is not found in system"
        return 1
    fi
}

check_make_installed() {
    print_separator
    print_header "2 - make"
    print_separator
    sleep 2
    if command -v make &>/dev/null; then
        print_success "make is already installed"  
        return 0
    else
        echo -e "make is not found in system" 
        return 1
    fi
}
install_figlet() {
    if check_figlet_installed; then
        return
    fi
    os_description=$(lsb_release -a 2>/dev/null | grep "Description:" | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"
    if grep -q 'Ubuntu' /etc/os-release; then
        print_init "Initializing Figlet installation process"
        sudo apt-get update
        sudo apt-get install -y figlet
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
    print_separator
}
install_make() {
    if check_make_installed; then
        return
    fi

    os_description=$(lsb_release -a 2>/dev/null | grep "Description:" | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"
    if grep -q 'Ubuntu' /etc/os-release; then
        print_init "Initializing Maker installation process"
        print_separator
        sudo apt-get update
        sudo apt-get install -y make
        sudo apt install -y make-guile
        print_success "Make installed successfully"
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
    print_separator
}
main() {
    install_figlet
    install_make
}

main 