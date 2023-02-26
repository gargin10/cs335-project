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
%token<str> UNDERSCORE PACKAGE GOTO IMPLEMENTS DECIMAL_INTEGER HEX_INTEGER OCTAL_INTEGER BINARY_INTEGER DECIMAL_FLOATING HEXADECIMAL_FLOATING
%token<str> AT PROTECTED PRIVATE ABSTRACT ELLIPSIS COMMA  OPERATOR SEPARATOR IDENTIFIER CURLYBRACESTART CURLYBRACEEND VAR SEMICOLON BRACESTART ELSE CATCH IF PERIOD 
%token<str> QUESTION AND XOR LESSER THIS CLASS BOOLEAN VOID NEW EQUAL LITERAL
%token<str> INSTANCEOF BYTE SHORT INT LONG CHAR FLOAT DOUBLE DEC INC NOT TILDE ADD SUB MUL DIV MOD LSHIFT RSHIFT URSHIFT LSHIFT_ASSIGN RSHIFT_ASSIGN NEQ EQ ASSIGN
%token<str> MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN LEQ GEQ URSHIFT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN SCOPE EXTENDS
%token<str> TRY DEFAULT BRACEEND WHILE SWITCH DO FOR OR COLON RETURN THROW SYNCHRONIZED FINALLY BREAK CONTINUE PTR GREATER ASSERT SQUAREBRACESTART SQUAREBRACEEND AND_AND OR_OR

%token<str> YIELD TRANSITIVE RECORD OPEN WITH TO PROVIDES NON_SEALED SEALED PERMITS MODULE USES REQUIRES OPENS EXPORTS SUPER NATIVE CONST VOLATILE STRICTFP STATIC INTERFACE FINAL TRANSIENT ENUM CASE THROWS PUBLIC IMPORT

%type<str> Block BlockStatements BlockStatement LocalClassOrInterfaceDeclaration LocalVariableDeclarationStatement LocalVariableDeclaration LocalVariableType
%type<str> Statement StatementNoShortIf StatementWithoutTrailingSubstatement EmptyStatement LabeledStatement LabeledStatementNoShortIf ExpressionStatement StatementExpression
%type<str> IfThenStatement IfThenElseStatement IfThenElseStatementNoShortIf AssertStatement SwitchStatement SwitchBlock SwitchRule SwitchBlockStatementGroup SwitchLabel CaseConstant 
%type<str> WhileStatement WhileStatementNoShortIf DoStatement ForStatement ForStatementNoShortIf BasicForStatement BasicForStatementNoShortIf ForInit ForUpdate 
%type<str> StatementExpressionList EnhancedForStatement EnhancedForStatementNoShortIf BreakStatement YieldStatement ContinueStatement ReturnStatement ThrowStatement
%type<str> SynchronizedStatement TryStatement Catches CatchClause CatchFormalParameter CatchType Finally TryWithResourcesStatement ResourceSpecification 
%type<str> ResourceList Resource Pattern TypePattern SwitchColonLabel0 CommaCaseConstant0  SwitchBlockStatementGroup0
%type<str> SwitchRule0  CommaStatExp0 BarClassType0 SemicolonResource0 VariableModifier0 classmethod Classdec

%type<str> NormalClassDeclaration EnumDeclaration TypeIdentifier ClassBody TypeParameters ClassExtends  ClassPermits ClassModifier RecordComponent VariableArityRecordComponent RecordComponentModifier
%type<str> Annotation TypeParameterList TypeNames TypeName ClassBodyDeclaration ClassMemberDeclaration InstanceInitializer  RecordBodyDeclaration CompactConstructorDeclaration
%type<str> StaticInitializer ConstructorDeclaration FieldDeclaration MethodDeclaration ClassDeclaration  UnannType VariableDeclaratorList VariableDeclarator  EnumConstantList EnumBodyDeclarations ReceiverParameter
%type<str> VariableDeclaratorId VariableInitializer UnannPrimitiveType UnannReferenceType UnannArrayType UnannClassType 
%type<str> MethodHeader MethodBody Result MethodDeclarator Throws FormalParameterList ConstructorDeclarator ConstructorBody ConstructorModifier SimpleTypeName ExplicitConstructorInvocation ExpressionName Primary ArgumentList
%type<str> FormalParameter VariableArityParameter VariableModifier ExceptionTypeList ExceptionType EnumConstant EnumConstantModifier RecordDeclaration RecordHeader RecordBody RecordComponentList EnumBody

%type<str> ClassModifier0 ClassBodyDeclaration0 FieldModifier0 Annotation0 MethodModifier0 
%type<str> RecordComponentModifier0 RecordBodyDeclaration0 

%type<str> MethodInvocation CommaExpression0 MethodReference ArrayCreationExpression
%type<str> DimExprs DimExpr Expression LambdaExpression LambdaParameters LambdaParameterList CommaLambdaParameter0 CommaIdentifier0 LambdaParameter
%type<str> LambdaParameterType LambdaBody AssignmentExpression Assignment AssignmentOperator ConditionalExpression ConditionalOrExpression ConditionalAndExpression InclusiveOrExpression
%type<str> ExclusiveOrExpression AndExpression EqualityExpression RelationalExpression InstanceofExpression ShiftExpression AdditiveExpression MultiplicativeExpression UnaryExpression
%type<str> PreIncrementExpression PreDecrementExpression UnaryExpressionNotPlusMinus PostfixExpression PostIncrementExpression PostDecrementExpression CastExpression SwitchExpression
%type<str> ArrayInitializer VariableInitializerList CommaVariableInitializer0 PrimitiveType NumericType IntegralType FloatingPointType
%type<str> ReferenceType  ClassType ArrayType Dims TypeParameter TypeParameterModifier0 TypeParameterModifier TypeBound
%type<str> TypeArguments TypeArgumentList CommaTypeArgument0 TypeArgument WildcardBounds
%type<str> MethodName LeftHandSide SquareBracePeriod StaticFinal0 fieldclassmethod
%type<str> PrimaryNoNewArray ClassLiteral SquareBrace0 ClassInstanceCreationExpression UnqualifiedClassInstanceCreationExpression 

