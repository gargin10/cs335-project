%{
    #include <bits/stdc++.h>
    #include <string>
    int lines=1;
    extern "C" {
        int yyparse();
        int yylex(void);
        int yyerror(char* s)
        {
            printf("ERROR: %s Line Number: %d\n",s,lines);
            return 0;
        }
    }
    using namespace std;

%}
%code requires {
    #include <string>

}
%union {
    char* str;
}
%token<str> COMMA KEYWORD LITERAL OPERATOR SEPARATOR IDENTIFIER CURLYBRACESTART CURLYBRACEEND VAR SEMICOLON BRACESTART ELSE CATCH IF
%token<str> TRY DEFAULT BRACEEND CASE WHILE SWITCH DO FOR BAR COLON RETURN THROW SYNCHRONIZED FINALLY BREAK YIELD CONTINUE DASH GREATER ASSERT

%type<str> Block BlockStatements BlockStatement LocalClassOrInterfaceDeclaration LocalVariableDeclarationStatement LocalVariableDeclaration LocalVariableType
%type<str> Statement StatementNoShortIf StatementWithoutTrailingSubstatement EmptyStatement LabeledStatement LabeledStatementNoShortIf ExpressionStatement StatementExpression
%type<str> IfThenStatement IfThenElseStatement IfThenElseStatementNoShortIf AssertStatement SwitchStatement SwitchBlock SwitchRule SwitchBlockStatementGroup SwitchLabel CaseConstant 
%type<str> WhileStatement WhileStatementNoShortIf DoStatement ForStatement ForStatementNoShortIf BasicForStatement BasicForStatementNoShortIf ForInit ForUpdate 
%type<str> StatementExpressionList EnhancedForStatement EnhancedForStatementNoShortIf BreakStatement YieldStatement ContinueStatement ReturnStatement ThrowStatement
%type<str> SynchronizedStatement TryStatement Catches CatchClause CatchFormalParameter CatchType Finally TryWithResourcesStatement ResourceSpecification 
%type<str> ResourceList Resource Pattern TypePattern SwitchColonLabel0 Expression01 CommaCaseConstant0 Catches01 Finally01 SwitchBlockStatementGroup0
%type<str> SwitchRule0 ForInit01 ForUpdate01 CommaStatExp0 VariableModifier0 BarClassType0 SemicolonResource0

%%
Block:
CURLYBRACESTART BlockStatements CURLYBRACEEND

BlockStatements:
BlockStatement CURLYBRACESTART BlockStatement CURLYBRACEEND

BlockStatement:
    LocalClassOrInterfaceDeclaration
|   LocalVariableDeclarationStatement
|   Statement

LocalClassOrInterfaceDeclaration:
    ClassDeclaration
|   NormalInterfaceDeclaration

LocalVariableDeclarationStatement:
    LocalVariableDeclaration ;

LocalVariableDeclaration:
CURLYBRACESTART VariableModifier CURLYBRACEEND LocalVariableType VariableDeclaratorList

LocalVariableType:
    UnannType
|   VAR

Statement: StatementWithoutTrailingSubstatement
|   LabeledStatement
|   IfThenStatement
|   IfThenElseStatement
|   WhileStatement
|   ForStatement

StatementNoShortIf:
|   StatementWithoutTrailingSubstatement
|   LabeledStatementNoShortIf
|   IfThenElseStatementNoShortIf
|   WhileStatementNoShortIf
|   ForStatementNoShortIf

StatementWithoutTrailingSubstatement:
|   Block
|   EmptyStatement
|   ExpressionStatement
|   AssertStatement
|   SwitchStatement
|   DoStatement
|   BreakStatement
|   ContinueStatement
|   ReturnStatement
|   SynchronizedStatement
|   ThrowStatement
|   TryStatement
|   YieldStatement;

EmptyStatement: SEMICOLON

LabeledStatement:
Identifier COLON Statement

LabeledStatementNoShortIf:
Identifier COLON StatementNoShortIf

ExpressionStatement:
StatementExpression SEMICOLON   

StatementExpression:
Assignment
|   PreIncrementExpression
|   PreDecrementExpression
|   PostIncrementExpression
|   PostDecrementExpression
|   MethodInvocation
|   ClassInstanceCreationExpression

IfThenStatement:
IF BRACESTART Expression BRACEEND Statement

IfThenElseStatement:
IF BRACESTART Expression BRACEEND StatementNoShortIf ELSE Statement

