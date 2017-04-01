#!/bin/bash

set -e

PRODUCT_NAME=$1
LOGO_TYPE=$2
TIMESTAMP=$3

if [ "$LOGO_TYPE"x = "mlogo"x ]; then
    echo ${LOGO_TYPE}
    cp -f /home/jenkins/resource/wxga_kernel.bmp bootable/bootloader/lk/dev/logo/wxga/
    cp -f /home/jenkins/resource/wxga_uboot.bmp bootable/bootloader/lk/dev/logo/wxga/
else
    echo ${LOGO_TYPE}
fi

cat ./device/htt/htt8163_e/full_htt8163_e.mk.bac | sed "s:20160826.160000:${TIMESTAMP}:g" > ./device/htt/htt8163_e/full_htt8163_e.mk

case ${PRODUCT_NAME} in
Outdoor|outdoor)
echo "compiling product_type "$product_type
APK_NAME=Outdoor.apk
AOSP_FOLDER=aosp-outdoor

BIZ_APK_SRC=/home/jenkins/resource/outdoor_latest.apk
BIZ_APK_DES=./vendor/htt/custom_apk/Outdoor.apk

;;
Indoor|indoor)
echo "compilg product_type "$product_type
APK_NAME=Indoor.apk
AOSP_FOLDER=aosp-indoor

BIZ_APK_SRC=/home/jenkins/resource/indoor_latest.apk
BIZ_APK_DES=./vendor/htt/custom_apk/Indoor.apk

;;
*) echo -e "exception !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n"
exit 1
;;
esac

echo "APK_NAME:     "$APK_NAME
echo "AOSP_FOLDER:  "$AOSP_FOLDER
echo "DEST_DIR:     "$DEST_DIR

echo  -e "\n\n ---------------  getting resouce ready  ---------------  "  && sleep 1s

if [ ! -f "${BIZ_APK_DES}" ]; then
cp ${BIZ_APK_SRC} ${BIZ_APK_DES}
fi

if [ ! -f "${BIZ_APK_DES}" ]
then
echo "copying ...."
cp ${BIZ_APK_SRC} ${BIZ_APK_DES}
else
echo "already exists: "${BIZ_APK_DES}
fi
