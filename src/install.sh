#!/bin/bash
#Author: Viki -> V Natrajan (https://viki.design)

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
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
sudo apt-add-repository 'deb https://download.ceph.com/debian-mimic xenial main'
sudo apt-get update
sudo apt-get remove ceph-deploy -y
sudo apt-get -y install ceph-deploy
check_command_status ${LINENO}

ceph-deploy purge $CEPH_MON_HOSTNAME $CEPH_OSD1_HOSTNAME $CEPH_OSD2_HOSTNAME $CEPH_OSD3_HOSTNAME
ceph-deploy purgedata $CEPH_MON_HOSTNAME $CEPH_OSD1_HOSTNAME $CEPH_OSD2_HOSTNAME $CEPH_OSD3_HOSTNAME
ceph-deploy forgetkeys
rm ceph*

ceph-deploy  new $CEPH_MON_HOSTNAME
check_command_status ${LINENO}

echo "public network = $CEPH_NETWORK" >> ceph.conf

ceph-deploy install --release mimic $CEPH_MON_HOSTNAME  $CEPH_OSD1_HOSTNAME $CEPH_OSD2_HOSTNAME $CEPH_OSD3_HOSTNAME


check_command_status ${LINENO}


ceph-deploy  mon create-initial

check_command_status ${LINENO}

ceph-deploy  admin $CEPH_MON_HOSTNAME  $CEPH_OSD1_HOSTNAME  $CEPH_OSD2_HOSTNAME $CEPH_OSD3_HOSTNAME

check_command_status ${LINENO}

ceph-deploy   mgr create $CEPH_MON_HOSTNAME

check_command_status ${LINENO}

ceph-deploy   osd create --data /dev/vdd  $CEPH_OSD1_HOSTNAME
check_command_status ${LINENO}

ceph-deploy   osd create --data /dev/vdd  $CEPH_OSD2_HOSTNAME
check_command_status ${LINENO}

ceph-deploy   osd create --data /dev/vdd  $CEPH_OSD3_HOSTNAME
check_command_status ${LINENO}

#Login to monitor and check ceph health

ceph-deploy   mds create $CEPH_MON_HOSTNAME
check_command_status ${LINENO}

#add extra monitor
ceph-deploy  mon add $CEPH_OSD1_HOSTNAME
check_command_status ${LINENO}

ceph-deploy  mon add $CEPH_OSD2_HOSTNAME
check_command_status ${LINENO}

ceph-deploy  rgw create $CEPH_MON_HOSTNAME



