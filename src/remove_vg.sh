#!/bin/bash
DISK_VOLUME=$1
echo "[ EXECUTING ] sudo pvdisplay $DISK_VOLUME  $VOLUME_GROUP" >> /tmp/ceph_uninstall_status
eval VOLUME_GROUP=`sudo pvdisplay $DISK_VOLUME | grep "VG Name" | awk '{print $3}'`
if [ ! -z "$VOLUME_GROUP" ]
then
	echo "[ EXECUTING ] sudo vgchange -a n $VOLUME_GROUP" >> /tmp/ceph_uninstall_status
	sudo vgchange -a n $VOLUME_GROUP >> /tmp/ceph_uninstall_status
	echo "[ EXECUTING ] vgremove -f $VOLUME_GROUP >> /tmp/ceph_uninstall_status"
	sudo vgremove -f $VOLUME_GROUP >> /tmp/ceph_uninstall_status
else
	echo "  ( NOTICE ) No Volume Group Exist" >> /tmp/ceph_uninstall_status
fi


	      
