#!/bin/bash
#interactive =

device=$2

function help(){
	 echo "usage: ./script.sh <options> <device>
	 options: s = sync c = clobber l = clean u = upload
         while no options will run interactive"
}
function clean(){
	make clean
}
function sync(){
	repo sync
}
function clobber(){
        make clobber
}
function UPLOAD(){
	upload=yes
}

. build/envsetup.sh

for arg
do
  delim=""
  case "$arg" in
  #change long options to short options... will fix later
           --help) args="${args}-h ";;
       *) [[ "${arg:0:1}" == "-" ]] || delim="\""
           args="${args}${delim}${arg}${delim} ";;
  esac
done
#reset params for short opts
eval set -- $args
  while getopts ":hsclu?" option 2>/dev/null
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
           *) echo $OPTARG is an unrecognized option;
              help; exit ;;
        esac
    done
#if [ $device =  ]
# then
#  echo "Build for what device?"
#   read device
#else
# echo "d2tmo"
#fi

echo "Removing older builds"
 find . -name *${device}_\*.zip* -exec echo "removing previous" {} \; -exec rm {} \;

#if [ $upload = "" ]
# then
#  echo "Do you want to upload this build to Goo?"
#   read upload
#fi

#if [ $upload = yes ]
#	then
#	   echo "I will upload this to Goo.im"
#    else
#	echo "I will not upload this to Goo.im"
#     fi

echo "brunch" $device
  brunch $device

if [ $upload="yes" ]
   then
	find . -name *${device}_\*.zip -printf %p\\n -exec rsync -v -e ssh {} goo.im:public_html/ROMS \;
             echo "Build and upload Complete. Download from goo.im/devs/KAsp3rd"
   else [ $upload !="yes" ]
    echo "Build complete and NOT uploaded."
fi
