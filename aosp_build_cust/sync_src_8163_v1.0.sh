#!/bin/bash


#usage:
# bash xx.sh indoor Feature8inch dev 
# bash xx.sh outdoor master dev
set -e

PRODUCT_NAME=$1
KERN_BRANCH=$2
SYST_BRANCH=$3
TIMESTAMP=$4

HOST_NAME=code.zhimahezi.net

echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \n"
echo PRODUCT_NAME= ${PRODUCT_NAME}
echo KERN_BRANCH=  ${KERN_BRANCH}
echo SYST_BRANCH=  ${SYST_BRANCH}
echo TIMESTAMP=    ${TIMESTAMP}
echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \n"

mkdir ${TIMESTAMP}
cd ${TIMESTAMP}

array_comm=( abi art bionic cts dalvik developers docs hardware libcore libnativehelper ndk pdk prebuilts sdk tools )
array_diff=( build development device external frameworks packages system vendor )
array_kern=( bootable kernel-3.10 )

for data in ${array_comm[@]}
do
    echo ${data}  
    GIT_URI=git@${HOST_NAME}:android-mtk8163e/${data}.git
    echo ${GIT_URI}
    git clone ${GIT_URI}
    cd ${data} && git checkout ${SYST_BRANCH} && cd -
done

for data in ${array_diff[@]}
do
    echo ${data}  
    GIT_URI=git@${HOST_NAME}:android-mtk8163e-${PRODUCT_NAME}/${data}.git
    echo ${GIT_URI}
    git clone ${GIT_URI}
    cd ${data} && git checkout ${SYST_BRANCH} && cd -
done


for data in ${array_kern[@]}
do
    echo ${data}  
    GIT_URI=git@${HOST_NAME}:android-mtk8163e-kernel-${PRODUCT_NAME}/${data}.git
    echo ${GIT_URI}
    git clone ${GIT_URI}
    cd ${data} && git checkout ${KERN_BRANCH} && cd -
done

