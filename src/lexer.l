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

"_"             {yylval.node = createNode("UNDERSCORE"); return(UNDERSCORE); }
"abstract"      {yylval.node = createNode("ABSTRACT"); return(ABSTRACT); }
"continue"      {yylval.node = createNode("CONTINUE"); return(CONTINUE); }
"while"         {yylval.node = createNode("WHILE"); return(WHILE); }
"for"           {yylval.node = createNode("FOR"); return(FOR); }
"new"           {yylval.node = createNode("NEW"); return(NEW); }
"switch"        {yylval.node = createNode("SWITCH"); return(SWITCH); } 
"assert"        {yylval.node = createNode("ASSERT"); return(ASSERT); }
"default"       {yylval.node = createNode("DEFAULT"); return(DEFAULT); }
"if"            {yylval.node = createNode("IF"); return(IF); }
"package"       {yylval.node = createNode("PACKAGE"); return(PACKAGE); }
"synchronized"  {yylval.node = createNode("SYNCHRONIZED"); return(SYNCHRONIZED); }
"boolean"       {yylval.node = createNode("BOOLEAN"); return(BOOLEAN); }
"do"            {yylval.node = createNode("DO"); return(DO); }
"goto"          {yylval.node = createNode("GOTO"); return(GOTO); }
"private"       {yylval.node = createNode("PRIVATE"); return(PRIVATE); }
"this"          {yylval.node = createNode("THIS"); return(THIS); }
"break"         {yylval.node = createNode("BREAK"); return(BREAK); }
"double"        {yylval.node = createNode("DOUBLE"); return(DOUBLE); }
"implements"    {yylval.node = createNode("IMPLEMENTS"); return(IMPLEMENTS); }
"protected"     {yylval.node = createNode("PROTECTED"); return(PROTECTED); }
"throw"         {yylval.node = createNode("THROW"); return(THROW); }
"byte"          {yylval.node = createNode("BYTE"); return(BYTE); }
"else"          {yylval.node = createNode("ELSE"); return(ELSE); }
"import"        {yylval.node = createNode("IMPORT"); return(IMPORT); }
"public"         {yylval.node = createNode("PUBLIC"); return(PUBLIC); }
"throws"           {yylval.node = createNode("THROWS"); return(THROWS); }
"case"           {yylval.node = createNode("CASE"); return(CASE); }
"enum"           {yylval.node = createNode("ENUM"); return(ENUM); }
"instanceof"           {yylval.node = createNode("INSTANCEOF"); return(INSTANCEOF); }
"return"           {yylval.node = createNode("RETURN"); return(RETURN); }
"transient"           {yylval.node = createNode("TRANSIENT"); return(TRANSIENT); }
"catch"           {yylval.node = createNode("CATCH"); return(CATCH); }
"extends"           {yylval.node = createNode("EXTENDS"); return(EXTENDS); }
"int"           {yylval.node = createNode("INT"); return(INT); }
"short"           {yylval.node = createNode("SHORT"); return(SHORT); }
"try"           {yylval.node = createNode("TRY"); return(TRY); }
"char"           {yylval.node = createNode("CHAR"); return(CHAR); }
"final"           {yylval.node = createNode("FINAL"); return(FINAL); }
"interface"           {yylval.node = createNode("INTERFACE"); return(INTERFACE); }
"static"           {yylval.node = createNode("STATIC"); return(STATIC); }
"void"           {yylval.node = createNode("VOID"); return(VOID); }
"class"           {yylval.node = createNode("CLASS"); return(CLASS); }
"finally"           {yylval.node = createNode("FINALLY"); return(FINALLY); }
"long"           {yylval.node = createNode("LONG"); return(LONG); }
"strictfp"           {yylval.node = createNode("STRICTFP"); return(STRICTFP); }
"volatile"           {yylval.node = createNode("VOLATILE"); return(VOLATILE); }
"const"           {yylval.node = createNode("CONST"); return(CONST); }
"float"           {yylval.node = createNode("FLOAT"); return(FLOAT); }
"native"           {yylval.node = createNode("NATIVE"); return(NATIVE); }
"super"           {yylval.node = createNode("SUPER"); return(SUPER); }
"exports"           {yylval.node = createNode("EXPORTS"); return(EXPORTS); }
"opens"           {yylval.node = createNode("OPENS"); return(OPENS); }
"requires"           {yylval.node = createNode("REQUIRES"); return(REQUIRES); }
"uses"           {yylval.node = createNode("USES"); return(USES); }
"module"           {yylval.node = createNode("MODULE"); return(MODULE); }
"permits"           {yylval.node = createNode("PERMITS"); return(PERMITS); }
"sealed"           {yylval.node = createNode("SEALED"); return(SEALED); }
"var"           {yylval.node = createNode("VAR"); return(VAR); }
"non-sealed"           {yylval.node = createNode("NON_SEALED"); return(NON_SEALED); }
"provides"           {yylval.node = createNode("PROVIDES"); return(PROVIDES); }
"to"           {yylval.node = createNode("TO"); return(TO); }
"with"           {yylval.node = createNode("WITH"); return(WITH); }
"open"           {yylval.node = createNode("OPEN"); return(OPEN); }
"record"           {yylval.node = createNode("RECORD"); return(RECORD); }
"transitive"           {yylval.node = createNode("TRANSITIVE"); return(TRANSITIVE); }
"yield"           {yylval.node = createNode("YIELD"); return(YIELD); }



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

