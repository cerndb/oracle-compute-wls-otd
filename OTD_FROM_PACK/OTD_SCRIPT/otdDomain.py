selectTemplate('Oracle Traffic Director - Restricted JRF')
loadTemplates()
cd('Servers/AdminServer')
set('ListenAddress','cernanappiloadbalancer')
set('ListenPort',7001)
cd('/')
cd('Security/base_domain/User/weblogic')
cmo.setPassword('that is a secret')
setOption('OverwriteDomain','true')
cd('/NMProperties')
set('SecureListener','false')
writeDomain('/ORA/Oracle/Middleware/Oracle_Home/user_projects/domains/otd_domain1')
closeTemplate()
exit('y')
