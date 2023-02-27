%{
    #include <bits/stdc++.h>
    #include <string>
    int lines=1;
    FILE* dotfile;
    extern "C" {
        int yyparse();
        int yylex(void);
        int yyerror(char* s)
        {
            printf("ERROR: %s Line Number: %d\n",s,lines);
            return 0;
        }
    }
    char* concat(char* s1, char* s2)
    {
        char* ans=new char[strlen(s1)+strlen(s2)+1];
        strcpy(ans,s1);
        strcat(ans,s2);
        return ans;
    }
    using namespace std;

    struct Node{
        char* val;
        vector<Node*> children;
    };

    struct Strval{
        Node* node;
        char* data;
    };
    Node* root;
    Node* createNode(char* value, vector<Node*> children)
    {
        Node* temp= new Node();
        temp->val=value;
        temp->children=children;
        return temp;
    }
    Node* createNode(char* value)
    {
        Node* temp= new Node();
        temp->val=value;
        return temp;
    }

    int buildTree(Node* node, int parentno, int co) 
    {
        if(node==NULL)
        return co;

        int nodeno=co++;
        fprintf(dotfile," node%d [label=\"%s\"]\n",nodeno,node->val);
        if(parentno>=0) 
            fprintf(dotfile," node%d -> node%d\n",parentno,nodeno);
        
        int n=node->children.size();
        vector<Node*> children=node->children;
        for(int i=0;i<n;i++)
        {
            co=buildTree(children[i],nodeno,co);
        }
        return co;
    }
%}
%code requires {
    #include <bits/stdc++.h>
    #include <string>
    #include <vector>
    #include <cstdio>

    struct Node;
    using namespace std;
    Node* createNode(char* value, vector<Node*> children);
    Node* createNode(char* value);

}
%union {
    Node* node;
    char* val;
}
%token<node> UNDERSCORE PACKAGE GOTO IMPLEMENTS DECIMAL_INTEGER HEX_INTEGER OCTAL_INTEGER BINARY_INTEGER DECIMAL_FLOATING HEXADECIMAL_FLOATING
%token<node> AT PROTECTED PRIVATE ABSTRACT ELLIPSIS COMMA  OPERATOR SEPARATOR IDENTIFIER CURLYBRACESTART CURLYBRACEEND VAR SEMICOLON BRACESTART ELSE CATCH IF PERIOD 
%token<node> QUESTION AND XOR LESSER THIS CLASS BOOLEAN VOID NEW EQUAL LITERAL
%token<node> INSTANCEOF BYTE SHORT INT LONG CHAR FLOAT DOUBLE DEC INC NOT TILDE ADD SUB MUL DIV MOD LSHIFT RSHIFT URSHIFT LSHIFT_ASSIGN RSHIFT_ASSIGN NEQ EQ ASSIGN
%token<node> MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN LEQ GEQ URSHIFT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN SCOPE EXTENDS
%token<node> TRY DEFAULT BRACEEND WHILE SWITCH DO FOR OR COLON RETURN THROW SYNCHRONIZED FINALLY BREAK CONTINUE PTR GREATER ASSERT SQUAREBRACESTART SQUAREBRACEEND AND_AND OR_OR

%token<node> YIELD TRANSITIVE RECORD OPEN WITH TO PROVIDES NON_SEALED SEALED PERMITS MODULE USES REQUIRES OPENS EXPORTS SUPER NATIVE CONST VOLATILE STRICTFP STATIC INTERFACE FINAL TRANSIENT ENUM CASE THROWS PUBLIC IMPORT

