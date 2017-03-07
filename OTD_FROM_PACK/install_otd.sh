#!/bin/bash

current_dir=`pwd`
packages=`cat $current_dir/to_install.txt`
sudo yum install -y $packages
sudo rpm -ivh $current_dir/jdk-*.rpm
sudo swapon -v /dev/mapper/vg_main-lv_swap


mkdir /ORA/tmp
export TMP="/ORA/tmp"
export TEMP=$TMP

rm -rf /tmp/*

OTD_DOMAIN="/ORA/Oracle/Middleware/Oracle_Home/user_projects/domains/otd_domain1"
export _JAVA_OPTIONS="$_JAVA_OPTIONS -Djava.io.tmpdir=/ORA/tmp"


java -jar $current_dir/fmw_12.2.1.2.0_infrastructure.jar -silent -responseFile $current_dir/responseFile -invPtrLoc $current_dir/oraInst.loc


export ORACLE_HOME=/ORA/Oracle/Middleware/Oracle_Home/

rm -rf /tmp/*

java -jar $current_dir/fmw_12.2.1.2.0_wls.jar -silent ORACLE_HOME=$ORACLE_HOME -responseFile $current_dir/responseFileWLS -invPtrLoc $current_dir/oraInst.loc

/ORA/Oracle/Middleware/Oracle_Home/oracle_common/common/bin/wlst.sh $current_dir/create-wls-domain-total.py

rm -rf /tmp/*

$current_dir/fmw_12.2.1.2.0_otd_linux64.bin -silent ORACLE_HOME=$ORACLE_HOME DECLINE_SECURITY_UPDATES=true INSTALL_TYPE="Collocated OTD (Managed through WebLogic server)" -invPtrLoc $ORACLE_HOME/oraInst.loc

/ORA/Oracle/Middleware/Oracle_Home/oracle_common/common/bin/wlst.sh $current_dir/OTD_SCRIPT/otdDomain.py

$OTD_DOMAIN/startWebLogic.sh &

sed -i.bak "s/ListenAddress=localhost/ListenAddress=`hostname`/" $OTD_DOMAIN/nodemanager/nodemanager.properties

sudo yum install -y nc

host=`hostname`
test_admin=`nc $host 7001 < /dev/null`
result_test_admin=$?

while [ $result_test_admin -ne 0 ]
do
      sleep 10
      nc $host 7001 < /dev/null
      result_test_admin=$?
done


$OTD_DOMAIN/bin/startNodeManager.sh &

test_node_nm=`nc $host 5556 < /dev/null`
result_test_nm=$?

while [ $result_test_nm -ne 0 ]
do
	      sleep 10
              nc $host 5556 < /dev/null
              result_test_nm=$?
done




/ORA/Oracle/Middleware/Oracle_Home/oracle_common/common/bin/wlst.sh $current_dir/OTD_SCRIPT/otdMachine.py
/ORA/Oracle/Middleware/Oracle_Home/oracle_common/common/bin/wlst.sh $current_dir/OTD_SCRIPT/otdConfigurationOnline.py
/ORA/Oracle/Middleware/Oracle_Home/oracle_common/common/bin/wlst.sh $current_dir/OTD_SCRIPT/otdInstanceOnline.py
/ORA/Oracle/Middleware/Oracle_Home/oracle_common/common/bin/wlst.sh $current_dir/OTD_SCRIPT/otdStartInstance.py






