#!/bin/bash
# Script to turn lead into gold
# Copyright (C) 2013 Patrick Jones - All Rights Reserved
# Permission to copy and modify is granted under the foo license
# Last revised 6/28/2013

declare -r SCRIPT_NAME=$(basename "$BASH_SOURCE" .sh)

## exit the shell(default status code: 1) after printing the message to stderr
bail() {
    echo -ne "$1" >&2
    exit ${2-1}
} 

## help message
declare -r HELP_MSG="Usage: $SCRIPT_NAME [OPTION]... [ARG]...
  -h    display this help and exit
"

## print the usage and exit the shell(default status code: 2)
usage() {
    declare status=2
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        status=$1
        shift
    fi
    bail "${1}$HELP_MSG" $status
}

while getopts ":h" opt; do
    case $opt in
        h)
            usage 0
            ;;
        \?)
            usage "Invalid option: -$OPTARG \n"
            ;;
    esac
done

#shift $(($OPTIND - 1))
#[[ "$#" -lt 1 ]] && usage "Too few arguments\n"

#==========MAIN CODE BELOW==========
clear
#echo "This test program will relay when a user has changed the position on a ro"
#Initialize the pins as inputs and set internal resistors to pull up
#echo "Starting Up..."
for i in 4 17 18 22 23 27
do
        gpio -g mode $i in
#       if [ "$Debug" -eq "$testToggle" ]
#       then
#                echo "Pin $i set to INPUT MODE"
#       fi
        gpio -g mode $i up
#       if [ "$Debug" -eq "$testToggle" ]
#       then
#                echo "Pin $i is now using PULL UP RESISTOR"
#       fi
done

# Start Polling for changes in pins
# Todo: add interrupts instead of constant polling
#echo "Polling for changes in the rotary switch"

while :
do
        for i in 4 17 18 22 23 27
        do
		COMP=`gpio -g read ${i}`
		CHECK=`fgconsole`
                if [ "$COMP" == "0" ]
                then
#                        echo "You have selected Pin $i"
			case "$i" in 
			23)	if [ "$CHECK" <> "1" ]
				then
					chvt 1
				fi
				;;
                        18)     if [ "$CHECK" <> "2" ]
                                then
                                        chvt 2
                                fi
				;;
                        22)     if [ "$CHECK" <> "3" ]
                                then
                                        chvt 3
                                fi
				;;
                        27)     if [ "$CHECK" <> "4" ]
                                then
                                        chvt 4
                                fi
                                ;;
                        17)     if [ "$CHECK" <> "5" ]
                                then
                                        chvt 5
                                fi
                                ;;
                       	4)     if [ "$CHECK" <> "7" ]
                                then
                                        chvt 7
                                fi
                                ;;
			esac
		fi
        done
	sleep 1
done