%type<node> Block BlockStatements BlockStatement LocalClassOrInterfaceDeclaration LocalVariableDeclarationStatement LocalVariableDeclaration LocalVariableType
%type<node> Statement StatementNoShortIf StatementWithoutTrailingSubstatement EmptyStatement LabeledStatement LabeledStatementNoShortIf ExpressionStatement StatementExpression
%type<node> IfThenStatement IfThenElseStatement IfThenElseStatementNoShortIf AssertStatement SwitchStatement SwitchBlock SwitchRule SwitchBlockStatementGroup SwitchLabel CaseConstant 
%type<node> WhileStatement WhileStatementNoShortIf DoStatement ForStatement ForStatementNoShortIf BasicForStatement BasicForStatementNoShortIf ForInit ForUpdate 
%type<node> StatementExpressionList EnhancedForStatement EnhancedForStatementNoShortIf BreakStatement YieldStatement ContinueStatement ReturnStatement ThrowStatement
%type<node> SynchronizedStatement TryStatement Catches CatchClause CatchFormalParameter CatchType Finally TryWithResourcesStatement ResourceSpecification 
%type<node> ResourceList Resource Pattern TypePattern SwitchColonLabel0 CommaCaseConstant0  SwitchBlockStatementGroup0
%type<node> SwitchRule0  CommaStatExp0 BarClassType0 SemicolonResource0 VariableModifier0 classmethod Classdec

%type<node> NormalClassDeclaration EnumDeclaration TypeIdentifier ClassBody TypeParameters ClassExtends  ClassPermits ClassModifier RecordComponent VariableArityRecordComponent 
%type<node> TypeParameterList TypeNames TypeName ClassBodyDeclaration ClassMemberDeclaration InstanceInitializer  RecordBodyDeclaration CompactConstructorDeclaration
%type<node> StaticInitializer ConstructorDeclaration FieldDeclaration MethodDeclaration ClassDeclaration  UnannType VariableDeclaratorList VariableDeclarator  EnumConstantList EnumBodyDeclarations ReceiverParameter
%type<node> VariableDeclaratorId VariableInitializer UnannPrimitiveType UnannReferenceType UnannArrayType UnannClassType 
%type<node> MethodHeader MethodBody Result MethodDeclarator Throws FormalParameterList ConstructorDeclarator ConstructorBody ConstructorModifier SimpleTypeName ExplicitConstructorInvocation ExpressionName Primary ArgumentList
%type<node> FormalParameter VariableArityParameter VariableModifier ExceptionTypeList ExceptionType EnumConstant RecordDeclaration RecordHeader RecordBody RecordComponentList EnumBody

%type<node> ClassModifier0 ClassBodyDeclaration0 FieldModifier0 MethodModifier0 
%type<node>  RecordBodyDeclaration0 NormalClassDeclaration0

%type<node> MethodInvocation CommaExpression0 MethodReference ArrayCreationExpression
%type<node> DimExprs DimExpr Expression LambdaExpression LambdaParameters LambdaParameterList CommaLambdaParameter0 CommaIdentifier0 LambdaParameter
%type<node> LambdaParameterType LambdaBody AssignmentExpression Assignment AssignmentOperator ConditionalExpression ConditionalOrExpression ConditionalAndExpression InclusiveOrExpression
%type<node> ExclusiveOrExpression AndExpression EqualityExpression RelationalExpression InstanceofExpression ShiftExpression AdditiveExpression MultiplicativeExpression UnaryExpression
%type<node> PreIncrementExpression PreDecrementExpression UnaryExpressionNotPlusMinus PostfixExpression PostIncrementExpression PostDecrementExpression CastExpression SwitchExpression
%type<node> ArrayInitializer VariableInitializerList CommaVariableInitializer0 PrimitiveType NumericType IntegralType FloatingPointType
%type<node> ReferenceType  ClassType ArrayType Dims TypeParameter TypeBound
%type<node> TypeArguments TypeArgumentList CommaTypeArgument0 TypeArgument WildcardBounds
%type<node> MethodName LeftHandSide SquareBracePeriod StaticFinal0 fieldclassmethod
%type<node> PrimaryNoNewArray ClassLiteral SquareBrace0 ClassInstanceCreationExpression UnqualifiedClassInstanceCreationExpression 

%type<node>  CompilationUnit OrdinaryCompilationUnit TopLevelClassOrInterfaceDeclaration
%type<node> UnannClassOrInterfaceType FieldModifier MethodModifier FieldAccess ArrayAccess ClassOrInterfaceType UnqualifiedMethodIdentifier
%type<node> VariableAccess Wildcard ContextualExceptYield ContextualExceptPRS MethodNameBrace

%%

