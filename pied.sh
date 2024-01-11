#!/bin/sh

if [ -z "$EDITOR" ]; then
  echo "pied: EDITOR unset." >&2
  exit 1
fi

edfile=$(mktemp)

if [ -t 0 ]; then
  touch $edfile
else
  cat > $edfile
fi
$EDITOR $edfile </dev/tty >/dev/tty
cat $edfile
rm $edfile
