#!/bin/bash


#usage:
# bash xx.sh indoor Feature8inch dev 
# bash xx.sh outdoor master dev
set -e

PRODUCT_NAME=$1
KERN_BRANCH=$2
SYST_BRANCH=$3

HOST_NAME=code.moredian.com
HOST_NAME_K=code.moredian.com

echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \n"
echo PRODUCT_NAME= ${PRODUCT_NAME}
echo KERN_BRANCH=  ${KERN_BRANCH}
echo SYST_BRANCH=  ${SYST_BRANCH}
echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \n"

array_comm=( abi art bionic cts dalvik developers docs hardware libcore libnativehelper ndk pdk prebuilts sdk tools )
array_diff=( build development device external frameworks packages system vendor )
array_kern=( bootable kernel-3.10 )

for data in ${array_comm[@]}
do
    echo ${data}  
    GIT_URI=git@${HOST_NAME}:android_mtk8163e/${data}.git
    echo ${GIT_URI}
    git clone ${GIT_URI} -b ${SYST_BRANCH}
done

for data in ${array_diff[@]}
do
    echo ${data}  
    GIT_URI=git@${HOST_NAME}:android_mtk8163e_${PRODUCT_NAME}/${data}.git
    echo ${GIT_URI}
    git clone ${GIT_URI} -b ${SYST_BRANCH}
done


for data in ${array_kern[@]}
do
    echo ${data}  
    GIT_URI=git@${HOST_NAME_K}:android_mtk8163e_kernel_${PRODUCT_NAME}/${data}.git
    echo ${GIT_URI}
    git clone ${GIT_URI} -b ${KERN_BRANCH}
done

cd ..