%type<str> MarkerAnnotation SingleElementAnnotation CompilationUnit OrdinaryCompilationUnit TopLevelClassOrInterfaceDeclaration DotAnnotation0
%type<str> UnannClassOrInterfaceType FieldModifier MethodModifier EnumConstantModifier0 FieldAccess ArrayAccess ClassOrInterfaceType UnqualifiedMethodIdentifier
%type<str> VariableAccess NormalAnnotation Wildcard ContextualExceptYield ContextualExceptPRS MethodNameBrace CommaElementvalue0

%%

CompilationUnit:
|   OrdinaryCompilationUnit

OrdinaryCompilationUnit: 
    TopLevelClassOrInterfaceDeclaration
|   TopLevelClassOrInterfaceDeclaration OrdinaryCompilationUnit

TopLevelClassOrInterfaceDeclaration:
    ClassDeclaration
|   StaticFinal0 Classdec
|   ABSTRACT Classdec
|   SEMICOLON

ClassDeclaration:
    NormalClassDeclaration
|   EnumDeclaration
|   RecordDeclaration

NormalClassDeclaration:
    CLASS TypeIdentifier ClassBody
|   CLASS TypeIdentifier ClassPermits ClassBody
|   CLASS TypeIdentifier ClassExtends ClassBody
|   CLASS TypeIdentifier ClassExtends ClassPermits ClassBody
|   CLASS TypeIdentifier TypeParameters ClassBody
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassBody
|   CLASS TypeIdentifier TypeParameters ClassPermits ClassBody
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassPermits ClassBody
|   ClassModifier0 CLASS TypeIdentifier ClassBody
|   ClassModifier0 CLASS TypeIdentifier ClassPermits ClassBody
|   ClassModifier0 CLASS TypeIdentifier ClassExtends ClassBody
|   ClassModifier0 CLASS TypeIdentifier ClassExtends ClassPermits ClassBody
|   ClassModifier0 CLASS TypeIdentifier TypeParameters ClassBody
|   ClassModifier0 CLASS TypeIdentifier TypeParameters ClassExtends ClassBody
|   ClassModifier0 CLASS TypeIdentifier TypeParameters ClassPermits ClassBody
|   ClassModifier0 CLASS TypeIdentifier TypeParameters ClassExtends ClassPermits ClassBody

Classdec:
    CLASS TypeIdentifier ClassBody
|   CLASS TypeIdentifier ClassPermits ClassBody
|   CLASS TypeIdentifier ClassExtends ClassBody
|   CLASS TypeIdentifier ClassExtends ClassPermits ClassBody
|   CLASS TypeIdentifier TypeParameters ClassBody
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassBody
|   CLASS TypeIdentifier TypeParameters ClassPermits ClassBody
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassPermits ClassBody

ClassModifier0:
    ClassModifier
|   ConstructorModifier
|   ClassModifier ConstructorModifier
|   ConstructorModifier ClassModifier

StaticFinal0:
    STATIC
|   FINAL
|   STATIC StaticFinal0
|   FINAL StaticFinal0

ClassModifier:
    SEALED 
|   NON_SEALED 
|   STRICTFP

TypeParameters:
    LESSER TypeParameterList LESSER

TypeParameterList:
    TypeParameter 
|   TypeParameterList COMMA TypeParameter

ClassExtends:
    EXTENDS ClassType

ClassPermits:
    PERMITS TypeNames

TypeNames:
    TypeName
|   TypeNames COMMA TypeName

ClassBody:
    CURLYBRACESTART CURLYBRACEEND
|   CURLYBRACESTART ClassBodyDeclaration0 CURLYBRACEEND

ClassBodyDeclaration0: 
    ClassBodyDeclaration
|   ClassBodyDeclaration0 ClassBodyDeclaration

ClassBodyDeclaration:
    ClassMemberDeclaration
|   InstanceInitializer
|   StaticInitializer
|   ConstructorDeclaration

ClassMemberDeclaration:
    FieldDeclaration
|   MethodDeclaration
|   ClassDeclaration
|   StaticFinal0 fieldclassmethod
|   StaticFinal0 ConstructorModifier
|   ABSTRACT classmethod
|   ConstructorModifier ABSTRACT classmethod
|   ConstructorModifier StaticFinal0 fieldclassmethod
|   SEMICOLON

classmethod:
    MethodHeader MethodBody
|   UnannType MethodDeclarator
|   UnannType MethodDeclarator Throws
|   CLASS TypeIdentifier ClassBody
|   CLASS TypeIdentifier ClassPermits ClassBody
|   CLASS TypeIdentifier ClassExtends ClassBody
|   CLASS TypeIdentifier ClassExtends ClassPermits ClassBody
|   CLASS TypeIdentifier TypeParameters ClassBody
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassBody
|   CLASS TypeIdentifier TypeParameters ClassPermits ClassBody
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassPermits ClassBody

fieldclassmethod:
    UnannType VariableDeclaratorList SEMICOLON
|   classmethod

FieldDeclaration:
    UnannType VariableDeclaratorList SEMICOLON
|   FieldModifier0 UnannType VariableDeclaratorList SEMICOLON
|   ConstructorModifier UnannType VariableDeclaratorList SEMICOLON
|   ConstructorModifier FieldModifier UnannType VariableDeclaratorList SEMICOLON

FieldModifier0: 
    FieldModifier
|   FieldModifier ConstructorModifier

FieldModifier:
    TRANSIENT
|   VOLATILE

MethodModifier:
    ABSTRACT
|   SYNCHRONIZED 
|   NATIVE 
|   STRICTFP

MethodDeclaration:
    MethodHeader MethodBody
