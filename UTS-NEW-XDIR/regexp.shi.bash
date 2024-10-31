# bash variable.
^[a-zA-Z_][a-zA-Z0-9_]*$

# fn:
^[a-zA-Z_][a-zA-Z0-9._:()-]*$


Alphanumeric Characters

[[:alnum:]]: Represents all letters (both uppercase and lowercase) and digits.
Equivalent to [A-Za-z0-9].
Alphabetic Characters

[[:alpha:]]: Represents all letters (both uppercase and lowercase).
Equivalent to [A-Za-z].
Digits

[[:digit:]]: Represents all digits.
Equivalent to [0-9].
Whitespace Characters

[[:space:]]: Represents all whitespace characters, including spaces, tabs, newlines, and carriage returns.
Printable Characters

[[:print:]]: Represents all printable characters, which include all visible characters plus the space character.
Control Characters

[[:cntrl:]]: Represents all control characters (ASCII values 0-31).
Punctuation Characters

[[:punct:]]: Represents all punctuation characters.
Uppercase Letters

[[:upper:]]: Represents all uppercase letters.
Equivalent to [A-Z].
Lowercase Letters

[[:lower:]]: Represents all lowercase letters.
Equivalent to [a-z].
Hexadecimal Digits

[[:xdigit:]]: Represents all hexadecimal digits (0-9, A-F, a-f).
Word Characters

[[:word:]]: Represents all word characters, typically equivalent to [A-Za-z0-9_]. Note: This class is not standardized in all environments.


--- sed... matches.
echo "your_string_here" | sed -n '/your_regex_here/p'
Checking the Exit Status
You can check the exit status of the sed command to determine if there was a match:

An exit status of 0 indicates a match.
An exit status of 1 indicates no match.
An exit status of 2 indicates an error in the command.



tag coding...

tag.prefix tag.suffix tag.sub-prefix tag.sub-suffix tag.sep tag.taglevel...


