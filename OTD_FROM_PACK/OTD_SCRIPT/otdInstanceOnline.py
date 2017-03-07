connect('weblogic','that is a secret','t3://cernanappiloadbalancer:7001/em')
#readDomain('/ORA/Oracle/Middleware/Oracle_Home/user_projects/domains/otd_domain1')
edit()
startEdit()
props={'machine': 'anappilb', 'configuration': 'defaultConfiguration'}
otd_createInstance(props)
save()
activate()
exit()
