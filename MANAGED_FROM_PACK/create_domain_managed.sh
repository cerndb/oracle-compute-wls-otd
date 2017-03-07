#!/bin/bash

current_dir=`pwd`


echo -e "\n"                         
echo "source $current_dir/set_env.sh"
echo "source $current_dir/set_env.sh"
echo -e "\n"                         

/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/oracle_common/common/bin/unpack.sh -template="$current_dir/oracle_cloud_managed.jar" -domain="/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/base_domain" -overwrite_domain=true
mkdir -p /ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/base_domain/servers/AdminServer/security
echo "username=weblogic" > /ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/base_domain/servers/AdminServer/security/boot.properties
echo "password=$ADMIN_PASSWORD" >> /ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/base_domain/servers/AdminServer/security/boot.properties
echo ". /ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/$DOMAIN_NAME/bin/setDomainEnv.sh" >> /ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/.bashrc
echo "export PATH=$PATH:/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/wlserver/common/bin:/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/base_domain/bin" >> /ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/.bashrc

$current_dir/startManagedWebLogic.sh
