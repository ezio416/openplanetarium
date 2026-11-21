program     -> _ literal (__ literal):* _

literal     -> boolean | nullptr | number

boolean     -> "true" | "false"

nullptr     -> "null"

number      -> number_flt | number_hex | number_int | number_oct | number_bin
number_flt  -> ( number_int "." number_uint:? | number_int:? "." number_uint ) "f":?
number_hex  -> "0x" digit_hex:+
digit_hex   -> [0-9A-Fa-f]
number_int  -> "-":? number_uint
number_uint -> digit_int:+
digit_int   -> [0-9]
number_oct  -> "0o" digit_oct:+
digit_oct   -> [0-7]
number_bin  -> "0b" digit_bin:+
digit_bin   -> [01]

_           -> WS:*
__          -> WS:+
WS          -> " " | "\n" | "\r" | "\t"
