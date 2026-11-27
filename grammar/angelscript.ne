# angelscript grammar reference: https://www.angelcode.com/angelscript/sdk/docs/manual/doc_script_bnf.html
# some changes needed to be made as the official reference is not perfect

@{%
const moo = require("moo")
const lexer = moo.compile({
    string: {  // TODO just copied from an example
        match: /"(?:[^\n\\"]|\\["\\ntbfr])*"/,
        value: v => JSON.parse(v)
    },
    // TODO comments
    identifier: {
        match: /[A-Z_a-z][0-9A-Z_a-z]*/,
        type: moo.keywords({
            kw_abstract:   "abstract",
            kw_and:        "and",
            kw_auto:       "auto",
            kw_bool:       "bool",
            kw_break:      "break",
            kw_case:       "case",
            kw_cast:       "cast",
            kw_catch:      "catch",
            kw_class:      "class",
            kw_const:      "const",
            kw_continue:   "continue",
            kw_default:    "default",
            kw_delete:     "delete",
            kw_do:         "do",
            kw_double:     "double",
            kw_else:       "else",
            kw_enum:       "enum",
            kw_explicit:   "explicit",
            kw_external:   "external",
            kw_false:      "false",
            kw_final:      "final",
            kw_float:      "float",
            kw_for:        "for",
            kw_foreach:    "foreach",
            kw_from:       "from",
            kw_funcdef:    "funcdef",
            kw_function:   "function",
            kw_get:        "get",
            kw_if:         "if",
            kw_import:     "import",
            kw_in:         "in",
            kw_inout:      "inout",
            kw_int:        "int",
            kw_int8:       "int8",
            kw_int16:      "int16",
            kw_int32:      "int32",
            kw_int64:      "int64",
            kw_interface:  "interface",
            kw_is:         "is",
            kw_mixin:      "mixin",
            kw_namespace:  "namespace",
            kw_not:        "not",
            kw_null:       "null",
            kw_or:         "or",
            kw_out:        "out",
            kw_override:   "override",
            kw_private:    "private",
            kw_property:   "property",
            kw_protected:  "protected",
            kw_return:     "return",
            kw_set:        "set",
            kw_shared:     "shared",
            kw_super:      "super",
            kw_switch:     "switch",
            kw_this:       "this",
            kw_true:       "true",
            kw_try:        "try",
            kw_typedef:    "typedef",
            kw_uint:       "uint",
            kw_uint8:      "uint8",
            kw_uint16:     "uint16",
            kw_uint32:     "uint32",
            kw_uint64:     "uint64",
            kw_using:      "using",
            kw_void:       "void",
            kw_while:      "while",
            kw_xor:        "xor",
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
        match: /(?:[0-9](?:'?[0-9])*\.(?:[0-9](?:'?[0-9])*)?|[0-9]*\.[0-9](?:'?[0-9])*)[df]?/,
        value: v => parseFloat(v.replaceAll("'", ""))
    },
    num_hexadecimal: {
        match: /0[Xx][0-9A-Fa-f](?:'?[0-9A-Fa-f])*/,
        value: v => parseInt(v.replaceAll("'", ""), 16)  // don't need to replace 0[Xx]
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
    lbrace:      "{",
    rbrace:      "}",
    lbracket:    "[",
    rbracket:    "]",
    lparen:      "(",
    rparen:      ")",
    increment:   "++",
    pluseq:      "+=",
    plus:        "+",
    decrement:   "--",
    minuseq:     "-=",
    dash:        "-",
    poweq:       "**=",
    pow:         "**",
    timeseq:     "*=",
    star:        "*",
    diveq:       "/=",
    slash:       "/",
    modeq:       "%=",
    percent:     "%",
    lshifteq:    "<<=",
    lshift:      "<<",
    lte:         "<=",
    larrow:      "<",
    rlogshifteq: ">>>=",
    rlogshift:   ">>>",
    rshifteq:    ">>=",
    rshift:      ">>",
    gte:         ">=",
    rarrow:      ">",
    and:         "&&",
    andeq:       "&=",
    amp:         "&",
    or:          "||",
    oreq:        "|=",
    bar:         "|",
    xor:         "^^",
    xoreq:       "^=",
    carrot:      "^",
    eq:          "==",
    neq:         "!=",
    assign:      "=",
    scope:       "::",
    colon:       ":",
    semi:        ";",
    comma:       ",",
    ellipses:    "...",
    dot:         ".",
    question:    "?",
    bang:        "!",
    at:          "@",
    tilde:       "~",
    whitespace: {
        match: /\s+/,
        lineBreaks: true
    }
})
%}

@lexer lexer

# SCRIPT        -> ( IMPORT | ENUM | TYPEDEF | CLASS | MIXIN | INTERFACE | FUNCDEF | VIRTPROP | VAR | FUNC | NAMESPACE | USING | %semi ):*
 # IMPORT        -> %kw_import TYPE %amp:? %identifier PARAMLIST FUNCATTR %kw_from %string %semi
 # USING         -> %kw_using %kw_namespace %identifier ( %scope %identifier ):* %semi
 # NAMESPACE     -> %kw_namespace %identifier ( %scope %identifier ):* %lbrace SCRIPT %rbrace
# ENUM          -> ( %kw_shared | %kw_external ):* %kw_enum %identifier ( %colon ( %kw_int | %kw_int8 | %kw_int16 | %kw_int32 | %kw_int64 | %kw_uint | %kw_uint8 | %kw_uint16 | %kw_uint32 | %kw_uint64 ) ):? ( %semi | ( %lbrace %identifier ( %assign EXPR ):? ( %comma %identifier ( %assign EXPR ):? ):* %rbrace ) )
 # FUNCDEF       -> ( %kw_external | %kw_shared ):* %kw_funcdef TYPE %amp:? %identifier PARAMLIST %semi
# FUNC          -> ( %kw_shared | %kw_external ):* ( %kw_private | %kw_protected ):? ( ( ( TYPE %amp:? ) | %tilde ) ):? _ %identifier PARAMLIST _ %kw_const:? FUNCATTR ( %semi | STATBLOCK )
# VIRTPROP      -> ( %kw_private | %kw_protected ):? TYPE %amp:? %identifier %lbrace ( ( %kw_get | %kw_set ) %kw_const:? FUNCATTR ( STATBLOCK | %semi ) ):* %rbrace
# INTERFACE     -> ( %kw_external | %kw_shared ):* %kw_interface %identifier ( %semi | ( ( %colon %identifier ( %comma %identifier ):* ):? %lbrace ( VIRTPROP | INTFMTHD ):* %rbrace ) )
# MIXIN         -> %kw_mixin CLASS
# CLASS         -> ( %kw_shared | %kw_abstract | %kw_final | %kw_external ):* %kw_class %identifier ( %semi | ( ( %colon %identifier ( %comma %identifier ):* ):? %lbrace ( VIRTPROP | FUNC | VAR | FUNCDEF ):* %rbrace ) )
 # VAR           -> ( %kw_private | %kw_protected ):? TYPE %identifier ( ( %assign ( INITLIST | EXPR ) ) | ARGLIST ):? ( %comma %identifier ( ( %assign ( INITLIST | EXPR ) ) | ARGLIST ):? ):* %semi
 # TYPEDEF       -> %kw_typedef PRIMTYPE %identifier %semi
 # INTFMTHD      -> TYPE %amp:? %identifier PARAMLIST %kw_const:? %semi
# STATBLOCK     -> %lbrace ( VAR | STATEMENT | USING ):* %rbrace
 # PARAMLIST     -> %lparen ( %kw_void | ( TYPE TYPEMOD ( %ellipses | %identifier:? ( %assign EXPR ):? ) ( %comma TYPE TYPEMOD ( %ellipses | %identifier:? ( %assign EXPR ):? ) ):* ) ):? %rparen
 # TYPEMOD       -> ( %amp ( %kw_in | %kw_out | %kw_inout ):? ):?
 # TYPE          -> %kw_const:? SCOPE DATATYPE TEMPLTYPELIST:? ( ( %lbrace %rbrace ) | ( %at %kw_const:? ) ):*
 # TEMPLTYPELIST -> %larrow TYPE ( %comma TYPE ):* %rarrow
 # INITLIST      -> %lbrace ( ASSIGN | INITLIST ):? ( %comma ( ASSIGN | INITLIST ):? ):* %rbrace
 # SCOPE         -> %scope:? ( %identifier %scope ):* ( %identifier TEMPLTYPELIST:? %scope ):?
 # DATATYPE      -> ( %identifier | PRIMTYPE | %question | %kw_auto )
 # PRIMTYPE      -> %kw_void | %kw_int | %kw_int8 | %kw_int16 | %kw_int32 | %kw_int64 | %kw_uint | %kw_uint8 | %kw_uint16 | %kw_uint32 | %kw_uint64 | %kw_float | %kw_double | %kw_bool
 # FUNCATTR      -> ( %kw_override | %kw_final | %kw_explicit | %kw_property | %kw_delete ):*
# STATEMENT     -> ( IF | FOR | FOREACH | WHILE | RETURN | STATBLOCK | BREAK | CONTINUE | DOWHILE | SWITCH | EXPRSTAT | TRY )
 # EXPRSTAT      -> ASSIGN:? %semi
 # SWITCH        -> %kw_switch %lparen ASSIGN %rparen %lbrace CASE:* %rbrace
# IF            -> %kw_if %lparen ASSIGN %rparen STATEMENT ( %kw_else STATEMENT ):?
# TRY           -> %kw_try STATBLOCK %kw_catch STATBLOCK
# FOR           -> %kw_for %lparen ( VAR | EXPRSTAT ) EXPRSTAT ( ASSIGN ( %comma ASSIGN ):* ):? %rparen STATEMENT
# FOREACH       -> %kw_foreach %lparen TYPE %identifier ( %comma TYPE %identifier ):* %colon ASSIGN %rparen STATEMENT
# WHILE         -> %kw_while %lparen ASSIGN %rparen STATEMENT
# DOWHILE       -> %kw_do STATEMENT %kw_while %lparen ASSIGN %rparen %semi
 # RETURN        -> %kw_return ASSIGN:? %semi
 # BREAK         -> %kw_break %semi
 # CONTINUE      -> %kw_continue %semi
# EXPR          -> EXPRTERM ( EXPROP EXPRTERM ):*
 # CASE          -> ( ( %kw_case EXPR ) | %kw_default ) %colon STATEMENT:*
# EXPRTERM      -> ( ( TYPE %assign ):? INITLIST ) | ( EXPRPREOP:* EXPRVALUE EXPRPOSTOP:* )
# EXPRVALUE     -> %kw_void | CONSTRUCTCALL | FUNCCALL | VARACCESS | CAST | LITERAL | %lparen ASSIGN %rparen | LAMBDA
 # CONSTRUCTCALL -> TYPE ARGLIST
 # EXPRPREOP     -> %dash | %plus | %bang | %increment | %decrement | %tilde | %at
 # EXPRPOSTOP    -> ( %dot ( FUNCCALL | %identifier ) ) | ( %lbrace ( %identifier %colon ):? ASSIGN ( %comma ( %identifier %colon ):? ASSIGN ):* %rbrace ) | ARGLIST | %increment | %decrement
 # CAST          -> %kw_cast %larrow TYPE %rarrow %lparen ASSIGN %rparen
 # LITERAL       -> number | %string | boolean | %kw_null
# LAMBDA        -> %kw_function %lparen ( ( TYPE TYPEMOD ):? %identifier:? ( %comma ( TYPE TYPEMOD ):? %identifier:? ):* ):? %rparen STATBLOCK
 # FUNCCALL      -> SCOPE %identifier TEMPLTYPELIST:? ARGLIST
 # VARACCESS     -> SCOPE %identifier
 # ARGLIST       -> %lparen ( %identifier %colon ):? ASSIGN ( %comma ( %identifier %colon ):? ASSIGN ):* %rparen
 # ASSIGN        -> CONDITION ( ASSIGNOP ASSIGN ):?
 # CONDITION     -> EXPR ( %question ASSIGN %colon ASSIGN ):?
 # EXPROP        -> MATHOP | COMPOP | LOGICOP | BITOP
 # MATHOP        -> %plus | %dash | %star | %slash | %percent | %pow
 # COMPOP        -> %eq | %neq | %larrow | %lte | %rarrow | %gte | %kw_is | %bang %kw_is
 # LOGICOP       -> %and | %or | %xor | %kw_and | %kw_or | %kw_xor
 # BITOP         -> %amp | %bar | %carrot | %lshift | %rshift | %rlogshift
 # ASSIGNOP      -> %assign | %pluseq | %minuseq | %timeseq | %diveq | %oreq | %andeq | %xoreq | %modeq | %poweq | %lshifteq | %rshifteq | %rlogshifteq

@{%

function token(d) {
    return {
        token_type: d.type,
        value:      d.value !== d.text ? d.value : undefined,
        text:       d.text,
        offset:     d.offset,
        line:       d.line,
        col:        d.col,
    }
}

%}

script -> _ ( ( test | import | typedef | funcdef | namespace | using | %semi ) _ ):* {% d => {
    return {
        parse_type: "script",
        children:   d[1].map(v => v[0][0])
    }
} %}

test -> statement {% id %}

import -> %kw_import _ type _ ( %amp _ ):? id _ param_list _ ( func_attr _ ):? %kw_from _ %string _ %semi {% d => {
    return {
        parse_type: "import",
        type:       d[2],
        ref:        !!d[4],
        name:       d[5],
        params:     d[7],
        attr:       d[9],
        module:     d[12]
    }
} %}

using -> %kw_using _ %kw_namespace _ id ( _ %scope _ id ):* _ %semi {% d => {
    ret = {
        parse_type: "using",
        ids:        [ d[4] ]
    }
    if (d[5]) {
        ret.ids.push(...d[5].map(v => v[3]))
    }
    return ret
} %}

namespace -> %kw_namespace _ id ( _ %scope _ id ):* _ %lbrace script %rbrace {% d => {
    ret = {
        parse_type: "namespace",
        ids:        [ d[2] ],
        script:     d[6]
    }
    if (d[3]) {
        ret.ids.push(...d[3].map(v => v[3]))
    }
    return ret
} %}

funcdef -> ( ( %kw_external | %kw_shared ) _ ):* %kw_funcdef _ type _ ( %amp _ ):? id _ param_list _ %semi {% d => {
    return {
        parse_type: "funcdef",
        mods:       d[0] ? d[0].map(v => token(v[0][0])) : [],
        type:       d[3],
        ref:        !!d[5],
        name:       d[6],
        params:     d[8]
    }
} %}

var -> ( ( %kw_private | %kw_protected ) _ ):? type _ var_assign _ ( %comma _ var_assign _ ):* %semi {% d => {
    ret = {
        parse_type: "var",
        mod:        d[0] ? d[0][0][0] : null,
        type:       d[1],
        children:   [ d[3] ]
    }
    if (d[5]) {
        ret.children.push(...d[5].map(v => v[2]))
    }
    return ret
} %}

var_assign -> id ( _ ( ( %assign _ ( init_list | expr ) ) | arg_list ) ):? {% d => {
    ret = {
        parse_type: "var_assign",
        key:        d[0],
        value:      null
    }
    if (d[1]) {
        if (Array.isArray(d[1][1][0])) {
            ret.value = d[1][1][0][2][0]
        } else {
            ret.value = d[1][1][0]
        }
    }
    return ret
} %}

typedef -> %kw_typedef _ prim_type _ id _ %semi {% d => {
    return {
        parse_type: "typedef",
        old:        token(d[2]),
        new:        d[4]
    }
} %}

interface_method -> type _ ( %amp _ ):? id _ param_list _ ( %kw_const _ ):? %semi {% d => {
    return {
        parse_type: "interface_method",
        type:       d[0],
        ref:        !!d[2],
        name:       d[3],
        params:     d[5],
        const:      !!d[7]
    }
} %}

param_list -> %lparen _ ( ( %kw_void | param_list_inner ) _ ):? %rparen {% d => {
    ret = {
        parse_type: "param_list",
        children:   []
    }
    if (d[2]) {
        if (d[2][0][0].hasOwnProperty("children")) {
            ret.children = d[2][0][0].children
        } else {
            ret.children.push(token(d[2][0][0]))
        }
    }
    return ret
} %}

param_list_inner -> param_list_item ( _ %comma _ param_list_item ):* {% d => {
    ret = {
        parse_type: "param_list_inner",
        children:   [ d[0] ]
    }
    if (d[1]) {
        ret.children.push(...d[1].map(v => v[3]))
    }
    return ret
} %}

param_list_item -> type ( _ type_mod ):? _ ( %ellipses | %identifier ( _ %assign _ expr ):? ) {% d => {
    return {
        parse_type: "param_list_item",
        type:       d[0],
        type_mod:   d[1] ? d[1][1] : null,
        key:        token(d[3][0]),
        value:      d[3] && d[3].length === 2 && d[3][1] ? d[3][1][3] : null
    }
} %}

type_mod -> %amp ( _ ( %kw_in | %kw_out | %kw_inout ) ):? {% d => {
    ret = {
        parse_type: "type_mod",
        parts:      [ token(d[0]) ]
    }
    if (d.length > 1 && d[1]) {
        ret.parts.push(token(d[1][1][0]))
    }
    return ret
} %}

type -> ( %kw_const _ ):? ( scope _ ):? data_type ( _ templ_type_list ):? ( _ %lbracket ( _ %rbracket ) | _ %at ( _ %kw_const ):? ):* {% d => {
    return {
        parse_type: "type",
        const:      d[0] ? token(d[0][0]) : null,
        scope:      d[1] ? d[1][0] : null,
        name:       d[2],
        template:   d[3] ? d[3][1] : null,
        mods:       d[4].map(v => [
            token(v[1]),
            v[2] ? token(v[2][1]) : null
        ])
    }
} %}

templ_type_list -> %larrow _ type ( _ %comma _ type ):* _ %rarrow {% d => {
    ret = {
        parse_type: "templ_type_list",
        types:      [ d[2] ]
    }
    if (d[3]) {
        ret.types.push(...d[3].map(v => v[3]))
    }
    return ret
} %}

init_list -> %lbrace _ ( ( init_list_item _ %comma _ ):* init_list_item _ ( %comma _ ):? ):? %rbrace {% d => {
    ret = {
        parse_type: "init_list",
        elements:   []
    }
    if (d[2]) {
        if (d[2][0]) {
            ret.elements.push(...d[2][0].map(v => v[0]))
        }
        ret.elements.push(d[2][1])
    }
    return ret
} %}

init_list_item -> (
    assign
    | init_list
) {% d => d[0][0] %}

scope -> ( %scope _ ):? id _ ( %scope _ id _ ):* ( templ_type_list _ ):? %scope {% d => {
    ret = {
        parse_type: "scope",
        global:     !!d[0],
        scopes:     [ d[1] ],
        template:   d[4] ? d[4][0] : []
    }
    if (d[3]) {
        ret.scopes.push(...d[3].map(v => v[2]))
    }
    return ret
} %}

data_type -> (
    %identifier
    | prim_type
    # | %question
    | %kw_auto
    | %kw_void
) {% d => token(d[0][0]) %}

prim_type -> (
    %kw_int
    | %kw_int8
    | %kw_int16
    | %kw_int32
    | %kw_int64
    | %kw_uint
    | %kw_uint8
    | %kw_uint16
    | %kw_uint32
    | %kw_uint64
    | %kw_float
    | %kw_double
    | %kw_bool
) {% d => d[0][0] %}

func_attr -> func_attr_kw ( _ func_attr_kw ):* {% d => {
    ret = {
        parse_type: "func_attr",
        attrs:      [ d[0] ]
    }
    if (d[1]) {
        ret.attrs.push(...d[1].map(v => v[1]))
    }
    return ret
} %}

func_attr_kw -> (
    %kw_override
    | %kw_final
    | %kw_explicit
    | %kw_property
    | %kw_delete
) {% d => token(d[0][0]) %}

statement -> (
    # | IF
    # | FOR
    # | FOREACH
    # | WHILE
    return
    # | STATBLOCK
    | break
    | continue
    # | DOWHILE
    | switch
    | expr_stat
    # | TRY
) {% d => d[0][0] %}

expr_stat -> ( assign _ ):? %semi {% d => {
    return {
        parse_type: "expr_stat",
        assign:     d[0] ? d[0][0] : null
    }
} %}

switch -> %kw_switch _ %lparen _ assign _ %rparen _ %lbrace _ ( case _ ):* %rbrace {% d => {
    return {
        parse_type: "switch",
        assign:     d[4],
        children:   d[10] ? d[10].map(v => v[0]) : []
    }
} %}

return -> %kw_return _ ( assign _ ):? %semi {% d => {
    return {
        parse_type: "return",
        assign:     d[2] ? d[2][0] : null
    }
} %}

break -> %kw_break _ %semi {% d => token(d[0]) %}

continue -> %kw_continue _ %semi {% d => token(d[0]) %}

expr -> literal {% d => {  // TODO temporary
    return {
        parse_type: "expr",
        expr:       d[0]
    }
} %}

case -> ( %kw_case _ expr | %kw_default ) _ %colon ( _ statement ):* {% d => {
    return {
        parse_type: "case",
        label:      d[0],
        children:   d[3] ? d[3].map(v => v[1]) : []
    }
} %}

construct_call -> type _ arg_list {% d => {
    return {
        parse_type: "construct_call",
        type:       d[0],
        args:       d[2]
    }
} %}

expr_pre_op -> (
    %dash
    | %plus
    | %bang
    | %increment
    | %decrement
    | %tilde
    | %at
) {% d => token(d[0][0]) %}

expr_post_op -> arg_list {% d => {
    return {
        parse_type: "expr_post_op",
        sub_type:   "fn1",
        children:   d[0].children
    }
} %}
expr_post_op -> %dot _ func_call {% d => {
    return {
        parse_type: "expr_post_op",
        sub_type:   "dot",
        children:   [ d[2] ]
    }
} %}
expr_post_op -> %dot _ id {% d => {
    return {
        parse_type: "expr_post_op",
        sub_type:   "dot",
        children:   [ d[2] ]
    }
} %}
expr_post_op -> ( %increment | %decrement ) {% d => {
    return {
        parse_type: "expr_post_op",
        sub_type:   "inc",
        children:   [ token(d[0][0]) ]
    }
} %}
expr_post_op -> %lbracket _ ( arg_list_inner _ ):? %rbracket {% d => {
    return {
        parse_type: "expr_post_op",
        sub_type:   "fn2",
        children:   d[2] ? d[2][0].children : []
    }
} %}

cast -> %kw_cast _ %larrow _ type _ %rarrow _ %lparen _ assign _ %rparen {% d => {
    return {
        parse_type: "cast",
        type:       d[4],
        assign:     d[10]
    }
} %}

func_call -> ( scope _ ):? id ( _ templ_type_list ):? _ arg_list {% d => {
    return {
        parse_type: "func_call",
        scope:      d[0] ? d[0][0] : null,
        name:       d[1],
        template:   d[2] ? d[2][1] : null,
        args:       d[4]
    }
} %}

var_access -> ( scope _ ):? id {% d => {
    return {
        parse_type: "var_access",
        scope:      d[0] ? d[0][0] : null,
        var:        d[1]
    }
} %}

arg_list -> %lparen _ ( arg_list_inner _ ):? %rparen {% d => {
    return {
        parse_type: "arg_list",
        children:   d[2] ? d[2][0].children : []
    }
} %}

arg_list_inner -> ( id _ %colon _ ):? assign ( _ %comma _ ( id _ %colon _ ):? assign ):* {% d => {
    ret = {
        parse_type: "arg_list_inner",
        children:   [ {
            key:   d[0] ? d[0][0] : null,
            value: d[1]
        } ]
    }
    if (d[2]) {
        ret.children.push(...d[2].map(v => {
            return {
                key:   v[3] ? v[3][0] : null,
                value: v[4]
            }
        }))
    }
    return ret
} %}

assign -> condition ( _ assign_op _ assign ):? {% d => {
    return {
        parse_type: "assign",
        condition:  d[0],
        assign:     d[1] ? d[1][3] : null
    }
} %}

condition -> expr ( _ %question _ assign _ %colon _ assign ):? {% d => {
    return {
        parse_type:   "condition",
        expr:         d[0],
        assign_true:  d[1] ? d[1][3] : null,
        assign_false: d[1] ? d[1][7] : null
    }
} %}

expr_op -> (  # TODO op order
    math_op
    | comp_op
    | logic_op
    | bit_op
) {% d => d[0][0] %}

math_op -> (
    %plus
    | %dash
    | %star
    | %slash
    | %percent
    | %pow
) {% d => token(d[0][0]) %}

comp_op -> (
    %eq
    | %neq
    | %larrow
    | %lte
    | %rarrow
    | %gte
    | %kw_is
    | %bang %kw_is
) {% d => token(d[0][0]) %}

logic_op -> (
    %and
    | %or
    | %xor
    | %kw_and
    | %kw_or
    | %kw_xor
) {% d => token(d[0][0]) %}

bit_op -> (
    %amp
    | %bar
    | %carrot
    | %lshift
    | %rshift
    | %rlogshift
) {% d => token(d[0][0]) %}

assign_op -> (
    %assign
    | %pluseq
    | %minuseq
    | %timeseq
    | %diveq
    | %oreq
    | %andeq
    | %xoreq
    | %modeq
    | %poweq
    | %lshifteq
    | %rshifteq
    | %rlogshifteq
) {% d => token(d[0][0]) %}

id -> %identifier {% d => token(d[0]) %}

literal -> number   {% id %}
literal -> %string  {% d => { d[0].value = d[0].text.slice(1, -1); return token(d[0]) } %}
literal -> boolean  {% d => { d[0].value = d[0].text === "true";   return token(d[0]) } %}
literal -> %kw_null {% d => { d[0].value = null;                   return token(d[0]) } %}

number -> (
    %num_scientific
    | %num_float
    | %num_hexadecimal
    | %num_octal
    | %num_binary
    | %num_integer
) {% d => token(d[0][0]) %}

boolean -> (
    %kw_false
    | %kw_true
) {% d => token(d[0][0]) %}

_ -> %whitespace:*
