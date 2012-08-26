#!/bin/bash

BUILD_DIR=/home/$USER/aokp
export USE_CCACHE=1

for i in $@; do :; done
device=$i

function help(){
	 echo "usage: $0 [options] <device>
	 options: s = sync c = clobber l = clean u = upload b: <device> = build for <device>
         example: $0 -scu d2tmo toro maguro"
}
function clean(){
        lunch aokp_${device}-userdebug
	mka clean
}
function sync(){
	repo sync -j4
}
function clobber(){
        lunch aokp_${device}-userdebug
        mka clobber
}
function build(){
         find . -name *${device}_\*.zip* -exec echo "removing previous" {} \; -exec rm {} \;
         echo "building $device"
          time brunch $device
}
function UPLOAD(){
         upload=1
}
if [ "$1" == "" ]
  then
   help
   exit
 else
 cd $BUILD_DIR
 . build/envsetup.sh
fi

for arg
do
  delim=""
  case "$arg" in
  #change long options to short options... will fix later
           --help) args="${args}-h ";;
           --build) args="${args}-b";;
       *) [[ "${arg:0:1}" == "-" ]] || delim="\""
           args="${args}${delim}${arg}${delim} ";;
  esac
done
#reset params for short opts
eval set -- $args
  while getopts ":hsclb:u?" option 2>/dev/null
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
          b)            build
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

if [ $upload == "1" ]
  time find . -name *aokp_\*jb*.zip -printf %p\\n -exec scp {} goo.im:public_html/ROMS/ $
   echo "refreshing goo.im index"; wget -q http://goo.im/update_index
   echo "Build and upload Complete. Download from goo.im/devs/KAsp3rd"