IfThenElseStatementNoShortIf:
IF BRACESTART Expression BRACEEND StatementNoShortIf ELSE StatementNoShortIf

AssertStatement:
    assert Expression SEMICOLON
|   assert Expression COLON Expression SEMICOLON

SwitchStatement:
SWITCH BRACESTART Expression BRACEEND SwitchBlock

SwitchBlock:
    CURLYBRACESTART SwitchRule SwitchRule0 CURLYBRACEEND
|   CURLYBRACESTART SwitchBlockStatementGroup0 SwitchColonLabel0 CURLYBRACEEND

SwitchRule0:
|   SwitchRule SwitchRule0

SwitchBlockStatementGroup0: 
|   SwitchBlockStatementGroup;

SwitchColonLabel0:
| SwitchLabel COLON SwitchColonLabel0

SwitchRule:
    SwitchLabel DASH GREATER Expression SEMICOLON
|   SwitchLabel DASH GREATER Block
|   SwitchLabel DASH GREATER ThrowStatement

SwitchBlockStatementGroup:
SwitchLabel COLON SwitchColonLabel0 BlockStatements

SwitchLabel:
CASE CaseConstant CommaCaseConstant0

CommaCaseConstant0:
|   COMMA CaseConstant CommaCaseConstant0
|   DEFAULT

CaseConstant:
ConditionalExpression

WhileStatement:
WHILE BRACESTART Expression BRACEEND Statement

WhileStatementNoShortIf:
WHILE BRACESTART Expression BRACEEND StatementNoShortIf

DoStatement:
DO Statement WHILE BRACESTART Expression BRACEEND ;

ForStatement:
    BasicForStatement
|   EnhancedForStatement

ForStatementNoShortIf:
    BasicForStatementNoShortIf
|   EnhancedForStatementNoShortIf

BasicForStatement:
FOR BRACESTART ForInit01 SEMICOLON Expression01 SEMICOLON ForUpdate01 BRACEEND Statement

ForInit01:  | ForInit
Expression01: | Expression
ForUpdate01: | ForUpdate

BasicForStatementNoShortIf:
FOR BRACESTART ForInit01 SEMICOLON Expression01 SEMICOLON ForUpdate01 BRACEEND StatementNoShortIf

ForInit:
    StatementExpressionList
|   LocalVariableDeclaration

ForUpdate:
StatementExpressionList

StatementExpressionList:
StatementExpression CommaStatExp0

CommaStatExp0: | COMMA StatementExpression CommaStatExp0

EnhancedForStatement:
FOR BRACESTART LocalVariableDeclaration COLON Expression BRACEEND Statement

EnhancedForStatementNoShortIf:
FOR BRACESTART LocalVariableDeclaration COLON Expression BRACEEND StatementNoShortIf

BreakStatement: BREAK
|   BREAK Identifier SEMICOLON

YieldStatement:
YIELD Expression SEMICOLON

ContinueStatement: CONTINUE
|   CONTINUE Identifier SEMICOLON

ReturnStatement: RETURN
RETURN Expression SEMICOLON

ThrowStatement:
THROW Expression SEMICOLON

SynchronizedStatement:
SYNCHRONIZED BRACESTART Expression BRACEEND Block

TryStatement:
    TRY Block Catches
|   TRY Block Finally
|   TRY Block Catches Finally
|   TryWithResourcesStatement

Catches:
    CatchClause 
|   CatchClause Catches

CatchClause:
CATCH BRACESTART CatchFormalParameter BRACEEND Block

CatchFormalParameter:
VariableModifier0 CatchType VariableDeclaratorId

VariableModifier0: 
|   VariableModifier VariableModifier0

CatchType:
UnannClassType BarClassType0

BarClassType0:
|   BAR ClassType BarClassType0

Finally:
FINALLY Block

TryWithResourcesStatement:
TRY ResourceSpecification Block Catches01 Finally01

Catches01: | Catches
Finally01: | Finally

ResourceSpecification:
BRACESTART ResourceList BRACEEND
|   BRACESTART ResourceList SEMICOLON BRACEEND

ResourceList:
Resource SemicolonResource0

SemicolonResource0: 
|   SEMICOLON Resource

Resource:
    LocalVariableDeclaration
|   VariableAccess

Pattern:
TypePattern

TypePattern:
LocalVariableDeclaration
%%

int main() {
    yyparse();
    return 0;
}