#!/bin/bash

. utils.shi
. uts.unit.shi

function list.encode() # -a - encode the whole list? including elements...
{
	:;
}

function list.decode() # allow non-encoded. tag if encoded. # -a ?
{
	:;
}

# const return; const compare; --err
#function list.null()
#{
#	if test $# = 0; then errecho "$(fnname -l 2) - null list found"; exiterr -k; fi
#}
#

list.echo() { :; } # ???

function list.null()
{
	eval $(boolopt --err ERR_OPT "$@");
	
	if $ERR_OPT; then
		local value=$(arg $1);
		if test $value = ""; then
			errecho "$(fnname -l 2) - null list error - bye!)";
			uts.exit;
		else
			return 0;
		fi
	else
		list.new;
	fi
}


function list.bounds()
{
	local lower=1;
	local value=$(arg $1)
	local upper=$(arg $2);

	if test $value -lt $lower || test $value -gt $upper; then
		local msg="$(fnname -l 2): index out of range (index: $value lower: $lower upper: $upper)";
		errecho $msg;
		exiterr -k;
	fi
}

function list.new() # -E -D
{
    echo "$@";
}

function list.reverse()
{
	if ! null "$@"; then
		local head=$1;
		shift;
		local tail="$@"
		echo $(list.reverse $tail) $head;
	fi
}

function list.to()
{
	local upto=$(arg int $1);
	shift;
	local len=$#;

	list.bounds $upto $len

	rev=$(list.reverse "$@");
	set -- $rev

	local shiftval=$((len-upto));
	shift $shiftval;
	echo $(list.reverse "$@");
}

function list.from()
{
    local from=$(arg int $1);
	shift $((from+1));
    echo "$@";
}

function list.range()
{
    local from=$(arg int $1); 
	local to=$(arg int $2); 
	shift 2;

	list.bounds $from $#
	list.bounds $to $#

    local num=$((to - from));
	echo $(list.new $(list.to $num $(list.from $from "$@")))
}

function list.head()
{
	list.null --err "$@"
	echo $1;
}

function list.tail()
{
	list.null --err "$@"
	shift;
    echo "$@";
}

function list.len()
{
	echo $#;
}

function list.na()
{
	echo -9999
}

function list.find() # <val> 
{
	eval $(valopt -m _FND_MSG "$@");
	local val=$1; shift;

	if null $val; then 
		errecho "$(fnname): no position index given $_FND_MSG";
		exiterr -k;
	fi

	local count=1;
	for i in "$@"; do
		if test $i = $val; then
			echo $count;
			return 0;
		fi
		count=$((count+1))
	done

	list.na;
	return 1;
}

function list.contains()
{
	no list.find "$@"
}

function list.cat()
{
	local list1=$(arg $1);
	local list2=$(arg $2);

	list.new $list1 $list2
}

function list.set()
{
    local index=$(arg $1);
    local value=$(arg $2); 
    shift 2;

	local testin="$@"
    local retval;

    retval=$(list.to $((index - 1)) $testin);
    retval=$(list.append $value $retval); 
    retval=$(list.cat $retval $(list.from $index $testin));

    echo $retval;
}

function list.get()
{
    local index=$(arg int $1); shift;
	local value=$1;

	getarg $index "$@";
}

function list.push() 
{
	echo "$@";
}

function list.popv()
{
    list.get 1 "$@";
}

function list.pop()
{
    list.from 1 "$@";
}

function list.append()
{
	local value=$(arg $1);

	echo $(list.new "$@" $value);
}

function list.foreach()
{
	local callfn=$(arg fn $1);
	shift;

	list.new $(callfn $list.head) $(list.forall $callfn $(list.tail "$@"));
}

# list.start return iter list.next <iter>

# TEST FUNCTIONS

if tst.active; then
# no indent.

_seqs()
{
	seq -s ' ' "$@"
}

function test.list.new()
{
	local testin="a b c d e f g"
	local testout=$(list.new $testin);

	echo "<$testin>"
	echo "<$testout>"

	if test "$testin" = "$testout"; then
		echo same
	else
		echo diff
	fi

	tst.assertSame "$testin" "$testout"
	exit
}

