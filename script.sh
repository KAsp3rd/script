#!/bin/bash
#interactive =

device=$2
date=`date +"%b-%d-%y"`
echo $date

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

if [ $# != 0 ]
    then
	while getopts ":hsclu?" Option
	 do
	case $Option in
	  h | ?  )	help
			exit
			;;
          s )           sync
                        ;;
          c )           clobber
                        ;;
	  l | --clean ) clean
                        ;;
          u | --upload )UPLOAD
			;;
                    *) echo "invalid input"
		       help
        esac
      shift $(($OPTIND - 1))
    done
else
 echo "Build for what device?"
  read device
fi
   find . -name *${date}\* -exec echo "removing previous" {} \; -exec rm {} \;

echo "Do you want to upload this build to Goo?"
 read upload
    if [ $upload = yes ]
	then
	   echo "I will upload this to Goo.im"
    else
	echo "I will not upload this to Goo.im"
     fi
echo "brunch" $device
  brunch $device

if [ $upload=yes ]
   then
	find . -name *${date}\*.zip -printf %p\\n -exec rsync -v -e ssh {} goo.im:public_html/ROMS \;
             echo "Build and upload Complete. Download from goo.im/devs/KAsp3rd"
   elif [ $upload != yes ]
    echo "Build complete and not uploaded. FAILED"
fi
