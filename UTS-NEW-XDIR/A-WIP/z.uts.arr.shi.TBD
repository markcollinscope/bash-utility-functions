

. uts.unit.shi
. uts._.shi;

###
function arr.echo()
{
	local -n arr=$(_.ref $1);
	echo ${arr[@]}
}

function test.arr.echo()
{
	local -a in=(one two three);

	local xout='one two three';
	local out=$(arr.echo in);

	tst.assert --same "$xout" "$out"
}
###

###
function arr.len()
{
	local -n arr=$(_.ref $1);
	echo ${#arr[@]}
} 

function test.arr.len()
{
	local -a in=(one two three 'four five six but not really 4 5 6 - just fourth element in array');
	local xout=4;
	local out=$(arr.len in);

	tst.assert --same $xout $out;
}
###

###
function arr.at()
{
	local -n arr=$(_.ref $1);
	local pos=$(_.arg $2);

	echo ${arr[$pos]}
}

function test.arr.at()
{
	local in=(one two three four);
	local len=$(arr.len in);
	local i;

	for ((i=0;i<len; i++)); do
		out=$(arr.at in $i);
		xout=${in[$i]};
		tst.assert --same $out $xout;
	done
}
###

tst.run
