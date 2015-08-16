if [ -f /etc/centos-release ] ; then
     DistroBasedOn='CentOS'
     DIST=`cat /etc/redhat-release |sed s/\ release.*//`
     PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
     REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
fi

if [ $DistroBasedOn == "CentOS" ]; then
     echo "**CentOS - Operating System found"
     echo "**Running update"
     sudo yum update -y
     echo "**Running Upgrade"
     sudo yum upgrade -y
     FILE=~/.bash_profile
     cp $FILE /tmp
     echo "**Setting Proxy"
     cat << EOF > $FILE
# .bash_profile
# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
PATH=$PATH:$HOME/bin
export PATH
export http_proxy=http://proxy-wsa.esl.cisco.com:80
export https_proxy=http://proxy-wsa.esl.cisco.com:80
export HTTP_PROXY=http://proxy-wsa.esl.cisco.com:80
export HTTPS_PROXY=http://proxy-wsa.esl.cisco.com:80
export ftp_proxy=http://proxy-wsa.esl.cisco.com:80
export FTP_PROXY=http://proxy-wsa.esl.cisco.com:80
export no_proxy=localhost,10.52.*,172.16.*,192.168.*
EOF
     echo "**Making backup to /tmp/"
     FILE=/etc/sysconfig/selinux
     cp $FILE /tmp
     echo "**Disabling SELinux"
     cat << EOF > $FILE
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
# enforcing - SELinux security policy is enforced.
# permissive - SELinux prints warnings instead of enforcing.
# disabled - SELinux is fully disabled.
SELINUX=disabled
# SELINUXTYPE= type of policy in use. Possible values are:
# targeted - Only targeted network daemons are protected.
# strict - Full SELinux protection.
SELINUXTYPE=targeted
EOF
     echo "**Stopping Network Manager"
     service NetworkManager stop
     echo "**Disabling Network Manager on reboot"
     chkconfig NetworkManager off
     echo "**Enabling default network controller"
     chkconfig network on
     echo "**Starting default network controller"
     service network start
     echo "**Setting Default Gateway"
     FILE=/etc/sysconfig/network
     cat << EOF > $FILE
GATEWAY=10.52.208.1
EOF
     echo "**Adding EPEL repository"
     sudo yum install epel-release -y
     echo "**Enabling new repositories"
     sed '/\[epel\]/,/enabled=0/ { s/enabled=0/enabled=1/ }' /etc/yum.repos.d/epel.repo -i
     sed '/\[epel-source\]/,/enabled=0/ { s/enabled=0/enabled=1/ }' /etc/yum.repos.d/epel.repo -i
     sed '/\[epel-debuginfo\]/,/enabled=0/ { s/enabled=0/enabled=1/ }' /etc/yum.repos.d/epel.repo -i
     echo "**Setting YUM Proxy"
     sed '/\[main\]/,/proxy/ { s@proxy=.*@proxy=http://proxy-wsa.esl.cisco.com:80@ }' /etc/yum.conf -i
     echo "**Updating packages"
     sudo yum update
     echo "**Installing some base tools"
     sudo yum install -y nano wget
     echo "**Installing RDO Juno"
     sudo yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-juno/rdo-release-juno-1.noarch.rpm
     echo "**Installing packstack"
     sudo yum install -y openstack-packstack
     echo "**Running packstack"
     packstack --allinone
     FILE=/etc/sysconfig/network-scripts/ifcfg-br-ex
     cat << EOF > $FILE
DEVICE=br-ex 
ONBOOT=yes 
DEVICETYPE=ovs 
TYPE=OVSIntPort 
OVS_BRIDGE=br-ex 
USERCTL=no 
BOOTPROTO=none 
HOTPLUG=no 
IPADDR=10.52.208.83
NETMASK=255.255.255.0
GATEWAY=10.52.208.1
DNS1=10.52.208.5,144.254.71.184
DEVICE=ens32
ONBOOT=yes 
NETBOOT=yes 
IPV6INIT=no 
BOOTPROTO=none 
NAME=ens32
DEVICETYPE=ovs 
TYPE=OVSPort 
OVS_BRIDGE=br-ex
EOF
     sudo service network restart
fi
