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
DecimalInteger {DecimalNumeral}{IntegerSuffix}?

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
SignedInteger {DecimalNumeral}
Exponent [eE]
ExponentPart {Exponent}{Sign}?{SignedInteger}
DecimalFloating {DecimalNumeral}"\."{Digits}?{ExponentPart}?{FloatSuffix}?|"\."{Digits}{ExponentPart}?{FloatSuffix}?|{DecimalNumeral}{ExponentPart}?{FloatSuffix}?

BinaryExponent [pP]
BinaryExponentPart {BinaryExponent}{Sign}?{SignedInteger}
HexSignificand {HexNumeral}"\."?|0[xX]{HexDigits}?"\."{HexDigits}
HexadecimalFloating {HexSignificand}{BinaryExponentPart}{FloatSuffix}?

OctalEscape "\\"[0-7][0-7]?|"\\"[0-3][0-7][0-7]
EscapeSequence "\\"[bstnfr]|"\\\""|"\\\'"|"\\\\"|{OctalEscape}

StringCharacter {EscapeSequence}|[^"\\""\""]

TextblockCharacter [^"\\"]|[\n\r]|{EscapeSequence}
TextblockWhitespace [ \t\f]

%%

"_"             {yylval.node = createNode(strdup(yytext)); return(UNDERSCORE); }
"abstract"      {yylval.node = createNode(strdup(yytext)); return(ABSTRACT); }
"continue"      {yylval.node = createNode(strdup(yytext)); return(CONTINUE); }
"while"         {yylval.node = createNode(strdup(yytext)); return(WHILE); }
"for"           {yylval.node = createNode(strdup(yytext)); return(FOR); }
"new"           {yylval.node = createNode(strdup(yytext)); return(NEW); }
"switch"        {yylval.node = createNode(strdup(yytext)); return(SWITCH); } 
"assert"        {yylval.node = createNode(strdup(yytext)); return(ASSERT); }
"default"       {yylval.node = createNode(strdup(yytext)); return(DEFAULT); }
"if"            {yylval.node = createNode(strdup(yytext)); return(IF); }
"package"       {yylval.node = createNode(strdup(yytext)); return(PACKAGE); }
"synchronized"  {yylval.node = createNode(strdup(yytext)); return(SYNCHRONIZED); }
"boolean"       {yylval.node = createNode(strdup(yytext)); return(BOOLEAN); }
"do"            {yylval.node = createNode(strdup(yytext)); return(DO); }
"goto"          {yylval.node = createNode(strdup(yytext)); return(GOTO); }
"private"       {yylval.node = createNode(strdup(yytext)); return(PRIVATE); }
"this"          {yylval.node = createNode(strdup(yytext)); return(THIS); }
"break"         {yylval.node = createNode(strdup(yytext)); return(BREAK); }
"double"        {yylval.node = createNode(strdup(yytext)); return(DOUBLE); }
"implements"    {yylval.node = createNode(strdup(yytext)); return(IMPLEMENTS); }
"protected"     {yylval.node = createNode(strdup(yytext)); return(PROTECTED); }
"throw"         {yylval.node = createNode(strdup(yytext)); return(THROW); }
"byte"          {yylval.node = createNode(strdup(yytext)); return(BYTE); }
"else"          {yylval.node = createNode(strdup(yytext)); return(ELSE); }
"import"        {yylval.node = createNode(strdup(yytext)); return(IMPORT); }
"public"         {yylval.node = createNode(strdup(yytext)); return(PUBLIC); }
"throws"           {yylval.node = createNode(strdup(yytext)); return(THROWS); }
"case"           {yylval.node = createNode(strdup(yytext)); return(CASE); }
"enum"           {yylval.node = createNode(strdup(yytext)); return(ENUM); }
"instanceof"           {yylval.node = createNode(strdup(yytext)); return(INSTANCEOF); }
"return"           {yylval.node = createNode(strdup(yytext)); return(RETURN); }
"transient"           {yylval.node = createNode(strdup(yytext)); return(TRANSIENT); }
"catch"           {yylval.node = createNode(strdup(yytext)); return(CATCH); }
"extends"           {yylval.node = createNode(strdup(yytext)); return(EXTENDS); }
"int"           {yylval.node = createNode(strdup(yytext)); return(INT); }
"short"           {yylval.node = createNode(strdup(yytext)); return(SHORT); }
"try"           {yylval.node = createNode(strdup(yytext)); return(TRY); }
"char"           {yylval.node = createNode(strdup(yytext)); return(CHAR); }
"final"           {yylval.node = createNode(strdup(yytext)); return(FINAL); }
"interface"           {yylval.node = createNode(strdup(yytext)); return(INTERFACE); }
"static"           {yylval.node = createNode(strdup(yytext)); return(STATIC); }
"void"           {yylval.node = createNode(strdup(yytext)); return(VOID); }
"class"           {yylval.node = createNode(strdup(yytext)); return(CLASS); }
"finally"           {yylval.node = createNode(strdup(yytext)); return(FINALLY); }
"long"           {yylval.node = createNode(strdup(yytext)); return(LONG); }
"strictfp"           {yylval.node = createNode(strdup(yytext)); return(STRICTFP); }
"volatile"           {yylval.node = createNode(strdup(yytext)); return(VOLATILE); }
"const"           {yylval.node = createNode(strdup(yytext)); return(CONST); }
"float"           {yylval.node = createNode(strdup(yytext)); return(FLOAT); }
"native"           {yylval.node = createNode(strdup(yytext)); return(NATIVE); }
"super"           {yylval.node = createNode(strdup(yytext)); return(SUPER); }
"exports"           {yylval.node = createNode(strdup(yytext)); return(EXPORTS); }
"opens"           {yylval.node = createNode(strdup(yytext)); return(OPENS); }
"requires"           {yylval.node = createNode(strdup(yytext)); return(REQUIRES); }
"uses"           {yylval.node = createNode(strdup(yytext)); return(USES); }
"module"           {yylval.node = createNode(strdup(yytext)); return(MODULE); }
"permits"           {yylval.node = createNode(strdup(yytext)); return(PERMITS); }
"sealed"           {yylval.node = createNode(strdup(yytext)); return(SEALED); }
"var"           {yylval.node = createNode(strdup(yytext)); return(VAR); }
"non-sealed"           {yylval.node = createNode(strdup(yytext)); return(NON_SEALED); }
"provides"           {yylval.node = createNode(strdup(yytext)); return(PROVIDES); }
"to"           {yylval.node = createNode(strdup(yytext)); return(TO); }
"with"           {yylval.node = createNode(strdup(yytext)); return(WITH); }
"open"           {yylval.node = createNode(strdup(yytext)); return(OPEN); }
"record"           {yylval.node = createNode(strdup(yytext)); return(RECORD); }
"transitive"           {yylval.node = createNode(strdup(yytext)); return(TRANSITIVE); }
"yield"           {yylval.node = createNode(strdup(yytext)); return(YIELD); }


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

