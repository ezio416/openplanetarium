# angelscript grammar reference: https://www.angelcode.com/angelscript/sdk/docs/manual/doc_script_bnf.html

@{%
const moo = require("moo")
const lexer = moo.compile({
    // reference: /&\s*(?:(?:in|inout|out)\b)?/,
    identifier: {
        match: /[A-Z_a-z][0-9A-Z_a-z]*/,
        type: moo.keywords({
            bool_false:      "false",
            bool_true:       "true",
            cast:            "cast",
            cmp_is:          "is",
            cls_super:       "super",
            cls_this:        "this",
            ctl_break:       "break",
            ctl_case:        "case",
            ctl_continue:    "continue",
            ctl_default:     "default",
            ctl_return:      "return",
            decl_class:      "class",
            decl_enum:       "enum",
            decl_from:       "from",
            decl_funcdef:    "funcdef",
            decl_function:   "function",
            decl_get:        "get",
            decl_import:     "import",
            decl_interface:  "interface",
            decl_namespace:  "namespace",
            decl_set:        "set",
            decl_typedef:    "typedef",
            decl_using:      "using",
            log_and:         "and",
            log_or:          "or",
            log_xor:         "xor",
            mod_abstract:    "abstract",
            mod_const:       "const",
            mod_delete:      "delete",
            mod_explicit:    "explicit",
            mod_external:    "external",
            mod_final:       "final",
            mod_mixin:       "mixin",
            mod_override:    "override",
            mod_private:     "private",
            mod_property:    "property",
            mod_protected:   "protected",
            mod_shared:      "shared",
            nullptr:         "null",
            prim_auto:       "auto",
            prim_bool:       "bool",
            prim_double:     "double",
            prim_float:      "float",
            prim_int:        "int",
            prim_int8:       "int8",
            prim_int16:      "int16",
            prim_int32:      "int32",
            prim_int64:      "int64",
            prim_uint:       "uint",
            prim_uint8:      "uint8",
            prim_uint16:     "uint16",
            prim_uint32:     "uint32",
            prim_uint64:     "uint64",
            prim_void:       "void",
            ref_in:          "in",
            ref_inout:       "inout",
            ref_out:         "out",
            std_array:       "array",
            std_dictionary:  "dictionary",
            std_ref:         "ref",
            std_string:      "string",
            stmt_catch:      "catch",
            stmt_do:         "do",
            stmt_else:       "else",
            stmt_for:        "for",
            stmt_foreach:    "foreach",
            stmt_if:         "if",
            stmt_switch:     "switch",
            stmt_try:        "try",
            stmt_while:      "while"
        })
    },
    num_scientific: {
        match: /(?:[0-9](?:'?[0-9])*|[0-9](?:'?[0-9])*\.(?:[0-9](?:'?[0-9])*)?|[0-9]*\.[0-9](?:'?[0-9])*)[Ee](?:[+-]?[0-9](?:'?[0-9])*)?/,
        value: v => {
            if (v.endsWith("E") || v.endsWith("e")) {
                v += "0"  // AS implicitly adds a 0 exponent, JS doesn't
            }
            return Number(v.replaceAll("'", ""))
        }
    },
    num_float: {
        match: /(?:[0-9](?:'?[0-9])*\.(?:[0-9](?:'?[0-9])*)?|[0-9]*\.[0-9](?:'?[0-9])*)f?/,
        value: v => parseFloat(v.replaceAll("'", ""))
    },
    num_hexadecimal: {
        match: /0[Xx][0-9A-Fa-f](?:'?[0-9A-Fa-f])*/,
        value: v => parseInt(v.replaceAll("'", ""), 16)
    },
    num_octal: {
        match: /0[Oo][0-7](?:'?[0-7])*/,
        value: v => parseInt(v.replace("O", "").replace("o", "").replaceAll("'", ""), 8)
    },
    num_binary: {
        match: /0[Bb][01](?:'?[01])*/,
        value: v => parseInt(v.replace("0B", "").replace("0b", "").replaceAll("'", ""), 2)
    },
    num_integer: {
        match: /(?:0[Dd])?[0-9](?:'?[0-9])*/,
        value: v => parseInt(v.replace("0D", "").replace("0d", "").replaceAll("'", ""))
    },
    lbrace: "{",
    rbrace: "}",
    lbracket: "[",
    rbracket: "]",
    lparen: "(",
    rparen: ")",
    lte: "<=",
    lt: "<",
    gte: ">=",
    gt: ">",
    scope_access: "::",
    member_access: ".",
    question: "?",
    colon: ":",
    comma: ",",
    handle: "@",
    sentinel: /;/,
    whitespace: {
        match: /\s+/,
        lineBreaks: true
    }
})
%}

@lexer lexer

program -> ( _ statement ):+ _ {% d => d[0].map(v => v[1]).filter(s => s !== null) %}

statement -> expression:? _ %sentinel {% d => d[0] %}
statement -> %lbrace _ statement _ %rbrace {% d => d[2] %}

expression -> constant {% id %}
expression -> %lparen _ expression _ %rparen {% d => d[2] %}

constant -> boolean {% d => { d[0].value = d[0].text === "true"; return d[0] } %}
constant -> %nullptr {% d => { d[0].value = null; return d[0] } %}
constant -> number {% id %}

boolean -> %bool_false {% id %}
boolean -> %bool_true {% id %}

number -> %num_scientific {% id %}
number -> %num_float {% id %}
number -> %num_hexadecimal {% id %}
number -> %num_octal {% id %}
number -> %num_binary {% id %}
number -> %num_integer {% id %}

_ -> %whitespace:*