|   UnannType MethodDeclarator Throws
|   UnannType MethodDeclarator
|   MethodModifier0 MethodHeader MethodBody
|   ConstructorModifier MethodHeader MethodBody
|   ConstructorModifier MethodModifier MethodHeader MethodBody
|   MethodModifier0 UnannType MethodDeclarator Throws MethodBody
|   ConstructorModifier UnannType MethodDeclarator Throws MethodBody
|   ConstructorModifier MethodModifier UnannType MethodDeclarator Throws MethodBody
|   MethodModifier0 UnannType MethodDeclarator MethodBody
|   ConstructorModifier UnannType MethodDeclarator MethodBody
|   ConstructorModifier MethodModifier UnannType MethodDeclarator MethodBody


MethodModifier0: 
    MethodModifier
|   MethodModifier ConstructorModifier

VariableDeclaratorList:
    VariableDeclarator
|   VariableDeclaratorList COMMA VariableDeclarator

VariableDeclarator:
    VariableDeclaratorId 
|   VariableDeclaratorId ASSIGN VariableInitializer

VariableDeclaratorId:
    IDENTIFIER
|   IDENTIFIER Dims

VariableInitializer:
    Expression
|   ArrayInitializer

UnannType:
    UnannPrimitiveType
|   UnannReferenceType

UnannPrimitiveType:
    NumericType
|   BOOLEAN

UnannReferenceType:
    UnannClassOrInterfaceType
|   TypeIdentifier
|   UnannArrayType

UnannClassOrInterfaceType:
    UnannClassType

UnannClassType:
    TypeIdentifier
|   TypeIdentifier TypeArguments
|   UnannClassOrInterfaceType PERIOD TypeIdentifier
|   UnannClassOrInterfaceType PERIOD Annotation0 TypeIdentifier
|   UnannClassOrInterfaceType PERIOD TypeIdentifier TypeArguments
|   UnannClassOrInterfaceType PERIOD Annotation0 TypeIdentifier TypeArguments

UnannArrayType:
    UnannPrimitiveType Dims
|   UnannClassOrInterfaceType Dims




MethodHeader:
    VOID MethodDeclarator 
|   TypeParameters Result MethodDeclarator
|   TypeParameters Annotation0 Result MethodDeclarator
|   VOID MethodDeclarator Throws
|   TypeParameters Result MethodDeclarator Throws
|   TypeParameters Annotation0 Result MethodDeclarator Throws


Result:
    UnannType
|   VOID

MethodDeclarator:
    IDENTIFIER BRACESTART BRACEEND
|   IDENTIFIER BRACESTART FormalParameterList BRACEEND
|   IDENTIFIER BRACESTART ReceiverParameter COMMA BRACEEND
|   IDENTIFIER BRACESTART ReceiverParameter COMMA FormalParameterList BRACEEND 
|   IDENTIFIER BRACESTART BRACEEND Dims
|   IDENTIFIER BRACESTART FormalParameterList BRACEEND Dims
|   IDENTIFIER BRACESTART ReceiverParameter COMMA BRACEEND Dims
|   IDENTIFIER BRACESTART ReceiverParameter COMMA FormalParameterList BRACEEND Dims

ReceiverParameter:
    UnannType THIS
|   Annotation0 UnannType THIS
|   UnannType IDENTIFIER PERIOD THIS
|   Annotation0 UnannType IDENTIFIER PERIOD THIS

FormalParameterList:
    FormalParameter
|   FormalParameterList COMMA FormalParameter

FormalParameter:
    UnannType VariableDeclaratorId
|   Annotation UnannType VariableDeclaratorId
|   VariableModifier0 UnannType VariableDeclaratorId
|   VariableArityParameter

VariableArityParameter:
    UnannType ELLIPSIS IDENTIFIER
|   Annotation UnannType ELLIPSIS IDENTIFIER
|   VariableModifier0 UnannType ELLIPSIS IDENTIFIER
|   UnannType Annotation0 ELLIPSIS IDENTIFIER
|   Annotation UnannType Annotation0 ELLIPSIS IDENTIFIER
|   VariableModifier0 UnannType Annotation0 ELLIPSIS IDENTIFIER

VariableModifier0: 
    Annotation VariableModifier0
|   VariableModifier
|   VariableModifier VariableModifier0

VariableModifier:
    FINAL

Throws:
    THROWS ExceptionTypeList

ExceptionTypeList:
    ExceptionType
|   ExceptionTypeList COMMA ExceptionType

ExceptionType:
    ClassType

MethodBody:
    Block
|   SEMICOLON

InstanceInitializer:
    Block

StaticInitializer:
    STATIC Block

ConstructorDeclaration:
    ConstructorDeclarator ConstructorBody
|   ConstructorDeclarator Throws ConstructorBody
|   ConstructorModifier ConstructorDeclarator ConstructorBody
|   ConstructorModifier ConstructorDeclarator Throws ConstructorBody

ConstructorModifier:
    PUBLIC 
|   PROTECTED 
|   PRIVATE

ConstructorDeclarator:
    SimpleTypeName BRACESTART BRACEEND
|   SimpleTypeName BRACESTART ReceiverParameter COMMA BRACEEND
|   SimpleTypeName BRACESTART FormalParameterList BRACEEND
|   SimpleTypeName BRACESTART ReceiverParameter COMMA FormalParameterList BRACEEND
|   TypeParameters SimpleTypeName BRACESTART BRACEEND
|   TypeParameters SimpleTypeName BRACESTART ReceiverParameter COMMA BRACEEND
|   TypeParameters SimpleTypeName BRACESTART FormalParameterList BRACEEND
|   TypeParameters SimpleTypeName BRACESTART ReceiverParameter COMMA FormalParameterList BRACEEND

SimpleTypeName:
    TypeIdentifier

ConstructorBody:
    CURLYBRACESTART CURLYBRACEEND
|   CURLYBRACESTART BlockStatements CURLYBRACEEND
|   CURLYBRACESTART ExplicitConstructorInvocation CURLYBRACEEND
|   CURLYBRACESTART ExplicitConstructorInvocation BlockStatements CURLYBRACEEND

ExplicitConstructorInvocation:
    THIS BRACESTART BRACEEND SEMICOLON
