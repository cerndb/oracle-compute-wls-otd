DOMAIN_DIR=${DOMAIN_HOME:-/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/base_domain}

sed -i 's/WLS_USER=.*/WLS_USER="weblogic"/' $DOMAIN_DIR/bin/startManagedWebLogic.sh
sed -i 's/WLS_PW=.*/WLS_PW=$ADMIN_PASSWORD/' $DOMAIN_DIR/bin/startManagedWebLogic.sh

yum install -y nc

current_dir=`pwd`

source $current_dir/set_env.sh

test_admin=`nc $ADMIN_HOST $ADMIN_PORT < /dev/null`
result_test_admin=$?

while [ $result_test_admin -ne 0 ]
do
   sleep 10
   test_admin=`nc $ADMIN_HOST $ADMIN_PORT < /dev/null`
   result_test_admin=$?
done


server=`hostname`

$DOMAIN_DIR/bin/startManagedWebLogic.sh $server http://$ADMIN_HOST:$ADMIN_PORT



