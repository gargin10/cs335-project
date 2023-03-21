%option yylineno
%{
    #include <string>
    #include "parser.tab.h"
    int lineno=1;
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

"_"             {yylval.node = createNode("UNDERSCORE",lineno); return(UNDERSCORE); }
"abstract"      {yylval.node = createNode("ABSTRACT",lineno); return(ABSTRACT); }
"continue"      {yylval.node = createNode("CONTINUE",lineno); return(CONTINUE); }
"while"         {yylval.node = createNode("WHILE",lineno); return(WHILE); }
"for"           {yylval.node = createNode("FOR",lineno); return(FOR); }
"new"           {yylval.node = createNode("NEW",lineno); return(NEW); }
"switch"        {yylval.node = createNode("SWITCH",lineno); return(SWITCH); } 
"assert"        {yylval.node = createNode("ASSERT",lineno); return(ASSERT); }
"default"       {yylval.node = createNode("DEFAULT",lineno); return(DEFAULT); }
"if"            {yylval.node = createNode("IF",lineno); return(IF); }
"package"       {yylval.node = createNode("PACKAGE",lineno); return(PACKAGE); }
"synchronized"  {yylval.node = createNode("SYNCHRONIZED",lineno); return(SYNCHRONIZED); }
"boolean"       {yylval.node = createNode("BOOLEAN",lineno); return(BOOLEAN); }
"do"            {yylval.node = createNode("DO",lineno); return(DO); }
"goto"          {yylval.node = createNode("GOTO",lineno); return(GOTO); }
"private"       {yylval.node = createNode("PRIVATE",lineno); return(PRIVATE); }
"this"          {yylval.node = createNode("THIS",lineno); return(THIS); }
"break"         {yylval.node = createNode("BREAK",lineno); return(BREAK); }
"double"        {yylval.node = createNode("DOUBLE",lineno); return(DOUBLE); }
"implements"    {yylval.node = createNode("IMPLEMENTS",lineno); return(IMPLEMENTS); }
"protected"     {yylval.node = createNode("PROTECTED",lineno); return(PROTECTED); }
"throw"         {yylval.node = createNode("THROW",lineno); return(THROW); }
"byte"          {yylval.node = createNode("BYTE",lineno); return(BYTE); }
"else"          {yylval.node = createNode("ELSE",lineno); return(ELSE); }
"import"        {yylval.node = createNode("IMPORT",lineno); return(IMPORT); }
"public"         {yylval.node = createNode("PUBLIC",lineno); return(PUBLIC); }
"throws"           {yylval.node = createNode("THROWS",lineno); return(THROWS); }
"case"           {yylval.node = createNode("CASE",lineno); return(CASE); }
"enum"           {yylval.node = createNode("ENUM",lineno); return(ENUM); }
"instanceof"           {yylval.node = createNode("INSTANCEOF",lineno); return(INSTANCEOF); }
"return"           {yylval.node = createNode("RETURN",lineno); return(RETURN); }
"transient"           {yylval.node = createNode("TRANSIENT",lineno); return(TRANSIENT); }
"catch"           {yylval.node = createNode("CATCH",lineno); return(CATCH); }
"extends"           {yylval.node = createNode("EXTENDS",lineno); return(EXTENDS); }
"int"           {yylval.node = createNode("INT",lineno); return(INT); }
"short"           {yylval.node = createNode("SHORT",lineno); return(SHORT); }
"try"           {yylval.node = createNode("TRY",lineno); return(TRY); }
"char"           {yylval.node = createNode("CHAR",lineno); return(CHAR); }
"final"           {yylval.node = createNode("FINAL",lineno); return(FINAL); }
"interface"           {yylval.node = createNode("INTERFACE",lineno); return(INTERFACE); }
"static"           {yylval.node = createNode("STATIC",lineno); return(STATIC); }
"void"           {yylval.node = createNode("VOID",lineno); return(VOID); }
"class"           {yylval.node = createNode("CLASS",lineno); return(CLASS); }
"finally"           {yylval.node = createNode("FINALLY",lineno); return(FINALLY); }
"long"           {yylval.node = createNode("LONG",lineno); return(LONG); }
"strictfp"           {yylval.node = createNode("STRICTFP",lineno); return(STRICTFP); }
"volatile"           {yylval.node = createNode("VOLATILE",lineno); return(VOLATILE); }
"const"           {yylval.node = createNode("CONST",lineno); return(CONST); }
"float"           {yylval.node = createNode("FLOAT",lineno); return(FLOAT); }
"native"           {yylval.node = createNode("NATIVE",lineno); return(NATIVE); }
"super"           {yylval.node = createNode("SUPER",lineno); return(SUPER); }
"exports"           {yylval.node = createNode("EXPORTS",lineno); return(EXPORTS); }
"opens"           {yylval.node = createNode("OPENS",lineno); return(OPENS); }
"requires"           {yylval.node = createNode("REQUIRES",lineno); return(REQUIRES); }
"uses"           {yylval.node = createNode("USES",lineno); return(USES); }
"module"           {yylval.node = createNode("MODULE",lineno); return(MODULE); }
"permits"           {yylval.node = createNode("PERMITS",lineno); return(PERMITS); }
"sealed"           {yylval.node = createNode("SEALED",lineno); return(SEALED); }
"var"           {yylval.node = createNode("VAR",lineno); return(VAR); }
"non-sealed"           {yylval.node = createNode("NON_SEALED",lineno); return(NON_SEALED); }
"provides"           {yylval.node = createNode("PROVIDES",lineno); return(PROVIDES); }
"to"           {yylval.node = createNode("TO",lineno); return(TO); }
"with"           {yylval.node = createNode("WITH",lineno); return(WITH); }
"open"           {yylval.node = createNode("OPEN",lineno); return(OPEN); }
"record"           {yylval.node = createNode("RECORD",lineno); return(RECORD); }
"transitive"           {yylval.node = createNode("TRANSITIVE",lineno); return(TRANSITIVE); }
"yield"           {yylval.node = createNode("YIELD",lineno); return(YIELD); }



 /* Comments */
"/*" {
        int c;
        for ( ; ; ){
            while ( (c = yyinput()) != '*' && c != EOF ) 
            {
                if(c == '\n')
                    lineno++;
            };
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

[\/]{2}[^\n\r]* {
    // printf("Comment: %s\n",yytext);
}

"="    { yylval.node = createNode(strdup(yytext),lineno); return(ASSIGN); }
">"    { yylval.node = createNode(strdup(yytext),lineno); return(GREATER); }
"<"    { yylval.node = createNode(strdup(yytext),lineno); return(LESSER); }
"!"    { yylval.node = createNode(strdup(yytext),lineno); return(NOT); }
"~"    { yylval.node = createNode(strdup(yytext),lineno); return(TILDE); }
"?"    { yylval.node = createNode(strdup(yytext),lineno); return(QUESTION); }
":"    { yylval.node = createNode(strdup(yytext),lineno); return(COLON); }
"->"    { yylval.node = createNode(strdup(yytext),lineno); return(PTR); }
"=="    { yylval.node = createNode(strdup(yytext),lineno); return(EQUAL); }
">="    { yylval.node = createNode(strdup(yytext),lineno); return(GEQ); }
"<="    { yylval.node = createNode(strdup(yytext),lineno); return(LEQ); }
"!="    { yylval.node = createNode(strdup(yytext),lineno); return(NEQ); }
"&&"    { yylval.node = createNode(strdup(yytext),lineno); return(AND_AND); }
"||"    { yylval.node = createNode(strdup(yytext),lineno); return(OR_OR); }
"++"    { yylval.node = createNode(strdup(yytext),lineno); return(INC); }
"--"    { yylval.node = createNode(strdup(yytext),lineno); return(DEC); }
"+"    { yylval.node = createNode(strdup(yytext),lineno); return(ADD); }
"-"    { yylval.node = createNode(strdup(yytext),lineno); return(SUB); }
"*"    { yylval.node = createNode(strdup(yytext),lineno); return(MUL); }
"/"    { yylval.node = createNode(strdup(yytext),lineno); return(DIV); }
"&"    { yylval.node = createNode(strdup(yytext),lineno); return(AND); }
"|"    { yylval.node = createNode(strdup(yytext),lineno); return(OR); }
"^"    { yylval.node = createNode(strdup(yytext),lineno); return(XOR); }
"%"    { yylval.node = createNode(strdup(yytext),lineno); return(MOD); }
"<<"    { yylval.node = createNode(strdup(yytext),lineno); return(LSHIFT); }
">>"    { yylval.node = createNode(strdup(yytext),lineno); return(RSHIFT); }
">>>"    { yylval.node = createNode(strdup(yytext),lineno); return(URSHIFT); }
"+="    { yylval.node = createNode(strdup(yytext),lineno); return(ADD_ASSIGN); }
"-="    { yylval.node = createNode(strdup(yytext),lineno); return(SUB_ASSIGN); }
"*="    { yylval.node = createNode(strdup(yytext),lineno); return(MUL_ASSIGN); }
"&="    { yylval.node = createNode(strdup(yytext),lineno); return(AND_ASSIGN); }
"/="    { yylval.node = createNode(strdup(yytext),lineno); return(DIV_ASSIGN); }
"|="    { yylval.node = createNode(strdup(yytext),lineno); return(OR_ASSIGN); }
"^="    { yylval.node = createNode(strdup(yytext),lineno); return(XOR_ASSIGN); }
"%="    { yylval.node = createNode(strdup(yytext),lineno); return(MOD_ASSIGN); }
"<<="    { yylval.node = createNode(strdup(yytext),lineno); return(LSHIFT_ASSIGN); }
">>="    { yylval.node = createNode(strdup(yytext),lineno); return(RSHIFT_ASSIGN); }
">>>="    { yylval.node = createNode(strdup(yytext),lineno); return(URSHIFT_ASSIGN); }


"("    { yylval.node = createNode(strdup(yytext),lineno); return(BRACESTART); }
")"    { yylval.node = createNode(strdup(yytext),lineno); return(BRACEEND); }
"{"    { yylval.node = createNode(strdup(yytext),lineno); return(CURLYBRACESTART); }
"}"    { yylval.node = createNode(strdup(yytext),lineno); return(CURLYBRACEEND); }
"["    { yylval.node = createNode(strdup(yytext),lineno); return(SQUAREBRACESTART); }
"]"    { yylval.node = createNode(strdup(yytext),lineno); return(SQUAREBRACEEND); }
";"    { yylval.node = createNode(strdup(yytext),lineno); return(SEMICOLON); }
","    { yylval.node = createNode(strdup(yytext),lineno); return(COMMA); }
"."    { yylval.node = createNode(strdup(yytext),lineno); return(PERIOD); }
"..."    { yylval.node = createNode(strdup(yytext),lineno); return(ELLIPSIS); }
"@"    { yylval.node = createNode(strdup(yytext),lineno); return(AT); }
"::"    { yylval.node = createNode(strdup(yytext),lineno); return(SCOPE); }


{DecimalInteger}   {yylval.node = createNode(strdup(yytext),"INT_LITERAL",lineno); return(LITERAL); }
{HexInteger}   {yylval.node = createNode(strdup(yytext),"INT_LITERAL",lineno); return(LITERAL); }
{OctalInteger}   {yylval.node = createNode(strdup(yytext),"INT_LITERAL",lineno); return(LITERAL); }
{BinaryInteger}   {yylval.node = createNode(strdup(yytext),"INT_LITERAL",lineno); return(LITERAL); }
{DecimalFloating}   {yylval.node = createNode(strdup(yytext),"FLOAT_LITERAL",lineno); return(LITERAL);}
{HexadecimalFloating}   {yylval.node = createNode(strdup(yytext),"FLOAT_LITERAL",lineno); return(LITERAL); }

"true"|"false"   {yylval.node = createNode(strdup(yytext),"BOOLEAN_LITERAL",lineno); return(LITERAL); }
"null"   {yylval.node = createNode(strdup(yytext),"NULL_LITERAL",lineno); return(LITERAL); }

'{EscapeSequence}'|'[^"\\""\'"']?' {
    yylval.node = createNode(strdup(yytext),"CHAR_LITERAL"); 
    return (LITERAL);
}

[a-zA-Z][a-zA-Z0-9$_]*|[_$][a-zA-Z0-9_$]+ {
    yylval.node = createNode(strdup(yytext),"IDENTIFIER", lineno); 
    return (IDENTIFIER);
}
[ \t\r\f]+ {}
[\n]    {lineno++;}

 /* Text Block String*/
["]["]["] {
    int c; string s = "";
    for( ; ; ){
        while( ( c = yyinput() ) != '"' && c != EOF ){
            if( c == '\n' ){
                lineno++;
            }
            s += c;
        }
        if( c == '\n' ){
            lineno++;
        }
        if( c == EOF ){
            // printf("Error: EOF in string.\n");
            return -1;
        }
        if( (c = yyinput()) == '"' ){
            if( (c = yyinput()) == '"' ) break;
            else { 
                if( c == '\n' ){
                    lineno++;
                }
                if( c == EOF ){
                    // printf("EOF inside the Text Block at line \n");
                    return -1;
                }
                s += '"';
                s += '"';
                s += c;
                continue;
            }
        } else {
            if( c == '\n' ){
                lineno++;
            }
            if( c == EOF ){
                // printf("EOF inside the Text Block at line \n");
                return -1;
            }
            s += '"';
            s += c;
            continue;
        }
        if( c == '\n' ){
            lineno++;
        }
        if( c == EOF ){
            // printf("EOF inside the Text Block at line \n");
            return -1;
        }
    }

    yylval.node = createNode( strdup(s.c_str()),"STRING_LITERAL",lineno); 
    return (LITERAL);
}

 /* String Character */
"\"" {
    int c; string s = "";
    for( ; ; ){
        while( ( c = yyinput() ) != '"' && c != EOF ){
            if( c == '\n' ){
                // printf("Error: Illegal Syntax %d\n", lineno);
                return -1;
            }
            s += c;
        }
        if( c == '"' ) break;
        if( c == EOF ){
             // printf("Error: EOF between string %d\n", lineno);
            return -1;
        }
    }
    yylval.node = createNode( strdup(s.c_str()),"STRING_LITERAL",lineno); 
    return (LITERAL);
}

. {
    printf("Error: Illegal token Line number:%d\n", lineno);
}
%%

int yywrap() {return 1;}