|   SUPER BRACESTART BRACEEND SEMICOLON
|   IDENTIFIER PERIOD SUPER BRACESTART BRACEEND SEMICOLON
|   ExpressionName PERIOD SUPER BRACESTART BRACEEND SEMICOLON
|   Primary PERIOD SUPER BRACESTART BRACEEND SEMICOLON
|   TypeArguments THIS BRACESTART BRACEEND SEMICOLON
|   TypeArguments SUPER BRACESTART BRACEEND SEMICOLON
|   IDENTIFIER PERIOD TypeArguments SUPER BRACESTART BRACEEND SEMICOLON
|   ExpressionName PERIOD TypeArguments SUPER BRACESTART BRACEEND SEMICOLON
|   Primary PERIOD TypeArguments SUPER BRACESTART BRACEEND SEMICOLON
|   THIS BRACESTART ArgumentList BRACEEND SEMICOLON
|   SUPER BRACESTART ArgumentList BRACEEND SEMICOLON
|   IDENTIFIER PERIOD SUPER BRACESTART ArgumentList BRACEEND SEMICOLON
|   ExpressionName PERIOD SUPER BRACESTART ArgumentList BRACEEND SEMICOLON
|   Primary PERIOD SUPER BRACESTART ArgumentList BRACEEND SEMICOLON
|   TypeArguments THIS BRACESTART ArgumentList BRACEEND SEMICOLON
|   TypeArguments SUPER BRACESTART ArgumentList BRACEEND SEMICOLON
|   IDENTIFIER PERIOD TypeArguments SUPER BRACESTART ArgumentList BRACEEND SEMICOLON
|   ExpressionName PERIOD TypeArguments SUPER BRACESTART ArgumentList BRACEEND SEMICOLON
|   Primary PERIOD TypeArguments SUPER BRACESTART ArgumentList BRACEEND SEMICOLON

EnumDeclaration:
    ENUM TypeIdentifier EnumBody
|   ClassModifier0 ENUM TypeIdentifier EnumBody

EnumBody:
    CURLYBRACESTART COMMA CURLYBRACEEND
|   CURLYBRACESTART CURLYBRACEEND
|   CURLYBRACESTART COMMA EnumBodyDeclarations CURLYBRACEEND
|   CURLYBRACESTART EnumBodyDeclarations CURLYBRACEEND
|   CURLYBRACESTART EnumConstantList COMMA CURLYBRACEEND
|   CURLYBRACESTART EnumConstantList CURLYBRACEEND
|   CURLYBRACESTART EnumConstantList COMMA EnumBodyDeclarations CURLYBRACEEND
|   CURLYBRACESTART EnumConstantList EnumBodyDeclarations CURLYBRACEEND

EnumConstantList:
    EnumConstant
|   EnumConstantList COMMA EnumConstant

EnumConstant:
    IDENTIFIER
|   IDENTIFIER PArgumentList
|   IDENTIFIER ClassBody
|   IDENTIFIER PArgumentList ClassBody
|   EnumConstantModifier0 IDENTIFIER
|   EnumConstantModifier0 IDENTIFIER PArgumentList
|   EnumConstantModifier0 IDENTIFIER ClassBody
|   EnumConstantModifier0 IDENTIFIER PArgumentList ClassBody

PArgumentList:
    BRACESTART BRACEEND
|   BRACESTART ArgumentList BRACEEND

EnumConstantModifier0:
    EnumConstantModifier
|   EnumConstantModifier EnumConstantModifier0

EnumConstantModifier:
    Annotation

EnumBodyDeclarations:
    SEMICOLON ClassBodyDeclaration0

RecordDeclaration:
    RECORD TypeIdentifier RecordHeader RecordBody
|   RECORD TypeIdentifier TypeParameters RecordHeader RecordBody
|   ClassModifier0 RECORD TypeIdentifier RecordHeader RecordBody
|   ClassModifier0 RECORD TypeIdentifier TypeParameters RecordHeader RecordBody

RecordHeader:
    BRACESTART BRACEEND
|   BRACESTART RecordComponentList BRACEEND

RecordComponentList:
    RecordComponent
|   RecordComponentList COMMA RecordComponent

RecordComponent:
    UnannType IDENTIFIER
|   RecordComponentModifier0 UnannType IDENTIFIER
|   VariableArityRecordComponent

VariableArityRecordComponent:
    UnannType ELLIPSIS IDENTIFIER
|   UnannType Annotation0 ELLIPSIS IDENTIFIER
|   RecordComponentModifier0 UnannType ELLIPSIS IDENTIFIER
|   RecordComponentModifier0 UnannType Annotation0 ELLIPSIS IDENTIFIER

RecordComponentModifier0:
    RecordComponentModifier
|   RecordComponentModifier RecordComponentModifier0

RecordComponentModifier:
    Annotation

RecordBody:
    CURLYBRACESTART CURLYBRACEEND
|   CURLYBRACESTART RecordBodyDeclaration0 CURLYBRACEEND

RecordBodyDeclaration0:
    RecordBodyDeclaration
|   RecordBodyDeclaration RecordBodyDeclaration0

RecordBodyDeclaration:
    ClassBodyDeclaration
|   CompactConstructorDeclaration
    
CompactConstructorDeclaration:
    SimpleTypeName ConstructorBody
|   Annotation SimpleTypeName ConstructorBody
|   ConstructorModifier SimpleTypeName ConstructorBody

Block: 
    CURLYBRACESTART CURLYBRACEEND 
|   CURLYBRACESTART BlockStatements CURLYBRACEEND

BlockStatements: 
    BlockStatement
|   BlockStatement BlockStatements

BlockStatement:
    LocalClassOrInterfaceDeclaration
|   LocalVariableDeclarationStatement
|   Statement

LocalClassOrInterfaceDeclaration:
    ClassDeclaration

LocalVariableDeclarationStatement:
    LocalVariableDeclaration SEMICOLON

LocalVariableDeclaration:
    LocalVariableType VariableDeclaratorList
|   Annotation LocalVariableType VariableDeclaratorList
|   VariableModifier0 LocalVariableType VariableDeclaratorList


LocalVariableType:
    UnannType
|   VAR

Statement:  
    StatementWithoutTrailingSubstatement
