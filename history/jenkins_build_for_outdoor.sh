#!/bin/bash

#cd /home/jenkins/
TIMESTAMP=outdoor.tmp.$(date +%Y%m%d.%H%M%S)
mkdir $TIMESTAMP
cd $TIMESTAMP

array_comm=( abi art bionic cts dalvik developers docs hardware libcore libnativehelper ndk pdk prebuilts sdk tools )
array_diff=( build development device external frameworks packages system vendor )
array_kern=( bootable kernel-3.10 )

for data in ${array_comm[@]}
do
    echo ${data}  
    GIT_URI=git@192.168.1.2:android-mtk8163e/${data}.git
    echo $GIT_URI
    git clone $GIT_URI
done

for data in ${array_diff[@]}
do
    echo ${data}  
    GIT_URI=git@192.168.1.2:android-mtk8163e-outdoor/${data}.git
    echo $GIT_URI
    git clone $GIT_URI
done


for data in ${array_kern[@]}
do
    echo ${data}  
    GIT_URI=git@192.168.1.2:android-mtk8163e-kernel-outdoor/${data}.git
    echo $GIT_URI
    git clone $GIT_URI
done

cp build/Makefile               .

time bash ~/scripts/auto_build_latest.sh outdoor OTA CacheClean "GitLatest.BranchMaster"

cd -
#rm -rf $TIMESTAMP


