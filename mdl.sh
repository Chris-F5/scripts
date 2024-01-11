#!/bin/sh
tr '\n' '\0' | xargs -0 -n1 md
