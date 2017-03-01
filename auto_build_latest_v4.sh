#!/bin/bash

# auto_build.sh Indoor/Outdoor OTA/noOTA CacheClean/noCacheClean 

set -e
. /etc/profile
java -version

echo -e " ---------------  v9   ---------------  "  && sleep 1s


echo -e " ---------------  echo \$#, \$@, \$0   ---------------  "  && sleep 1s
echo $#
echo $@
echo $0

echo  -e "\n\n ---------------  echo args  ---------------  "  && sleep 1s
for args in $@
do
	echo $args
done

echo -e "\n\n"


echo  -e "\n\n ---------------  analysing args  ---------------  "  && sleep 1s
product_type=$1
target_type=$2
cache_type=$3
comment_str=$4

echo "product_type: "$product_type
echo "target_type:  "$target_type
echo "cache_type:   "$cache_type
echo "comment_str:  "$comment_str

echo  -e "\n\n ---------------  verifying args  ---------------  "  && sleep 1s
if [ $# -ne 4 ]
then
  echo "invalid para number"
  exit 1
fi
echo  -e "verify success ^_^ " 

echo  -e "\n\n ---------------  initing  ---------------  "  && sleep 1s
TIMESTAMP=$(date +%Y%m%d.%H%M%S)
echo "TIMESTAMP: "$TIMESTAMP

APK_NAME=undefined.apk
AOSP_FOLDER=aosp-notdefined
FTP_FOLDER=ftp://undefined.com/somefolder

BIZ_APK_SRC=/undefined_latest.apk
BIZ_APK_DES=./undefined.apk

echo  -e "\n\n ---------------  dumping pid  ---------------  "  && sleep 1s
echo $TIMESTAMP: $$ >> ./pid.txt

echo  -e "\n\n ---------------  product type  ---------------  "  && sleep 1s


case $product_type in
  Outdoor|outdoor)
  echo "compiling product_type "$product_type
  APK_NAME=Outdoor.apk
  AOSP_FOLDER=aosp-outdoor
  FTP_FOLDER=ftp://192.168.2.23/release/outdoor

  BIZ_APK_SRC=/home/jenkins/resource/outdoor_latest.apk
  BIZ_APK_DES=./vendor/htt/custom_apk/Outdoor.apk

  ;;
  Indoor|indoor)
  echo "compilg product_type "$product_type
  APK_NAME=Indoor.apk
  AOSP_FOLDER=aosp-indoor
  FTP_FOLDER=ftp://192.168.2.23/release/indoor

  BIZ_APK_SRC=/home/jenkins/resource/indoor_latest.apk
  BIZ_APK_DES=./vendor/htt/custom_apk/Indoor.apk
 
  ;;
  *) echo -e "exception !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n"  
     exit 1
  ;;
esac


echo  -e "\n\n ---------------  assembling  DEST_DIR ---------------  "  && sleep 1s
DEST_DIR=/share/samba/public/release/$AOSP_FOLDER/user-fac-$TIMESTAMP-by.`whoami`.$comment_str

echo "APK_NAME:     "$APK_NAME
echo "AOSP_FOLDER:  "$AOSP_FOLDER
echo "FTP_FOLDER:   "$FTP_FOLDER
echo "DEST_DIR:     "$DEST_DIR

echo  -e "\n\n ---------------  getting resouce ready  ---------------  "  && sleep 1s

cat ./device/htt/htt8163_e/full_htt8163_e.mk.bac | sed "s:20160826.160000:$TIMESTAMP:g" > ./device/htt/htt8163_e/full_htt8163_e.mk
#rm -rf vendor/htt/custom_apk/$APK_NAME    # mv vendor/htt/custom_apk/$APK_NAME vendor/htt/custom_apk/$APK_NAME.bac
#rm -rf vendor/htt/custom_apk/readme.txt   # mv vendor/htt/custom_apk/readme.txt vendor/htt/custom_apk/readme.txt.bac
if [ ! -f "${BIZ_APK_DES}" ]; then
  cp ${BIZ_APK_SRC} ${BIZ_APK_DES}
fi

cp ${BIZ_APK_SRC} ${BIZ_APK_DES}

echo  -e "\n\n ---------------  cache type  ---------------  "  && sleep 1s


case $cache_type in
  CacheClean)
  echo -e "\t ###### Cleaning the OutCache\t ###### "
  if [ -d out ]
  then
    mv out out_$TIMESTAMP
    mv out_$TIMESTAMP /.recyclebin/
  fi
  ;;
  noCacheClean)
  echo -e "\t ###### retain the OutCache\t ###### "
  ;;
  *) echo -e "exception !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n" 
     exit 1
  ;;
esac



echo  -e "\n\n ---------------  cleaning output  ---------------  "  && sleep 1s

if [ -d out/target/product/htt8163_e ]
then
  find out/target/product/htt8163_e/ -maxdepth 1 -type f -name "*ota*.zip" -exec rm -f {}  \;
  find out/target/product/htt8163_e/ -maxdepth 1 -type f -name "*.img" -exec rm -f {}  \;
fi


set +e
echo  -e "\n\n ---------------  build fac image start  ---------------  "  && sleep 1s
. build/envsetup.sh
set -e

lunch 17

time make -j64

echo "DEST_DIR: "$DEST_DIR
mkdir -p $DEST_DIR


find out/target/product/htt8163_e/ -maxdepth 1 -type f -exec cp {} $DEST_DIR  \;
cp out/target/product/htt8163_e/obj/KERNEL_OBJ/vmlinux $DEST_DIR

#cp ./vendor/htt/custom_apk/readme.txt $DEST_DIR
#chown `whoami`:grphpsmb $DEST_DIR -R
chmod 775 $DEST_DIR -R

echo  -e "\n\n ---------------  target_type: OTA?  ---------------  "  && sleep 1s

case $target_type in
  OTA)
  echo -e "\t ###### OTA building\t ###### "
  find out/target/product/htt8163_e/ -maxdepth 1 -type f -name "*ota*.zip" -exec rm -f {}  \;
  . build/envsetup.sh && lunch 18 && time make otapackage -j64
  cp out/target/product/htt8163_e/*ota*.zip $DEST_DIR
  ;;
  noOTA)
  echo -e "\t ###### OTA skipping\t ###### "
  ;;
  *) echo -e "exception !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n" 
     exit 1
  ;;
esac


echo  -e "\n\n ---------------  ch own mod  ---------------  "  && sleep 1s
#chown `whoami`:grphpsmb $DEST_DIR -R
chmod 775 $DEST_DIR -R

#chown `whoami`:grphpsmb out/ -R
chmod 775 $DEST_DIR -R

echo  -e "\n\n ---------------  conclusion  ---------------  "  && sleep 1s
echo "TIMESTAMP: "$TIMESTAMP
echo "NOW      : "$(date +%Y%m%d.%H%M%S)
echo -e "....  bash shell ends here  ....\n\n"


