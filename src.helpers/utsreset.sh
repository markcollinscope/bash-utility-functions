#!/bin/bash
# for debug on utils_...

echo "this is a development tool - to enable the re-inclusions of all *.shi files"
echo ". $(script) to do this on the command line - in-shell."
echo 

UTILS_CORE=
UTILS_FD=
UTILS_GIT=
UTILS_GLOBALS=
UTILS_MAP=
UTILS_MSC=
UTILS_OPTS=
UTILS_UIO=
UTILS_VB=
UTILS_PVAR=

DEBUGUTILS=true
echo DEBUGUTILS=$DEBUGUTILS

echo  "Setup Utils Include? Ctrl-c to Exit"
read x

. utils.shi
