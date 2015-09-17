#!/bin/bash

# Renders full screen slates for
# - Now
# - Next
# - "Technical difficulties"
# - "Join us next year"
# Outputs .mov and .png files.

OUTPUT_DIR=~/Videos/egx/2015
mkdir -p $OUTPUT_DIR

function render {

	DAY=$1
	TIME=$2
	NAME=$3
	INFO=$4

	NOW="$OUTPUT_DIR/$DAY/now-$TIME.mov"
	NEXT="$OUTPUT_DIR/$DAY/next-$TIME.mov"

	mkdir -p $OUTPUT_DIR/$DAY

	# Now
	./bin/qtrle_render_slide.sh templates/now.webvfx.html $NOW \
		time="$TIME" \
		name="$NAME" \
		info="$INFO"

	# Next
	./bin/qtrle_render_slide.sh templates/next.webvfx.html $NEXT \
		time="$TIME" \
		name="$NAME" \
		info="$INFO"

	# Convert to PNG
	avconv -ss 00:00:03 -r 1 -i $NOW -frames 1 ${NOW/.mov/.png}
	avconv -ss 00:00:03 -r 1 -i $NEXT -frames 1 ${NEXT/.mov/.png}
}

# Read from sesssions.txt and build the lower thirds
while read line; do

	DAY=$(echo "$line" | cut -f 1)
	TIME=$(echo "$line" | cut -f 2)
	NAME=$(echo "$line" | cut -f 3)
	INFO=$(echo "$line" | cut -f 4)
	
	echo "Rendering $DAY, $TIME: $NAME"
	echo "-------------------------------------------"
	render "$DAY" "$TIME" "$NAME" "$INFO"
	echo

done < sessions.txt

# Do general slates
for file in "technical_difficulties" "join_us_for_egx"; do
	OUT="$OUTPUT_DIR/$file.mov"
	./bin/render_slide_noalpha.sh templates/$file.webvfx.html $OUT
	avconv -r 1 -i $OUT -frames 1 ${OUT/.mov/.png}
done