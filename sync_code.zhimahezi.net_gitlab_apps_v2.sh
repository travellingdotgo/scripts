#!/bin/bash

echo "script starting"
set -e

ROOT_DIR=/home/jenkins/code.zhimahezi.net_gitlab_apps
HOST=code.zhimahezi.net

rm -rf ${ROOT_DIR}

if [ ! -d ${ROOT_DIR} ]; then
    echo "mkdir ing"
    mkdir -p ${ROOT_DIR}
else
    echo "ROOT_DIR already exists"
fi

cd ${ROOT_DIR}

arr_groups=( x others onboard android_app )

x=( Guardian ScanDemo seeinerMaterial CameraApplication XApp CameraDemo mydemo )
others=( ScanDemoDoubleCamera TestLiveDetect )
onboard=( BaseCamp )
android_app=( zhima-hotel-pack zhima-outdoor zhima-indoor sip-cloudrtc-demo moredian-interim-idcard zhima-gate zhima-self-visitor moredian-taxhall zhima-interim-idcard zhima-community demo4camera SecurityGate zhima-managercenter android-personmanager zhima-visitor MyJsBridge MqttDemo agingtest Doc zhima-nfcverify )

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
