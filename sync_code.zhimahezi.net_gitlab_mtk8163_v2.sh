#!/bin/bash

echo "script starting"
set -e

ROOT_DIR=/home/jenkins/code.zhimahezi.net_gitlab_mtk8163
HOST=code.zhimahezi.net

PRODUCT_NAME=indoor #indoor|outdoor

rm -rf ${ROOT_DIR}

if [ ! -d ${ROOT_DIR} ]; then
    echo "mkdir ing"
    mkdir -p ${ROOT_DIR}
else
    echo "ROOT_DIR already exists"
fi

cd ${ROOT_DIR}


arr_groups=( android_mtk8163e android_mtk8163e_indoor android_mtk8163e_outdoor android_mtk8163e_kernel_indoor android_mtk8163e_kernel_outdoor )
android_mtk8163e=( abi art bionic cts dalvik developers docs hardware libcore libnativehelper ndk pdk prebuilts sdk tools )
android_mtk8163e_indoor=( build development device external frameworks packages system vendor )
android_mtk8163e_outdoor=( build development device external frameworks packages system vendor )
android_mtk8163e_kernel_indoor=( bootable kernel-3.10 )
android_mtk8163e_kernel_outdoor=( bootable kernel-3.10 )



for arrayname in ${arr_groups[@]}; do
    eval "array=(\${$arrayname[@]})"
    echo "$arrayname has ${#array[@]} entries:"
    mkdir ${arrayname} ; cd ${arrayname}
    for id in ${!array[@]}; do
        item=${array[$id]}
        arrayname_connector=${arrayname//_/-}
        GIT_URI=git@${HOST}:${arrayname_connector}/${item}.git
        echo $GIT_URI
        git clone $GIT_URI
    done
    cd ..
    echo
done

