#!/bin/bash
#interactive =

DEVICE=$2

date=`date +"%b-%d-%y"`
echo $date

function help(){
	 echo "usage:  s = sync c = clobber l = clean u = upload
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

if [$1 != "" ]
then
. build/envsetup.sh
while getopts ":h:s:c:l:u:?" Option
do
	case $Option in

	  h | ?  )	help
			exit
			;;
          s  )
                        sync
                        ;;
          c  )
                        clobber
                        ;;
	  l | --clean )
			clean
                        ;;
          u | --upload )
			UPLOAD
			;;
                    *) echo "error"
        esac
shift $(($OPTIND - 1))
done

else
echo "Build for what device?"
  read device
   find . -name *${date}\* -exec echo 'removing previous' {} \; -exec  rm {} \;

echo "Do you want to upload this build to Goo?"
  read upload
    if [ $upload = yes ]
	then echo "I will upload this to Goo.im"
    elif [ $upload = no ]
	then echo "I will not upload this to Goo.im"
    fi
fi

echo "brunch" $2
  brunch $device

if [ $upload=yes ]
   then
	find . -name *${date}\*.zip -printf %p\\n -exec rsync -v -e ssh {} goo.im:public_html/ROMS \;
             echo "Build and upload Complete. Download from goo.im/devs/KAsp3rd"
   elif [ $upload != yes ]
    echo "Build complete and not uploaded. FAILED"
fi
