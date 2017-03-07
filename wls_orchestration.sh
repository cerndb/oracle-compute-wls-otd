#!/bin/bash

orchestration_name="CERNorchestration"
compute_cloud="https://api-cloud.compute.example.oracle.com"
token_file="requestbody.json"
admin_instance_name="CERNanappiComputeAdmin"
lb_instance_name="CERNanappiLoadBalancer"
id_project="YOUR_ID_PROJECT"
user="Antonio.Nappi@cern.ch"
admin_ipreservation_name="cern-anappi-reservation-admin"
lb_ipreservation_name="cern-anappi-reservation-lb"
managed1_ipreservation_name="cern-anappi-reservation-managed1"
managed1_instance_name="cernanappicomputemanaged1"
create_storage_command="sudo mkdir /ORA && sudo mkfs.ext3 -q /dev/xvdb && sudo mount /dev/xvdb/ /ORA && sudo chown -R opc:opc /ORA"
clean_storage_command="sudo umount /ORA && sudo rm -rf /ORA"


function get_ip_public() {

	local ip=`curl -s -X GET -H "Cookie: $COMPUTE_COOKIE" -H "Accept: application/oracle-compute-v3+json" $compute_cloud/ip/reservation/Compute-$id_project/$user/$1/ |  python -c "import sys, json; print json.load(sys.stdin)['result'][0]['ip']"`
	echo $ip

}


function wait_orchestration {

	echo "curl -s -X GET -H \"Cookie: $COMPUTE_COOKIE\" -H \"Accept: application/oracle-compute-v3+json\" $compute_cloud/orchestration/Compute-$id_project/$user/$orchestration_name | python -c \"import sys,json; print json.load(sys.stdin)['result']\""
	result=""
	while [ "$result" != "ready" ]
	do
		result=`curl -s -X GET -H "Cookie: $COMPUTE_COOKIE" -H "Accept: application/oracle-compute-v3+json" $compute_cloud/orchestration/Compute-$id_project/$user/$orchestration_name | python -c "import sys,json; print json.load(sys.stdin)['oplans'][0]['status']"`
		echo "The orchestration is not ready yet. It is in this status: " $result
		sleep 5
	done
}


function create_orchestration {

	echo -e "\n"
	echo "curl -s -i -X POST -H \"Cookie: $COMPUTE_COOKIE\" -H \"Content-Type: application/oracle-compute-v3+json\" -H \"Accept: application/oracle-compute-v3+json\" -d \"@orchestration.json\" $compute_cloud/orchestration/"
	curl -s -i -X POST -H "Cookie: $COMPUTE_COOKIE" -H "Content-Type: application/oracle-compute-v3+json" -H "Accept: application/oracle-compute-v3+json" -d "@orchestration.json" $compute_cloud/orchestration/
}


function get_auth_token {

	prefix="Set-Cookie: "
	echo -e "\n"
	echo "curl -s -i -X POST -H \"Content-Type: application/oracle-compute-v3+json\" -d @$token_file $compute_cloud/authenticate/ | grep $prefix"
	token=`curl -s -i -X POST -H "Content-Type: application/oracle-compute-v3+json" -d @$token_file $compute_cloud/authenticate/ | grep $prefix`
	token=`echo $token | sed -e "s/^$prefix//"`
	export COMPUTE_COOKIE=$token
}


function configure_admin() {

	echo "scp -q -o StrictHostKeyChecking=no -i privateKey -r ADMIN_FROM_PACK opc@$1:/home"
	scp -q -o StrictHostKeyChecking=no -i privateKey -r ADMIN_FROM_PACK opc@$1:/home
}


function configure_storage() {

	echo "ssh -q -o StrictHostKeyChecking=no -i privateKey opc@$1 \"$create_storage_command\""
	ssh -q -o StrictHostKeyChecking=no -i privateKey opc@$1 "$create_storage_command"

}


function copy_private_key_to_admin() {

	echo "scp -q -o 'StrictHostKeyChecking=no' -i privateKey ./privateKey opc@$1:/ORA"
	scp -q -o 'StrictHostKeyChecking=no' -i privateKey ./privateKey opc@$1:/ORA
}


function copy_file_to_admin {

	echo "sudo scp -o StrictHostKeyChecking=no -i ./privateKey -r ./ADMIN_FROM_PACK opc@$1:/ORA/"
	sudo scp -q -o 'StrictHostKeyChecking=no' -i ./privateKey -r ./ADMIN_FROM_PACK opc@$1:/ORA/
	echo "sudo scp -q -o StrictHostKeyChecking=no -i ./privateKey -r ./rpms opc@$1:/ORA/"
	sudo scp -q -o StrictHostKeyChecking=no -i ./privateKey -r ./rpms opc@$1:/ORA/

}


function configure_admin() {

	echo "ssh -o StrictHostKeyChecking=no -i privateKey opc@$1 \"sudo rpm -i /ORA/rpms/cerndb*.rpm\""
	ssh -o 'StrictHostKeyChecking=no' -i privateKey opc@$1 "sudo rpm -i /ORA/rpms/cerndb*.rpm"
	echo "ssh -o StrictHostKeyChecking=no -i privateKey opc@$1 \"cd /ORA/ADMIN_FROM_PACK && sudo /ORA/ADMIN_FROM_PACK/create_domain_from_jar.sh\""
	ssh -o 'StrictHostKeyChecking=no' -i privateKey opc@$1 "cd /ORA/ADMIN_FROM_PACK && sudo sh /ORA/ADMIN_FROM_PACK/create_domain_from_jar.sh > admin.log 2>&1 " &
}


