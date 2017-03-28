#!/bin/bash

#. /etc/env_java18.sh
java -version

set -e

TIMESTAMP=$(date +%Y%m%d.%H%M%S)
PROJ_NAME=$1
GIT_BRANCH=$2
WORK_DIR=`pwd`
TARGET_PATH=/share/samba/public/release/${PROJ_NAME}/${GIT_BRANCH}.${TIMESTAMP}

# download
mkdir ${TIMESTAMP}
cd ${TIMESTAMP}
git clone git@code.moredian.com:terminals/${PROJ_NAME}.git
cd ${PROJ_NAME}

#compile
git checkout ${GIT_BRANCH}
bash ./gradlew clean build
#VERCODE=`git rev-list HEAD --count`
#GIT_TAG=`git describe --tags`

VERSION_AAPT=`aapt  dump badging ./app/build/outputs/apk/app-release.apk | grep version`
echo ${VERSION_AAPT}

#cp & cleanup
mkdir -p ${TARGET_PATH}
cp -rf ./app/build/outputs/* ${TARGET_PATH}
chmod 777 -R ${TARGET_PATH}
cd ${TARGET_PATH}/apk


for  i in `ls|grep apk`
do
VERCODE=${VERSION_AAPT#*versionCode\=\'}
VERCODE=${VERCODE%%\'\ versionName*}
VERNAME=${VERSION_AAPT#*versionName\=\'}
VERNAME=${VERNAME%%\'\ platformBuildVersionName*}
newName=${PROJ_NAME}_verName.${VERNAME}_verCode.${VERCODE}_${GIT_BRANCH}_${TIMESTAMP}_${i}
mv ${i} ${newName}
md5sum ${newName} >> md5.txt
done
#rm -rf ${WORK_DIR}/${TIMESTAMP}






#usage:
# bash xx.sh moredian-taxhall master
