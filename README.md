# BASH-UTILS - VERSION 0.9.1 - UNDER FINAL REVIEW - PRODUCTION RELEASE - CAN BE USED.

[nb: There may be typos in this documentation. It is still under review. Please let the author know if you spot any.]

A set of around 100 bash utility functions to make writing complex well structured Bash Scripts easier.

In this README:
* How to setup the utilities for use.
* List of source files and their contents in overview.
* Detailed description of each function in each file.
* Descriptions of HELPER functions provided. These search for function(s) by part names - and give details from there. Useful if you can't remember a function name or what options, etc. it has.


Broadly speaking the utilities provide functionality to simplify 
* run time checking bash functions - argument checking for functions, etc, 
* assist undertaking of debugging (verbose output when -v or --vb flag passed into a script - flag configurable), 
* get or override user input (-f type flag), 
* create cross-script or same-script (as defined by context) 'persistent' bash variables that hide implementation details.
* check or ensure files and directories exist, 
* do useful stuff with git directories, move stuff around, commit stuff from scripts, branch from scripts, etc.
* automatically process command line flags (e.g. script -x -y -z 200 arg1 arg2) as either boolean flags or values to be set) - and automatically add usage documentation if you use the default Usage() function (provided automatically),
* enable the creation of map data structures (multi-d), 

and a whole load of other useful stuff.

## Using the utilities

To use any of the utilities they must  be 'included' within your script. 

To do this - having cloned this repo:
* copy the contents of the SRC directory to a place on your PATH.
* put the following at the top of your script(s).

```
# this is optional - and shows the redefinition of a default 
# value ('--vb') within utilities, see later documentation.
export UTILS_VERBOSEFLAG='-v' 

. utils.shi  
# note the 'dot' (.)
```

nb: bash functions 'return' values in one of two ways - either by echo-return (echoing a value) - in which case the calling script
must use something like the following to pick up the return:
```
VALUE=$(fn) 
```

Alternatively they may 'return' values is using a 'return' statement explicity - either 0 or non-0.
```
0 - will be evaluated as True in bash conditional statements
Non-0 - will be evaluated as False in bash conditional statements.

boolf() { return 1; }
if boolf; then 
	... 
else 
	... 
fi 
```

would execute the 'else' part of this 'if' expression.
## Source Files and Overview of Content

### Summary of Functionality

