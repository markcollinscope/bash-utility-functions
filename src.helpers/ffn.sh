#!/bin/bash

. utils.shi

# DBG: uts access for functions. started to get somewhere TBD.

######
USAGE=$(cat <<END_USAGE

Usage: $(basename $0) [-options] <part-fn-name>

Search <MY_SCR_ROOT> and sub-dirs for all 'script includes (*.$UTILS_BASHINCLUDE, etc)' to find bash fns matching the partial name given.
<part-fn-name> is a grep style pattern. Do *not* put '()' at the end - this is done automatically.

nb: you must define MY_SCR_ROOT in your environment for this function to work, or an error will be given.

Matches functions of the form:
"afunctionname()" - i.e. function name is at start of line, alphanumeric name, () at the end, no spaces in name or before ().

END_USAGE
)
######


chkvar MY_SCR_ROOT
vbvar MY_SCR_ROOT

Usage()
{
	OPTIONS="$(getOptUsage)"
	>&2 cat<<<$USAGE
	>&2 cat<<<$OPTIONS
	exiterr 1
}

# option variables.
ANYFUNCTION=false;
EXACTMATCH=false;
SHORTFORMAT=false;
LONGFORMAT=false;
PRINTFILENAMEONLY=false;
FILE_EXT=""

FNEND='()'

eval $(boolopt --rem "match any function (do not give a function name)" -a ANYFUNCTION "$@")
eval $(boolopt --rem "search for an exact match only" -x EXACTMATCH "$@")
eval $(boolopt --rem "print matching file name only" -f PRINTFILENAMEONLY "$@")
eval $(valopt  --rem "specify files (by glob pattern) to match (ls style - e.g. *.sh)" -m FILE_EXT "$@")
eval $(boolopt --rem "use shorter output format (prints fn upto open brace)" -s SHORTFORMAT "$@")
eval $(boolopt --rem "use longer detailed output format (full listing)" -l LONGFORMAT "$@")
eval $(boolopt --rem "use bash native (set) output format (full listing, after parsing by bash)" -d USEBASHNATIVE "$@")
eval $(boolopt --rem "search uts utilities ares" -u USEUTS "$@")
errifopt "$@";

USEUTS=true;
vbvar USEUTS

declare -g STARTDIR=$MY_SCR_ROOT

if $USEUTS; then 
	STARTDIR=$MY_UTS_REPO; 
	source uts.shi
	source uts.rgx.shi
fi

vbvar STARTDIR

fnpattern()
{
	local partfnname=$1;
	chkvar partfnname;

	local res="^[[:alpha:]_]*$partfnname[[:alnum:]_]*$FNEND";
	if $USEUTS; then
		res="^.*function[[:space:]]*[[:alpha:]_\.]*$partfnname[[:alnum:]_\.]*$FNEND"
	fi
	echo $res;
}

searchForMatch()
{
	if $ANYFUNCTION; then
		PARTFNNAME="";
	else
		setvar PARTFNNAME "$1"; shift;
	fi

	local FILE_PATT=

	for i in "$@"; do
		FILE_PATT="*$i $FILE_PATT"
	done

	vbfnecho "FILE_PATT: <$FILE_PATT>"

	local FUNCT=$(fnpattern $PARTFNNAME);
	local MATCHES=$(xfindfilesgrep "$FUNCT" $FILE_PATT)
	local COUNT=$(count $MATCHES)

	vbecho "MATCHES: <$MATCHES>"

	if $EXACTMATCH; then
		FUNCT="^$PARTFNNAME$FNEND"
	fi
	
	if $USEBASHNATIVE && (( COUNT > 0 )); then
		fndef $PARTFNNAME;
		return 0;
	fi

	vbvar MATCHES
	vbvar COUNT 
	vbvar FILE_PATT
	vbvar FUNCT

	for match in $MATCHES; do
		vbvar match

		if $LONGFORMAT; then
			vbfnecho 'Long Option Chosen'
			printbetween $FUNCT '^}$' $match;

		elif $SHORTFORMAT; then
			vbfnecho "Short Option Chosen ($FUNCT, $match)"
			printbetween $FUNCT '^{' $match | sed 's/^{//g';

		elif $PRINTFILENAMEONLY; then
			vbfnecho 'Name Only Option Chosen'
			echo $match; 
		else
			vbfnecho 'No Option Chosen'
			xgrep $FUNCT $match;
		fi
	done
	return 0;
}

main()
{
	cd $STARTDIR || { errecho "$STARTDIR not found"; exiterr 1; }

	vbecho "Starting search in <$(pwd)>"
	FILE_EXT=${FILE_EXT:-".shi"}
	vbfnecho
	vbvar FILE_EXT
	vbfnecho "starting search... <$FILE_EXT>"

	if $ANYFUNCTION; then
		searchForMatch "$FILE_EXT"
	else
		if (( $# != 1 )); then Usage; fi
		setvar PARTFN "$1"
		searchForMatch "$PARTFN" "$FILE_EXT"
	fi
}

main "$@"
