#!/bin/bash
for arg
do
    delim=""
    case "$arg" in
    #translate --gnu-long-options to -g (short options)
        --some-other-gnu) args="${args}-g ";;
       --long-gnu-option) args="${args}-l ";;
       #pass through anything else
       *) [[ "${arg:0:1}" == "-" ]] || delim="\""
           args="${args}${delim}${arg}${delim} ";;
    esac
done
 
#Reset the positional parameters to the short options
eval set -- $args
 
while getopts ":a:gl" option 2>/dev/null
do
    case $option in
        g) echo "some other gnu option";;
        l) echo "long gnu option";;
        a) echo ${OPTARG[@]};;
        *) echo $OPTARG is an unrecognized option;;
    esac
done