Filename            | Notes
--------------------|--------------
utils_core.shi      | Core utility functions for bash. These functions are used across other utility functions extensively. Many are more for convenience or readibility than for extensive functionality, e.g. 'script' - print the basename of the currently running script... functions include dir/file checking/creation, null arg checking, bash argument checking and default Usage() function (requires USAGE var to be defined).
utils_vb.shi        | Functions mainly used in debugging - that print values, etc. when a 'verbose' flag is set to TRUE/ON.  Note that the functionality automatically parses (then removes) "--vb", if it is an argument to a script using these utils. If detected the 'verbose' flag (UTILS_VERBOSE) is set to TRUE/ON. If not detected UTILS_VERBOSE will be set to FALSE/OFF.
utils_opts.shi 		| Utility functions to enable the automatic parsing of command line option flags (-x, --doit, etc) and their subsequent removal from the command line argument to make processing easier. Options can appear in any position. Use of an optional --rem 'description ...' when specifying command line flag auto processing results in the 'description ...' being added automatically to the Usage description in the containing script (assuming it uses the default Usage() function).
utils_git.shi 		| Utitlites to assist in the automation of git related activities. In particular allows detection of the 'current' git repo. e.g. get currrent git root dir, is this a git repo? what's the current branch called ... etc.
utils_pvar.shi      | Provides services to enable bash scripts to store 'persistent' variables. Persisent meaning the variable retain their value across different calls to the same, or another, script. Enables the setting of context to determine the exact scope of persistent vars.
utils_fd.shi 	    | Utilities for file and directory management. Find directories and files, check they exist, find directories not in the 'excluded' list (UTILS_EXCLUDE - defined in egrep format). Functions with 'x' as first char exclude results based on the UTILS_EXCLUDE value.
utils_map.shi 		| Utilities to provide multi-dimentional hash-map style functionality to bash, enabling the addition or extraction of values from a named MAP given any number of keys (one key per dimension).
utils_msc.shi 		| Provides misc servces for thing like: padded output; stripping whitespaces; counting arguments; checking a scripts software dependencies & tarring up directories.
utils_uio.shi       | Functions that request user input ("warning: do you want to..., hit any key to...") before continuing. Putting "--ff" as an arguments to a script call 'forces' the functions to skip user input (e.g. like rm -f does).Parsing of UTILS_FORCEFLAG (--ff) is automatic.
_					| _
utils.shi            | put '. utils.shi' at the top of your script to includes all utils files listed above.
utils_globals.shi   | This is a set of bash variables that are useful in scripts - globally assigned values for backup directories, git directories, etc.  Defaults are provided but if set externally and exported these values can be overridden. Some functions *will* expect the values to be set. It is possible to override any value without editing the file - environment takes precedence.
## Per File - Detailed Description of Functions.
### utils_core.shi
```
nostdout() 
# turn off standard output.
 
nostderr() 
# turn of standard error.
 
null() # <...args>
# if any args are supplied return true (0), else return false (1); uses test -z
# e.g. < if null "$@"; then ... fi >
 
isdir() # <name>
# return true (0)  if <name> is a directory, false (1) otherwise.
# e.g. < if isdir "$NAME"; then ... fi >
 
isDir() # <name>
# return true (0)  if <name> is a directory, false (1) otherwise.
 	
isfile() # <name>
# return true (0)  if <name> is a file, false (1) otherwise.
# e.g. < if isfile "$NAME"; then ... fi >
 
isFile() # <name> 
# return true (0)  if <name> is a file, false (1) otherwise  (duplicate of isfile).
 
script() 
# echo name (no path) of current (containing) bash script file.
 
scriptName() 
# print base of current bash script *file* name (duplicate function)
 
callFnIfExists() # <name> <...args>
# if <name> is a function, call it with <...args>, otherwise do nothing.
 
Usage() 
# default Usage function. Autocalled by bash utils - details of usage expected in bash $USAGE variable.
 
# exit with code, if not in terminal mode, otherwise print message.
 
exitok()
# exit with ok status (0). If in terminal (command line) mode - don't exit terminal shell - instead print a message.
 
exiterr() # [ -k | <exit code>]
# exit with non-ok status ($1). If in terminal (command line) mode - don't exit terminal - instead print a message.
# use -k option to exit from nested subprocesses.
 
chkarg() # <bash variable name> [<level> (default 2)]
# if <bash variable name> does not have a value - print error and exit.
# <level> - how many levels of function call to find function name (for error message)
# e.g. 2: use function calling chkarg; 3: function that calls function that calls this function. etc.

chkvar() 
# as chkarg
 
chkval() 
# as chkarg
 
setvar() # <bash var name> <value>
# set <bash var name> to <value> - if <value> is undefined - error and exit.
# use to check parameters passed to functions correctly.
 
isTerminalOutput() 
# if the current output stream (1, 2 ...) is to a terminal return true (0), else false (1)

setcol() # <color code>
# set text color - see VT100 color codes in this file. 
# color code values include: BLACK RED LIGHTRED GREEN YELLOW BLUE MAGENTA CYAN WHITE NORMAL RESET (both WHITE).
# precede color code with $ (e.g. $BLACK).

setcolnorm() 
# reset text color to 'normal'. 

resetcol() 
# reset text color to 'normal'. 
 	
scrCurPos() # [ <x> <y> ]
# Position the cursor at(row,column(relative top rhs) as per <x>,<y> - or at 0,0 if either args not given.

scrClear() # no args.
# clear the screen.

errecho() # [-s] <...args>
# print message to stderr. -s: precede message with using script name
  
errfnecho() # <...args>
# always precedes error with script and bash function name.
# print message to stderr.
 
fnname() # [-l <call-fn-level>] 
# echo the current function name (the function calling this one)
# -l:  e.g. "fnname -l 2"  echo name of function  calling function calling this function.

ne() # <bash command ... >
# run command without those irritating error messages! (ne: No Error) e.g. $ ne errecho hello - no output
 
no() # <bash command ...>
# run command without std output! (no: No Output) - e.g. $ no echo hello - no output
 
checkNotEmptyString() # <msg> [ <bash var name> ] 
# deprecated - use chkarg().
# e.g. usage: $ 'local NAME=""; checkNotEmptyString "You forgot to give a name!" $NAME' 

xgrep() # <...normal 'grep' args>
# call grep with args given, but exclude certain patterns from results (grep -v)
# $UTILS_EXCLUDE defines the pattern - in egrep form - see utils_globals.shi.
 
xfind() # <... standard find args>
# call find with args given, but exclude certain patterns from results (grep -v)
# $UTILS_EXCLUDE defines the pattern - in egrep form - see utils_globals.shi.
 
 
```
### utils_fd.shi
```
ensuredeleted() # <file/dir name>
# if it exists, delete the <file/dir> given. otherwise do nothing.

checkfileexists() # <file>
# check if <file> exists - exit with error if not.

checkdirexists() # <dir>
# check if <dir> exists - exit with error if not.

ensuredirexists() # <dir>
# if <dir> does not already exist, create it.

fdmatch() # <shell glob pattern>
# is there a matching file or dir for shell glob pattern given? return true/false (0/non-0)

tmpFile() # [ <num> ] 
# generate a tmp file name with <num> unique charactors in it. Default 5.

fileecho() # [--rm] <message> <file> [...<file>] 
# (write <message> to multiple files. clear files first if '--rm')

findFile() # [ -d <dir> ] [ -h ] <file>
# downwards recursive search for file (inc. part name). start in cwd unless -d: use <dir> -h: use $HOME

findfile() # [ -d <dir> ] [ -h ] <file>
# downwards recursive search for file (inc. part name). start in cwd unless -d: use <dir> -h: use $HOME
 
backupFile() # <file/dir>
# make a backup <to UTILS_BACKUPDIR> of <file> nb: can be a dir.

backupDir() # <dir>
# make a backup <to UTILS_BACKUPDIR> of <dir> nb: can be a file.
 
getPath() # [-h] 
# return space seperated list of all dirs (full path name) on $PATH; -h: only those under $HOME

mkfindor() # <...args>
# make a find 'or expression' with many filename patterns ("$@").
# e.g. 'mkfindor *.sh *.shi' echos => '-name *.sh -o -name *.shi'

xfinddirs() # [-i]
# find non excluded dirs below current.
# -i: include current dir in results.

xforeachdir() 
# run a command in each directory echo-returned by $(xfinddirs).

xfindfiles() # <...args> ("$@")
# find files below current dir that match the glob pattern(s) (ls style) in <args>.
# e.g. xfindfiles *.ts *.js

xfindfilesgrep() # <grep arg>
# return (list, echo)  files containing a pattern with a recursive dir descent search 
# -s: show grep results; by default: no grep output is shown.

xfindcwd() 
# list files (applying exclusions) in current dir.

 
```
### utils_git.shi
```
gitroot() 
# echo-return the name of the root git repo given the cwd.

gitrootns() 
# echo-return the name of the root git repo given the cwd.
# however, remoate any '/'s e.g. '/usr/include'  - will be echo-returned as '_usr_include'
# enables git root dir to be used as an identifier or filename - or context for pvars (see utils).

gitCurrentBranch() 
# return the current git branch

isGitRootDir()
# is the cwd a git root directory - return 0 [T] or 1 [F]

isGitDir() 
# returns T/F [0/1] depending whether the cwd is in a git repo.

checkIsGitDir() 
# error and exit if cwd is not within a git repo.

xfindgitdirs()
# recursive dir search down from cwd, echo-return all the git root dir names.

gitNeedsCommit()
# does the current git repo have data to potentially commit?

gitStatus()
# prints a message if the git repo which contains the cwd requires a git commit.

gitAbandonChanges()
# abandon all changes since the last commit. prints warning message.

gitDoPush()
# push current repo to origin.

gitDoCommit() # [<message>]
# undertake a git commit using <message> - or a default message if none supplied.

gitCommitAndPush() # <messasge>
# commit changes using <message>, then push to origin.

gitcandpfn() # <message>
# commit changes using <message>, then push to origin.
 
 
```
### utils_map.shi
```




setMapValue() # <map-name> <value> <key 1> [<key 2> ... <key N>]
# insert <value> into the given map by <map-name> enabling it to be recovered by providing the same set of keys as given here.

getMapValue() # <map-name> <key 1> [<key 2> ... <key N>] 
# echo-returns the value selected by <map-name> and whatever keys were given.

mapKeys() # <map> (for debug, mainly) 
# echo-return list of all map keys for <map>
# nb: this will be in 'mangled' internal format - 
# understanding will require reading the source code.

mapKeyValues()  # <map<> (for debug, mainly) 
# echo-return a list of key-value pairs 
# nb: keys shown in mangled internal format 
# understanding will require reading the source.

 
```
### utils_msc.shi
```
softwareRequired() # <software-name> - e.g. cpp, tar, git ...
# check if <software-name> is installed, if not print error. exit.

stripwhite() # <string>
# <string> => <string> but without excess whitespace (\t and space) & control chars

count() 
# count #args given, echo number as return.
 
concat() # [-s | -c <string>] <args...> - join args together.
# e.g. concat a b c => 'abc', concat -c : a b c => 'a:b:c' , concat -s a b => "a b" (space between)
 
delimit() # [-d <_LIMITCHAR>] <string> - was useful once... deprecate... TBD.
# e.g. delimit <string> => %%<string>%%, delimit -d x <string> => x<string>x.

randomString() # <numchars - default 10>
# return a random string (by echo).

isNum() # <arg>
# return (via exit code) if <arg> is a valid number. e.g. if isNum xxx; then ...

roundDown() # <value>
# round down <value> to whole int.

getDirs() # [-x]: exclude cwd.
# echo full path name of dirs, from cwd, recursive, exclude unwanted. 

nds() # no double slash - e.g. "nds echo $PATH" - echo PATH with // => /.. 

explode() # <string>
# explode "ABCDE" => A B C D E

printbetween() # [ -n] <start> <end> <file>
# print lines between regexps <start> and <end> (inclusive) in <file>.

len() # <string>
# how many chars in <string> - what is its length.

tardir() # <dir> 
# tar up a directory <dir> into a tar file.

untardir() # <tar file name> 
# 'untar' file (<tar-file-name>) created using tardir() fn.

echoPadded() # <padlen> <...text>
# echo <text> in standard manner. If less than <padlen> chars used, pad out with spaces.

errechoPadded() # <padlen> <...text>
# errecho <text> (to stderr, &2) in standard manner. If less than <padlen> chars used, pad out with spaces.

datefmt() # [-l|--long] --s]: echo-return formatted date.
# -l - use a long format
# -s - use a short format

getarg() # <num> <...args>
# echo-return the <num>'th argument in <...args> (i.e. $<num>)

 
```
### utils_opts.shi
```
optautocomplete() # <auto complete command>
# e.g. a scripts could contain:
# optautocomplete "_git_rmb() { _git_checkout; }; export _git_rmb" - see bash and git autocomplete for more details.



getOptUsage() # [-n]
# print option documentation a given by '--rem' argument to xxxopt functions.
# -n: don't print "Options:" at head of option list.

binopt() # [ --rem <documentation...> ] <flag> <bash var> <default-value> <value-if-flag-given> "$@"
# called in the form:
# eval $(binopt --rem <documentation...' -a AVARIABLE 99 101 "$@")
# where: 	<flag> (-a) is the flag to be processed on the including script.
#			<bash-var> (AVARIABLE) - the bash var to set set to either <default-value> or <other-value>
#			<defaul-value> - <bash-var> is set to this value if <flag> is not present.
#			<value-if-flag-given> - <bash-var> is set to this value if <flag> is present
# --rem is optional. If given <documentation...> will be added to Usage of containing script.

boolopt() # [ --rem <documentation...> ] <flag> <bash var> "$@"
# called in the form:
# eval $(boolopt --rem <documentation...' -a AVARIABLE "$@"
# where: 	<flag> (-a) is the flag to be processed on the including script.
#			<bash-var> (AVARIABLE) - the bash var to set set to either 'true' or 'false'
# --rem is optional. If given <documentation...> will be added to Usage of containing script.
# 
# AVARIABLE is set to true if <flag> is present on the script call command line.

valopt() # [ --rem <documentation...> ] <flag> <bash var> <value> "$@"
# called in the form:
# eval $(valopt --rem <documentation...' -a AVARIABLE hello "$@")
# where: 	<flag> (-a) is the flag to be processed on the including script.
#			<bash-var> (AVARIABLE) - the bash var to set set to either <default-value> or <other-value>
#			<value> - the value AVARIABLE is set to if <flag> is present. AVARIABLE will undefined if not.
# --rem is optional. If given <documentation...> will be added to Usage of containing script.

Usage() # no args. 
# print $USAGE and also print option documentation defined using boolopt, valopt (with --rem flag), etc.
# nb: redefinition of Usage defined in _core utils.

chkargcount() # [-l] <lower-limit> <upper-limit> "$@"
# check argument count in "$@" is between <lower-limit> and <upper-limit> inclusive - if not,  error with exit.
# [-l] - lower limit only required, no upper limit.

# print usage if help has been requested on the command line.

errifopt() # "$@"
# exit with error if there are options (-*) present (or left after boolopt, valopt processing)  in "$@" 
# if help has been requested by command line flag (e.g. --hh) it will be shown.

 
```
### utils_pvar.shi
```





pvar_context() # <context-name> - the context (or namespace) to be used for storing subsequent pvars.
# Call this function IF you do not want to use the default context (namespace) - which is the calling bash script name.

pvar_declare() # <pvar-name> <pvar-init-value>
# pvars must be declared. <pvar-name> will be intitialised to <pvar-init-value> which must be supplied (non null).

pvar_set() # <pvar-name> <value>
# set the pvar <pvar-name> to the given <value>

pvar_get() # <pvar-name>
# returns (via echo) the value of <pvar-name> - if any.

pvar_clear() # <pvar-name>
# 'make sure' <pvar-name> doesn't already have a value - clear it.

pvar_default() # <pvar-name> [<value>] 
# if <value> set, return it (and store it in <pvar-name>); if not, return the value of <pvar-name>

pvar_rmcontext()
# deletes all variables in the current context (namespace).

pvar_rmdir()
# moves the pvar storage area (i.e. all pvars, all contexts) to a tmp-dir location (/tmp/...).

 
```
### utils_uio.shi
```
setForce() 		
# set the force flag to true.
 
resetForce()	
# set the force flag to false.
 
getForce()		
# return TRUE if the force flag is set.
 
force()			
# return TRUE if the force flag is set.
 
checkIfForce() # <arg> - deprecated - for back compatibility and internal utils use.
# check if <arg> is $UTILS_FORCEFLAG- if it is the force flag will be set.

hitAnyKeyToContinue() # [<message>] 
# print <message> and wait for 'enter' key press.

Warning() # [-n] [<message>] 
# show <message> - then wait for yes/n response, exit on 'n'.
# [-n] - do not exit on "no" reponse - return false (1) instead.
# <message> is optional. Default is 'Continue?'

 
```
### utils_vb.shi
```
setVerbose() 
# set the verbose flag to TRUE 
# nb: used by vbecho and similar functions
 
getVerbose()	
# return true (0) if verbose flag set to on.
 
verbose()		
# return true (0) if verbose flag set to on.
 
resetVerbose() 	
# set verbose flag to false.
# nb: used by vbecho and similar functions
 
vbvar() # <bash-var> - nb: no '$' needed or permitted.
# e.g. vbvar MY_VAR
# for debug -  print name and value of bash variable - <bash-var>

vbecho() # <string>
# print <string> if $(verbose) - verbose output flag - is true.
 
vbfnecho() # <string>
# print <echo style string> if $(verbose) - verbose output flag - is true.
# precede <echo style string> with function name of calling function.
 
vbsleep() # <seconds>
# sleep for <seconds> if $(verbose) (verbose output flag) is true.
 
checkIfVerbose() # <arg> - deprecated 
# now autoparses - for backwards compatibility and internal utils use only.
# quick parse to set if <arg> is $UTILS_VERBOSEFLAG flag (by default '--vb', but can be reset).

 
```
### File naming