|   LabeledStatement
|   IfThenStatement
|   IfThenElseStatement
|   WhileStatement
|   ForStatement

StatementNoShortIf:
    StatementWithoutTrailingSubstatement
|   LabeledStatementNoShortIf
|   IfThenElseStatementNoShortIf
|   WhileStatementNoShortIf
|   ForStatementNoShortIf

StatementWithoutTrailingSubstatement:
    Block
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
|   YieldStatement

EmptyStatement: SEMICOLON

LabeledStatement:
    IDENTIFIER COLON Statement

LabeledStatementNoShortIf:
    IDENTIFIER COLON StatementNoShortIf

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
    ASSERT Expression SEMICOLON
|   ASSERT Expression COLON Expression SEMICOLON

SwitchStatement:
    SWITCH BRACESTART Expression BRACEEND SwitchBlock

SwitchBlock:
    CURLYBRACESTART SwitchRule0 CURLYBRACEEND
|   CURLYBRACESTART CURLYBRACEEND
|   CURLYBRACESTART SwitchColonLabel0 CURLYBRACEEND
|   CURLYBRACESTART SwitchBlockStatementGroup0 CURLYBRACEEND
|   CURLYBRACESTART SwitchBlockStatementGroup0 SwitchColonLabel0 CURLYBRACEEND

SwitchRule0:
    SwitchRule
|   SwitchRule SwitchRule0

SwitchBlockStatementGroup0: 
    SwitchBlockStatementGroup
|   SwitchBlockStatementGroup SwitchBlockStatementGroup0;

SwitchColonLabel0:
    SwitchLabel COLON
|   SwitchLabel COLON SwitchColonLabel0

SwitchRule:
    SwitchLabel PTR Expression SEMICOLON
|   SwitchLabel PTR Block
|   SwitchLabel PTR ThrowStatement

SwitchBlockStatementGroup:
SwitchLabel COLON SwitchColonLabel0 BlockStatements

SwitchLabel:
    CASE CaseConstant
|   CASE CaseConstant CommaCaseConstant0

CommaCaseConstant0:
    COMMA CaseConstant
|   COMMA CaseConstant CommaCaseConstant0
|   DEFAULT

CaseConstant:
ConditionalExpression

WhileStatement:
WHILE BRACESTART Expression BRACEEND Statement

WhileStatementNoShortIf:
WHILE BRACESTART Expression BRACEEND StatementNoShortIf

DoStatement:
DO Statement WHILE BRACESTART Expression BRACEEND SEMICOLON

ForStatement:
    BasicForStatement
|   EnhancedForStatement

ForStatementNoShortIf:
    BasicForStatementNoShortIf
|   EnhancedForStatementNoShortIf

BasicForStatement:
    FOR BRACESTART SEMICOLON SEMICOLON BRACEEND Statement
|   FOR BRACESTART ForInit SEMICOLON SEMICOLON BRACEEND Statement
|   FOR BRACESTART SEMICOLON Expression SEMICOLON BRACEEND Statement
|   FOR BRACESTART ForInit SEMICOLON Expression SEMICOLON BRACEEND Statement
|   FOR BRACESTART SEMICOLON SEMICOLON ForUpdate BRACEEND Statement
|   FOR BRACESTART ForInit SEMICOLON SEMICOLON ForUpdate BRACEEND Statement
|   FOR BRACESTART SEMICOLON Expression SEMICOLON ForUpdate BRACEEND Statement
|   FOR BRACESTART ForInit SEMICOLON Expression SEMICOLON ForUpdate BRACEEND Statement

BasicForStatementNoShortIf:
    FOR BRACESTART SEMICOLON SEMICOLON BRACEEND StatementNoShortIf
|   FOR BRACESTART ForInit  SEMICOLON SEMICOLON BRACEEND StatementNoShortIf
|   FOR BRACESTART SEMICOLON Expression SEMICOLON BRACEEND StatementNoShortIf
|   FOR BRACESTART ForInit  SEMICOLON Expression SEMICOLON BRACEEND StatementNoShortIf
|   FOR BRACESTART SEMICOLON SEMICOLON ForUpdate BRACEEND StatementNoShortIf
|   FOR BRACESTART ForInit  SEMICOLON SEMICOLON ForUpdate BRACEEND StatementNoShortIf
|   FOR BRACESTART SEMICOLON Expression SEMICOLON ForUpdate BRACEEND StatementNoShortIf
|   FOR BRACESTART ForInit  SEMICOLON Expression SEMICOLON ForUpdate BRACEEND StatementNoShortIf


ForInit:
    StatementExpressionList
|   LocalVariableDeclaration

ForUpdate:
StatementExpressionList

StatementExpressionList:
    StatementExpression
|   StatementExpression CommaStatExp0

CommaStatExp0: 
    COMMA StatementExpression
|   COMMA StatementExpression CommaStatExp0

EnhancedForStatement:
FOR BRACESTART LocalVariableDeclaration COLON Expression BRACEEND Statement

EnhancedForStatementNoShortIf:
FOR BRACESTART LocalVariableDeclaration COLON Expression BRACEEND StatementNoShortIf

BreakStatement: 
    BREAK SEMICOLON
|   BREAK IDENTIFIER SEMICOLON

YieldStatement:
YIELD Expression SEMICOLON

ContinueStatement: 
    CONTINUE SEMICOLON
|   CONTINUE IDENTIFIER SEMICOLON

ReturnStatement: 
    RETURN SEMICOLON
|   RETURN Expression SEMICOLON

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
    CatchType VariableDeclaratorId
|   Annotation CatchType VariableDeclaratorId
|   VariableModifier0 CatchType VariableDeclaratorId

CatchType:
    UnannClassType
|   UnannClassType BarClassType0


BarClassType0:
    OR ClassType
|   OR ClassType BarClassType0

Finally:
FINALLY Block

TryWithResourcesStatement:
    TRY ResourceSpecification Block 
|   TRY ResourceSpecification Block Catches
|   TRY ResourceSpecification Block Finally
|   TRY ResourceSpecification Block Catches Finally

ResourceSpecification:
    BRACESTART IDENTIFIER BRACEEND
