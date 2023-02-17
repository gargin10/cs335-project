%option yylineno
%{
    #include <string>
    #include "parser.tab.h"
    extern "C" {
        int yylex(void);
    }
%}

Sign "+"|"-"

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

"_"             {yylval.str = strdup(yytext); return(UNDERSCORE); }
"abstract"      {yylval.str = strdup(yytext); return(ABSTRACT); }
"continue"      {yylval.str = strdup(yytext); return(CONTINUE); }
"while"         {yylval.str = strdup(yytext); return(WHILE); }
"for"           {yylval.str = strdup(yytext); return(FOR); }
"new"           {yylval.str = strdup(yytext); return(NEW); }
"switch"        {yylval.str = strdup(yytext); return(SWITCH); } 
"assert"        {yylval.str = strdup(yytext); return(ASSERT); }
"default"       {yylval.str = strdup(yytext); return(DEFAULT); }
"if"            {yylval.str = strdup(yytext); return(IF); }
"package"       {yylval.str = strdup(yytext); return(PACKAGE); }
"synchronized"  {yylval.str = strdup(yytext); return(SYNCHRONIZED); }
"boolean"       {yylval.str = strdup(yytext); return(BOOLEAN); }
"do"            {yylval.str = strdup(yytext); return(DO); }
"goto"          {yylval.str = strdup(yytext); return(GOTO); }
"private"       {yylval.str = strdup(yytext); return(PRIVATE); }
"this"          {yylval.str = strdup(yytext); return(THIS); }
"break"         {yylval.str = strdup(yytext); return(BREAK); }
"double"        {yylval.str = strdup(yytext); return(DOUBLE); }
"implements"    {yylval.str = strdup(yytext); return(IMPLEMENTS); }
"protected"     {yylval.str = strdup(yytext); return(PROTECTED); }
"throw"         {yylval.str = strdup(yytext); return(THROW); }
"byte"          {yylval.str = strdup(yytext); return(BYTE); }
"else"          {yylval.str = strdup(yytext); return(ELSE); }
"import"        {yylval.str = strdup(yytext); return(IMPORT); }
"public"         {yylval.str = strdup(yytext); return(PUBLIC); }
"throws"           {yylval.str = strdup(yytext); return(THROWS); }
"case"           {yylval.str = strdup(yytext); return(CASE); }
"enum"           {yylval.str = strdup(yytext); return(ENUM); }
"instanceof"           {yylval.str = strdup(yytext); return(INSTANCEOF); }
"return"           {yylval.str = strdup(yytext); return(RETURN); }
"transient"           {yylval.str = strdup(yytext); return(TRANSIENT); }
"catch"           {yylval.str = strdup(yytext); return(CATCH); }
"extends"           {yylval.str = strdup(yytext); return(EXTENDS); }
"int"           {yylval.str = strdup(yytext); return(INT); }
"short"           {yylval.str = strdup(yytext); return(SHORT); }
"try"           {yylval.str = strdup(yytext); return(TRY); }
"char"           {yylval.str = strdup(yytext); return(CHAR); }
"final"           {yylval.str = strdup(yytext); return(FINAL); }
"interface"           {yylval.str = strdup(yytext); return(INTERFACE); }
"static"           {yylval.str = strdup(yytext); return(STATIC); }
"void"           {yylval.str = strdup(yytext); return(VOID); }
"class"           {yylval.str = strdup(yytext); return(CLASS); }
"finally"           {yylval.str = strdup(yytext); return(FINALLY); }
"long"           {yylval.str = strdup(yytext); return(LONG); }
"strictfp"           {yylval.str = strdup(yytext); return(STRICTFP); }
"volatile"           {yylval.str = strdup(yytext); return(VOLATILE); }
"const"           {yylval.str = strdup(yytext); return(CONST); }
"float"           {yylval.str = strdup(yytext); return(FLOAT); }
"native"           {yylval.str = strdup(yytext); return(NATIVE); }
"super"           {yylval.str = strdup(yytext); return(SUPER); }
"exports"           {yylval.str = strdup(yytext); return(EXPORTS); }
"opens"           {yylval.str = strdup(yytext); return(OPENS); }
"requires"           {yylval.str = strdup(yytext); return(REQUIRES); }
"uses"           {yylval.str = strdup(yytext); return(USES); }
"module"           {yylval.str = strdup(yytext); return(MODULE); }
"permits"           {yylval.str = strdup(yytext); return(PERMITS); }
"sealed"           {yylval.str = strdup(yytext); return(SEALED); }
"var"           {yylval.str = strdup(yytext); return(VAR); }
"non-sealed"           {yylval.str = strdup(yytext); return(NON_SEALED); }
"provides"           {yylval.str = strdup(yytext); return(PROVIDES); }
"to"           {yylval.str = strdup(yytext); return(TO); }
"with"           {yylval.str = strdup(yytext); return(WITH); }
"open"           {yylval.str = strdup(yytext); return(OPEN); }
"record"           {yylval.str = strdup(yytext); return(RECORD); }
"transitive"           {yylval.str = strdup(yytext); return(TRANSITIVE); }
"yield"           {yylval.str = strdup(yytext); return(YIELD); }


 /* Comments */
"/*" {
        int c;
        for ( ; ; ){
            while ( (c = yyinput()) != '*' && c != EOF ) ;
            if ( c == '*' ){
                while( (c = yyinput()) == '*' ) ;
                if ( c == '/' ) break;
            }
            if ( c == EOF ){
                printf("EOF between Comments");
                break;
            }
        }
     }

