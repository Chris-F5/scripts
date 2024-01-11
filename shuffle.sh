#!/bin/sh

find $@ -type f | sort -R | tr '\n' '\0' | xargs -0 mpv