|   BRACESTART IDENTIFIER SEMICOLON BRACEEND
|   BRACESTART ResourceList BRACEEND
|   BRACESTART ResourceList SEMICOLON BRACEEND

ResourceList:
    IDENTIFIER SemicolonResource0
|   Resource
|   Resource SemicolonResource0

SemicolonResource0: 
    SEMICOLON IDENTIFIER 
|   SEMICOLON IDENTIFIER SemicolonResource0
|   SEMICOLON Resource 
|   SEMICOLON Resource SemicolonResource0

Resource:
    LocalVariableDeclaration
|   VariableAccess

Pattern:
TypePattern

TypePattern:
LocalVariableDeclaration




Annotation:
   NormalAnnotation
|  MarkerAnnotation
|  SingleElementAnnotation

NormalAnnotation:
    AT TypeName BRACESTART ElementValuePairList BRACEEND
|   AT TypeName BRACESTART BRACEEND

MarkerAnnotation:
    AT TypeName

SingleElementAnnotation:
    AT TypeName BRACESTART ElementValue BRACEEND

ElementValuePairList:
   ElementValuePair 
|  ElementValuePairList COMMA ElementValuePair

ElementValuePair:
   IDENTIFIER ASSIGN ElementValue

ElementValue:
    ConditionalExpression
|   ElementValueArrayInitializer
|   Annotation

ElementValueArrayInitializer:
    CURLYBRACESTART COMMA CURLYBRACEEND
|   CURLYBRACESTART CURLYBRACEEND
|   CURLYBRACESTART ElementValueList COMMA CURLYBRACEEND
|   CURLYBRACESTART ElementValueList CURLYBRACEEND

ElementValueList:
    ElementValue
|   ElementValue CommaElementvalue0

CommaElementvalue0:
    COMMA ElementValue
|   CommaElementvalue0 COMMA ElementValue

VariableAccess:
    ExpressionName
|   FieldAccess

ExpressionName:
    IDENTIFIER PERIOD IDENTIFIER
|   ExpressionName PERIOD IDENTIFIER

FieldAccess:
    Primary PERIOD IDENTIFIER
|   SUPER PERIOD IDENTIFIER
|   TypeName PERIOD SUPER PERIOD IDENTIFIER

Primary:
    PrimaryNoNewArray
|   ArrayCreationExpression

PrimaryNoNewArray:
    LITERAL
|   ClassLiteral
|   THIS
|   TypeName PERIOD THIS
|   BRACESTART Expression BRACEEND
|   ClassInstanceCreationExpression
|   FieldAccess
|   ArrayAccess
|   MethodInvocation
|   MethodReference

ClassLiteral:
    TypeName PERIOD CLASS
|   NumericType PERIOD CLASS
|   BOOLEAN PERIOD CLASS
|   TypeName SquareBracePeriod CLASS
|   NumericType SquareBracePeriod CLASS
|   BOOLEAN SquareBracePeriod CLASS
|   VOID PERIOD CLASS

SquareBracePeriod:
    SquareBrace0 PERIOD

SquareBrace0:
    SQUAREBRACESTART SQUAREBRACEEND
|   SQUAREBRACESTART SQUAREBRACEEND SquareBrace0 

ClassInstanceCreationExpression:
    UnqualifiedClassInstanceCreationExpression
|   IDENTIFIER PERIOD UnqualifiedClassInstanceCreationExpression
|   ExpressionName PERIOD UnqualifiedClassInstanceCreationExpression
|   Primary PERIOD UnqualifiedClassInstanceCreationExpression

UnqualifiedClassInstanceCreationExpression:
    NEW ClassOrInterfaceTypeToInstantiate BRACESTART BRACEEND
|   NEW ClassOrInterfaceTypeToInstantiate BRACESTART BRACEEND ClassBody
|   NEW ClassOrInterfaceTypeToInstantiate BRACESTART ArgumentList BRACEEND 
|   NEW ClassOrInterfaceTypeToInstantiate BRACESTART ArgumentList BRACEEND ClassBody
|   NEW TypeArguments ClassOrInterfaceTypeToInstantiate BRACESTART BRACEEND
|   NEW TypeArguments ClassOrInterfaceTypeToInstantiate BRACESTART BRACEEND ClassBody
|   NEW TypeArguments ClassOrInterfaceTypeToInstantiate BRACESTART ArgumentList BRACEEND 
|   NEW TypeArguments ClassOrInterfaceTypeToInstantiate BRACESTART ArgumentList BRACEEND ClassBody

ClassOrInterfaceTypeToInstantiate:
    IDENTIFIER 
|   IDENTIFIER TypeArgumentsOrDiamond
|   IDENTIFIER DotAnnotation0 
|   IDENTIFIER DotAnnotation0 TypeArgumentsOrDiamond
|   Annotation0 IDENTIFIER 
|   Annotation0 IDENTIFIER TypeArgumentsOrDiamond
|   Annotation0 IDENTIFIER DotAnnotation0 
|   Annotation0 IDENTIFIER DotAnnotation0 TypeArgumentsOrDiamond

DotAnnotation0: 
    PERIOD Annotation0 IDENTIFIER
|   PERIOD Annotation0 IDENTIFIER DotAnnotation0

Annotation0: Annotation
|   Annotation Annotation0
    
TypeArgumentsOrDiamond:
    TypeArguments
|   LESSER GREATER

ArrayAccess:
    IDENTIFIER SQUAREBRACESTART Expression SQUAREBRACEEND
|   ExpressionName SQUAREBRACESTART Expression SQUAREBRACEEND
|   PrimaryNoNewArray SQUAREBRACESTART Expression SQUAREBRACEEND

MethodInvocation:
    MethodNameBrace BRACEEND
