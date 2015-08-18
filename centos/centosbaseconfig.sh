#!/bin/bash
# sh scriptname IP NETMASK GATEWAY
# 

HOSTNAME = "ukidcv-centos-roporter"

COLOR_NC='\e[0m';COLOR_WHITE='\e[1;37m';COLOR_BLACK='\e[0;30m';COLOR_BLUE='\e[0;34m';COLOR_LIGHT_BLUE='\e[1;34m';COLOR_GREEN='\e[0;32m';COLOR_LIGHT_GREEN='\e[1;32m';COLOR_CYAN='\e[0;36m';COLOR_LIGHT_CYAN='\e[1;36m';COLOR_RED='\e[0;31m';COLOR_LIGHT_RED='\e[1;31m';COLOR_PURPLE='\e[0;35m';COLOR_LIGHT_PURPLE='\e[1;35m';COLOR_BROWN='\e[0;33m';COLOR_YELLOW='\e[1;33m';COLOR_GRAY='\e[0;30m';COLOR_LIGHT_GRAY='\e[0;37m'

if [ $# -eq 3 ]
  then
    var_ip = $1
    var_nm = $2
    var_dg = $3
  else
    var_ip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d'/')
    var_nm=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f2 -d'/')
    if [ $var_nm -eq "24" ]
      then
        var_nm="255.255.255.0"
    fi
    var_dg=$(/sbin/ip route | awk '/default/ { print $3 }')
fi

printf "${COLOR_YELLOW}Hello, we are just initialising a few things ready for customisation.${COLOR_NC}\n"
printf "==========================${COLOR_LIGHT_PURPLE}IP Information${COLOR_NC}=============================\n"
printf "${COLOR_YELLOW}IP = ${COLOR_NC}${var_ip}\n"
printf "${COLOR_YELLOW}Netmask = ${COLOR_NC}${var_nm}\n"
printf "${COLOR_YELLOW}Default Gateway = ${COLOR_NC}${var_dg}\n"
printf "==========================${COLOR_LIGHT_PURPLE}OS Check${COLOR_NC}===================================\n"

