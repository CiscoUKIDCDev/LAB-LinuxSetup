if [ -f /etc/centos-release ] ; then
     DistroBasedOn='CentOS'
     DIST=`cat /etc/redhat-release |sed s/\ release.*//`
     PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
     REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
fi

echo $DistroBasedOn
echo $DIST
echo $PSUEDONAME
echo $REV

if [ $DistroBasedOn == "CentOS" ]; then
     echo "CentOS - Operating System found"
     echo "Running update"
     sudo yum update -y
     echo "Running Upgrade"
     sudo yum upgrade -y
     FILE=~/.bash_profile
     cp $FILE /tmp
     echo "Setting Proxy"
     cat << EOF > $FILE
# .bash_profile
# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
PATH=$PATH:$HOME/bin
export PATH
export http_proxy=http://proxy-wsa.esl.cisco.com:80/
export https_proxy=http://proxy-wsa.esl.cisco.com:80/
export HTTP_PROXY=http://proxy-wsa.esl.cisco.com:80/
export HTTPS_PROXY=http://proxy-wsa.esl.cisco.com:80/
EOF
     echo "Disabling SELinux"
     echo "Making backup to /tmp/"
     FILE=/etc/sysconfig/selinux
     cp $FILE /tmp
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
     echo "done!"
     echo "Stopping Network Manager"
     service NetworkManager stop
     echo "Disabling Network Manager on reboot"
     chkconfig NetworkManager off
     echo "Enabling default network controller"
     chkconfig network on
     echo "Starting default network controller"
     service network start
     echo "Adding EPEL repository"
     sudo yum install epel-release -y
     sed '/\[epel\]/,/enabled=0/ { s/enabled=0/enabled=1/ }' /etc/yum.repos.d/epel.repo -i
     sed '/\[epel-source\]/,/enabled=0/ { s/enabled=0/enabled=1/ }' /etc/yum.repos.d/epel.repo -i
     sed '/\[epel-debuginfo\]/,/enabled=0/ { s/enabled=0/enabled=1/ }' /etc/yum.repos.d/epel.repo -i
     sudo yum update
     sudo yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-juno/rdo-release-juno-1.noarch.rpm
     sudo yum install -y openstack-packstack
     packstack --allinone
fi
