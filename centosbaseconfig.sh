
    if [ -f /etc/redhat-release ] ; then
      DistroBasedOn='RedHat'
      DIST=`cat /etc/redhat-release |sed s/\ release.*//`
      PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
      REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
    
    echo $DistroBasedOn
    echo $DIST
    echo $PSUEDONAME
    echo $REV
