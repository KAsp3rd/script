#!/bin/bash

BUILD_DIR=/home/$USER/aokp
DATE=$(date +%h-%d-%y)
export USE_CCACHE=1
export CCACHE_COMPILERCHECK=none
#exporting for use of newer ccache. Default on 2.4 is none, Default on 3.* is mtime

if [ "$1" == "" ]
  then
   help
   exit
 else
 cd $BUILD_DIR
 . build/envsetup.sh
fi
sy=1

for i in "${@:2}"
do
device=$i
#reset upload to 0 until the last device is built
upload=0

function help(){
	 echo "usage: $0 [options] <device> <device>
	 options: s = sync c = clobber l = clean u = upload b= build only for <device>
         example: $0 -scu d2tmo toro maguro"
}
function clean(){
        lunch aokp_${device}-userdebug
	make clean
}
function sync(){
      if [ $sy == "1" ]; then
	repo sync
#set sync to 0 so it will only run repo sync once if more then one device is being parsed
        sy=0
      fi
}
function clobber(){
        lunch aokp_${device}-userdebug
        make clobber
}
function build(){
         find . -name *${device}_\*.zip* -exec echo "removing previous" {} \; -exec rm {} \;
         echo "building $device"
         time brunch $device
}
function UPLOAD(){
         upload=1
}

for arg in $1
 do
  delim=""
  case "$arg" in
  #change long options to short options... will fix later
           --help) args="${args}-h ";;
           --build) args="${args}-b ";;
       *) [[ "${arg:0:1}" == "-" ]] || delim="\""
           args="${args}${delim}${arg}${delim} ";;
  esac
done
#reset params for short opts
eval set -- $args
  while getopts ":hsclbu?" option 2>/dev/null
   do
   case $option in
	  h )	help
			exit
			;;
          s )           sync
                        ;;
          c )           clobber
                        ;;
	  l )           clean
                        ;;
          b )           build
                        ;;
          u )           UPLOAD
			;;
          :)            echo "Option -$OPTARG requires an argument."
                        help
                        exit
                        ;;
           *)           echo $OPTARG is an unrecognized option;
                        help;
                        exit
                        ;;
        esac
      done
   done
shift
if [ $upload == "1" ]; then
  time find . -name *aokp_\*${DATE}*.zip -printf %p\\n -exec scp {} goo.im:public_html/ROMS/ \; 
echo "refreshing goo.im index"; wget -q http://goo.im/update_index 
rm update_*
echo "Build and upload Complete. Download from goo.im/devs/KAsp3rd" 
fi