"//" {
    int c;
    for( ; ; ){
        while( ( c = yyinput() ) != '\n' && c != EOF ) ;
        if( c == '\n' ) break;
        if( c == EOF )
         printf("EOF between Comments");
    }
}

"="    { yylval.str = strdup(yytext); return(ASSIGN); }
">"    { yylval.str = strdup(yytext); return(GREATER); }
"<"    { yylval.str = strdup(yytext); return(LESSER); }
"!"    { yylval.str = strdup(yytext); return(NOT); }
"~"    { yylval.str = strdup(yytext); return(TILDE); }
"?"    { yylval.str = strdup(yytext); return(QUESTION); }
":"    { yylval.str = strdup(yytext); return(COLON); }
"->"    { yylval.str = strdup(yytext); return(PTR); }
"=="    { yylval.str = strdup(yytext); return(EQUAL); }
">="    { yylval.str = strdup(yytext); return(GEQ); }
"<="    { yylval.str = strdup(yytext); return(LEQ); }
"!="    { yylval.str = strdup(yytext); return(NEQ); }
"&&"    { yylval.str = strdup(yytext); return(AND_AND); }
"||"    { yylval.str = strdup(yytext); return(OR_OR); }
"++"    { yylval.str = strdup(yytext); return(INC); }
"--"    { yylval.str = strdup(yytext); return(DEC); }
"+"    { yylval.str = strdup(yytext); return(ADD); }
"-"    { yylval.str = strdup(yytext); return(SUB); }
"*"    { yylval.str = strdup(yytext); return(MUL); }
"/"    { yylval.str = strdup(yytext); return(DIV); }
"&"    { yylval.str = strdup(yytext); return(AND); }
"|"    { yylval.str = strdup(yytext); return(OR); }
"^"    { yylval.str = strdup(yytext); return(XOR); }
"%"    { yylval.str = strdup(yytext); return(MOD); }
"<<"    { yylval.str = strdup(yytext); return(LSHIFT); }
">>"    { yylval.str = strdup(yytext); return(RSHIFT); }
">>>"    { yylval.str = strdup(yytext); return(URSHIFT); }
"+="    { yylval.str = strdup(yytext); return(ADD_ASSIGN); }
"-="    { yylval.str = strdup(yytext); return(SUB_ASSIGN); }
"*="    { yylval.str = strdup(yytext); return(MUL_ASSIGN); }
"&="    { yylval.str = strdup(yytext); return(AND_ASSIGN); }
"/="    { yylval.str = strdup(yytext); return(DIV_ASSIGN); }
"|="    { yylval.str = strdup(yytext); return(OR_ASSIGN); }
"^="    { yylval.str = strdup(yytext); return(XOR_ASSIGN); }
"%="    { yylval.str = strdup(yytext); return(MOD_ASSIGN); }
"<<="    { yylval.str = strdup(yytext); return(LSHIFT_ASSIGN); }
">>="    { yylval.str = strdup(yytext); return(RSHIFT_ASSIGN); }
">>>="    { yylval.str = strdup(yytext); return(URSHIFT_ASSIGN); }


"("    { yylval.str = strdup(yytext); return(BRACESTART); }
")"    { yylval.str = strdup(yytext); return(BRACEEND); }
"{"    { yylval.str = strdup(yytext); return(CURLYBRACESTART); }
"}"    { yylval.str = strdup(yytext); return(CURLYBRACEEND); }
"["    { yylval.str = strdup(yytext); return(SQUAREBRACESTART); }
"]"    { yylval.str = strdup(yytext); return(SQUAREBRACEEND); }
";"    { yylval.str = strdup(yytext); return(SEMICOLON); }
","    { yylval.str = strdup(yytext); return(COMMA); }
"."    { yylval.str = strdup(yytext); return(PERIOD); }
"..."    { yylval.str = strdup(yytext); return(ELLIPSIS); }
"@"    { yylval.str = strdup(yytext); return(AT); }
"::"    { yylval.str = strdup(yytext); return(SCOPE); }


{DecimalInteger}   {yylval.str = strdup(yytext); return(LITERAL); }
{HexInteger}   {yylval.str = strdup(yytext); return(LITERAL); }
{OctalInteger}   {yylval.str = strdup(yytext); return(LITERAL); }
{BinaryInteger}   {yylval.str = strdup(yytext); return(LITERAL); }
{DecimalFloating}   {yylval.str = strdup(yytext); return(LITERAL); }
{HexadecimalFloating}   {yylval.str = strdup(yytext); return(LITERAL); }

"true"|"false"   {yylval.str = strdup(yytext); return(LITERAL); }
"null"   {yylval.str = strdup(yytext); return(NULL); }

'{EscapeSequence}'|'[^"\\""\'"']?' {
    yylval.str = strdup(yytext);
    return (LITERAL);
}

[a-zA-Z][a-zA-Z0-9$_]*|[_$][a-zA-Z0-9_$]+ {
    yylval.str = strdup(yytext);
    return (IDENTIFIER);
}
[ \t\n\r\f]+ {}

"\""{StringCharacter}*"\"" {
    yylval.str = strdup(yytext);
    return (LITERAL);
}

"\"\"\""([^\"]|(["\""][^"\""])|(["\""]["\""][^"\""]))*"\"\"\"" {
    yylval.str = strdup(yytext);
    return (LITERAL);
}

"\""[^\"]*"\"" {
    yylval.str = strdup(yytext);
    return (LITERAL);
}

. {
    printf("Error: Illegal token Line number:%d\n",yylineno);
}
%%

int yywrap() {return 1;}