#!/bin/sh

## The Ubports project
## Wait for WCNSS service to setup WLAN device over QMI

# Workaround for conn_init not copying the updated firmware
#rm /data/misc/wifi/WCNSS_qcom_cfg.ini
#rm /data/misc/wifi/WCNSS_qcom_wlan_nv.bin

#export LD_LIBRARY_PATH=/vendor/lib64:/system/lib64:/vendor/lib:/system/lib

sudo cp /system/etc/wifi/WCNSS_qcom_cfg.ini /data/misc/wifi/WCNSS_qcom_cfg.ini

echo initilizing

MAXTRIES=15
j=1

while [ ! $j -gt $MAXTRIES ]  ; do
    echo 1 > /dev/wcnss_wlan
    echo sta > /sys/module/wlan/parameters/fwpath
    if [ "$?" -ne "0" ]; then
      sleep 1
    fi
    
    j=$((j + 1))
done

n=0

until [ "$n" -ge 5 ]
do
   sudo echo 1 > /dev/wcnss_wlan && break
   echo sta > /sys/module/wlan/parameters/fwpath && break  
   n=$((n+1)) 
   sleep 2
   echo round 1
done



sleep 4

echo sta > /sys/module/wlan/parameters/fwpath

echo stage 1

sudo echo 1 > /dev/wcnss_wlan

sleep 4

sudo echo sta > /sys/module/wlan/parameters/fwpath

echo stage 2

sudo -i

sudo echo 1 > /dev/wcnss_wlan

sleep 4

sudo echo sta > /sys/module/wlan/parameters/fwpath

echo echo stage 3

enable_bt () {

        if [[ `getprop ro.qualcomm.bt.hci_transport` != "smd" ]]; then
            setprop ro.qualcomm.bt.hci_transport smd
        fi

        #initialize bt device
        echo 0 > /sys/module/hci_smd/parameters/hcismd_set
        /system/bin/logwrapper -k /system/bin/hci_qcomm_init -vvv -e
        sleep 1
        echo 1 > /sys/module/hci_smd/parameters/hcismd_set

}




done
