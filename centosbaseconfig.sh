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
fi