|   TypeName PERIOD IDENTIFIER BRACESTART BRACEEND
|   IDENTIFIER PERIOD IDENTIFIER BRACESTART BRACEEND
|   ExpressionName PERIOD IDENTIFIER BRACESTART BRACEEND
|   Primary PERIOD IDENTIFIER BRACESTART BRACEEND
|   SUPER PERIOD IDENTIFIER BRACESTART BRACEEND
|   TypeName PERIOD SUPER PERIOD IDENTIFIER BRACESTART BRACEEND
|   TypeName PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND
|   IDENTIFIER PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND
|   ExpressionName PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND
|   Primary PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND
|   SUPER PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND
|   TypeName PERIOD SUPER PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND
|   MethodNameBrace ArgumentList BRACEEND
|   TypeName PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND
|   IDENTIFIER PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND
|   ExpressionName PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND
|   Primary PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND
|   SUPER PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND
|   TypeName PERIOD SUPER PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND
|   TypeName PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND
|   IDENTIFIER PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND
|   ExpressionName PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND
|   Primary PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND
|   SUPER PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND
|   TypeName PERIOD SUPER PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND

MethodNameBrace:
    IDENTIFIER BRACESTART
|   MethodName BRACESTART

ArgumentList:
    Expression CommaExpression0
    
CommaExpression0:
    COMMA Expression 
|   COMMA Expression CommaExpression0
  
    
MethodReference:
    IDENTIFIER SCOPE IDENTIFIER
|   ExpressionName SCOPE IDENTIFIER
|   Primary SCOPE IDENTIFIER
|   ReferenceType SCOPE IDENTIFIER
|   SUPER SCOPE IDENTIFIER
|   TypeName PERIOD SUPER SCOPE IDENTIFIER
|   ClassType SCOPE NEW
|   ArrayType SCOPE NEW
|   IDENTIFIER SCOPE TypeArguments IDENTIFIER
|   ExpressionName SCOPE TypeArguments IDENTIFIER
|   Primary SCOPE TypeArguments IDENTIFIER
|   ReferenceType SCOPE TypeArguments IDENTIFIER
|   SUPER SCOPE TypeArguments IDENTIFIER
|   TypeName PERIOD SUPER SCOPE TypeArguments IDENTIFIER
|   ClassType SCOPE TypeArguments NEW

ArrayCreationExpression:
    NEW BOOLEAN DimExprs
|   NEW PrimitiveType DimExprs
|   NEW ClassOrInterfaceType DimExprs
|   NEW BOOLEAN DimExprs Dims
|   NEW PrimitiveType DimExprs Dims
|   NEW ClassOrInterfaceType DimExprs Dims
|   NEW BOOLEAN Dims ArrayInitializer
|   NEW PrimitiveType Dims ArrayInitializer
|   NEW ClassOrInterfaceType Dims ArrayInitializer

DimExprs:
    DimExpr
|   DimExpr DimExprs

DimExpr:
    SQUAREBRACESTART Expression SQUAREBRACEEND
|   Annotation0 SQUAREBRACESTART Expression SQUAREBRACEEND

Expression:
    LambdaExpression
|   AssignmentExpression

LambdaExpression:
    IDENTIFIER PTR LambdaBody
|   LambdaParameters PTR LambdaBody
    
LambdaParameters:
    BRACESTART BRACEEND
|   BRACESTART LambdaParameterList BRACEEND
    
LambdaParameterList:
    LambdaParameter
|   LambdaParameter CommaLambdaParameter0
|   CommaIdentifier0

CommaLambdaParameter0:
    COMMA LambdaParameter
|   COMMA LambdaParameter CommaLambdaParameter0
   
CommaIdentifier0:
    IDENTIFIER
|   COMMA CommaIdentifier0
 
LambdaParameter:
    LambdaParameterType VariableDeclaratorId
|   Annotation LambdaParameterType VariableDeclaratorId
|   VariableModifier0 LambdaParameterType VariableDeclaratorId
|   VariableArityParameter

LambdaParameterType:
    UnannType
|   VAR

LambdaBody:
   Expression
|  Block

AssignmentExpression:
   ConditionalExpression
|  Assignment

Assignment:
   IDENTIFIER AssignmentOperator Expression
|  LeftHandSide AssignmentOperator Expression

LeftHandSide:
   ExpressionName
|  FieldAccess
|  ArrayAccess

AssignmentOperator:
   ASSIGN
|  MUL_ASSIGN
|  DIV_ASSIGN
|  MOD_ASSIGN
|  ADD_ASSIGN
|  SUB_ASSIGN
|  RSHIFT_ASSIGN
|  LSHIFT_ASSIGN
|  AND_ASSIGN
|  XOR_ASSIGN
|  OR_ASSIGN   
|  URSHIFT_ASSIGN
   

ConditionalExpression:
    ConditionalOrExpression
|   ConditionalOrExpression QUESTION Expression COLON ConditionalExpression
|   ConditionalOrExpression QUESTION Expression COLON LambdaExpression

ConditionalOrExpression:
    ConditionalAndExpression
|   ConditionalOrExpression OR_OR ConditionalAndExpression
    
ConditionalAndExpression:
    InclusiveOrExpression
|   ConditionalAndExpression AND_AND InclusiveOrExpression

InclusiveOrExpression:
    ExclusiveOrExpression
|   InclusiveOrExpression OR ExclusiveOrExpression

ExclusiveOrExpression:
    AndExpression
|   ExclusiveOrExpression XOR AndExpression

AndExpression:
    EqualityExpression
|   AndExpression AND EqualityExpression

EqualityExpression:
    RelationalExpression
|   EqualityExpression EQUAL RelationalExpression
|   EqualityExpression NEQ RelationalExpression

RelationalExpression:
    ShiftExpression
|   RelationalExpression LESSER ShiftExpression
|   RelationalExpression GREATER ShiftExpression
|   RelationalExpression LEQ ShiftExpression
|   RelationalExpression GEQ ShiftExpression
|   InstanceofExpression

InstanceofExpression:
    RelationalExpression INSTANCEOF ReferenceType
|   RelationalExpression INSTANCEOF Pattern

ShiftExpression:
    AdditiveExpression
|   ShiftExpression LSHIFT AdditiveExpression
|   ShiftExpression RSHIFT AdditiveExpression
|   ShiftExpression URSHIFT AdditiveExpression

