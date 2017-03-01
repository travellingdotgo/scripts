#!/bin/bash


PRODUCT_NAME=$1
GIT_BRANCH=$2
PWD=`pwd`
ANOTATION=GitLatest.Branch.$GIT_BRANCH

echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \n"
echo GIT_BRANCH= $GIT_BRANCH
echo PWD= $PWD
echo ANOTATION= $ANOTATION
echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \n"

TIMESTAMP=${PRODUCT_NAME}.tmp.$(date +%Y%m%d.%H%M%S)
mkdir ${TIMESTAMP}
cd ${TIMESTAMP}

array_comm=( abi art bionic cts dalvik developers docs hardware libcore libnativehelper ndk pdk prebuilts sdk tools )
array_diff=( build development device external frameworks packages system vendor )
array_kern=( bootable kernel-3.10 )

for data in ${array_comm[@]}
do
    echo ${data}  
    GIT_URI=git@192.168.1.2:android-mtk8163e/${data}.git
    echo $GIT_URI
    git clone $GIT_URI
    cd ${data} && git checkout $GIT_BRANCH && cd -
done

for data in ${array_diff[@]}
do
    echo ${data}  
    GIT_URI=git@192.168.1.2:android-mtk8163e-${PRODUCT_NAME}/${data}.git
    echo $GIT_URI
    git clone $GIT_URI
    cd ${data} && git checkout $GIT_BRANCH && cd -
done


for data in ${array_kern[@]}
do
    echo ${data}  
    GIT_URI=git@192.168.1.2:android-mtk8163e-kernel-${PRODUCT_NAME}/${data}.git
    echo $GIT_URI
    git clone $GIT_URI
    cd ${data} && git checkout $GIT_BRANCH && cd -
done

cp build/Makefile               .

time bash /home/jenkins/scripts/auto_build_latest_v4.sh ${PRODUCT_NAME} noOTA CacheClean ${ANOTATION}

cd $PWD
rm -rf ${TIMESTAMP}

#usage:
# bash xx.sh indoor master
# bash xx.sh outdoor dev
