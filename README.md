# !@#$%^&*()_+
## A symbolic language

|Command|Effect|
|-|-|
|`!`|duplicate top member of stack|
|`@`|pops top of stack and prints that popped number as a character|
|`#`|pops top of stack and prints that popped number as a number|
|`$`|swaps the top two members of the stack|
|`%`|rotates the stack by 1 to the left|
|`^`|increments the top of the stack|
|`&`|(unimplemented)|
|`*`|reads 1 byte of input from STDIN and adds it to top of stack|
|`(`|open loop|
|`)`|close loop|
|`_`|negate top of stack|
|`+`|pops top of stack and adds it to the new top of stack|
|`?`|prints state info|