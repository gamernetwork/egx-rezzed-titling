#!/bin/bash

DURATION=150
#FILENAME=EGX`date +%Y`_`date +%a_%T`_$SHOT.ts

usage()
{
cat << EOF
usage: $0 options <template filename> <output filename>

Renders egx titling templates to Prores

OPTIONS:
   -h      Show this message
   -d      Duration of render in seconds (default=150)
EOF
}

while getopts “d:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         d)
             DURATION=$OPTARG
		 	 echo "Rendering a $DURATION second clip\n"
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

shift $((OPTIND-1))

echo "Using template $1"
echo "Using output $2"

LD_LIBRARY_PATH=/usr/local/lib/ \
	melt \
	webvfx:$1 \
	length=$DURATION \
	speaker="Mark Kennedy" \
	company="Gamer Network Ltd" \
	transparent=1 \
	-consumer avformat:$2 \
	no_audio=1 \
	mlt_image_format=rgb24a \
	frame_rate_num=30000 \
	frame_rate_den=1001 \
	width=1920 \
	height=1080 \
	transparent=1 \
	pix_fmt=yuva444p10le \
	alpha_bits=8 \
	profile=4444 \
	vcodec=prores