* *.shi (shell include) is used as a suffix for all utility files.

### Code conventions

* *tabstops* - the code uses tabs to indent. The tabstop during development is set to 4, though you should be able to vary this at the beginning of lines at least (but perhaps not once text has started).

* *test -z xxx vs. [[ -z xxx ]]* - the code currently uses the 'test' form of condition for 'if' statements, etc. e.g. 'test -z ""' - is  an empty string. If enough people complain I could be tempted to convert this - but is it worth it?

## HELPER SCRIPTS and related notes

This README.md file was generated from a bash script (see README.sh) using some HELPER functions (see HELPER related sub-directory), 
mainly to extract functions and their documentation from the utils_xxx.shi files.

The HELPER scripts provided are:
### ffn.sh
```

Usage: ffn.sh [-options] <part-fn-name>

Search <MYENV_SCRIPTROOT> and sub-dirs for all 'script includes (*.shi, etc)' to find bash fns matching the partial name given.
<part-fn-name> is a grep style pattern. Do *not* put '()' at the end - this is done automatically.

nb: you must define MYENV_SCRIPTROOT in your environment for this function to work, or an error will be given.

Matches functions of the form:
"afunctionname()" - i.e. function name is at start of line, alphanumeric name, () at the end, no spaces in name or before ().
Options:
-a match any function (do not give a function name)
-x search for an exact match only
-n print matching file name only
-m specify files (by glob pattern) to match (ls style - e.g. *.sh)
-s use shorter output format (prints fn upto open brace)
-l use longer detailed output format (full listing)
-d use bash native (set) output format (full listing, after parsing by bash)

```

### fndef.sh
```
fndef.sh  <part-fn-name>
Show bash function definition(s) - using native bash 'set' format (full listing)
Match any function that contains <part-fn-name> within it.


```

## Comments and Contributions Welcome

Feedback or Contributions welcome:
* email:markcollinscope+bashutils@gmail.com, or message here.
* branch etc. to contribute something new and make a pull request.
* be patient - do let me know if you're doing something in advance, please.

