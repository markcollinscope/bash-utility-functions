if test -z $___uts___; then
	___uts___='already-included'

uts.exit() { exit ${1:-0}; }
uts.isfn() 
{
    test $(type -t "$1") = 'function'; 
}

uts.count() { echo $#; }
uts.err() { >&2 echo $*; }

uts.fnname()
{
    local level=${1:-1}; 
    echo "${FUNCNAME[$level]}"; 
}

uts.stack()
{
    local i=1;
    local fnname=$(uts.fnname $i);
    local stack=$(
        while test $fnname != ""; do
            echo $fnname;
            i=$((i+1));
            fnname=$(uts.fnname $i)
        done
    )
    echo $stack;
}

function uts.abort()
{
    local callingfn=$(uts.fnname 2);

	uts.err "$callingfn: error - aborting.  $@"
	uts.err
	uts.err "call stack:"
	uts.err $(uts.stack);
	uts.err
	uts.exit 1
}

uts.isflag()
{
	local flg=$1;
	if test -z "$f"; then uts.abort "no argument provided."; fi
	
	local dashfree=$(echo $flg | sed 's/^-*//g');
	test "$flg" != "$dashfree";
}

# HERE HERE HERE !

uts.nargs()
{
	local n=$1;
	if test -z "$n"; then uts.abort "no args provided."; fi
	echo $#
}

uts.flag.match()
{
	local match=$1;
	local flag=$2;

	local -n ismatch=$3;
	ismatch=false;
	shift 3;
	local action="$@";

	for i in match flag ismatch; do
		if test -z ${!i}; then uts.abort "no value for ($i)"; fi
	done

	if test -z "$match"; then uts.abort; fi
	if test -z "$flag"; then uts.abort; fi
	if test -z "$retval"; then uts.abort; fi

	ismatch=1;
	if test $match == $flag; then
		$action;
		ismatch=0;
		return 2;
	fi
	return 0;
}

uts.assert()
{
	local noerrx=1;
	shift $(uts.flag.match $1 $(uts.flag.noerrx) noerrx);

	local fn=$(uts.fnname 1);
	local value=$1;
	shift;
	
	local msg=$*; 
	if ! "$value"; then 
		if ! $noerrx; then 
				uts.abort "$fn - assertion failure. $msg"; 
			else
				return 1;
			fi
		fi
	fi
	return 0;
}

uts.fncallifexists()
{
	local fn=$1;
	shift;

	if ! test -z "$fn" && uts.isfn "$fn"; then
		$fn "$@";
	fi
}

uts.null()
{
    local xerr=false;
    if test "$1" == $(uts.flag.errexit); then
        xerr=true;
        shift;
    fi
    
    local val=$1;
    if test -z "$val"; then
        if $xerr; then
            uts.abort 'null value error';
        else
            return 0;
        fi
    fi
    return 1;  
}

uts.notnull()
{
	uts.assert 
}

uts.cat()
{
	local i;
	local res=
	for i in "$@"; do
		res=$res$i;
	done
	echo $res;
}

uts.arg()
{
    local val=$(uts.cat "$@");
    uts.null --assert "$val";
    echo $val;
}

uts.env()
{
	local varname=$(uts.arg $1);
	local default=$2;
	 
    local varvalue=${!varname};

	if test -z "$varvalue" && test -z "$default"; then
        uts.abort "env var <$varname> is not set, & no default provided"
    
    elif test -z "$varvalue"; then
	    varvalue=$default;
	fi			

	echo $varvalue;
}


uts.re()
{
	if test "$1" == "--white"; then
		echo "";
		return 0;
	fi
}

uts.rmre() 
{ 
    local str=$(uts.arg $1); shift; 
    local res=$(echo $* | sed "s?$str??g"); 
    echo $res
}
uts.rmdot() { uts.rmre '\\.' $*; };
uts.rmwhite() { uts.rmre ' ' $*; };
uts.rmslash() { uts.rmre '/' $*; };
uts.rmdash() { uts.rmre '-' $*; };


