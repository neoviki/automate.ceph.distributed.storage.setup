#!/bin/bash
#Author: Vignesh Natrajan (https://vikiworks.io)
eval UTILITY_DIR=`pwd`
USERNAME="ubuntu"
ADMIN_HOSTNAME="host-192-168-0-6"
CEPH_MON_HOSTNAME="host-192-168-0-20"
CEPH_OSD1_HOSTNAME="host-192-168-0-8"
CEPH_OSD2_HOSTNAME="host-192-168-0-19"
CEPH_OSD3_HOSTNAME="host-192-168-0-4"
#CEPH_OSD4_HOSTNAME="host-192-168-0-17"
#CEPH_OSD4_HOSTNAME="host-192-168-0-21"
CEPH_NETWORK="192.168.0.0/24"
CLUSTER_NAME="my_cluster"
DISK_VOLUME="/dev/vdd"

check_command_status(){
    if [ $? -eq 0 ]; then
   	echo
        echo "{ COMMAND STATUS } [ LINE NO: $1 ] [ SUCCESS ] [ CONTINUE ]"
	echo 
    else
	echo
        echo "{ COMMAND STATUS } [ LINE NO: $1 ] [ FAILURE ]    [ EXITTING ]"
	echo
	exit 1 
    fi
}

mkdir ~/$CLUSTER_NAME
cd ~/$CLUSTER_NAME
#wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
#sudo apt-add-repository 'deb https://download.ceph.com/debian-mimic xenial main'
#sudo apt-get update
#sudo apt-get install ceph_deploy 
#check_command_status ${LINENO}

#remove cmt
ceph-deploy purge $CEPH_MON_HOSTNAME $CEPH_OSD1_HOSTNAME $CEPH_OSD2_HOSTNAME $CEPH_OSD3_HOSTNAME
ceph-deploy purgedata $CEPH_MON_HOSTNAME $CEPH_OSD1_HOSTNAME $CEPH_OSD2_HOSTNAME $CEPH_OSD3_HOSTNAME
ceph-deploy forgetkeys
rm ceph*

cd $UTILITY_DIR
ssh -t $CEPH_OSD1_HOSTNAME "sudo rm -rf /tmp/remove_vg.sh;"
ssh -t $CEPH_OSD2_HOSTNAME "sudo rm -rf /tmp/remove_vg.sh;"
ssh -t $CEPH_OSD3_HOSTNAME "sudo rm -rf /tmp/remove_vg.sh;"
scp ./remove_vg.sh $CEPH_OSD1_HOSTNAME:/tmp/
ssh -t $CEPH_OSD1_HOSTNAME "chmod +x /tmp/remove_vg.sh; /tmp/remove_vg.sh $DISK_VOLUME; rm /tmp/remove_vg.sh"
scp ./remove_vg.sh $CEPH_OSD2_HOSTNAME:/tmp/
ssh -t $CEPH_OSD2_HOSTNAME "chmod +x /tmp/remove_vg.sh; /tmp/remove_vg.sh $DISK_VOLUME; rm /tmp/remove_vg.sh"
scp ./remove_vg.sh $CEPH_OSD3_HOSTNAME:/tmp/
ssh -t $CEPH_OSD3_HOSTNAME "chmod +x /tmp/remove_vg.sh; /tmp/remove_vg.sh $DISK_VOLUME; rm /tmp/remove_vg.sh"

