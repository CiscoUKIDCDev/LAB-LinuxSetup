#!/bin/bash
# sh scriptname IP NETMASK GATEWAY
#

HOSTNAME = "ukidcv-ubuntu-roporter"

COLOR_NC='\e[0m';COLOR_WHITE='\e[1;37m';COLOR_BLACK='\e[0;30m';COLOR_BLUE='\e[0;34m';COLOR_LIGHT_BLUE='\e[1;34m';COLOR_GREEN='\e[0;32m';COLOR_LIGHT_GREEN='\e[1;32m';COLOR_CYAN='\e[0;36m';COLOR_LIGHT_CYAN='\e[1;36m';COLOR_RED='\e[0;31m';COLOR_LIGHT_RED='\e[1;31m';COLOR_PURPLE='\e[0;35m';COLOR_LIGHT_PURPLE='\e[1;35m';COLOR_BROWN='\e[0;33m';COLOR_YELLOW='\e[1;33m';COLOR_GRAY='\e[0;30m';COLOR_LIGHT_GRAY='\e[0;37m'

if [ -f /etc/lsb-release ] ; then
    DistroBasedOn='Debian'
    DISTRIB_KERNEL_VERSION=$(uname -a | sed -n -r "s/.*([0-9]+\.[0-9]+\.[0-9]+-[0-9]+)[ -]+.*/\1/p")
    DISTRIB_ID=$(sed -n 's/DISTRIB_ID=//p' /etc/lsb-release)
    DISTRIB_RELEASE=$(sed -n 's/DISTRIB_RELEASE=//p' /etc/lsb-release)
    DISTRIB_CODENAME=$(sed -n 's/DISTRIB_CODENAME=//p' /etc/lsb-release)
fi

if [ $DistroBasedOn == "Debian" ]; then
     echo "Debian based - Operating System found.......continuing"
     printf "==========================${COLOR_LIGHT_PURPLE}OS Information${COLOR_NC}=============================\n"
     printf "${COLOR_YELLOW}Distribution = ${COLOR_NC}${DISTRIB_ID}\n"
     printf "${COLOR_YELLOW}Branch = ${COLOR_NC}${DISTRIB_CODENAME}\n"
     printf "${COLOR_YELLOW}OS Revision = ${COLOR_NC}${DISTRIB_RELEASE}\n"
     printf "${COLOR_YELLOW}Kernel Version = ${COLOR_NC}${DISTRIB_KERNEL_VERSION}\n"
     printf "==========================${COLOR_LIGHT_PURPLE}Config Files${COLOR_NC}===============================\n"
fi
