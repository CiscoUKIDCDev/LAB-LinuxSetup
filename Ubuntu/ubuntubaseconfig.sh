#!/bin/bash
# sh scriptname IP NETMASK GATEWAY
#

HOSTNAME="roporter-ubuntu"

COLOR_RESET="$(tput sgr0)"
COLOR_RED="$(tput setaf 1)"
COLOR_GREEN="$(tput setaf 2)"
COLOR_YELLOW="$(tput setaf 3)"
COLOR_BLUE="$(tput setaf 4)"
COLOR_PURPLE="$(tput setaf 5)"
COLOR_LBLUE="$(tput setaf 6)"
COLOR_WHITE="$(tput setaf 7)"
COLOR_BOLD="$(tput bold)"
COLOR_UNDERLINE="$(tput sgr 0 1)"

if [ -f /etc/lsb-release ]
    then DistroBasedOn='Debian'
    DISTRIB_KERNEL_VERSION=$(uname -a | sed -n -r "s/.*([0-9]+\.[0-9]+\.[0-9]+-[0-9]+)[ -]+.*/\1/p")
    DISTRIB_ID=$(sed -n 's/DISTRIB_ID=//p' /etc/lsb-release)
    DISTRIB_RELEASE=$(sed -n 's/DISTRIB_RELEASE=//p' /etc/lsb-release)
    DISTRIB_CODENAME=$(sed -n 's/DISTRIB_CODENAME=//p' /etc/lsb-release)
fi

if [ $DistroBasedOn = "Debian" ]
     then clear 
     echo "Debian based - Operating System found.......continuing"
     printf "==========================${COLOR_PURPLE}OS Information${COLOR_RESET}=============================\n"
     printf "${COLOR_YELLOW}Distribution = ${COLOR_RESET}${DISTRIB_ID}\n"
     printf "${COLOR_YELLOW}Branch = ${COLOR_RESET}${DISTRIB_CODENAME}\n"
     printf "${COLOR_YELLOW}OS Revision = ${COLOR_RESET}${DISTRIB_RELEASE}\n"
     printf "${COLOR_YELLOW}Kernel Version = ${COLOR_RESET}${DISTRIB_KERNEL_VERSION}\n"
printf "==========================${COLOR_PURPLE}Config Files${COLOR_RESET}===============================\n"
     FILE=/etc/environment
     echo "Setting system wide alias commands"
     if( grep -Rq "alias python3" $FILE )
	then echo "Settings already exist"
     else
     cat >> $FILE << EOF
alias python3='/usr/bin/python3.4'
alias drm="docker rm -f"
alias dps="docker ps -a"
alias drmi="docker rmi"
alias dim="docker images"
alias ..="cd .."
export PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'
EOF
     fi
     FILE=/etc/hostname
     echo "Setting hostname"
     cp $FILE /tmp
     echo $HOSTNAME > $FILE
     echo "Disabling firewall"
     ufw disable
     printf "${COLOR_GREEN}Config Files - Complete${COLOR_RESET}\n"
printf "==========================${COLOR_PURPLE}Running Hacks${COLOR_RESET}==============================\n"
     echo "Sourcing new environment file..........."; . /etc/environment
     echo "Removing apt lock manually.............."; rm -f /var/run/apt.pid
     printf "${COLOR_GREEN}Running Hacks - Complete${COLOR_RESET}\n"
printf "==========================${COLOR_LIGHT_PURPLE}Enabling Repositories${COLOR_RESET}======================\n"
     printf "${COLOR_GREEN}Enabling Repositories - Complete${COLOR_RESET}\n"
