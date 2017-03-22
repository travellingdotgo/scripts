#!/bin/bash

# -- usage:
# bash /home/jenkins/scripts/aosp_build_cust/facade_v1.0.sh ${PRODUCT_NAME} ${KERN_BRANCH} ${SYST_BRANCH} ${LOGO_TYPE} ${PARA_OTA} ${PARA_CLEANUP}
# bash xx.sh indoor  Feature8inch dev mlogo  OTA   clean
# bash xx.sh outdoor master       dev slogo  noOTA nocle

# /home/jenkins/resource/*_latest.apk should be ready
set -e


echo  -e "\n\n ---------------  verifying args  ---------------  "  && sleep 1s
if [ $# -ne 6 ]
then
echo "invalid para number"
exit 1
fi
echo  -e "verify success ^_^ "

PRODUCT_NAME=$1
KERN_BRANCH=$2
SYST_BRANCH=$3
LOGO_TYPE=$4
OTA_PARA=$5
PARA_CLEAN=$6
PWD=`pwd`
TIMESTAMP=$(date +%Y%m%d.%H%M%S)
ANOTATION=Gitlatest.KERN_${KERN_BRANCH}.SYST_${SYST_BRANCH}

DEST_DIR=/share/samba/public/release/aosp_${PRODUCT_NAME}/user_fac_${TIMESTAMP}_by.`whoami`.${ANOTATION}

BASHDIR="`dirname $BASH_SOURCE`"
SCRIDIR=`readlink -f "$BASHDIR"`

echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \n"
echo PRODUCT_NAME= ${PRODUCT_NAME}
echo KERN_BRANCH=  ${KERN_BRANCH}
echo SYST_BRANCH=  ${SYST_BRANCH}
echo TIMESTAMP=    ${TIMESTAMP}
echo LOGO_TYPE=    ${LOGO_TYPE}
echo PWD= ${PWD}
echo ANOTATION= ${ANOTATION}
. /etc/profile
java -version
echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \n"

# sync source code
time bash ${SCRIDIR}/sync_src_8163_v1.0.sh ${PRODUCT_NAME} ${KERN_BRANCH} ${SYST_BRANCH} ${TIMESTAMP}

# replace
cd ${PWD}/${TIMESTAMP}
time bash ${SCRIDIR}/cust_src_8163_v1.0.sh ${PRODUCT_NAME} ${LOGO_TYPE}

#compile fac
cd ${PWD}/${TIMESTAMP}
cp build/Makefile               .
. build/envsetup.sh && lunch 17 && time make -j64

#deliver
mkdir -p ${DEST_DIR}
cd ${PWD}/${TIMESTAMP}
find out/target/product/htt8163_e/ -maxdepth 1 -type f -exec cp {} ${DEST_DIR}  \;
cp out/target/product/htt8163_e/obj/KERNEL_OBJ/vmlinux ${DEST_DIR}

#compile ota & deliver
cd ${PWD}/${TIMESTAMP}
case $target_type in
OTA)
echo -e "\t ###### OTA building\t ###### "
. build/envsetup.sh && lunch 17 && time make otapackage -j64
cp out/target/product/htt8163_e/*ota*.zip ${DEST_DIR}
;;
noOTA)
echo -e "\t ###### OTA skipping\t ###### "
;;
*) echo -e "exception !!!!!!!!!!!!!!\n\n"
exit 1
;;
esac

#cleanup
chmod 775 ${DEST_DIR} -R

if [ "$PARA_CLEAN"x = "clean"x ]; then
	rm -rf ${PWD}/${TIMESTAMP}
else
	echo "skipping rm"
fi


echo  -e "\n\n ---------------  conclusion  ---------------  "  && sleep 1s
echo "TIMESTAMP: "$TIMESTAMP
echo "NOW      : "$(date +%Y%m%d.%H%M%S)
echo -e "....  bash shell ends here  ....\n\n"


# backup
# find out/target/product/htt8163_e/ -maxdepth 1 -type f -name "*ota*.zip" -exec rm -f {}  \;
