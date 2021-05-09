#!/bin/bash
TMPFILE=$(mktemp)
[ "$XDG_SESSION_TYPE" = "x11" ] && xclip -selection clipboard -t image/png -o 2>/dev/null > $TMPFILE
[ "$XDG_SESSION_TYPE" = "wayland" ] && wl-paste -n -t image/png 2>/dev/null > $TMPFILE
if [ -s "$TMPFILE" ]; then
    TMPJPG=$(mktemp)
    convert -quality 70 $TMPFILE $TMPJPG
    [ "$XDG_SESSION_TYPE" = "x11" ] && echo -n "<img alt='Clipped Image' src='data:image/jpeg;base64,"$(base64 -w0 ${TMPJPG})"' />" | xclip -selection clipboard
    [ "$XDG_SESSION_TYPE" = "wayland" ] && echo -n "<img alt='Clipped Image' src='data:image/jpeg;base64,"$(base64 -w0 ${TMPJPG})"' />" | wl-copy
    rm $TMPJPG
else    
    [ "$XDG_SESSION_TYPE" = "x11" ] && TMPSTRING=$(xclip -selection clipboard -t text/plain -o 2>/dev/null)
    [ "$XDG_SESSION_TYPE" = "wayland" ] && TMPSTRING=$(wl-paste -n -t text/plain)
    if [[ "$TMPSTRING" =~ ^\<svg.* ]]; then
        TMPSVG=$(mktemp)
        echo -n $TMPSTRING > $TMPSVG
        [ "$XDG_SESSION_TYPE" = "x11" ] && echo -n "<img alt='Clipped Image' src='data:image/svg+xml;base64,"$(base64 -w0 ${TMPSVG})"' />" | xclip -selection clipboard
        [ "$XDG_SESSION_TYPE" = "wayland" ] && echo -n "<img alt='Clipped Image' src='data:image/svg+xml;base64,"$(base64 -w0 ${TMPSVG})"' />" | wl-copy
        rm $TMPSVG
    elif [[ "$TMPSTRING" =~ \.svg$ ]]; then
        [ "$XDG_SESSION_TYPE" = "x11" ] && echo -n "<img alt='Clipped Image' src='data:image/svg+xml;base64,"$(base64 -w0 $(echo -n ${TMPSTRING} | sed -e 's/file:\/\///'))"' />" | xclip -selection clipboard
        [ "$XDG_SESSION_TYPE" = "wayland" ] && echo -n "<img alt='Clipped Image' src='data:image/svg+xml;base64,"$(base64 -w0 $(echo -n ${TMPSTRING} | sed -e 's/file:\/\///'))"' />" | wl-copy
    fi
fi
rm $TMPFILE