function copy_file_to_managed() {

	echo "sudo scp -o StrictHostKeyChecking=no -i ./privateKey -r ./MANAGED_FROM_PACK opc@$1:/ORA/"
        sudo scp -q -o StrictHostKeyChecking=no -i ./privateKey -r ./MANAGED_FROM_PACK opc@$1:/ORA/
	echo "sudo scp -q -o StrictHostKeyChecking=no -i ./privateKey -r ./rpms opc@$1:/ORA/"
	sudo scp -q -o StrictHostKeyChecking=no -i ./privateKey -r ./rpms opc@$1:/ORA/
}


function configure_managed() {

	echo "ssh -o StrictHostKeyChecking=no -i privateKey opc@$1 \"sudo rpm -i /ORA/rpms/cerndb*.rpm\""
	ssh -o 'StrictHostKeyChecking=no' -i privateKey opc@$1 "sudo rpm -i /ORA/rpms/cerndb*.rpm"
	echo "ssh -o StrictHostKeyChecking=no -i privateKey opc@$1 \"cd /ORA/MANAGED_FROM_PACK && sudo /ORA/MANAGED_FROM_PACK/create_domain_managed.sh\""
	ssh -o 'StrictHostKeyChecking=no' -i privateKey opc@$1 "cd /ORA/MANAGED_FROM_PACK && sudo sh /ORA/MANAGED_FROM_PACK/create_domain_managed.sh > managed1.log 2>&1" &
}


function copy_file_to_lb() {

	echo "sudo scp -o StrictHostKeyChecking=no -i ./privateKey -r ./OTD_FROM_PACK opc@$1:/ORA/"
	sudo scp -q -o StrictHostKeyChecking=no -i ./privateKey -r ./OTD_FROM_PACK opc@$1:/ORA
	echo "sudo scp -q -o StrictHostKeyChecking=no -i ./privateKey -r ./rpms opc@$1:/ORA/OTD_FROM_PACK"
	sudo scp -q -o StrictHostKeyChecking=no -i ./privateKey -r ./rpms/jdk-*.rpm opc@$1:/ORA/OTD_FROM_PACK
	echo "sudo scp -q -o StrictHostKeyChecking=no -i ./privateKey -r ./bin/* opc@$1:/ORA/OTD_FROM_PACK"
	sudo scp -q -o StrictHostKeyChecking=no -i ./privateKey -r ./bin/* opc@$1:/ORA/OTD_FROM_PACK


}


function configure_lb(){

	echo "ssh -o 'StrictHostKeyChecking=no' -i privateKey opc@$1 \"cd /ORA/OTD_FROM_PACK/ && sudo chmod +x install_otd.sh && sh install_otd.sh > otd.log 2>&1\""
	ssh -o 'StrictHostKeyChecking=no' -i privateKey opc@$1 "cd /ORA/OTD_FROM_PACK/ && sudo chmod +x install_otd.sh && sh install_otd.sh > otd.log 2>&1"
}


function main {

	get_auth_token
	create_orchestration
	wait_orchestration
	echo -e "\n"
	local admin_public_ip=$(get_ip_public $admin_ipreservation_name)
	local lb_public_ip=$(get_ip_public $lb_ipreservation_name)
	local managed1_public_ip=$(get_ip_public $managed1_ipreservation_name)
	ssh-keygen -R $admin_public_ip
	ssh-keygen -R $lb_public_ip
	ssh-keygen -R $managed1_public_ip

	echo -e "\n"
	echo "###################################"
	echo "#########CONFIGURATION STORAGE#####"
	echo "#########ADMIN#####################"
	configure_storage $admin_public_ip
	echo "#########LB########################"
	configure_storage $lb_public_ip
	echo "#########MANAGED1##################"
	configure_storage $managed1_public_ip
	echo "#####END CONFIGURATION STORAGE#####"
	echo "###################################"

	echo "###################################"
	echo "#########CONFIGURATION ADMIN#######"
	echo "#########COPY FILE#################"
	copy_file_to_admin $admin_public_ip
	echo "#########START WLS ON ADMIN########"
	configure_admin $admin_public_ip
	echo "#####END CONFIGURATION ADMIN#######"
	echo "###################################"

	echo "###################################"
	echo "########CONFIGURATION MANAGED1#####"
	echo "#########COPY FILE#################"
	copy_file_to_managed $managed1_public_ip
	echo "#########START WLS ON MANAGED1#####"
	configure_managed $managed1_public_ip
	echo "#####END CONFIGURATION MANAGED1####"
	echo "###################################"

	echo "###################################"
	echo "########CONFIGURATION LB#####"
	echo "#########COPY FILE#################"
	copy_file_to_lb $lb_public_ip
	echo "#########START OTD#################"
	configure_lb $lb_public_ip
	echo "#####END CONFIGURATION LB####"
	echo "###################################"

}

main "$@"
