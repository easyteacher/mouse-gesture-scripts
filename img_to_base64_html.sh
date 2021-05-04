#!/bin/bash
TMPFILE=$(mktemp)
xclip -selection clipboard -t image/png -o 2>/dev/null > $TMPFILE
if [ -s "$TMPFILE" ]; then
    TMPJPG=$(mktemp)
    convert -quality 70 $TMPFILE $TMPJPG
    echo -n "<img alt='Clipped Image' src='data:image/jpeg;base64,"$(base64 -w0 ${TMPJPG})"' />" | xclip -selection clipboard
    rm $TMPJPG
else    
    TMPSTRING=$(xclip -selection clipboard -t text/plain -o 2>/dev/null)
    if [[ "$TMPSTRING" =~ ^\<svg.* ]]; then
        TMPSVG=$(mktemp)
        echo -n $TMPSTRING > $TMPSVG
        echo -n "<img alt='Clipped Image' src='data:image/svg+xml;base64,"$(base64 -w0 ${TMPSVG})"' />" | xclip -selection clipboard
        rm $TMPSVG
    fi
fi
rm $TMPFILE