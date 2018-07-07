#!/bin/bash


OSS=$(cat /etc/redhat-release | grep -oh '7\|6' | head -n1| grep -v ^$)
ipaddr2=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
mkdir  /etc/yum.repos.d/old &> /dev/null

mv /etc/yum.repos.d/Cent* /etc/yum.repos.d/old/ &> /dev/null

#This line will check vsftpd installed or not
vsftpdcheck=$(rpm -qa | grep -o vsftpd)
if [ $vsftpdcheck == "vsftpd" ]
then
        echo "installed" > /dev/null
else
        exit 1
fi

# This line looking for the line for
findresult=$(find /var/ftp/ -name "RPM-GPG-KEY-CentOS-Debug-6" | sed  "s/RPM-GPG-KEY-CentOS-Debug-6//g" | cut -c9-)
sed "s|folder|$findresult|g" -i /etc/yum.repos.d/template.repo


yum install tree -y &> /dev/null

# This line will check tree command
tree=$(rpm -qa | grep -o tree)
if [ $tree == "tree" ]  &> /dev/null 
then
	echo "true"
else
	echo "false"
fi



