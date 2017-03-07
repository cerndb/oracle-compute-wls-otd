#!/bin/bash

current_dir=`pwd`

rm -rf /ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/

echo -e "\n"
echo "source $current_dir/set_env.sh"
echo -e "\n"

source $current_dir/set_env.sh
/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/oracle_common/common/bin/unpack.sh -template="$current_dir/oracle_cloud_admin.jar" -domain="/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/base_domain" -server_start_mode="dev" -user_name="weblogic" -password="that's a secret" -overwrite_domain=true

mkdir -p /ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/base_domain/servers/AdminServer/security
echo "username=weblogic" > /ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/base_domain/servers/AdminServer/security/boot.properties
echo "password=$ADMIN_PASSWORD" >> /ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/base_domain/servers/AdminServer/security/boot.properties
echo ". /ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/$DOMAIN_NAME/bin/setDomainEnv.sh" >> /ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/.bashrc
echo "export PATH=$PATH:/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/wlserver/common/bin:/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/base_domain/bin" >> /ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/.bashrc

/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/base_domain/startWebLogic.sh &