"//" {
    int c;
    for( ; ; ){
        while( ( c = yyinput() ) != '\n' && c != EOF ) ;
        if( c == '\n' ) {
            lineno++;
            break;
        }
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


{DecimalInteger}   {yylval.node = createNode(strdup(yytext),"LITERAL"); return(LITERAL); }
{HexInteger}   {yylval.node = createNode(strdup(yytext),"LITERAL"); return(LITERAL); }
{OctalInteger}   {yylval.node = createNode(strdup(yytext),"LITERAL"); return(LITERAL); }
{BinaryInteger}   {yylval.node = createNode(strdup(yytext),"LITERAL"); return(LITERAL); }
{DecimalFloating}   {yylval.node = createNode(strdup(yytext),"LITERAL"); return(LITERAL);}
{HexadecimalFloating}   {yylval.node = createNode(strdup(yytext),"LITERAL"); return(LITERAL); }

"true"|"false"   {yylval.node = createNode(strdup(yytext),"LITERAL"); return(LITERAL); }
"null"   {yylval.node = createNode(strdup(yytext),"LITERAL"); return(LITERAL); }

'{EscapeSequence}'|'[^"\\""\'"']?' {
    yylval.node = createNode(strdup(yytext),"LITERAL"); 
    return (LITERAL);
}

[a-zA-Z][a-zA-Z0-9$_]*|[_$][a-zA-Z0-9_$]+ {
    yylval.node = createNode(strdup(yytext),"IDENTIFIER"); 
    return (IDENTIFIER);
}
[ \t\r\f]+ {}
[\n]    {lineno++;}

 /*
"\""{StringCharacter}*"\"" {
    yylval.node = createNode( strdup(yytext),"LITERAL" ); 
    return (LITERAL);
}
 */

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
            printf("Error: EOF in string.\n");
            return -1;
        }
        if( (c = yyinput()) == '"' ){
            if( (c = yyinput()) == '"' ) break;
            else { 
                if( c == '\n' ){
                    lineno++;
                }
                if( c == EOF ){
                    printf("EOF inside the Text Block at line \n");
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
                printf("EOF inside the Text Block at line \n");
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
            printf("EOF inside the Text Block at line \n");
            return -1;
        }
    }

    yylval.node = createNode( strdup(s.c_str()),"LITERAL"); 
    return (LITERAL);
}

 /* String Character */
"\"" {
    int c; string s = "";
    for( ; ; ){
        while( ( c = yyinput() ) != '"' && c != EOF ){
            if( c == '\n' ){
                printf("Error: Illegal Syntax %d\n", lineno);
                return -1;
            }
            s += c;
        }
        if( c == '"' ) break;
        if( c == EOF ){
            printf("Error: EOF between string %d\n", lineno);
            return -1;
        }
    }
    yylval.node = createNode( strdup(s.c_str()),"LITERAL"); 
    return (LITERAL);
}

 /*
"\""[^\"]*"\"" {
    yylval.node = createNode(strdup(yytext),"LITERAL"); 
    return (LITERAL);
}
 */

. {
    printf("Error: Illegal token Line number:%d\n", lineno);
}
%%

int yywrap() {return 1;}