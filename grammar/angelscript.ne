# angelscript grammar reference: https://www.angelcode.com/angelscript/sdk/docs/manual/doc_script_bnf.html

@{%
const moo = require("moo")
const lexer = moo.compile({
    reference: /&\s*(?:(?:in|inout|out)\b)?/,
    identifier: {
        match: /[A-Z_a-z][0-9A-Z_a-z]*/,
        type: moo.keywords({
            boolean: [
                "false",
                "true"
            ],
            nullptr: "null"
        })
    },
    number_scientific: /(?:[0-9](?:'?[0-9])*|[0-9](?:'?[0-9])*\.(?:[0-9](?:'?[0-9])*)?|[0-9]*\.[0-9](?:'?[0-9])*)[Ee](?:[\+-]?[0-9](?:'?[0-9])*)?/,
    number_float: /(?:[0-9](?:'?[0-9])*\.(?:[0-9](?:'?[0-9])*)?|[0-9]*\.[0-9](?:'?[0-9])*)f?/,
    number_hexadecimal: /0[Xx][0-9A-Fa-f](?:'?[0-9A-Fa-f])*/,
    number_octal: /0[Oo][0-7](?:'?[0-7])*/,
    number_binary: /0[Bb][01](?:'?[01])*/,
    number_integer: /(?:0[Dd])?[0-9](?:'?[0-9])*/,
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

expression -> constant {% id %}
expression -> %lparen _ expression _ %rparen {% d => d[2] %}

constant -> %boolean {% d => { d[0].value = d[0].text === "true"; return d[0] } %}
constant -> %nullptr {% d => { d[0].value = null; return d[0] } %}
constant -> number {% id %}

number -> %number_scientific {% id %}
number -> %number_float {% id %}
number -> %number_hexadecimal {% id %}
number -> %number_octal {% id %}
number -> %number_binary {% id %}
number -> %number_integer {% id %}

_ -> %whitespace:*
