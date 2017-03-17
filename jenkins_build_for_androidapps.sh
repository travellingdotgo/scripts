#!/bin/bash

. /etc/env_java18.sh
java -version

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
aapt  dump badging ./app/build/outputs/apk/app-release.apk | grep version

#cp & cleanup
mkdir -p ${TARGET_PATH}
cp -rf ./app/build/outputs/* ${TARGET_PATH}
chmod 777 -R ${TARGET_PATH}
#rm -rf ${WORK_DIR}/${TIMESTAMP}






#usage:
# bash xx.sh moredian-taxhall master
