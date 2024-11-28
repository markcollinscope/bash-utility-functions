declare -g -a arr=('one two three' four five 'six seven');

count() { echo $#; }
count "$@"
echo expected-result: 0

set -- "${arr[@]}";
count "$@"
echo expected-result: 4

e() { echo "${arr[@]}"; }

count $(e);
echo expected-result: 7

set -- $(e)
count "$@"
echo expected-result:  7

echo
echo 'shows 1. that set -- works with a full inline arrays expansion: set -- "$|{arr[@]}"'
echo 'shows 2. that echo-ing the result of full expansion from a function does not maintain spaces - i.e. loses internal arr structure.
