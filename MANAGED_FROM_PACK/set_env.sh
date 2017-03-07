export DOMAIN_NAME="base_domain" \
	ADMIN_PORT="7001" \
	ADMIN_PORT_SSL="7002" \
	ADMIN_HOST="cernanappicomputeadmin" \
	ADMIN_USERNAME="weblogic" \
	ADMIN_PASSWORD="that's a secret" \
	DOMAIN_HOME="/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/base_domain" \
	SERVER1="cernanappicomputemanaged1" \
	SERVER2="cernanappicomputemanaged2" \
	NM_PORT="5557" \
	MS_PORT="7005" \
	CONFIG_JVM_ARGS="-Dweblogic.security.SSL.ignoreHostnameVerification=false -Dweblogic.security.SSL.enableJSSE=true -Djava.security.egd=file:/dev/./urandom -Dweblogic.data.canTransferAnyFile=true -Dweblogic.security.SSL.protocolVersion=TLS1" \
	JAVA_OPTIONS="-Dweblogic.security.SSL.ignoreHostnameVerification=false -Dweblogic.security.SSL.enableJSSE=true -Djava.security.egd=file:/dev/./urandom -Dweblogic.data.canTransferAnyFile=true -Doracle.net.tns_admin=/ORA/dbs01/syscontrol/etc -Dweblogic.security.SSL.protocolVersion=TLS1" \
	PATH=$PATH:/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/wlserver/common/bin:/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/oracle_comon/common/bin:/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic:/ORA/dbs01/oracle/product/Middleware_12.2.1.0_generic/user_projects/domains/${DOMAIN_NAME}/bin \
	POST_CLASSPATH=$POST_CLASSPATH:/ORA/dbs01/syscontrol/projects/wls/saml2Module/deployments/WlsAttributeNameMapper-2.0.jar \
	ADMINURL=$ADMIN_HOST:$ADMIN_PORT