AdditiveExpression:
    MultiplicativeExpression
|   AdditiveExpression ADD MultiplicativeExpression
|   AdditiveExpression SUB MultiplicativeExpression

MultiplicativeExpression:
    UnaryExpression
|   MultiplicativeExpression MUL UnaryExpression
|   MultiplicativeExpression DIV UnaryExpression
|   MultiplicativeExpression MOD UnaryExpression

UnaryExpression:
    PreIncrementExpression
|   PreDecrementExpression
|   ADD UnaryExpression
|   SUB UnaryExpression
|   UnaryExpressionNotPlusMinus

PreIncrementExpression:
    INC UnaryExpression

PreDecrementExpression:
    DEC UnaryExpression

UnaryExpressionNotPlusMinus:
    PostfixExpression
|   TILDE UnaryExpression
|   NOT UnaryExpression
|   CastExpression
|   SwitchExpression

PostfixExpression:
    Primary
|   IDENTIFIER
|   ExpressionName
|   PostIncrementExpression
|   PostDecrementExpression

PostIncrementExpression:
    PostfixExpression INC

PostDecrementExpression:
    PostfixExpression DEC

CastExpression:
    BRACESTART BOOLEAN BRACEEND UnaryExpression
|   BRACESTART PrimitiveType BRACEEND UnaryExpression
|   BRACESTART ReferenceType BRACEEND UnaryExpressionNotPlusMinus
|   BRACESTART ReferenceType  BRACEEND LambdaExpression

SwitchExpression:
    SWITCH BRACESTART Expression BRACEEND SwitchBlock
    

ArrayInitializer:
    CURLYBRACESTART CURLYBRACEEND
|   CURLYBRACESTART VariableInitializerList CURLYBRACEEND
|   CURLYBRACESTART COMMA CURLYBRACEEND
|   CURLYBRACESTART VariableInitializerList COMMA CURLYBRACEEND
    
VariableInitializerList:
    VariableInitializer
|   VariableInitializer CommaVariableInitializer0
    
CommaVariableInitializer0:
    COMMA VariableInitializer
|   COMMA VariableInitializer CommaVariableInitializer0

PrimitiveType:
    NumericType
|   Annotation0 NumericType
|   Annotation0 BOOLEAN

NumericType:
    IntegralType
|   FloatingPointType

IntegralType:
    BYTE 
|   SHORT
|   INT
|   LONG
|   CHAR

FloatingPointType:
    FLOAT
|   DOUBLE    

ReferenceType:
    ClassOrInterfaceType
|   ArrayType

ClassOrInterfaceType:
    ClassType

ClassType:
    TypeIdentifier
|   Annotation0 TypeIdentifier
|   ClassOrInterfaceType PERIOD TypeIdentifier
|   ClassOrInterfaceType PERIOD Annotation0 TypeIdentifier
|   TypeIdentifier TypeArguments
|   Annotation0 TypeIdentifier TypeArguments
|   ClassOrInterfaceType PERIOD TypeIdentifier TypeArguments
|   ClassOrInterfaceType PERIOD Annotation0 TypeIdentifier TypeArguments

ArrayType:
    BOOLEAN SQUAREBRACESTART SQUAREBRACEEND 
|   BOOLEAN Annotation0 SQUAREBRACESTART SQUAREBRACEEND 
|   BOOLEAN SQUAREBRACESTART SQUAREBRACEEND Dims
|   BOOLEAN Annotation0 SQUAREBRACESTART SQUAREBRACEEND Dims
|   PrimitiveType SQUAREBRACESTART SQUAREBRACEEND 
|   PrimitiveType Annotation0 SQUAREBRACESTART SQUAREBRACEEND 
|   PrimitiveType SQUAREBRACESTART SQUAREBRACEEND Dims
|   PrimitiveType Annotation0 SQUAREBRACESTART SQUAREBRACEEND Dims
|   ClassOrInterfaceType Dims

Dims:
    SQUAREBRACESTART SQUAREBRACEEND 
|   Annotation0 SQUAREBRACESTART SQUAREBRACEEND 
|   SQUAREBRACESTART SQUAREBRACEEND Dims
|   Annotation0 SQUAREBRACESTART SQUAREBRACEEND Dims

TypeParameter:
    TypeIdentifier
|   TypeIdentifier TypeBound
|   TypeParameterModifier0 TypeIdentifier
|   TypeParameterModifier0 TypeIdentifier TypeBound

TypeParameterModifier0:
    TypeParameterModifier
|   TypeParameterModifier TypeParameterModifier0
    
TypeParameterModifier:
    Annotation

TypeBound:
    EXTENDS ClassOrInterfaceType 

TypeArguments:
    LESSER TypeArgumentList GREATER

TypeArgumentList:
    TypeArgument
|   TypeArgument CommaTypeArgument0
    
CommaTypeArgument0:
    COMMA TypeArgument
|   COMMA TypeArgument CommaTypeArgument0   

TypeArgument:
    ReferenceType
|   Wildcard

Wildcard:
    QUESTION 
|   Annotation0 QUESTION
|   QUESTION WildcardBounds
|   Annotation0 QUESTION WildcardBounds
    
WildcardBounds:
    EXTENDS ReferenceType
|   SUPER ReferenceType

TypeName:
    TypeIdentifier
|   IDENTIFIER PERIOD TypeIdentifier

MethodName:
    UnqualifiedMethodIdentifier

ContextualExceptYield: 
    TRANSITIVE| RECORD| OPEN | WITH | TO | PROVIDES | NON_SEALED | VAR | SEALED | PERMITS | MODULE | USES | REQUIRES | OPENS | EXPORTS

ContextualExceptPRS:
    TRANSITIVE| OPEN | WITH | TO | PROVIDES | NON_SEALED | MODULE | USES | REQUIRES | OPENS | EXPORTS

UnqualifiedMethodIdentifier:
    ContextualExceptYield

TypeIdentifier:
    IDENTIFIER | ContextualExceptPRS

%%

int main() {
    yydebug = 1;
    yyparse();
    return 0;
}