"="    { yylval.node = createNode(strdup(yytext)); return(ASSIGN); }
">"    { yylval.node = createNode(strdup(yytext)); return(GREATER); }
"<"    { yylval.node = createNode(strdup(yytext)); return(LESSER); }
"!"    { yylval.node = createNode(strdup(yytext)); return(NOT); }
"~"    { yylval.node = createNode(strdup(yytext)); return(TILDE); }
"?"    { yylval.node = createNode(strdup(yytext)); return(QUESTION); }
":"    { yylval.node = createNode(strdup(yytext)); return(COLON); }
"->"    { yylval.node = createNode(strdup(yytext)); return(PTR); }
"=="    { yylval.node = createNode(strdup(yytext)); return(EQUAL); }
">="    { yylval.node = createNode(strdup(yytext)); return(GEQ); }
"<="    { yylval.node = createNode(strdup(yytext)); return(LEQ); }
"!="    { yylval.node = createNode(strdup(yytext)); return(NEQ); }
"&&"    { yylval.node = createNode(strdup(yytext)); return(AND_AND); }
"||"    { yylval.node = createNode(strdup(yytext)); return(OR_OR); }
"++"    { yylval.node = createNode(strdup(yytext)); return(INC); }
"--"    { yylval.node = createNode(strdup(yytext)); return(DEC); }
"+"    { yylval.node = createNode(strdup(yytext)); return(ADD); }
"-"    { yylval.node = createNode(strdup(yytext)); return(SUB); }
"*"    { yylval.node = createNode(strdup(yytext)); return(MUL); }
"/"    { yylval.node = createNode(strdup(yytext)); return(DIV); }
"&"    { yylval.node = createNode(strdup(yytext)); return(AND); }
"|"    { yylval.node = createNode(strdup(yytext)); return(OR); }
"^"    { yylval.node = createNode(strdup(yytext)); return(XOR); }
"%"    { yylval.node = createNode(strdup(yytext)); return(MOD); }
"<<"    { yylval.node = createNode(strdup(yytext)); return(LSHIFT); }
">>"    { yylval.node = createNode(strdup(yytext)); return(RSHIFT); }
">>>"    { yylval.node = createNode(strdup(yytext)); return(URSHIFT); }
"+="    { yylval.node = createNode(strdup(yytext)); return(ADD_ASSIGN); }
"-="    { yylval.node = createNode(strdup(yytext)); return(SUB_ASSIGN); }
"*="    { yylval.node = createNode(strdup(yytext)); return(MUL_ASSIGN); }
"&="    { yylval.node = createNode(strdup(yytext)); return(AND_ASSIGN); }
"/="    { yylval.node = createNode(strdup(yytext)); return(DIV_ASSIGN); }
"|="    { yylval.node = createNode(strdup(yytext)); return(OR_ASSIGN); }
"^="    { yylval.node = createNode(strdup(yytext)); return(XOR_ASSIGN); }
"%="    { yylval.node = createNode(strdup(yytext)); return(MOD_ASSIGN); }
"<<="    { yylval.node = createNode(strdup(yytext)); return(LSHIFT_ASSIGN); }
">>="    { yylval.node = createNode(strdup(yytext)); return(RSHIFT_ASSIGN); }
">>>="    { yylval.node = createNode(strdup(yytext)); return(URSHIFT_ASSIGN); }