if [ -f /etc/centos-release ] ; then
     DistroBasedOn='CentOS'
     DIST=$(cat /etc/redhat-release |sed s/\ release.*//)
     PSUEDONAME=$(cat /etc/redhat-release | sed s/.*\(// | sed s/\)//)
     REV=$(cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//)
     KERN=$(/usr/bin/uname -r)
fi

if [ $DistroBasedOn == "CentOS" ]; then
     echo "CentOS - Operating System found.......continuing"
     printf "==========================${COLOR_LIGHT_PURPLE}OS Information${COLOR_NC}=============================\n"
     printf "${COLOR_YELLOW}Distribution = ${COLOR_NC}${DIST}\n"
     printf "${COLOR_YELLOW}Branch = ${COLOR_NC}${PSUEDONAME}\n"
     printf "${COLOR_YELLOW}OS Revision = ${COLOR_NC}${REV}\n"
     printf "${COLOR_YELLOW}Kernel Version = ${COLOR_NC}${KERN}\n"   
     printf "==========================${COLOR_LIGHT_PURPLE}Config Files${COLOR_NC}===============================\n"
     FILE=/etc/environment
     value=$(<$FILE)
     if [[ $value == *"http_proxy"* ]]
     then
       echo "Proxy for Cisco Lab already set........."
     else
       cp $FILE /tmp
       echo "Setting system wide Proxy for Cisco Lab"
       cat >> $FILE << EOF
HTTP_PROXY=http://proxy.esl.cisco.com:80/
http_proxy=http://proxy.esl.cisco.com:80/
FTP_PROXY=http://proxy.esl.cisco.com:80/
ftp_proxy=http://proxy.esl.cisco.com:80/
HTTPS_PROXY=http://proxy.esl.cisco.com:80/
https_proxy=http://proxy.esl.cisco.com:80/
NO_PROXY=localhost,127.0.0.1,10.52.*,10.51.*,172.16.*,192.168.*,*.cisco.com
no_proxy=localhost,127.0.0.1,10.52.*,10.51.*,172.16.*,192.168.*,*.cisco.com
DISPLAY=:99.0
SCREEN_WIDTH=1200
SCREEN_HEIGHT=960
SCREEN_DEPTH=24
GEOMETRY="1200x960x24"
alias python3='/usr/bin/python3.4'
alias drm="docker rm -f"
alias dps="docker ps -a"
alias drm="docker rmi"
alias drm="docker images"
EOF
     fi
     FILE=/etc/hostname
     cp $FILE /tmp
     echo "Setting server hostname.................";
     echo $HOSTNAME > $FILE
     FILE=/etc/sysconfig/selinux
     cp $FILE /tmp
     echo "Setting SELinux to permissive...........";
     rm -f $FILE
     cat >> $FILE << EOF 
      # This file controls the state of SELinux on the system.
      # SELINUX= can take one of these three values:
      #     enforcing - SELinux security policy is enforced.
      #     permissive - SELinux prints warnings instead of enforcing.
      #     disabled - No SELinux policy is loaded.
      SELINUX=permissive
      # SELINUXTYPE= can take one of these two values:
      #     targeted - Targeted processes are protected,
      #     minimum - Modification of targeted policy. Only selected processes are protected. 
      #     mls - Multi Level Security protection.
      SELINUXTYPE=targeted 
EOF
     FILE=/etc/ssh/sshd_config
     sed -i -e "s/X11Forwarding no/X11Forwarding yes/g" $FILE
     sed -i -e "s/#X11Forwarding yes/X11Forwarding yes/g" $FILE
     sed -i -e "s/#X11DisplayOffset 10/X11DisplayOffset 10/g" $FILE
     
     
     printf "${COLOR_LIGHT_GREEN}Config Files - Complete${COLOR_NC}\n"
     printf "==========================${COLOR_LIGHT_PURPLE}Running Hacks${COLOR_NC}==============================\n"
     echo "Sourcing new environment file..........."; source /etc/environment
     echo "Removing yum lock manually.............."; rm -f /var/run/yum.pid
     printf "${COLOR_LIGHT_GREEN}Running Hacks - Complete${COLOR_NC}\n"
     printf "==========================${COLOR_LIGHT_PURPLE}Enabling Repositories${COLOR_NC}======================\n"
     echo "Importing predefined repo keys ........."; rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*
     echo "Fethcing key for elrepo for new kernel ."; rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
     echo "Enabling elrepo for new kernel ........."; yum install http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm &> /dev/null
     echo "Enabling epel release repo ............."; rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm &> /dev/null
     printf "${COLOR_LIGHT_GREEN}Enabling Repositories - Complete${COLOR_NC}\n"
     printf "==========================${COLOR_LIGHT_PURPLE}Installing${COLOR_NC}=================================\n"
     echo "Updating YUM ..........................."; yum update -y &> /dev/null
     echo "Upgrading YUM .........................."; yum upgrade -y &> /dev/null
     echo "Installing Dev Tools ..................."; yum groupinstall -y "Development Tools" &> /dev/null
     #echo "Installing Server GUI .................."; yum groupinstall -y "Server with GUI" &> /dev/null
     #echo "Installing X Window System ............."; yum groupinstall -y 'X Window System' &> /dev/null
     #echo "Installing GUI Fonts ..................."; yum groupinstall -y "Fonts" &> /dev/null
     #echo "Installing Cinnamon Desktop ............"; yum install -y cinnamon &> /dev/null
     echo "Installing bzip2 ......................."; yum install -y bzip2 &> /dev/null
     echo "Installing p7zip ......................."; yum install -y p7zip &> /dev/null
     echo "Installing unzip ......................."; yum install -y unzip &> /dev/null
     echo "Installing unrar ......................."; yum install -y unrar &> /dev/null
     echo "Installing nano ........................"; yum install -y nano &> /dev/null
     echo "Installing xorg-x11-server ............."; yum install -y xorg-x11-server-Xvfb &> /dev/null
     echo "Installing x11vnc ......................"; yum install -y x11vnc &> /dev/null
     echo "Installing gtk2 ........................"; yum install -y gtk2 &> /dev/null
     echo "Installing network tools ..............."; yum install -y net-tools &> /dev/null
     echo "Installing python3 ....................."; yum install -y python34.x86_64 &> /dev/null
     echo "Installing xorg-x11-fonts .............."; yum install -y xorg-x11-fonts* &> /dev/null
     echo "Installing Firefox ....................."; yum install -y firefox &> /dev/null
     echo "Installing wget ........................"; yum install -y wget &> /dev/null
     echo "Installing nmap ........................"; yum install -y nmap &> /dev/null
     echo "Installing ntfs-3g ....................."; yum install -y ntfs-3g &> /dev/null
     echo "Installing vsftpd ......................"; yum install -y vsftpd &> /dev/null
     echo "Installing telnet ......................"; yum install -y telnet &> /dev/null
     echo "Installing fail2ban ...................."; yum install -y fail2ban &> /dev/null
     echo "Installing ntp ........................."; yum install -y ntp &> /dev/null
     echo "Installing yum priorities .............."; yum install -y yum-priorities &> /dev/null
     echo "Installing lynx ........................"; yum install -y lynx &> /dev/null
     echo "Installing links ......................."; yum install -y links &> /dev/null
     echo "Installing docker-compose .............."; curl -L https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose &> /dev/null
     echo "Installing Java ........................"; yum install -y java &> /dev/null
     echo "Downloading bar ........................"; wget http://www.theiling.de/downloads/bar-1.4-src.tar.bz2 &> /dev/null
     echo "Extracting bar ........................."; tar xvf bar-1.4-src.tar.bz2 &> /dev/null
     echo "Moving bar ............................."; mv bar-1.4/bar /usr/bin
     echo "Tidying up from bar ...................."; rm -Rf bar-1.4; rm bar-1.4-src.tar.bz2 &> /dev/null
     echo "Installing new 4.x kernel .............."; yum --enablerepo=elrepo-kernel install kernel-ml &> /dev/null
     echo "Enabling new kernel as default ........."; grub2-set-default 0
     
     printf "${COLOR_LIGHT_GREEN}Installing - Complete${COLOR_NC}\n"
     printf "==========================${COLOR_LIGHT_PURPLE}Config Files${COLOR_NC}===============================\n"
     echo "Setting timezone ......................."; timedatectl set-timezone Europe/London
     echo "Setting vsftp configuration ............"
     FILE=/etc/vsftpd/vsftpd.conf
     sed -i -e "s/anonymous_enable=YES/anonymous_enable=NO/g" $FILE
     sed -i -e "s/local_enable=NO/local_enable=YES/g" $FILE
     sed -i -e "s/write_enable=NO/write_enable=YES/g" $FILE
     sed -i -e "s/chroot_local_user=NO/chroot_local_user=YES/g" $FILE
     sed -i -e "s/#chroot_local_user=YES/chroot_local_user=YES/g" $FILE
     
     value=$(cat /etc/vsftpd/vsftpd.conf | grep allow_writeable_chroot=YES)
     if [[ -z "$value" ]]
       then
         echo "allow_writeable_chroot=YES" >> $FILE
     fi
     
     echo "Setting wget proxy configurations ......"
     FILE=/etc/wgetrc
     sed -i -e "s,#ftp_proxy = http://proxy.yoyodyne.com:18023/,ftp_proxy = http://proxy.esl.cisco.com:80/,g" $FILE
     sed -i -e "s,#http_proxy = http://proxy.yoyodyne.com:18023/,http_proxy = http://proxy.esl.cisco.com:80/,g" $FILE
     sed -i -e "s,#https_proxy = http://proxy.yoyodyne.com:18023/,https_proxy = http://proxy.esl.cisco.com:80/,g" $FILE

     
     FILE=/etc/fail2ban/jail.local
     echo "Copying fail2ban confiure file ........."; rm $FILE &> /dev/null; cp /etc/fail2ban/jail.conf $FILE &> /dev/null
     echo "Enabling boot to GUI ..................."; ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target &> /dev/null
     echo "Creating alias for Python3 ............."; alias python3='/usr/bin/python3.4'
     echo "Changing permissions for docker-compose."; chmod +x /usr/local/bin/docker-compose
     #echo "Setting VNC passwd to ${COLOR_RED}secret${COLOR_NC} ..........."; mkdir -p ~/.vnc && x11vnc -storepasswd ${vncpass:-secret} ~/.vnc/passwd &> /dev/null
     
     printf "${COLOR_LIGHT_GREEN}Config Files - Complete${COLOR_NC}\n"
     
     
     printf "==========================${COLOR_LIGHT_PURPLE}Setting aliases${COLOR_NC}============================\n"
     echo "Setting alias for docker rm -f ........."; alias drm="docker rm -f"
     echo "Setting alias for docker ps -a ........."; alias dps="docker ps -a"
     echo "Setting alias for docker rmi ..........."; alias drm="docker rmi"
     echo "Setting alias for docker images ........"; alias drm="docker images"
     printf "${COLOR_LIGHT_GREEN}Disabling Services - Complete${COLOR_NC}\n"
     
     printf "==========================${COLOR_LIGHT_PURPLE}Disabling Services${COLOR_NC}=========================\n"
     echo "Disabling Firewall service .............."; systemctl disable firewalld.service
     printf "${COLOR_LIGHT_GREEN}Disabling Services - Complete${COLOR_NC}\n"
     
     printf "==========================${COLOR_LIGHT_PURPLE}Stopping Services${COLOR_NC}==========================\n"
     echo "Stopping Firewall service ..............."; systemctl stop firewalld.service
     printf "${COLOR_LIGHT_GREEN}Stopping Services - Complete${COLOR_NC}\n"

     printf "==========================${COLOR_LIGHT_PURPLE}Enabling Services${COLOR_NC}==========================\n"
     echo "Enabling vsftpd ........................"; systemctl enable vsftpd &> /dev/null
     echo "Enabling ntpd .........................."; systemctl enable ntpd &> /dev/null
     echo "Enabling fail2ban ......................"; systemctl enable fail2ban.service &> /dev/null
     printf "${COLOR_LIGHT_GREEN}Enabling Services - Complete${COLOR_NC}\n"
     
     printf "==========================${COLOR_LIGHT_PURPLE}Starting Services${COLOR_NC}==========================\n"
     #echo "Starting VNC for Firefox ..............."; xvfb-run --server-args="$DISPLAY -screen 0 $GEOMETRY -ac +extension RANDR" firefox > /var/log/ui_output.log 2> /var/log/ui_error.log &
     echo "Starting vsftpd ........................"; systemctl restart vsftpd
     echo "Starting ntpd .........................."; systemctl restart ntpd
     echo "Starting fail2ban ......................"; systemctl restart fail2ban.service
     echo "Restarting sshd ........................"; systemctl restart sshd
     echo "Switching to GUI Login ................."; systemctl set-default graphical.target &> /dev/null
     #sleep 2
     #echo "Starting VNC ..........................."; x11vnc -forever -usepw -shared -rfbport 5900 -display $DISPLAY
     printf "${COLOR_LIGHT_GREEN}Starting Services - Complete${COLOR_NC}\n"

     
  else
    exit 1
fi