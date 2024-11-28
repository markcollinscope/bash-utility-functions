#/bin/bash
# realecho() { /usr/bin/echo $*; }

e() { /usr/bin/echo $*; }

args() { echo 'eval echo "$@"' ; }
e -2
$(args)
e -1
e $(args)

fargs() { echo $(args); }
e 0
fargs 1 2 3

e 1;
e $(args)

e 2
ff() { e $(args); }
ff first second third 

# echo() { realecho $(args); }
# echo hello 1 2 3
e 3
fn() { shift; echo $(args); }
fn one two three

exit;
exit;

say() { echo $*; }
err() { echo $* >&2; exit 1; }
dbg() { echo dbg: $* >&2; }
ereturn() { echo $*; }

NB() { : ; }

declare -a -g anarr=(one two three 'four four four');
arr.all() { local -n myarr=$1; local name=$1; ereturn "${myarr[@]}"; return 0; }
arr.allv() { local -n myarr=$1; local len=${#myarr[@]}; for ((i=0; i<$len; i++)) do echo \'${myarr[$i]}\'; done; }

say all: $(arr.all anarr);
say allv: $(arr.allv anarr);

count() 
{
	local -n larr=$1;
	echo ${#larr[@]}
}
say count: anarr:
count anarr

declare -g -a secondarr=( $(arr.allv anarr) );
say secondarr@ count:
say ${#secondarr[@]};

say secondarr:allv values:
say $(arr.allv secondarr)

say count: secondarr:allv:
count secondarr;

exit;

declare -g ISTEST=1;
res.test() # $@
{
	case $1 in 
 		--test*)
			ISTEST=$(ret.true);
			return $ISTEST;
			;;

		--istest*)
			return $ISTEST;
			;;

		--ereturn)
			ereturn $0: test status: $ISTEST;
			return $ISTEST;
			;;
	esac;
	err $0: prog.error
}

if res.test "$@"; then shift; fi
res.test --ereturn;

res.test.fn()
{
	local fn=$1;
	local code=$2;

	local tpl="
		$fn() $code;
	";

	dbg "<$tpl>"

	if res.test --istest; then
		eval "$tpl"
	fi
	$fn
}

# test.ereturn.result() { local fn=$1 res=$2; 

test.status() 
{ 
	local fn=${FUNCNAME[1]};
	local status=$1; 
	ereturn status: $fn $status

	local passfail=fail;  
	if $status; then passfail=pass; fi
	ereturn "$fn (test status): <$passfail>";
}

hello() { ereturn hi; }

test.fn()
{
	ereturn 'running test.fn';

	local ares=$(hello);
	local xres='hello';

	dbg "ares: $ares"
	dbg "xres: $xres"

	local status=false;

	if test "$ares" == "$xres"; then status=true; fi
	test.status $status
}

test.fn
ereturn test.fn: $?
