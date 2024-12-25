#!/bin/bash

. utils.shi

chkenvvar MY_UTILS_REPO
ROOT=$MY_UTILS_REPO

USAGE=$(cat <<ENDUSAGE
Usage: $(script)
o print all UTS_ vars - recursive descent search used.
o by default - searches from <$ROOT> (see also options).
o use to ensure non-duplication of existing UTS_ vars and to find errors
ENDUSAGE
)
eval $(boolopt --rem ' start search from cwd' '--cwd' STARTCWD "$@");
errifopt "$@"

main()
{
	if $STARTCWD; then ROOT=$(pwd); fi
	(
		cd $ROOT;
		local results=$(xgrep -r -h UTS_ | sed 's/.*\(UTS_[[:alnum:]]*\).*/\1/' | sort | uniq);

		for r in $results; do 
			errecho "$r: <${!r}>"
		done
	)
}

main $*
