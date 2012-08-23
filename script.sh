#!/bin/bash
#interactive =

export USE_CCACHE=1

device=$2

function help(){
	 echo "usage: ./script.sh [options] <device>
	 options: s = sync c = clobber l = clean u = upload b: <device> = build for <device>
         example: ./script.sh -scu d2tmo"
}
function clean(){
        lunch aokp_${device}-userdebug
	make clean
}
function sync(){
	repo sync
}
function clobber(){
        lunch aokp_${device}-userdebug
        make clobber
}
function UPLOAD(){
	upload=yes
}
if [ "$1" == "" ]
  then
   help
   exit
 else
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
  while getopts ":hsclub:?" option 2>/dev/null
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
          u )           UPLOAD
			;;
	  b)            build
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


echo "Removing older builds"
 find . -name *${device}_\*.zip* -exec echo "removing previous" {} \; -exec rm {} \;


if [ "$upload" = "yes" ]
	then
        echo "I will upload this to Goo.im"
    else
	echo "I will not upload this to Goo.im"
     fi

if [ "$upload" = "yes" ]
   then
	find . -name *${device}_\*.zip -printf %p\\n -exec scp {} goo.im:public_html/ROMS/ \;
             wget -q -O /dev/null -U="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:14.0) Gecko/20100101 Firefox/14.0.1" http://goo.im/update_index
             echo "Build and upload Complete. Download from goo.im/devs/KAsp3rd"
   else [ "$upload" != "yes" ]
    echo "Build complete and NOT uploaded."
fi