function test.list.reverse()
{
	local lower=21
	local upper=27;

	local testin=$(list.new $(_seqs $lower $upper));
	local testout=$(list.reverse $testin);
	local xtestout=$(list.new $(_seqs $upper -1 $lower ));

	tst.assertSame "$testout" "$xtestout" 
}

function test.list.to()
{
	local upper=100;
	local upto=9;

	local testin=$(list.new $(_seqs 1 $upper));

	local testout=$(list.to $upto $testin);
	local xtestout=$(_seqs 1 $upto);

	tst.assertSame "$testout" "$xtestout" 
}

function test.list.from()
{
	local upper=100;
	local from=44;

	local testin=$(list.new $(_seqs 1 $upper));

	local testout=$(list.from $from $testin);
	local xtestout=$(_seqs $((from+1)) $upper);

	tst.assertSame "$testout" "$xtestout" 
}

function test.list.range()
{
	local from=3;
	local to=11;
	local upper=12;

	local testin=$(list.new $(_seqs 1 $upper));
	local testout=$(list.range $from $to $testin);
	local xtestout=$(list.new $(_seqs $((from+1)) $to));

	tst.assertSame "$testout" "$xtestout" 
}

function test.list.head.tail()
{
	local lower=2
	local upper=14;

	local testin=$(list.new $(_seqs $lower $upper));
	local testhead=$(list.head $testin)
	local xtesthead=$lower;

	tst.assertSame "$testhead" "$xtesthead";

	local testtail=$(list.tail $testin);
	local xtesttail=$(list.new $(_seqs $((lower+1)) $upper));

	tst.assertSame "$testtail" "$xtesttail";
}

function test.list.len()
{
	local upper=44

	local testin=$(list.new $(_seqs 1 $upper));
	local testout=$(list.len $testin);
	local xtestout=$upper;

	tst.assertSame "$testout" "$xtestout" 
}

# bool module. uts.tbd.
bool.status()
{
	local status=$(arg $1);
	if test $status = 0; then echo true; else echo false; fi
}

function test.list.contains()
{
	local upper=22;
	local isContained=11;
	local isNotContained=100;

	local testin=$(list.new $(_seqs 1 $upper));

	list.contains $isContained $testin;
	local res=$(bool.status $?);
	tst.assertSame $res true;

	list.contains $isNotContained $testin;
	res=$(bool.status $?);
	tst.assertSame $res false;
}

function test.list.find()
{
	local upper=22;
	local itemIsFound=18
	local itemIsNotFound=88;

	local testin=$(list.new $(_seqs 1 $upper));
	local pos=$(list.find $itemIsFound $testin);
	tst.assertSame $pos $itemIsFound;

	pos=$(list.find $itemIsNotFound $testin);
	tst.assertSame $pos $(list.na);
}

function test.list.get.set()
{
	local lower=1;
	local upper=17;
	local index=12;
	local newval='anewvalue';

	local testin=$(list.new $(_seqs $lower $upper));
	local value=$(list.get $index $testin);
	tst.assertSame $value $((lower + index -1));

	local testout=$(list.set $index $newval $testin);
	tst.assertSame $(list.len $testin) $(list.len $testout);

	value=$(list.get $index $testout);
	tst.assertSame $newval $value;
}

function test.list.push.pop.popv()
{
	local numpush=15;
	local testin=$(list.new $(_seqs 1 $upper));
	local newvalue='newvalinfn';

	local len=$(list.len $testin);
	local newlist=$(list.new $testin);
	local range=$(_seqs 1 $numpush)
	local i;

	for i in $range; do
		newlist=$(list.push $newvalue $newlist);
	done
	tst.assertSame $(list.len $newlist) $((len + numpush));

	local popvok=true; # uts.tbd assert $value (true) # assertNot $value;
	for i in $range; do
		local val=$(list.popv $newlist)
		if ! test $val = $newvalue; then
			popvok=false;
			break;
		fi
		newlist=$(list.pop $newlist);
	done
	tst.assertSame true $popvok;
	tst.assertSame $testin $newlist;
}

tst.run;
exit;

fi # test section.
