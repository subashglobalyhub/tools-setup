#!/bin/bash

# ------- LARGE Banner display section start

function print_separator {
    printf "\n%s\n" "--------------------------------------------------------------------------------"
}

function print_header {
    figlet -c -f slant "$1"
    print_separator
}
check_make_installed() {
    print_separator
    print_header "3 - make"
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
install_make
}

main 