"("    { yylval.node = createNode(strdup(yytext)); return(BRACESTART); }
")"    { yylval.node = createNode(strdup(yytext)); return(BRACEEND); }
"{"    { yylval.node = createNode(strdup(yytext)); return(CURLYBRACESTART); }
"}"    { yylval.node = createNode(strdup(yytext)); return(CURLYBRACEEND); }
"["    { yylval.node = createNode(strdup(yytext)); return(SQUAREBRACESTART); }
"]"    { yylval.node = createNode(strdup(yytext)); return(SQUAREBRACEEND); }
";"    { yylval.node = createNode(strdup(yytext)); return(SEMICOLON); }
","    { yylval.node = createNode(strdup(yytext)); return(COMMA); }
"."    { yylval.node = createNode(strdup(yytext)); return(PERIOD); }
"..."    { yylval.node = createNode(strdup(yytext)); return(ELLIPSIS); }
"@"    { yylval.node = createNode(strdup(yytext)); return(AT); }
"::"    { yylval.node = createNode(strdup(yytext)); return(SCOPE); }


{DecimalInteger}   {yylval.node = createNode(strdup(yytext)); return(LITERAL); }
{HexInteger}   {yylval.node = createNode(strdup(yytext)); return(LITERAL); }
{OctalInteger}   {yylval.node = createNode(strdup(yytext)); return(LITERAL); }
{BinaryInteger}   {yylval.node = createNode(strdup(yytext)); return(LITERAL); }
{DecimalFloating}   {yylval.node = createNode(strdup(yytext)); return(LITERAL); }
{HexadecimalFloating}   {yylval.node = createNode(strdup(yytext)); return(LITERAL); }

"true"|"false"   {yylval.node = createNode(strdup(yytext)); return(LITERAL); }
"null"   {yylval.node = createNode(strdup(yytext)); return(LITERAL); }

'{EscapeSequence}'|'[^"\\""\'"']?' {
    yylval.node = createNode(strdup(yytext));
    return (LITERAL);
}

[a-zA-Z][a-zA-Z0-9$_]*|[_$][a-zA-Z0-9_$]+ {
    yylval.node = createNode(strdup(yytext));
    return (IDENTIFIER);
}
[ \t\n\r\f]+ {}

"\""{StringCharacter}*"\"" {
    yylval.node = createNode(strdup(yytext));
    return (LITERAL);
}

"\"\"\""([^\"]|(["\""][^"\""])|(["\""]["\""][^"\""]))*"\"\"\"" {
    yylval.node = createNode(strdup(yytext));
    return (LITERAL);
}

"\""[^\"]*"\"" {
    yylval.node = createNode(strdup(yytext));
    return (LITERAL);
}

. {
    printf("Error: Illegal token Line number:%d\n",yylineno);
}
%%

int yywrap() {return 1;}