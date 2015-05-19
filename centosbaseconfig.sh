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
     FILE=/etc/sysconfig/selinux
     echo "Disabling SELinux"
     echo "Making backup to /tmp/"
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
     echo "Adding EPEL repository"
     sudo yum install epel-release -y
     sudo yum update
fi
