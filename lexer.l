%option yylineno
%{
    #include <string>
    #include "parser.tab.h"
    extern "C" {
        int yylex(void);
    }
%}

COMMENTEND  "*"[\/]
MIDDLE      ([^*]|[\n\r]|(\*+([^*/]|[\n\r])))*
Sign "+"|-

IntegerSuffix [lL]

Underscores [_]+
NonZeroDigit [1-9]
Digit [0]|{NonZeroDigit}
DigitOrUnderscore [_]|{Digit}
DigitAndUnderscores {DigitOrUnderscore}+
Digits {Digit}|{Digit}{DigitAndUnderscores}?{Digit}
DecimalNumeral 0|{NonZeroDigit}{Digits}?|{NonZeroDigit}{Underscores}{Digits}
DecimalInteger {Sign}?{DecimalNumeral}{IntegerSuffix}?

HexDigit [0-9A-Fa-f]
HexDigitOrUnderscore _|{HexDigit}
HexDigitAndUnderscore {HexDigitOrUnderscore}+
HexDigits {HexDigit}|{HexDigit}{HexDigitAndUnderscore}?{HexDigit}
HexNumeral 0[xX]{HexDigits}
HexInteger {HexNumeral}{IntegerSuffix}?

OctalDigit [0-7]
OctalDigitOrUnderscore _|{OctalDigit}
OctalDigitAndUnderscore {OctalDigitOrUnderscore}+
OctalDigits {OctalDigit}|{OctalDigit}{OctalDigitAndUnderscore}?{OctalDigit}
OctalNumeral 0{Underscores}?{OctalDigits}
OctalInteger {OctalNumeral}{IntegerSuffix}?


BinaryDigit [0-1]
BinaryDigitOrUnderscore _|{BinaryDigit}
BinaryDigitAndUnderscore {BinaryDigitOrUnderscore}+
BinaryDigits {BinaryDigit}|{BinaryDigit}{BinaryDigitAndUnderscore}?{BinaryDigit}
BinaryNumeral 0[bB]{BinaryDigits}
BinaryInteger {BinaryNumeral}{IntegerSuffix}?

FloatSuffix [fFdD]
SignedInteger {Sign}?{DecimalNumeral}
Exponent [eE]
ExponentPart {Exponent}{SignedInteger}
DecimalFloating {Sign}?{DecimalNumeral}"\."{Digits}?{ExponentPart}?{FloatSuffix}?|"\."{Digits}{ExponentPart}?{FloatSuffix}?|{Sign}?{DecimalNumeral}{ExponentPart}?{FloatSuffix}?

BinaryExponent [pP]
BinaryExponentPart {BinaryExponent}{SignedInteger}
HexSignificand {HexNumeral}"\."?|0[xX]{HexDigits}?"\."{HexDigits}
HexadecimalFloating {HexSignificand}{BinaryExponentPart}{FloatSuffix}?

OctalEscape "\\"[0-7][0-7]?|"\\"[0-3][0-7][0-7]
EscapeSequence "\\"[bstnfr]|"\\\""|"\\\'"|"\\\\"|{OctalEscape}

StringCharacter {EscapeSequence}|[^"\\""\""]

TextblockCharacter [^"\\"]|[\n\r]|{EscapeSequence}
TextblockWhitespace [ \t\f]

%%
_|abstract|continue|for|new|switch|assert|default|if|package|synchronized|boolean|do|goto|private|this|break|double|implements|protected|throw|byte|else|import|public|throws|case|enum|instanceof|return|transient|catch|extends|int|short|try|char|final|interface|static|void|class|finally|long|strictfp|volatile|const|float|native|super|while {
    return KEYWORD;
}
exports|opens|requires|uses|module|permits|sealed|var|non-sealed|provides|to|with|open|record|transitive|yield {
    return KEYWORD;
}
[\/]{2}[^\n\r]* {
    // printf("Comment: %s\n",yytext);
}
[\/]"*"{MIDDLE}{COMMENTEND} {
    // printf("Comment: %s\n",yytext);
}
=|>|<|!|~|"?"|:|->|==|>=|<=|!=|&&|"||"|"++"|--|"+"|-|"*"|"\/"|&|"|"|^|%|<<|>>|>>>|"+="|-=|"*="|"/="|&=|"|="|^=|%=|<<=|>>=|>>>= { 
    return OPERATOR;
}
"("|")"|"{"|"}"|"["|"]"|";"|","|"."|"..."|"@"|"::" { 
    return yytext;
}

{DecimalInteger}|{HexInteger}|{OctalInteger}|{BinaryInteger}|{DecimalFloating}|{HexadecimalFloating} {
    return LITERAL;
}

true|false|null {
    return LITERAL;
}
'{EscapeSequence}'|'[^"\\""\'"']?' {
    return LITERAL;
}

[a-zA-Z][a-zA-Z0-9$_]*|[_$][a-zA-Z0-9_$]+ {
    return IDENTIFIER;
}
[ \t\n\r\f]+ {}

"\""{StringCharacter}*"\"" {
    return LITERAL;
}

"\"\"\""([^\"]|(["\""][^"\""])|(["\""]["\""][^"\""]))*"\"\"\"" {
    return LITERAL;
}

"\""[^\"]*"\"" {
    return LITERAL;
}

. {
    printf("Error: Illegal token Line number:%d\n",yylineno);
}
%%

int yywrap() {return 1;}