CompilationUnit: {  root=$$; }
|   OrdinaryCompilationUnit {  root=$$; }

OrdinaryCompilationUnit: 
    TopLevelClassOrInterfaceDeclaration {  $$=$1; }
|   TopLevelClassOrInterfaceDeclaration OrdinaryCompilationUnit {
                                                                    vector<Node*> v{$1,$2};
                                                                    $$=createNode("OrdinaryCompilationUnit",v);
                                                                }

TopLevelClassOrInterfaceDeclaration:
    ClassDeclaration {  $$=$1; }
|   StaticFinal0 Classdec {
                            vector<Node*> v{$1,$2};
                            $$=createNode("TopLevelClassOrInterfaceDeclaration",v);
                        }
|   ABSTRACT Classdec {
                            vector<Node*> v{$1,$2};
                            $$=createNode("TopLevelClassOrInterfaceDeclaration",v);
                        }
|   SEMICOLON {  $$=$1; }

ClassDeclaration:
    NormalClassDeclaration {  $$=$1; }
|   EnumDeclaration {  $$=$1; }
|   RecordDeclaration {  $$=$1; }

NormalClassDeclaration:
    NormalClassDeclaration0 {  $$=$1; }
|   ClassModifier0 NormalClassDeclaration0 {
                                                vector<Node*> v{$1,$2};
                                                $$=createNode("NormalClassDeclaration",v);
                                            }

NormalClassDeclaration0:
    CLASS TypeIdentifier ClassBody {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode("NormalClassDeclaration",v);
                                    }
|   CLASS TypeIdentifier ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4};
                                                $$=createNode("NormalClassDeclaration",v);
                                            }
|   CLASS TypeIdentifier ClassExtends ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4};
                                                $$=createNode("NormalClassDeclaration",v);
                                            }
|   CLASS TypeIdentifier ClassExtends ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4,$5};
                                                $$=createNode("NormalClassDeclaration",v);
                                            }
|   CLASS TypeIdentifier TypeParameters ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4};
                                                $$=createNode("NormalClassDeclaration",v);
                                            }
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4,$5};
                                                $$=createNode("NormalClassDeclaration",v);
                                            }
|   CLASS TypeIdentifier TypeParameters ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4,$5};
                                                $$=createNode("NormalClassDeclaration",v);
                                            }
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4,$5,$6};
                                                $$=createNode("NormalClassDeclaration",v);
                                            }

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
|   STATIC FINAL

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
|   ABSTRACT ConstructorModifier

MethodModifier:
    SYNCHRONIZED 
|   NATIVE 
|   STRICTFP

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
|   UnannArrayType

UnannClassOrInterfaceType:
    UnannClassType

UnannClassType:
    TypeIdentifier
|   TypeIdentifier TypeArguments
|   UnannClassOrInterfaceType PERIOD TypeIdentifier
|   UnannClassOrInterfaceType PERIOD TypeIdentifier TypeArguments

UnannArrayType:
    UnannPrimitiveType Dims
|   UnannClassOrInterfaceType Dims




MethodHeader:
    VOID MethodDeclarator 
|   TypeParameters Result MethodDeclarator
|   VOID MethodDeclarator Throws
|   TypeParameters Result MethodDeclarator Throws


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
|   UnannType IDENTIFIER PERIOD THIS

FormalParameterList:
    FormalParameter
|   FormalParameterList COMMA FormalParameter

FormalParameter:
    UnannType VariableDeclaratorId
|   VariableModifier0 UnannType VariableDeclaratorId
|   VariableArityParameter

VariableArityParameter:
    UnannType ELLIPSIS IDENTIFIER
|   VariableModifier0 UnannType ELLIPSIS IDENTIFIER

VariableModifier0: 
    VariableModifier
|   VariableModifier0 VariableModifier

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

PArgumentList:
    BRACESTART BRACEEND
|   BRACESTART ArgumentList BRACEEND

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
|   VariableArityRecordComponent

VariableArityRecordComponent:
    UnannType ELLIPSIS IDENTIFIER

RecordBody:
    CURLYBRACESTART CURLYBRACEEND
|   CURLYBRACESTART RecordBodyDeclaration0 CURLYBRACEEND

