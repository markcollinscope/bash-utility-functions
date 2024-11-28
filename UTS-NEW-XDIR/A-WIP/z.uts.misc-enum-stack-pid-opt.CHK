# UTS CHECK CAT NULL UTS.ARG FNNAME STACK

uts.exit() { exit ${1:-0}; }
uts.err() { echo $* >&2; }
	
uts.fnname() # [-l <call-fn-level>] (clone).
{
	local flag=$1;
	local level=$2;

	local fnlevel=1;
	if test "$flag" = "-l"; then 
		if test -z "$level"; then uts.err "[fnname -l] NO LEVEL PROVIDED]"; uts.exit 1; fi
		fnlevel=$level; 
	fi
	echo "${FUNCNAME[$fnlevel]}"
}

uts.stack() 
{
	local cnt=1;
	local stack="stack trace:\n"

	local fnname='-----'
	while ! test -z "$fnname"; do
		stack=$(uts.cat $stack '\n' $fnname);
		cnt=$((cnt+1))
		fnname=$(uts.fnname -l $cnt);
	done
	echo $stack;
}

uts.abort()
{
	echo 'abort called:
	exit 1;
}

uts.cat()
{
	local result;
	for i in $*; do
		result=$result$i;
	done
	echo $result;
}

uts.null() # --errexit, -m <msg>
{
	local errexit=false;
	local msg;

    eval $(boolopt "--errexit" errexit "$@");
    eval $(valopt -m msg  "$@");

    if test -z "$@"; then
		if $errexit; then
			uts.err $(uts.stack);
			uts.err $msg
			uts.abort "unrecoverable null value error"
		fi
		return 0;
	fi
	return 1;
}

uts.arg() # --noerrwhite todo
{
	local value=$1;
	uts.nowhite $value;
	uts.null --errexit $value -m "$(uts.fnname -l 2) - null argument found"

	echo $value;
}

uts.optset()
{
	local opt=$(uts.arg $1);
	local value=$(uts.arg $2);

	test $opt == $value;
}

uts.rmdash()
{
	echo $* | sed 's/-//g'
}

uts.nowhite() # --noexit
{
	local exit=true;

	todo --noexit

	for i in "$@"; do
		local arg="$i";
		local rmwhitearg=$(echo "$i" | sed 's/ //g)'
		if ! test "$arg" == "$rmwhitearg"; then
			if $exitonerr; then uts.abort "error: whitespace found in argument <$arg>"; fi
			return 1;
		fi
	done;
	return 0;
}

uts.enumname()
{
	local basename=$(uts.arg $1);
	local prefix='__UTS_ENUM_';
	echo $prefix$basename
}

uts.pid()
{
	local prefix=__PROCES_UNIQUE_VALUE__;
	echo $(uts.cat $prefix $$);
}

uts.enums()
{
	local prefix=__UTS_DEFINED_ENUMS__
	local globenums=$(uts.cat $prefix $(uts.pid));
	declare -g $globenums;
	local -n refenums=$globenums;

	if $uts.optset $1 "--add"; then
		shift;
		local newenum=$(opt.arg $1);
		refenums=(uts.cat $refenums ' ' $newenum);
		return 0;
	fi
	echo $globenums;
}

uts.enum()
{
	uts.nowhite "$@"

	if $uts.optset $1 "--define"; then
		shift;
		local name=$(uts.arg $1);
		shift;
		local values="$@";
		local -n refenumvar=$(uts.enumname )
		refenumver=$(values);
		return 1;
	fi
	if $uts.optset $1 "--contains"; then
		shift;
		local name=$(uts.arg $1);
		local value=$(uts.arg $2);
		local refenumvar=


_enum.isopt()
{
	local option=$1

}

function enum()
{

}
