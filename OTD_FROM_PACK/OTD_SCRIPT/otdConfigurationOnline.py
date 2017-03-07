#readDomain('/ORA/Oracle/Middleware/Oracle_Home/user_projects/domains/otd_domain1')

connect('weblogic','that is a secret','t3://cernanappiloadbalancer:7001/em')
edit()
startEdit()
#origin-server are the pool where the lb have to listen
props={'server-name': 'cernanappiloadbalancer', 'configuration': 'defaultConfiguration', 'listener-port': '8080', 'origin-server': 'cernanappicomputemanaged1:10110'}
otd_createConfiguration(props)
save()

stopEdit('y')
exit('y')
