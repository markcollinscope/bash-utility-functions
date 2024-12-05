#/bin/bash

_err() { >&2 echo "$@"; }

_err STEP 1:
_err "basic constructor! and simple uint operation (uint +)"
# this stuff is all common across lots of areas. cut down versions shown. real stuff gives stack trace fn names... etc.
_abort() { _err 'Would abort here!!! - i.e. exit errorcode or SIGNAL - for trap/cleanup.'; }
_val() {  test -z $1 && _err 'no value given in _val' && _abort; echo $1; }

# another potential adt - but not the focus now.
re.match() 
{
	local rexp=$(_val $1);
	local fullrexp="^$rexp\$"
	shift;

	local in="$@";
	local out=$(sed "s?$fullrexp??" <<< $in)

	test "$in" != "$out"
}

# uint stuff - stripped down to basics - starts here.
uint.err() { local ival=$(_val $1); _err "<$ival> is not an uint - bye"; _abort; }

# validation.
uint.is() 
{ 
	local uintrgx='[0-9]*';
	local ival=$(_val $1); re.match $uintrgx $ival || uint.err $ival;
}

# basically the 'uint' constructor.
uint.init()
{
	local ival=$(_val $1);
	uint.is $ival || _err "<$ival> is not a well formed uint - bye"
	echo $ival;
}

# same pattern: + - * (x, times) / % ,,, etc,
uint.+()
{
	local v1=$(uint $1);
	local v2=$(uint $2);

	local result=$(($v1+$v2));
	echo $result;
}

# controlling function - delegates to the above functions...
uint()
{
	# $(val $1) - just checks there is a $1 passed, no other constraints, here at least.
	local op=$(_val $1);
	shift;

	local fn="uint.$op";

	if test "$(type -t $fn)" = "function"; then 
		$fn "$@";
	else
		local ival=$op;
		uint.init $ival;
	fi
}

# test code examples.
X=$(uint 22)
echo "X: <$X> EXPECT:22"

Y=$(uint + $X 33);
echo "Y: <$Y> EXPECT:55"

A=13
B=3;
C=$(uint + $A $B);
echo "C: <$C> EXPECT:16"

# error case.
NOTINT=$(uint 35X) 

_err END STEP 1.

_err 'hit return'
read x

_err STEP 2:
_err "improved error reporting - well stack trace"

# redefine or new fns.
_err() { >&2 printf "$@"; }

_stack() 
{ 
	local cnt=1;  
	_err "\nstack trace:\n"
	while ! test -z ${FUNCNAME[$cnt]}; do 
		_err "%s..." ${FUNCNAME[$cnt]};
		cnt=$((cnt + 1)); 
	done; 
}

_abort()
{
	_stack;
	_err "\nwould abort / exit / raise signal here!!!"
}

# error case again!
NOTINT=$(uint 35X) 
