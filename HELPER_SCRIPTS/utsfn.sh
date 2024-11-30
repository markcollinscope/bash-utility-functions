#!/bin/bash

source uts.global.shi
uts.source uts.base1.shi

USAGE=$(cat << UTXT
Usage: $(script) <fnname>
Run a function <fnname> from utils.shi from the cmd line.
UTXT
);

main()
{
	vbecho "Will execute 'eval <$@>'"
	eval "$@";
}

main "$@"