printf "==========================${COLOR_PURPLE}Installing${COLOR_RESET}=================================\n"
     echo "Updating APT ..........................."; apt update -y > /dev/null 2>&1
     echo "Upgrading APT .........................."; apt upgrade -y > /dev/null 2>&1
     echo "Installing Dev Tools ..................."; apt-get install -y build-essential > /dev/null
     echo "Installing bzip2 ......................."; apt-get install -y bzip2 > /dev/null
     echo "Installing libSSL-dev .................."; apt-get install -y libssl-dev > /dev/null
     echo "Installing OpenSSL ....................."; apt-get install -y openssl > /dev/null
     echo "Installing p7zip ......................."; apt-get install -y p7zip > /dev/null
     echo "Installing unzip ......................."; apt-get install -y unzip > /dev/null
     echo "Installing unrar ......................."; apt-get install -y unrar > /dev/null
     echo "Installing nano ........................"; apt-get install -y nano > /dev/null
     echo "Installing network tools ..............."; apt-get install -y net-tools > /dev/null
     echo "Installing wget ........................"; apt-get install -y wget > /dev/null
     echo "Installing npm ........................."; apt-get install -y npm > /dev/null
     echo "Installing git ........................."; apt-get install -y git > /dev/null
     echo "Installing ebtables ...................."; apt-get install -y ebtables > /dev/null 2>&1
     echo "Installing bower ......................."; npm install -g bower > /dev/null 2>&1
     echo "Installing bower-browser ..............."; npm install -g bower-browser > /dev/null 2>&1
     echo "Installing bower-installer ............."; npm install -g bower-installer > /dev/null 2>&1
     echo "Installing ntfs-3g ....................."; apt-get install -y ntfs-3g > /dev/null
     echo "Installing vsftpd ......................"; apt-get install -y vsftpd > /dev/null
     echo "Installing telnet ......................"; apt-get install -y telnet > /dev/null
     echo "Installing fail2ban ...................."; apt-get install -y fail2ban > /dev/null
     echo "Installing ntp ........................."; apt-get install -y ntp > /dev/null
     echo "Installing inotify-tools ..............."; apt-get install -y inotify-tools > /dev/null
     echo "Installing lynx ........................"; apt-get install -y lynx > /dev/null
     echo "Installing links ......................."; apt-get install -y links > /dev/null
     echo "Installing docker-compose .............."; curl -L https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose &> /dev/null
     echo "Installing Java ........................"; apt-get install -y default-jre > /dev/null
     echo "Downloading bar ........................"; wget --quiet http://www.theiling.de/downloads/bar-1.4-src.tar.bz2 > /dev/null 2>&1
     echo "Extracting bar ........................."; tar xvf bar-1.4-src.tar.bz2 > /dev/null 2>&1
     echo "Moving bar ............................."; mv bar-1.4/bar /usr/bin > /dev/null 2>&1
     echo "Tidying up from bar ...................."; rm -Rf bar-1.4; rm bar-1.4-src.tar.bz2 > /dev/null 2>&1
     
     printf "${COLOR_GREEN}Installing - Complete${COLOR_RESET}\n"
printf "==========================${COLOR_LIGHT_PURPLE}Config Files${COLOR_NC}===============================\n"
     echo "Setting timezone ......................."; timedatectl set-timezone Europe/London
     echo "Setting vsftp configuration ............"
     FILE=/etc/vsftpd.conf
     sed -i -e "s/anonymous_enable=YES/anonymous_enable=NO/g" $FILE
     sed -i -e "s/local_enable=NO/local_enable=YES/g" $FILE
     sed -i -e "s/write_enable=NO/write_enable=YES/g" $FILE
     sed -i -e "s/chroot_local_user=NO/chroot_local_user=YES/g" $FILE
     sed -i -e "s/#chroot_local_user=YES/chroot_local_user=YES/g" $FILE
     sed -i -e "s/local_umask=022/local_umask=0002/g" $FILE
     sed -i -e "s/#anon_upload_enable=YES/anon_upload_enable=YES/g" $FILE
     sed -i -e "s/#anon_mkdir_write_enable=YES/anon_mkdir_write_enable=YES/g" $FILE
     if( grep -Rq "file_open_mode=0777" $FILE )
         then echo "File Mode already set"
         else echo "file_open_mode=0777" >> $FILE
     fi
     if( grep -Rq "allow_writeable_chroot=YES" $FILE )
         then echo "Allow chroot already set"
     else
         echo "allow_writeable_chroot=YES" >> $FILE
     fi
     echo "Setting bashrc configurations..........."
     FILE=~/.bashrc
     if( grep -Rq ". /etc/environment" $FILE )
       then echo "Source environment already in bash file"
     else
         echo ". /etc/environment" >> $FILE
     fi

     FILE=/etc/fail2ban/jail.local
     echo "Copying fail2ban confiure file ........."; rm $FILE > /dev/null 2>&1; cp /etc/fail2ban/jail.conf $FILE > /dev/null 2>&1
     echo "Changing permissions for docker-compose."; chmod +x /usr/local/bin/docker-compose
     
     FILE=/root/.bowerrc
     echo "Setting bower customisations ..........."
     echo '{ "allow_root": true }' > $FILE

     echo "Adjusting git to use HTTPS ............."; git config --global url."https://".insteadOf git://

     printf "${COLOR_GREEN}Config Files complete${COLOR_RESET}\n"     

