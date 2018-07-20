#!/bin/bash

ipaddr=$(cat ../info.txt | awk '{print $1}')
checkhost=$(ping -c 1 $ipaddr &> /dev/null && echo success || echo fail)
if [ $checkhost == "success" ]
then
	ssh root@$ipaddr "ls"  &> /dev/null && echo "" &> /dev/null || echo "ERROR"
	cp template template.repo &> /dev/null
	ssh root@$ipaddr "mkdir  /etc/yum.repos.d/old " &> /dev/null
	ssh root@$ipaddr "mv /etc/yum.repos.d/* /etc/yum.repos.d/old/ " &> /dev/null
	sed -i  "s|IPADDR|$ipaddr|g"   template.repo &> /dev/null
	scp template.repo  root@$ipaddr:/etc/yum.repos.d/ &> /dev/null
	rm -rf template.repo &> /dev/null
	ssh root@$ipaddr "bash -s " < template.sh
else
	echo "DOWN"
fi
