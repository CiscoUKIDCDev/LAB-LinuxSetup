if [ -f /etc/centos-release ] ; then
    DistroBasedOn='CentOS'
    DIST=`cat /etc/redhat-release |sed s/\ release.*//`
    PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
    REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
    
echo $DistroBasedOn
echo $DIST
echo $PSUEDONAME
echo $REV