printf "==========================${COLOR_PURPLE}Creating files and folders${COLOR_RESET}=================\n"
     echo "Creating www directory ................."; mkdir /var/www > /dev/null 2>&1
     echo "Setting access permissons on directory ."; chmod 777 /var/www > /dev/null 2>&1
     echo "Setting gid for directory .............."; chmod g+s /var/www
     echo "Setting default group access ..........."; setfacl -d -m g::rwx /var/www
     echo "Setting default other group access ....."; setfacl -d -m o::rwx /var/www
     printf "${COLOR_GREEN}Creating files and folders - Complete${COLOR_RESET}\n"

printf "==========================${COLOR_PURPLE}Setting aliases${COLOR_RESET}============================\n"
     echo "Setting alias for docker rm -f ........."; alias drm="docker rm -f"
     echo "Setting alias for docker ps -a ........."; alias dps="docker ps -a"
     echo "Setting alias for docker rmi ..........."; alias drmi="docker rmi"
     echo "Setting alias for docker images ........"; alias dim="docker images"
     printf "${COLOR_GREEN}Disabling Services - Complete${COLOR_RESET}\n"

printf "==========================${COLOR_PURPLE}Disabling Services${COLOR_RESET}=========================\n"
     echo "Disabling Firewall service .............."; systemctl disable firewalld.service
     printf "${COLOR_GREEN}Disabling Services - Complete${COLOR_RESET}\n"

printf "==========================${COLOR_PURPLE}Stopping Services${COLOR_RESET}==========================\n"
     echo "Stopping Firewall service ..............."; systemctl stop firewalld.service
     printf "${COLOR_GREEN}Stopping Services - Complete${COLOR_RESET}\n"

printf "==========================${COLOR_PURPLE}Enabling Services${COLOR_RESET}==========================\n"
     echo "Enabling vsftpd ........................"; systemctl enable vsftpd > /dev/null 2>&1
     echo "Enabling ntpd .........................."; systemctl enable ntp > /dev/null 2>&1
     echo "Enabling fail2ban ......................"; systemctl enable fail2ban.service > /dev/null 2>&1
     printf "${COLOR_GREEN}Enabling Services - Complete${COLOR_RESET}\n"

printf "==========================${COLOR_PURPLE}Starting Services${COLOR_RESET}==========================\n"
     echo "Starting vsftpd ........................"; systemctl restart vsftpd
     echo "Starting ntp .........................."; systemctl restart ntp
     echo "Starting fail2ban ......................"; systemctl restart fail2ban.service
     echo "Restarting sshd ........................"; systemctl restart sshd
     printf "${COLOR_GREEN}Starting Services - Complete${COLOR_RESET}\n"

printf "==========================${COLOR_PURPLE}Installing Docker${COLOR_RESET}=============================\n"
     echo "Installing Docker ............"; curl -sSL https://get.docker.com/ | sh > /dev/null 2>&1
     echo "Starting Docker .............."; systemctl start docker > /dev/null 2>&1
     echo "Enabling Docker on Start ....."; systemctl enable docker > /dev/null 2>&1
     printf "${COLOR_GREEN}Installing Docker - Complete${COLOR_RESET}\n"

printf "==========================${COLOR_PURPLE}Kernel Upgrade${COLOR_RESET}===============================\n"
     if [ $DISTRIB_KERNEL_VERSION = "4.1.6-040106" ]
	 then echo "Kernel is already up to date, version = 4.1.6-040106"
     else
         echo "Downloading Kernel 4.1.6 headers ......."; wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.1.6-unstable/linux-headers-4.1.6-040106_4.1.6-040106.201508170230_all.deb > /dev/null 2>&1
         echo "Downloading Kernel 4.1.6 generic ......."; wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.1.6-unstable/linux-headers-4.1.6-040106-generic_4.1.6-040106.201508170230_amd64.deb > /dev/null 2>&1
         echo "Downloading Kernel 4.1.6 image ........."; wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.1.6-unstable/linux-image-4.1.6-040106-generic_4.1.6-040106.201508170230_amd64.deb > /dev/null 2>&1
         echo "Installing new Kernel now .............."; dpkg -i linux-headers-4.1.6*.deb linux-image-4.1.6*.deb > /dev/null 2>&1
     fi
     printf "${COLOR_GREEN}Kernel Upgrade - Complete${COLOR_RESET}\n"
     echo "Tidying up ..................."; apt-get -y autoremove > /dev/null 2>&1
printf "==========================${COLOR_PURPLE}Installation${COLOR_RESET}===============================\n"
printf "==========================${COLOR_PURPLE}FINISHED${COLOR_RESET}===============================\n"
printf "==========================${COLOR_RED}REBOOT NOW${COLOR_RESET}===============================\n"
          
fi
