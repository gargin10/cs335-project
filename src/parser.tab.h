/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 23 "parser.y"

    #include <bits/stdc++.h>
    #include "SymbolTable.cpp"
    #include "SymbolEntry.cpp"
    #include "AST.h"

#line 56 "parser.tab.h"

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    UNDERSCORE = 258,              /* UNDERSCORE  */
    PACKAGE = 259,                 /* PACKAGE  */
    GOTO = 260,                    /* GOTO  */
    IMPLEMENTS = 261,              /* IMPLEMENTS  */
    DECIMAL_INTEGER = 262,         /* DECIMAL_INTEGER  */
    HEX_INTEGER = 263,             /* HEX_INTEGER  */
    OCTAL_INTEGER = 264,           /* OCTAL_INTEGER  */
    BINARY_INTEGER = 265,          /* BINARY_INTEGER  */
    DECIMAL_FLOATING = 266,        /* DECIMAL_FLOATING  */
    HEXADECIMAL_FLOATING = 267,    /* HEXADECIMAL_FLOATING  */
    AT = 268,                      /* AT  */
    PROTECTED = 269,               /* PROTECTED  */
    PRIVATE = 270,                 /* PRIVATE  */
    ABSTRACT = 271,                /* ABSTRACT  */
    ELLIPSIS = 272,                /* ELLIPSIS  */
    COMMA = 273,                   /* COMMA  */
    OPERATOR = 274,                /* OPERATOR  */
    SEPARATOR = 275,               /* SEPARATOR  */
    IDENTIFIER = 276,              /* IDENTIFIER  */
    CURLYBRACESTART = 277,         /* CURLYBRACESTART  */
    CURLYBRACEEND = 278,           /* CURLYBRACEEND  */
    VAR = 279,                     /* VAR  */
    SEMICOLON = 280,               /* SEMICOLON  */
    BRACESTART = 281,              /* BRACESTART  */
    ELSE = 282,                    /* ELSE  */
    CATCH = 283,                   /* CATCH  */
    IF = 284,                      /* IF  */
    PERIOD = 285,                  /* PERIOD  */
    QUESTION = 286,                /* QUESTION  */
    AND = 287,                     /* AND  */
    XOR = 288,                     /* XOR  */
    LESSER = 289,                  /* LESSER  */
    THIS = 290,                    /* THIS  */
    CLASS = 291,                   /* CLASS  */
    BOOLEAN = 292,                 /* BOOLEAN  */
    VOID = 293,                    /* VOID  */
    NEW = 294,                     /* NEW  */
    EQUAL = 295,                   /* EQUAL  */
    LITERAL = 296,                 /* LITERAL  */
    INSTANCEOF = 297,              /* INSTANCEOF  */
    BYTE = 298,                    /* BYTE  */
    SHORT = 299,                   /* SHORT  */
    INT = 300,                     /* INT  */
    LONG = 301,                    /* LONG  */
    CHAR = 302,                    /* CHAR  */
    FLOAT = 303,                   /* FLOAT  */
    DOUBLE = 304,                  /* DOUBLE  */
    DEC = 305,                     /* DEC  */
    INC = 306,                     /* INC  */
    NOT = 307,                     /* NOT  */
    TILDE = 308,                   /* TILDE  */
    ADD = 309,                     /* ADD  */
    SUB = 310,                     /* SUB  */
    MUL = 311,                     /* MUL  */
    DIV = 312,                     /* DIV  */
    MOD = 313,                     /* MOD  */
    LSHIFT = 314,                  /* LSHIFT  */
    RSHIFT = 315,                  /* RSHIFT  */
    URSHIFT = 316,                 /* URSHIFT  */
    LSHIFT_ASSIGN = 317,           /* LSHIFT_ASSIGN  */
    RSHIFT_ASSIGN = 318,           /* RSHIFT_ASSIGN  */
    NEQ = 319,                     /* NEQ  */
    EQ = 320,                      /* EQ  */
    ASSIGN = 321,                  /* ASSIGN  */
    MUL_ASSIGN = 322,              /* MUL_ASSIGN  */
    DIV_ASSIGN = 323,              /* DIV_ASSIGN  */
    MOD_ASSIGN = 324,              /* MOD_ASSIGN  */
    ADD_ASSIGN = 325,              /* ADD_ASSIGN  */
    SUB_ASSIGN = 326,              /* SUB_ASSIGN  */
    LEQ = 327,                     /* LEQ  */
    GEQ = 328,                     /* GEQ  */
    URSHIFT_ASSIGN = 329,          /* URSHIFT_ASSIGN  */
    AND_ASSIGN = 330,              /* AND_ASSIGN  */
    XOR_ASSIGN = 331,              /* XOR_ASSIGN  */
    OR_ASSIGN = 332,               /* OR_ASSIGN  */
    SCOPE = 333,                   /* SCOPE  */
    EXTENDS = 334,                 /* EXTENDS  */
    TRY = 335,                     /* TRY  */
    DEFAULT = 336,                 /* DEFAULT  */
    BRACEEND = 337,                /* BRACEEND  */
    WHILE = 338,                   /* WHILE  */
    SWITCH = 339,                  /* SWITCH  */
    DO = 340,                      /* DO  */
    FOR = 341,                     /* FOR  */
    OR = 342,                      /* OR  */
    COLON = 343,                   /* COLON  */
    RETURN = 344,                  /* RETURN  */
    THROW = 345,                   /* THROW  */
    SYNCHRONIZED = 346,            /* SYNCHRONIZED  */
    FINALLY = 347,                 /* FINALLY  */
    BREAK = 348,                   /* BREAK  */
    CONTINUE = 349,                /* CONTINUE  */
    PTR = 350,                     /* PTR  */
    GREATER = 351,                 /* GREATER  */
    ASSERT = 352,                  /* ASSERT  */
    SQUAREBRACESTART = 353,        /* SQUAREBRACESTART  */
    SQUAREBRACEEND = 354,          /* SQUAREBRACEEND  */
    AND_AND = 355,                 /* AND_AND  */
    OR_OR = 356,                   /* OR_OR  */
    YIELD = 357,                   /* YIELD  */
    TRANSITIVE = 358,              /* TRANSITIVE  */
    RECORD = 359,                  /* RECORD  */
    OPEN = 360,                    /* OPEN  */
    WITH = 361,                    /* WITH  */
    TO = 362,                      /* TO  */
    PROVIDES = 363,                /* PROVIDES  */
    NON_SEALED = 364,              /* NON_SEALED  */
    SEALED = 365,                  /* SEALED  */
    PERMITS = 366,                 /* PERMITS  */
    MODULE = 367,                  /* MODULE  */
    USES = 368,                    /* USES  */
    REQUIRES = 369,                /* REQUIRES  */
    OPENS = 370,                   /* OPENS  */
    EXPORTS = 371,                 /* EXPORTS  */
    SUPER = 372,                   /* SUPER  */
    NATIVE = 373,                  /* NATIVE  */
    CONST = 374,                   /* CONST  */
    VOLATILE = 375,                /* VOLATILE  */
    STRICTFP = 376,                /* STRICTFP  */
    STATIC = 377,                  /* STATIC  */
    INTERFACE = 378,               /* INTERFACE  */
    FINAL = 379,                   /* FINAL  */
    TRANSIENT = 380,               /* TRANSIENT  */
    ENUM = 381,                    /* ENUM  */
    CASE = 382,                    /* CASE  */
    THROWS = 383,                  /* THROWS  */
    PUBLIC = 384,                  /* PUBLIC  */
    IMPORT = 385                   /* IMPORT  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 30 "parser.y"

    Node* node;
    char* val;

#line 208 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
