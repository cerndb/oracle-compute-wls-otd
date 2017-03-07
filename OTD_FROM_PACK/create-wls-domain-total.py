# Copyright (c) 2014-2015 Oracle and/or its affiliates. All rights reserved.
#
# WebLogic on Docker Default Domain
#
# Domain, as defined in DOMAIN_NAME, will be created in this script. Name defaults to 'base_domain'.
#
# Since : October, 2014
# Author: bruno.borges@oracle.com
# ==============================================
domain_name  = os.environ.get("DOMAIN_NAME", "base_domain")
admin_port   = int(os.environ.get("ADMIN_PORT", "7001"))
admin_port_ssl = int(os.environ.get("ADMIN_PORT_SSL", "7002"))
admin_pass   = os.environ.get("ADMIN_PASSWORD")
cluster_name = os.environ.get("CLUSTER_NAME", "DockerCluster")
domain_path  = '/ORA/Oracle/Middleware/Oracle_Home/user_projects/domains/' + domain_name

# Open default domain template
# ======================
readTemplate("/ORA/Oracle/Middleware/Oracle_Home/wlserver/common/templates/wls/wls.jar")

# Configure the Administration Server and SSL port.
# =========================================================
cd('/Servers/AdminServer')
set('ListenAddress', '')
set('ListenPort', admin_port)
set('TunnelingEnabled', 'true')
# Enablv SSL
# ========================

# Define the user password for weblogic
# =====================================
cd('/Security/base_domain/User/weblogic')
cmo.setPassword(admin_pass)

# Write the domain and close the domain template
# ==============================================
setOption('OverwriteDomain', 'true')
setOption('ServerStartMode','prod')

cd('/NMProperties')
set('ListenAddress','')
set('ListenPort',5556)
set('LogLevel', 'FINEST')
set('SecureListener', 'false')

# Set the Node Manager user name and password
cd('/SecurityConfiguration/base_domain')
set('NodeManagerUsername', 'weblogic')
set('NodeManagerPasswordEncrypted', admin_pass)

# Write Domain
# ============
writeDomain(domain_path)

# Exit WLST
# =========
exit()