RecordBodyDeclaration0:
    RecordBodyDeclaration
|   RecordBodyDeclaration0 RecordBodyDeclaration

RecordBodyDeclaration:
    ClassBodyDeclaration
|   CompactConstructorDeclaration
    
CompactConstructorDeclaration:
    SimpleTypeName ConstructorBody
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
|   SwitchRule0 SwitchRule

SwitchBlockStatementGroup0: 
    SwitchBlockStatementGroup
|   SwitchBlockStatementGroup0 SwitchBlockStatementGroup

SwitchColonLabel0:
    SwitchLabel COLON
|   SwitchColonLabel0 SwitchLabel COLON

SwitchRule:
    SwitchLabel PTR Expression SEMICOLON
|   SwitchLabel PTR Block
|   SwitchLabel PTR ThrowStatement

SwitchBlockStatementGroup:
SwitchLabel COLON SwitchColonLabel0 BlockStatements

SwitchLabel:
    CASE CaseConstant
|   CommaCaseConstant0 CASE CaseConstant

CommaCaseConstant0:
    COMMA CaseConstant
|   CommaCaseConstant0 COMMA CaseConstant
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
|   CommaStatExp0 COMMA StatementExpression 

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
|   VariableModifier0 CatchType VariableDeclaratorId

CatchType:
    UnannClassType
|   UnannClassType BarClassType0


BarClassType0:
    OR ClassType
|   BarClassType0 OR ClassType 

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
|   SemicolonResource0 SEMICOLON IDENTIFIER 
|   SEMICOLON Resource 
|   SemicolonResource0 SEMICOLON Resource 

Resource:
    LocalVariableDeclaration
|   VariableAccess

Pattern:
TypePattern

TypePattern:
LocalVariableDeclaration



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
|   SquareBrace0 SQUAREBRACESTART SQUAREBRACEEND  

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
|   CommaExpression0 COMMA Expression 
  
    
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
|   DimExprs DimExpr 

DimExpr:
    SQUAREBRACESTART Expression SQUAREBRACEEND

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
|   IDENTIFIER
|   IDENTIFIER CommaIdentifier0

CommaLambdaParameter0:
    COMMA LambdaParameter
|   CommaLambdaParameter0 COMMA LambdaParameter 
   
CommaIdentifier0:
    COMMA IDENTIFIER
|   CommaIdentifier0 COMMA IDENTIFIER 
 
LambdaParameter:
    LambdaParameterType VariableDeclaratorId
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
|   CommaVariableInitializer0 COMMA VariableInitializer 

PrimitiveType:
    NumericType
|   BOOLEAN

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
|   ClassOrInterfaceType PERIOD TypeIdentifier
|   TypeIdentifier TypeArguments
|   ClassOrInterfaceType PERIOD TypeIdentifier TypeArguments

ArrayType:
    BOOLEAN SQUAREBRACESTART SQUAREBRACEEND 
|   BOOLEAN SQUAREBRACESTART SQUAREBRACEEND Dims
|   PrimitiveType SQUAREBRACESTART SQUAREBRACEEND 
|   PrimitiveType SQUAREBRACESTART SQUAREBRACEEND Dims
|   ClassOrInterfaceType Dims

Dims:
    SQUAREBRACESTART SQUAREBRACEEND 
|   SQUAREBRACESTART SQUAREBRACEEND Dims

TypeParameter:
    TypeIdentifier
|   TypeIdentifier TypeBound


TypeBound:
    EXTENDS ClassOrInterfaceType 

TypeArguments:
    LESSER TypeArgumentList GREATER

TypeArgumentList:
    TypeArgument
|   TypeArgument CommaTypeArgument0
    
CommaTypeArgument0:
    COMMA TypeArgument
|   CommaTypeArgument0 COMMA TypeArgument    

TypeArgument:
    ReferenceType
|   Wildcard

Wildcard:
    QUESTION 
|   QUESTION WildcardBounds
    
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
    dotfile=fopen("output.txt","w");
    fprintf(dotfile,"digraph {\n");
    yyparse();
    buildTree(root,-1,0);
    fprintf(dotfile," }\n");
    return 0;
}