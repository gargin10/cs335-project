%{
    #include <bits/stdc++.h>
    #include <string>
    int lines=1;
    FILE* dotfile;
    extern FILE * yyin;
    extern "C" {
        int yyparse();
        int yylex(void);
        int yyerror(char* s)
        {
            printf("ERROR: %s Line Number: %d\n",s, lines);
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
    Node* createNode( char* lexeme, char* token)
    {
        Node* temp= new Node();
        char* ans=new char[strlen(lexeme)+strlen(token)+3];
        strcpy(ans,token);
        strcat(ans,"(");
        strcat(ans,lexeme);
        strcat(ans,")");
        temp->val=ans;
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
    Node* createNode(char* lexeme, char* token);

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
%type<node> SwitchRule0  CommaStatExp0 BarClassType0 SemicolonResource0 VariableModifier0 classmethod Classdec PArgumentList ClassOrInterfaceTypeToInstantiate

%type<node> NormalClassDeclaration EnumDeclaration TypeIdentifier ClassBody TypeParameters ClassExtends  ClassPermits ClassModifier RecordComponent VariableArityRecordComponent 
%type<node> TypeParameterList TypeNames TypeName ClassBodyDeclaration ClassMemberDeclaration InstanceInitializer  RecordBodyDeclaration CompactConstructorDeclaration
%type<node> StaticInitializer ConstructorDeclaration FieldDeclaration MethodDeclaration ClassDeclaration  UnannType VariableDeclaratorList VariableDeclarator  EnumConstantList EnumBodyDeclarations ReceiverParameter
%type<node> VariableDeclaratorId VariableInitializer UnannPrimitiveType UnannReferenceType UnannArrayType UnannClassType 
%type<node> MethodHeader MethodBody Result MethodDeclarator Throws FormalParameterList ConstructorDeclarator ConstructorBody ConstructorModifier SimpleTypeName ExplicitConstructorInvocation ExpressionName Primary ArgumentList
%type<node> FormalParameter VariableArityParameter VariableModifier ExceptionTypeList ExceptionType EnumConstant RecordDeclaration RecordHeader RecordBody RecordComponentList EnumBody

%type<node> ClassModifier0 ClassBodyDeclaration0 FieldModifier0 MethodModifier0 
%type<node>  RecordBodyDeclaration0 NormalClassDeclaration0 TypeArgumentsOrDiamond

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
    TopLevelClassOrInterfaceDeclaration {  $$ = $1; }
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
                            vector<Node*> v{$1, $2};
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
                                        $$=createNode("NormalClassDeclaration0",v);
                                    }
|   CLASS TypeIdentifier ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4};
                                                $$=createNode("Class",v);
                                            }
|   CLASS TypeIdentifier ClassExtends ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4};
                                                $$=createNode("Class",v);
                                            }
|   CLASS TypeIdentifier ClassExtends ClassPermits ClassBody {
                                               vector<Node*> v{$1,$2,$3,$4,$5};
                                                $$=createNode("Class",v);
                                            }
|   CLASS TypeIdentifier TypeParameters ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4};
                                                $$=createNode("Class",v);
                                            }
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4, $5};
                                                $$=createNode("Class",v);
                                            }
|   CLASS TypeIdentifier TypeParameters ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4, $5};
                                                $$=createNode("Class",v);
                                            }
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4,$5, $6};
                                        $$=createNode("Class",v);
                                            }

Classdec:
    CLASS TypeIdentifier ClassBody {
                                                vector<Node*> v{$1,$2,$3};
                                        $$=createNode("Class",v);
                                            }
|   CLASS TypeIdentifier ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode("Class",v);
                                            }
|   CLASS TypeIdentifier ClassExtends ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode("Class",v);
                                            }
|   CLASS TypeIdentifier ClassExtends ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4,$5};
                                        $$=createNode("Class",v);
                                            }
|   CLASS TypeIdentifier TypeParameters ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode("Class",v);
                                            }
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4,$5};
                                        $$=createNode("Class",v);
                                            }
|   CLASS TypeIdentifier TypeParameters ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4,$5};
                                        $$=createNode("Class",v);
                                            }
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4,$5,$6};
                                        $$=createNode("Class",v);
                                            }

ClassModifier0:
    ClassModifier { $$ = $1; }
|   ConstructorModifier { $$ = $1; }
|   ClassModifier ConstructorModifier {
                                                vector<Node*> v{$1,$2};
                                                $$=createNode( "ClassModifier0",v);
                                            }
|   ConstructorModifier ClassModifier {
                                                vector<Node*> v{$1,$2};
                                                $$=createNode( "ClassModifier0",v);
                                            }

StaticFinal0:
    STATIC { $$ = $1; }
|   FINAL { $$ = $1; }
|   STATIC FINAL  {
    vector<Node*> v{$1,$2};
    $$ = createNode("StaticFinal0", v); 
}

ClassModifier:
    SEALED { $$ = $1; }
|   NON_SEALED { $$ = $1; }
|   STRICTFP { $$ = $1; }

TypeParameters:
    LESSER TypeParameterList GREATER {
                                                vector<Node*> v{$1,$2,$3};
                                                $$=createNode( "TypeParameters",v);
                                            }

TypeParameterList:
    TypeParameter { $$ = $1; }
|   TypeParameterList COMMA TypeParameter {
                                                vector<Node*> v($1->children);
                                                v.push_back($3);
                                                $$=createNode( "TypeParameterList",v);
                                            }

ClassExtends:
    EXTENDS ClassType {
                            vector<Node*> v{$1,$2};
                            $$=createNode( "ClassExtends",v);
                        }

ClassPermits:
    PERMITS TypeNames {
                            vector<Node*> v{$1,$2};
                            $$=createNode( "ClassPermits",v);
                        }

TypeNames:
    TypeName { $$ = $1; }
|   TypeNames COMMA TypeName {
                           vector<Node*> v($1->children);
                            v.push_back($3);
                            $$=createNode( "TypeNames",v);
                        }

ClassBody:
    CURLYBRACESTART CURLYBRACEEND {
                            vector<Node*> v{$1,$2};
                            $$=createNode( "ClassBody",v);
                        }
|   CURLYBRACESTART ClassBodyDeclaration0 CURLYBRACEEND {
                           vector<Node*> v{$1,$2,$3};
                            $$=createNode( "ClassBody",v);
                        }

ClassBodyDeclaration0: 
    ClassBodyDeclaration  { $$ = $1; }
|   ClassBodyDeclaration0 ClassBodyDeclaration {
                            vector<Node*> v{$1,$2};
                            $$=createNode( "ClassBodyDeclaration0",v);
                        }

ClassBodyDeclaration:
    ClassMemberDeclaration { $$ = $1; }
|   InstanceInitializer { $$ = $1; }
|   StaticInitializer { $$ = $1; }
|   ConstructorDeclaration { $$ = $1; }

ClassMemberDeclaration:
    FieldDeclaration { $$ = $1; }
|   MethodDeclaration { $$ = $1; }
|   ClassDeclaration { $$ = $1; }
|   StaticFinal0 fieldclassmethod {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( "ClassMemberDeclaration",v);
                                    }
|   StaticFinal0 ConstructorModifier {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( "ClassMemberDeclaration",v);
                                    }
|   ABSTRACT classmethod {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( "ClassMemberDeclaration",v);
                                    }
|   ConstructorModifier ABSTRACT classmethod {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "ClassMemberDeclaration",v);
                                    }
|   ConstructorModifier StaticFinal0 fieldclassmethod {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "ClassMemberDeclaration",v);
                                    }
|   SEMICOLON { $$ = $1; }

classmethod:
    MethodHeader MethodBody {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( "classmethod",v);
                                    }
|   UnannType MethodDeclarator {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( "classmethod",v);
                                    }
|   UnannType MethodDeclarator Throws {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "classmethod",v);
                                    }
|   CLASS TypeIdentifier ClassBody {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "classmethod",v);
                                    }
|   CLASS TypeIdentifier ClassPermits ClassBody {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "classmethod",v);
                                    }
|   CLASS TypeIdentifier ClassExtends ClassBody {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "classmethod",v);
                                    }
|   CLASS TypeIdentifier ClassExtends ClassPermits ClassBody {
                                        vector<Node*> v{$1,$2,$3,$4,$5};
                                        $$=createNode( "classmethod",v);
                                    }
|   CLASS TypeIdentifier TypeParameters ClassBody {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "classmethod",v);
                                    }
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassBody  {
                                        vector<Node*> v{$1,$2,$3,$4,$5};
                                        $$=createNode( "classmethod",v);
                                    }
|   CLASS TypeIdentifier TypeParameters ClassPermits ClassBody {
                                        vector<Node*> v{$1,$2,$3,$4,$5};
                                        $$=createNode( "classmethod",v);
                                    }
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassPermits ClassBody {
                                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                                        $$=createNode( "classmethod",v);
                                    }

fieldclassmethod:
    UnannType VariableDeclaratorList SEMICOLON{
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "fieldclassmethod",v);
                                    }
|   classmethod { $$ = $1; }

FieldDeclaration:
    UnannType VariableDeclaratorList SEMICOLON {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "FieldDeclaration",v);
                                    }
|   FieldModifier0 UnannType VariableDeclaratorList SEMICOLON {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "FieldDeclaration",v);
                                    }
|   ConstructorModifier UnannType VariableDeclaratorList SEMICOLON {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "FieldDeclaration",v);
                                    }
|   ConstructorModifier FieldModifier UnannType VariableDeclaratorList SEMICOLON {
                                        vector<Node*> v{$1,$2,$3,$4,$5};
                                        $$=createNode( "FieldDeclaration",v);
                                    }

FieldModifier0: 
    FieldModifier { $$ = $1; }
|   FieldModifier ConstructorModifier {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( "FieldModifier0",v);
                                    }

FieldModifier:
    TRANSIENT { $$ = $1; }
|   VOLATILE { $$ = $1; }

MethodDeclaration:
    MethodHeader MethodBody {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( "MethodDeclaration",v);
                                    }
|   UnannType MethodDeclarator Throws {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "MethodDeclaration",v);
                                    }
|   UnannType MethodDeclarator {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( "MethodDeclaration",v);
                                    }
|   MethodModifier0 MethodHeader MethodBody {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "MethodDeclaration",v);
                                    }
|   ConstructorModifier MethodHeader MethodBody {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "MethodDeclaration",v);
                                    }
|   ConstructorModifier MethodModifier MethodHeader MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "MethodDeclaration",v);
                                    }
|   MethodModifier0 UnannType MethodDeclarator Throws MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4,$5};
                                        $$=createNode( "MethodDeclaration",v);
                                    }
|   ConstructorModifier UnannType MethodDeclarator Throws MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4,$5};
                                        $$=createNode( "MethodDeclaration",v);
                                    }
|   ConstructorModifier MethodModifier UnannType MethodDeclarator Throws MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                                        $$=createNode( "MethodDeclaration",v);
                                    }
|   MethodModifier0 UnannType MethodDeclarator MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "MethodDeclaration",v);
                                    }
|   ConstructorModifier UnannType MethodDeclarator MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "MethodDeclaration",v);
                                    }
|   ConstructorModifier MethodModifier UnannType MethodDeclarator MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4,$5};
                                        $$=createNode( "MethodDeclaration",v);
                                    }


MethodModifier0: 
    MethodModifier { $$ = $1; }
|   MethodModifier ConstructorModifier {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( "MethodModifier0",v);
                                    }
|   ABSTRACT ConstructorModifier {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( "MethodModifier0",v);
                                    }

MethodModifier:
    SYNCHRONIZED  { $$ = $1; }
|   NATIVE  { $$ = $1; }
|   STRICTFP { $$ = $1; }

VariableDeclaratorList:
    VariableDeclarator { $$ = $1; }
|   VariableDeclaratorList COMMA VariableDeclarator {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "VariableDeclaratorList",v);
                                    }

VariableDeclarator:
    VariableDeclaratorId  { $$ = $1; }
|   VariableDeclaratorId ASSIGN VariableInitializer {
                                        vector<Node*> v{$1,$3};
                                        $$=createNode( "=",v);
                                    }

VariableDeclaratorId:
    IDENTIFIER { $$ = $1; }
|   IDENTIFIER Dims {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "VariableDeclaratorId",v);
                    }

VariableInitializer:
    Expression { $$ = $1; }
|   ArrayInitializer { $$ = $1; }

UnannType:
    UnannPrimitiveType { $$ = $1; }
|   UnannReferenceType { $$ = $1; }

UnannPrimitiveType:
    NumericType { $$ = $1; }
|   BOOLEAN { $$ = $1; }

UnannReferenceType:
    UnannClassOrInterfaceType { $$ = $1; }
|   UnannArrayType { $$ = $1; }

UnannClassOrInterfaceType:
    UnannClassType { $$ = $1; }

UnannClassType:
    TypeIdentifier { $$ = $1; }
|   TypeIdentifier TypeArguments {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "UnannClassType",v);
                    }
|   UnannClassOrInterfaceType PERIOD TypeIdentifier {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "UnannClassType",v);
                    }
|   UnannClassOrInterfaceType PERIOD TypeIdentifier TypeArguments {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "UnannClassType",v);
                    }

UnannArrayType:
    UnannPrimitiveType Dims {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "UnannArrayType",v);
                    }
|   UnannClassOrInterfaceType Dims {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "UnannArrayType",v);
                    }




MethodHeader:
    VOID MethodDeclarator {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "MethodHeader",v);
                    }
|   TypeParameters Result MethodDeclarator {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "MethodHeader",v);
                    }
|   VOID MethodDeclarator Throws {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "MethodHeader",v);
                    }
|   TypeParameters Result MethodDeclarator Throws {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "MethodHeader",v);
                    }


Result:
    UnannType { $$ = $1; }
|   VOID { $$ = $1; }

MethodDeclarator:
    IDENTIFIER BRACESTART BRACEEND {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "MethodDeclarator",v);
                    }
|   IDENTIFIER BRACESTART FormalParameterList BRACEEND {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "MethodDeclarator",v);
                    }
|   IDENTIFIER BRACESTART ReceiverParameter COMMA BRACEEND {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "MethodDeclarator",v);
                    }
|   IDENTIFIER BRACESTART ReceiverParameter COMMA FormalParameterList BRACEEND {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                        $$=createNode( "MethodDeclarator",v);
                    }
|   IDENTIFIER BRACESTART BRACEEND Dims {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "MethodDeclarator",v);
                    }
|   IDENTIFIER BRACESTART FormalParameterList BRACEEND Dims {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "MethodDeclarator",v);
                    }
|   IDENTIFIER BRACESTART ReceiverParameter COMMA BRACEEND Dims {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                        $$=createNode( "MethodDeclarator",v);
                    }
|   IDENTIFIER BRACESTART ReceiverParameter COMMA FormalParameterList BRACEEND Dims {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "MethodDeclarator",v);
                    }

ReceiverParameter:
    UnannType THIS {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "ReceiverParameter",v);
                    }
|   UnannType IDENTIFIER PERIOD THIS {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "ReceiverParameter",v);
                    }

FormalParameterList:
    FormalParameter { $$ = $1; }
|   FormalParameterList COMMA FormalParameter {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "FormalParameterList",v);
                    }

FormalParameter:
    UnannType VariableDeclaratorId {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "FormalParameter",v);
                    }
|   VariableModifier0 UnannType VariableDeclaratorId {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "FormalParameter",v);
                    }
|   VariableArityParameter { $$ = $1; }

VariableArityParameter:
    UnannType ELLIPSIS IDENTIFIER {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "VariableArityParameter",v);
                    }
|   VariableModifier0 UnannType ELLIPSIS IDENTIFIER {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "VariableArityParameter",v);
                    }

VariableModifier0: 
    VariableModifier { $$ = $1; }
|   VariableModifier0 VariableModifier {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "VariableModifier0",v);
                    }

VariableModifier:
    FINAL { $$ = $1; }

Throws:
    THROWS ExceptionTypeList {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "Throws",v);
                    }

ExceptionTypeList:
    ExceptionType { $$ = $1; }
|   ExceptionTypeList COMMA ExceptionType {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "ExceptionTypeList",v);
                    }

ExceptionType:
    ClassType { $$ = $1; }

MethodBody:
    Block  { $$ = $1; }
|   SEMICOLON  { $$ = $1; }

InstanceInitializer:
    Block  { $$ = $1; }

StaticInitializer:
    STATIC Block {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "StaticInitializer",v);
                    }

ConstructorDeclaration: 
    ConstructorDeclarator ConstructorBody {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "ConstructorDeclaration",v);
                    }
|   ConstructorDeclarator Throws ConstructorBody {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "ConstructorDeclaration",v);
                    }
|   ConstructorModifier ConstructorDeclarator ConstructorBody {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "ConstructorDeclaration",v);
                    }
|   ConstructorModifier ConstructorDeclarator Throws ConstructorBody {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "ConstructorDeclaration",v);
                    }

ConstructorModifier:
    PUBLIC  { $$ = $1; }
|   PROTECTED  { $$ = $1; }
|   PRIVATE  { $$ = $1; }

ConstructorDeclarator:
    SimpleTypeName BRACESTART BRACEEND  {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   SimpleTypeName BRACESTART ReceiverParameter COMMA BRACEEND {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   SimpleTypeName BRACESTART FormalParameterList BRACEEND {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   SimpleTypeName BRACESTART ReceiverParameter COMMA FormalParameterList BRACEEND {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   TypeParameters SimpleTypeName BRACESTART BRACEEND {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   TypeParameters SimpleTypeName BRACESTART ReceiverParameter COMMA BRACEEND {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   TypeParameters SimpleTypeName BRACESTART FormalParameterList BRACEEND {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   TypeParameters SimpleTypeName BRACESTART ReceiverParameter COMMA FormalParameterList BRACEEND {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "ConstructorDeclarator",v);
                    }

SimpleTypeName:
    TypeIdentifier  { $$ = $1; }

ConstructorBody:
    CURLYBRACESTART CURLYBRACEEND 
|   CURLYBRACESTART BlockStatements CURLYBRACEEND {
                        vector<Node*> v{$2};
                        $$=createNode( "ConstructorBody",v);
                    }
|   CURLYBRACESTART ExplicitConstructorInvocation CURLYBRACEEND  {
                        vector<Node*> v{$2};
                        $$=createNode( "ConstructorBody",v);
                    }
|   CURLYBRACESTART ExplicitConstructorInvocation BlockStatements CURLYBRACEEND  {
                        vector<Node*> v{$2,$3};
                        $$=createNode( "ConstructorBody",v);
                    }

ExplicitConstructorInvocation:
    THIS BRACESTART BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   SUPER BRACESTART BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   IDENTIFIER PERIOD SUPER BRACESTART BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   ExpressionName PERIOD SUPER BRACESTART BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   Primary PERIOD SUPER BRACESTART BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   TypeArguments THIS BRACESTART BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   TypeArguments SUPER BRACESTART BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   IDENTIFIER PERIOD TypeArguments SUPER BRACESTART BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   ExpressionName PERIOD TypeArguments SUPER BRACESTART BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   Primary PERIOD TypeArguments SUPER BRACESTART BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   THIS BRACESTART ArgumentList BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   SUPER BRACESTART ArgumentList BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   IDENTIFIER PERIOD SUPER BRACESTART ArgumentList BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   ExpressionName PERIOD SUPER BRACESTART ArgumentList BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   Primary PERIOD SUPER BRACESTART ArgumentList BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   TypeArguments THIS BRACESTART ArgumentList BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   TypeArguments SUPER BRACESTART ArgumentList BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   IDENTIFIER PERIOD TypeArguments SUPER BRACESTART ArgumentList BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   ExpressionName PERIOD TypeArguments SUPER BRACESTART ArgumentList BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }
|   Primary PERIOD TypeArguments SUPER BRACESTART ArgumentList BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8};
                        $$=createNode( "ExplicitConstructorInvocation",v);
                    }

EnumDeclaration:
    ENUM TypeIdentifier EnumBody {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "EnumDeclaration",v);
                    }
|   ClassModifier0 ENUM TypeIdentifier EnumBody {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "EnumDeclaration",v);
                    }

EnumBody:
    CURLYBRACESTART COMMA CURLYBRACEEND {
                        vector<Node*> v{$2};
                        $$=createNode( "EnumBody",v);
                    }
|   CURLYBRACESTART CURLYBRACEEND
|   CURLYBRACESTART COMMA EnumBodyDeclarations CURLYBRACEEND {
                        vector<Node*> v{$2,$3};
                        $$=createNode( "EnumBody",v);
                    }
|   CURLYBRACESTART EnumBodyDeclarations CURLYBRACEEND {
                        vector<Node*> v{$2};
                        $$=createNode( "EnumBody",v);
                    }
|   CURLYBRACESTART EnumConstantList COMMA CURLYBRACEEND {
                        vector<Node*> v{$2,$3};
                        $$=createNode( "EnumBody",v);
                    }
|   CURLYBRACESTART EnumConstantList CURLYBRACEEND {
                        vector<Node*> v{$2};
                        $$=createNode( "EnumBody",v);
                    }
|   CURLYBRACESTART EnumConstantList COMMA EnumBodyDeclarations CURLYBRACEEND {
                        vector<Node*> v{$2,$3,$4};
                        $$=createNode( "EnumBody",v);
                    }
|   CURLYBRACESTART EnumConstantList EnumBodyDeclarations CURLYBRACEEND {
                        vector<Node*> v{$2,$3};
                        $$=createNode( "EnumBody",v);
                    }

EnumConstantList:
    EnumConstant { $$ = $1; }
|   EnumConstantList COMMA EnumConstant {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "EnumConstantList",v);
                    }

EnumConstant:
    IDENTIFIER  { $$ = $1; }
|   IDENTIFIER PArgumentList {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "EnumConstant",v);
                    }
|   IDENTIFIER ClassBody {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "EnumConstant",v);
                    }
|   IDENTIFIER PArgumentList ClassBody {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "EnumConstant",v);
                    }

PArgumentList:
    BRACESTART BRACEEND {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "PArgumentList",v);
                    }
|   BRACESTART ArgumentList BRACEEND {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "PArgumentList",v);
                    }

EnumBodyDeclarations:
    SEMICOLON ClassBodyDeclaration0 {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "EnumBodyDeclarations",v);
                    }

RecordDeclaration:
    RECORD TypeIdentifier RecordHeader RecordBody  {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "RecordDeclaration",v);
                    }
|   RECORD TypeIdentifier TypeParameters RecordHeader RecordBody {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "RecordDeclaration",v);
                    }
|   ClassModifier0 RECORD TypeIdentifier RecordHeader RecordBody {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "RecordDeclaration",v);
                    }
|   ClassModifier0 RECORD TypeIdentifier TypeParameters RecordHeader RecordBody {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                        $$=createNode( "RecordDeclaration",v);
                    }

RecordHeader:
    BRACESTART BRACEEND {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "RecordHeader",v);
                    }
|   BRACESTART RecordComponentList BRACEEND {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "RecordHeader",v);
                    }

RecordComponentList:
    RecordComponent {
                        vector<Node*> v{$1};
                        $$=createNode( "RecordComponentList",v);
                    }
|   RecordComponentList COMMA RecordComponent {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "RecordComponentList",v);
                    }

RecordComponent:
    UnannType IDENTIFIER {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "RecordComponent",v);
                    }
|   VariableArityRecordComponent {
                        vector<Node*> v{$1};
                        $$=createNode( "RecordComponent",v);
                    }

VariableArityRecordComponent:
    UnannType ELLIPSIS IDENTIFIER {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "VariableArityRecordComponent", v );
                    }

RecordBody:
    CURLYBRACESTART CURLYBRACEEND  {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "RecordBody", v );
                    }
|   CURLYBRACESTART RecordBodyDeclaration0 CURLYBRACEEND {
                        vector<Node*> v{$2};
                        $$=createNode( "RecordBody", v );
                    }

RecordBodyDeclaration0:
    RecordBodyDeclaration { $$ = $1; }
|   RecordBodyDeclaration0 RecordBodyDeclaration {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "RecordBodyDeclaration0", v );
                    }

RecordBodyDeclaration:
    ClassBodyDeclaration  { $$ = $1; }
|   CompactConstructorDeclaration  { $$ = $1; }
    
CompactConstructorDeclaration:
    SimpleTypeName ConstructorBody {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "CompactConstructorDeclaration", v );
                    }
|   ConstructorModifier SimpleTypeName ConstructorBody {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "CompactConstructorDeclaration", v );
                    }

Block: 
    CURLYBRACESTART CURLYBRACEEND 
|   CURLYBRACESTART BlockStatements CURLYBRACEEND {
                        vector<Node*> v{$2};
                        $$=createNode( "Block", v );
                    }

BlockStatements: 
    BlockStatement { $$ = $1; }
|   BlockStatement BlockStatements {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "BlockStatements", v );
                    }

BlockStatement:
    LocalClassOrInterfaceDeclaration  { $$ = $1; }
|   LocalVariableDeclarationStatement  { $$ = $1; }
|   Statement  { $$ = $1; }

LocalClassOrInterfaceDeclaration:
    ClassDeclaration  { $$ = $1; }

LocalVariableDeclarationStatement:
    LocalVariableDeclaration SEMICOLON {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "LocalVariableDeclarationStatement", v );
                    }


LocalVariableDeclaration:
    LocalVariableType VariableDeclaratorList {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "LocalVariableDeclaration", v );
                    }
|   VariableModifier0 LocalVariableType VariableDeclaratorList {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "LocalVariableDeclaration", v );
                    }


LocalVariableType:
    UnannType  { $$ = $1; }
|   VAR  { $$ = $1; }

Statement:  
    StatementWithoutTrailingSubstatement  { $$ = $1; }
|   LabeledStatement  { $$ = $1; }
|   IfThenStatement  { $$ = $1; }
|   IfThenElseStatement  { $$ = $1; }
|   WhileStatement  { $$ = $1; }
|   ForStatement  { $$ = $1; }

StatementNoShortIf:
    StatementWithoutTrailingSubstatement  { $$ = $1; }
|   LabeledStatementNoShortIf  { $$ = $1; }
|   IfThenElseStatementNoShortIf  { $$ = $1; }
|   WhileStatementNoShortIf  { $$ = $1; }
|   ForStatementNoShortIf  { $$ = $1; }

StatementWithoutTrailingSubstatement:
    Block  { $$ = $1; }
|   EmptyStatement  { $$ = $1; }
|   ExpressionStatement  { $$ = $1; }
|   AssertStatement  { $$ = $1; }
|   SwitchStatement  { $$ = $1; }
|   DoStatement  { $$ = $1; }
|   BreakStatement  { $$ = $1; }
|   ContinueStatement  { $$ = $1; }
|   ReturnStatement  { $$ = $1; }
|   SynchronizedStatement  { $$ = $1; }
|   ThrowStatement  { $$ = $1; }
|   TryStatement  { $$ = $1; }
|   YieldStatement  { $$ = $1; }

EmptyStatement: SEMICOLON  { $$ = $1; }

LabeledStatement:
    IDENTIFIER COLON Statement {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "LabeledStatement", v );
                    }

LabeledStatementNoShortIf:
    IDENTIFIER COLON StatementNoShortIf {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "LabeledStatementNoShortIf", v );
                    }

ExpressionStatement:
    StatementExpression SEMICOLON   {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "ExpressionStatement", v );
                    }

StatementExpression:
    Assignment  { $$ = $1; }
|   PreIncrementExpression  { $$ = $1; }
|   PreDecrementExpression  { $$ = $1; }
|   PostIncrementExpression  { $$ = $1; }
|   PostDecrementExpression  { $$ = $1; }
|   MethodInvocation  { $$ = $1; }
|   ClassInstanceCreationExpression  { $$ = $1; }

IfThenStatement:
    IF BRACESTART Expression BRACEEND Statement {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "IfThenStatement", v );
                    }

IfThenElseStatement:
    IF BRACESTART Expression BRACEEND StatementNoShortIf ELSE Statement {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "IfThenElseStatement", v );
                    }

IfThenElseStatementNoShortIf:
    IF BRACESTART Expression BRACEEND StatementNoShortIf ELSE StatementNoShortIf {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "IfThenElseStatementNoShortIf", v );
                    }

AssertStatement:
    ASSERT Expression SEMICOLON {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "AssertStatement", v );
                    }
|   ASSERT Expression COLON Expression SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "AssertStatement", v );
                    }

SwitchStatement:
    SWITCH BRACESTART Expression BRACEEND SwitchBlock {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "SwitchStatement", v );
                    }

SwitchBlock:
    CURLYBRACESTART SwitchRule0 CURLYBRACEEND {
                        vector<Node*> v{$2};
                        $$=createNode( "SwitchBlock", v );
                    }
|   CURLYBRACESTART CURLYBRACEEND
|   CURLYBRACESTART SwitchBlockStatementGroup0 CURLYBRACEEND {
                        vector<Node*> v{$2};
                        $$=createNode( "SwitchBlock", v );
                    }
|   CURLYBRACESTART SwitchBlockStatementGroup0 SwitchColonLabel0 CURLYBRACEEND {
                        vector<Node*> v{$2,$3};
                        $$=createNode( "SwitchBlock", v );
                    }

SwitchRule0:
    SwitchRule  { $$ = $1; }
|   SwitchRule0 SwitchRule {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "SwitchRule0", v );
                    }

SwitchBlockStatementGroup0: 
    SwitchBlockStatementGroup  { $$ = $1; }
|   SwitchBlockStatementGroup0 SwitchBlockStatementGroup {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "SwitchBlockStatementGroup0", v );
                    }

SwitchColonLabel0:
    SwitchLabel COLON {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "SwitchColonLabel0", v );
                    }
|   SwitchColonLabel0 SwitchLabel COLON {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "SwitchColonLabel0", v );
                    }

SwitchRule:
    SwitchLabel PTR Expression SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "SwitchRule", v );
                    }
|   SwitchLabel PTR Block {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "SwitchRule", v );
                    }
|   SwitchLabel PTR ThrowStatement {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "SwitchRule", v );
                    }

SwitchBlockStatementGroup:
    SwitchColonLabel0 
|   SwitchLabel COLON BlockStatements {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "SwitchBlockStatementGroup", v );
                    }
|   SwitchLabel COLON SwitchColonLabel0 BlockStatements {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "SwitchBlockStatementGroup", v );
                    }

SwitchLabel:
    CASE CaseConstant {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "SwitchLabel", v );
                    }
|   CommaCaseConstant0 CASE CaseConstant {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "SwitchLabel", v );
                    }
|   DEFAULT

CommaCaseConstant0:
    COMMA CaseConstant {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "CommaCaseConstant0", v );
                    }
|   CommaCaseConstant0 COMMA CaseConstant {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "CommaCaseConstant0", v );
                    }

CaseConstant:
ConditionalExpression  { $$ = $1; }

WhileStatement:
WHILE BRACESTART Expression BRACEEND Statement {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "WhileStatement", v );
                    }

WhileStatementNoShortIf:
WHILE BRACESTART Expression BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "WhileStatementNoShortIf", v );
                    }

DoStatement:
DO Statement WHILE BRACESTART Expression BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "DoStatement", v );
                    }

ForStatement:
    BasicForStatement  { $$ = $1; }
|   EnhancedForStatement  { $$ = $1; }

ForStatementNoShortIf:
    BasicForStatementNoShortIf  { $$ = $1; }
|   EnhancedForStatementNoShortIf  { $$ = $1; }

BasicForStatement:
    FOR BRACESTART SEMICOLON SEMICOLON BRACEEND Statement {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                        $$=createNode( "BasicForStatement", v );
                    }
|   FOR BRACESTART ForInit SEMICOLON SEMICOLON BRACEEND Statement {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "BasicForStatement", v );
                    }
|   FOR BRACESTART SEMICOLON Expression SEMICOLON BRACEEND Statement {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "BasicForStatement", v );
                    }
|   FOR BRACESTART ForInit SEMICOLON Expression SEMICOLON BRACEEND Statement {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8};
                        $$=createNode( "BasicForStatement", v );
                    }
|   FOR BRACESTART SEMICOLON SEMICOLON ForUpdate BRACEEND Statement {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "BasicForStatement", v );
                    }
|   FOR BRACESTART ForInit SEMICOLON SEMICOLON ForUpdate BRACEEND Statement {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8};
                        $$=createNode( "BasicForStatement", v );
                    }
|   FOR BRACESTART SEMICOLON Expression SEMICOLON ForUpdate BRACEEND Statement {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8};
                        $$=createNode( "BasicForStatement", v );
                    }
|   FOR BRACESTART ForInit SEMICOLON Expression SEMICOLON ForUpdate BRACEEND Statement {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8,$9};
                        $$=createNode( "BasicForStatement", v );
                    }

BasicForStatementNoShortIf:
    FOR BRACESTART SEMICOLON SEMICOLON BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                        $$=createNode( "BasicForStatementNoShortIf", v );
                    }
|   FOR BRACESTART ForInit  SEMICOLON SEMICOLON BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "BasicForStatementNoShortIf", v );
                    }
|   FOR BRACESTART SEMICOLON Expression SEMICOLON BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "BasicForStatementNoShortIf", v );
                    }
|   FOR BRACESTART ForInit  SEMICOLON Expression SEMICOLON BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8};
                        $$=createNode( "BasicForStatementNoShortIf", v );
                    }
|   FOR BRACESTART SEMICOLON SEMICOLON ForUpdate BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "BasicForStatementNoShortIf", v );
                    }
|   FOR BRACESTART ForInit  SEMICOLON SEMICOLON ForUpdate BRACEEND StatementNoShortIf  {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8};
                        $$=createNode( "BasicForStatementNoShortIf", v );
                    }
|   FOR BRACESTART SEMICOLON Expression SEMICOLON ForUpdate BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8};
                        $$=createNode( "BasicForStatementNoShortIf", v );
                    }
|   FOR BRACESTART ForInit  SEMICOLON Expression SEMICOLON ForUpdate BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8,$9};
                        $$=createNode( "BasicForStatementNoShortIf", v );
                    }


ForInit:
    StatementExpressionList
|   LocalVariableDeclaration

ForUpdate:
StatementExpressionList

StatementExpressionList:
    StatementExpression
|   StatementExpression CommaStatExp0 {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "StatementExpressionList", v );
                    }

CommaStatExp0: 
    COMMA StatementExpression {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "CommaStatExp0", v );
                    }
|   CommaStatExp0 COMMA StatementExpression {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "CommaStatExp0", v );
                    }

EnhancedForStatement:
FOR BRACESTART LocalVariableDeclaration COLON Expression BRACEEND Statement {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "EnhancedForStatement", v );
                    }

EnhancedForStatementNoShortIf:
FOR BRACESTART LocalVariableDeclaration COLON Expression BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                        $$=createNode( "EnhancedForStatement", v );
                    }

BreakStatement: 
    BREAK SEMICOLON  {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "BreakStatement", v );
                    }
|   BREAK IDENTIFIER SEMICOLON  {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "BreakStatement", v );
                    }

YieldStatement:
YIELD Expression SEMICOLON {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "YieldStatement", v );
                    }

ContinueStatement: 
    CONTINUE SEMICOLON {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "ContinueStatement", v );
                    }
|   CONTINUE IDENTIFIER SEMICOLON {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "ContinueStatement", v );
                    }

ReturnStatement: 
    RETURN SEMICOLON  {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "ReturnStatement", v );
                    }
|   RETURN Expression SEMICOLON {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "ReturnStatement", v );
                    }

ThrowStatement:
THROW Expression SEMICOLON {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "ThrowStatement", v );
                    }

SynchronizedStatement:
SYNCHRONIZED BRACESTART Expression BRACEEND Block  {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "SynchronizedStatement", v );
                    }

TryStatement:
    TRY Block Catches {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "TryStatement", v );
                    }
|   TRY Block Finally {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "TryStatement", v );
                    }
|   TRY Block Catches Finally {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "TryStatement", v );
                    }
|   TryWithResourcesStatement 

Catches:
    CatchClause 
|   CatchClause Catches {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "Catches", v );
                    }

CatchClause:
CATCH BRACESTART CatchFormalParameter BRACEEND Block {
                        vector<Node*> v{$1,$2,$3,$4,$5};
                        $$=createNode( "CatchClause", v );
                    }

CatchFormalParameter:
    CatchType VariableDeclaratorId {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "CatchFormalParameter", v );
                    }
|   VariableModifier0 CatchType VariableDeclaratorId {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "CatchFormalParameter", v );
                    }

CatchType:
    UnannClassType
|   UnannClassType BarClassType0 {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "CatchType", v );
                    }


BarClassType0:
    OR ClassType {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "BarClassType0", v );
                    }
|   BarClassType0 OR ClassType  {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "BarClassType0", v );
                    }

Finally:
FINALLY Block {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "Finally", v );
                }

TryWithResourcesStatement:
    TRY ResourceSpecification Block  {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "TryWithResourcesStatement", v );
                }
|   TRY ResourceSpecification Block Catches  {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "TryWithResourcesStatement", v );
                }
|   TRY ResourceSpecification Block Finally {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "TryWithResourcesStatement", v );
                }
|   TRY ResourceSpecification Block Catches Finally {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "TryWithResourcesStatement", v );
                }

ResourceSpecification:
    BRACESTART IDENTIFIER BRACEEND {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ResourceSpecification", v );
                }
|   BRACESTART IDENTIFIER SEMICOLON BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ResourceSpecification", v );
                }
|   BRACESTART ResourceList BRACEEND  {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ResourceSpecification", v );
                }
|   BRACESTART ResourceList SEMICOLON BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ResourceSpecification", v );
                }

ResourceList:
    IDENTIFIER SemicolonResource0  {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "ResourceList", v );
                }
|   Resource
|   Resource SemicolonResource0 {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "ResourceList", v );
                }

SemicolonResource0: 
    SEMICOLON IDENTIFIER {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "SemicolonResource0", v );
                }
|   SemicolonResource0 SEMICOLON IDENTIFIER {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "SemicolonResource0", v );
                }
|   SEMICOLON Resource  {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "SemicolonResource0", v );
                }
|   SemicolonResource0 SEMICOLON Resource {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "SemicolonResource0", v );
                } 

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
    IDENTIFIER PERIOD IDENTIFIER {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ExpressionName", v );
                }
|   ExpressionName PERIOD IDENTIFIER {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ExpressionName", v );
                }

FieldAccess:
    Primary PERIOD IDENTIFIER {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "FieldAccess", v );
                }
|   SUPER PERIOD IDENTIFIER {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "FieldAccess", v );
                }
|   TypeName PERIOD SUPER PERIOD IDENTIFIER {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "FieldAccess", v );
                }

Primary:
    PrimaryNoNewArray
|   ArrayCreationExpression

PrimaryNoNewArray:
    LITERAL
|   ClassLiteral
|   THIS
|   TypeName PERIOD THIS {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "PrimaryNoNewArray", v );
                }
|   BRACESTART Expression BRACEEND {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "PrimaryNoNewArray", v );
                }
|   ClassInstanceCreationExpression
|   FieldAccess
|   ArrayAccess
|   MethodInvocation
|   MethodReference

ClassLiteral:
    TypeName PERIOD CLASS {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ClassLiteral", v );
                }
|   NumericType PERIOD CLASS {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ClassLiteral", v );
                }
|   BOOLEAN PERIOD CLASS {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ClassLiteral", v );
                }
|   TypeName SquareBracePeriod CLASS {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ClassLiteral", v );
                }
|   NumericType SquareBracePeriod CLASS {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ClassLiteral", v );
                }
|   BOOLEAN SquareBracePeriod CLASS {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ClassLiteral", v );
                }
|   VOID PERIOD CLASS {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ClassLiteral", v );
                }

SquareBracePeriod:
    SquareBrace0 PERIOD {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "SquareBracePeriod", v );
                }

SquareBrace0:
    SQUAREBRACESTART SQUAREBRACEEND {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "SquareBrace0", v );
                }
|   SquareBrace0 SQUAREBRACESTART SQUAREBRACEEND  {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "SquareBrace0", v );
                } 

ClassInstanceCreationExpression:
    UnqualifiedClassInstanceCreationExpression
|   IDENTIFIER PERIOD UnqualifiedClassInstanceCreationExpression {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ClassInstanceCreationExpression", v );
                } 
|   ExpressionName PERIOD UnqualifiedClassInstanceCreationExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( ".", v );
                } 
|   Primary PERIOD UnqualifiedClassInstanceCreationExpression {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ClassInstanceCreationExpression", v );
                } 

UnqualifiedClassInstanceCreationExpression:
    NEW ClassOrInterfaceTypeToInstantiate BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW ClassOrInterfaceTypeToInstantiate BRACESTART BRACEEND ClassBody {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW ClassOrInterfaceTypeToInstantiate BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW ClassOrInterfaceTypeToInstantiate BRACESTART ArgumentList BRACEEND ClassBody {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW TypeArguments ClassOrInterfaceTypeToInstantiate BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW TypeArguments ClassOrInterfaceTypeToInstantiate BRACESTART BRACEEND ClassBody {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW TypeArguments ClassOrInterfaceTypeToInstantiate BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW TypeArguments ClassOrInterfaceTypeToInstantiate BRACESTART ArgumentList BRACEEND ClassBody {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 

ClassOrInterfaceTypeToInstantiate:
    IDENTIFIER 
|   IDENTIFIER TypeArgumentsOrDiamond {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "ClassOrInterfaceTypeToInstantiate", v );
                } 
    
TypeArgumentsOrDiamond:
    TypeArguments
|   LESSER GREATER {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "TypeArgumentsOrDiamond", v );
                } 

ArrayAccess:
    IDENTIFIER SQUAREBRACESTART Expression SQUAREBRACEEND {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ArrayAccess", v );
                } 
|   ExpressionName SQUAREBRACESTART Expression SQUAREBRACEEND {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ArrayAccess", v );
                } 
|   PrimaryNoNewArray SQUAREBRACESTART Expression SQUAREBRACEEND {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ArrayAccess", v );
                } 

MethodInvocation:
    MethodNameBrace BRACEEND {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "MethodInvocation", v );
                } 
|   IDENTIFIER PERIOD IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "MethodInvocation", v );
                } 
|   ExpressionName PERIOD IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "MethodInvocation", v );
                } 
|   Primary PERIOD IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "MethodInvocation", v );
                } 
|   SUPER PERIOD IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD SUPER PERIOD IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   IDENTIFIER PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   ExpressionName PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   Primary PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   SUPER PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD SUPER PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8};
                    $$=createNode( "MethodInvocation", v );
                } 
|   MethodNameBrace ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   IDENTIFIER PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   ExpressionName PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   Primary PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   SUPER PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD SUPER PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                    $$=createNode( "MethodInvocation", v );
                } 
|   IDENTIFIER PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                    $$=createNode( "MethodInvocation", v );
                } 
|   ExpressionName PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                    $$=createNode( "MethodInvocation", v );
                } 
|   Primary PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                    $$=createNode( "MethodInvocation", v );
                } 
|   SUPER PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6,$7};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD SUPER PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8,$9};
                    $$=createNode( "MethodInvocation", v );
                } 

MethodNameBrace:
    IDENTIFIER BRACESTART {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "MethodNameBrace", v );
                } 
|   MethodName BRACESTART  {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "MethodNameBrace", v );
                } 

ArgumentList:
    Expression
|   Expression CommaExpression0 {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "ArgumentList", v );
                } 
    
CommaExpression0:
    COMMA Expression  {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "CommaExpression0", v );
                } 
|   CommaExpression0 COMMA Expression  {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "CommaExpression0", v );
                } 
  
    
MethodReference: 
    IDENTIFIER SCOPE IDENTIFIER {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MethodReference", v );
                } 
|   ExpressionName SCOPE IDENTIFIER {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MethodReference", v );
                } 
|   Primary SCOPE IDENTIFIER {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MethodReference", v );
                } 
|   ReferenceType SCOPE IDENTIFIER {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MethodReference", v );
                } 
|   SUPER SCOPE IDENTIFIER {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MethodReference", v );
                } 
|   TypeName PERIOD SUPER SCOPE IDENTIFIER {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "MethodReference", v );
                } 
|   ClassType SCOPE NEW {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MethodReference", v );
                } 
|   ArrayType SCOPE NEW {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MethodReference", v );
                } 
|   IDENTIFIER SCOPE TypeArguments IDENTIFIER {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "MethodReference", v );
                } 
|   ExpressionName SCOPE TypeArguments IDENTIFIER {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "MethodReference", v );
                } 
|   Primary SCOPE TypeArguments IDENTIFIER {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "MethodReference", v );
                } 
|   ReferenceType SCOPE TypeArguments IDENTIFIER {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "MethodReference", v );
                } 
|   SUPER SCOPE TypeArguments IDENTIFIER  {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "MethodReference", v );
                } 
|   TypeName PERIOD SUPER SCOPE TypeArguments IDENTIFIER {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "MethodReference", v );
                } 
|   ClassType SCOPE TypeArguments NEW {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "MethodReference", v );
                } 

ArrayCreationExpression:
    NEW BOOLEAN DimExprs {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ArrayCreationExpression", v );
                } 
|   NEW PrimitiveType DimExprs {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ArrayCreationExpression", v );
                } 
|   NEW ClassOrInterfaceType DimExprs {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ArrayCreationExpression", v );
                } 
|   NEW BOOLEAN DimExprs Dims {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ArrayCreationExpression", v );
                } 
|   NEW PrimitiveType DimExprs Dims {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ArrayCreationExpression", v );
                } 
|   NEW ClassOrInterfaceType DimExprs Dims {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ArrayCreationExpression", v );
                } 
|   NEW BOOLEAN Dims ArrayInitializer {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ArrayCreationExpression", v );
                } 
|   NEW PrimitiveType Dims ArrayInitializer {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ArrayCreationExpression", v );
                } 
|   NEW ClassOrInterfaceType Dims ArrayInitializer {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ArrayCreationExpression", v );
                } 

DimExprs:
    DimExpr
|   DimExprs DimExpr {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "DimExprs", v );
                } 

DimExpr:
    SQUAREBRACESTART Expression SQUAREBRACEEND {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "DimExpr", v );
                } 

Expression:
    LambdaExpression
|   AssignmentExpression

LambdaExpression:
    IDENTIFIER PTR LambdaBody {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "LambdaExpression", v );
                } 
|   LambdaParameters PTR LambdaBody  {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "LambdaExpression", v );
                } 
    
LambdaParameters:
    BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "LambdaParameterList", v );
                } 
|   BRACESTART LambdaParameterList BRACEEND {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "LambdaParameterList", v );
                } 
    
LambdaParameterList:
    LambdaParameter
|   LambdaParameter CommaLambdaParameter0 {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "LambdaParameterList", v );
                } 
|   IDENTIFIER
|   IDENTIFIER CommaIdentifier0 {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "LambdaParameterList", v );
                } 

CommaLambdaParameter0:
    COMMA LambdaParameter  {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "CommaLambdaParameter0", v );
                } 
|   CommaLambdaParameter0 COMMA LambdaParameter  {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "CommaLambdaParameter0", v );
                } 
   
CommaIdentifier0:
    COMMA IDENTIFIER {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "CommaIdentifier0", v );
                } 
|   CommaIdentifier0 COMMA IDENTIFIER {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "CommaIdentifier0", v );
                } 
 
LambdaParameter:
    LambdaParameterType VariableDeclaratorId {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "LambdaParameter", v );
                } 
|   VariableModifier0 LambdaParameterType VariableDeclaratorId {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "LambdaParameter", v );
                } 
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
   IDENTIFIER ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "=", v );
                } 
|   IDENTIFIER MUL_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "*=", v );
                } 
|   IDENTIFIER DIV_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "/=", v );
                } 
|   IDENTIFIER MOD_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "%=", v );
                } 
|   IDENTIFIER ADD_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "+=", v );
                } 
|   IDENTIFIER SUB_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "-=", v );
                } 
|   IDENTIFIER RSHIFT_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( ">>=", v );
                } 
|   IDENTIFIER LSHIFT_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "<<=", v );
                } 
|   IDENTIFIER AND_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "&=", v );
                }
|   IDENTIFIER XOR_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "^=", v );
                }
|   IDENTIFIER OR_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "|=", v );
                }
|   IDENTIFIER URSHIFT_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( ">>>=", v );
                } 
|   LeftHandSide ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "=", v );
                } 
|   LeftHandSide MUL_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "*=", v );
                } 
|   LeftHandSide DIV_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "/=", v );
                } 
|   LeftHandSide MOD_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "%=", v );
                } 
|   LeftHandSide ADD_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "+=", v );
                } 
|   LeftHandSide SUB_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "-=", v );
                } 
|   LeftHandSide RSHIFT_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( ">>=", v );
                } 
|   LeftHandSide LSHIFT_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "<<=", v );
                } 
|   IDENTIFIER AND_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "&=", v );
                }
|   LeftHandSide XOR_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "^=", v );
                }
|   LeftHandSide OR_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "|=", v );
                }
|   LeftHandSide URSHIFT_ASSIGN Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( ">>>=", v );
                }  

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
|   ConditionalOrExpression QUESTION Expression COLON ConditionalExpression {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "ConditionalExpression", v );
                } 
|   ConditionalOrExpression QUESTION Expression COLON LambdaExpression {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "ConditionalExpression", v );
                } 

ConditionalOrExpression:
    ConditionalAndExpression
|   ConditionalOrExpression OR_OR ConditionalAndExpression {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ConditionalOrExpression", v );
                } 
    
ConditionalAndExpression:
    InclusiveOrExpression
|   ConditionalAndExpression AND_AND InclusiveOrExpression {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ConditionalAndExpression", v );
                } 

InclusiveOrExpression:
    ExclusiveOrExpression
|   InclusiveOrExpression OR ExclusiveOrExpression {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "InclusiveOrExpression", v );
                } 

ExclusiveOrExpression:
    AndExpression
|   ExclusiveOrExpression XOR AndExpression {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ExclusiveOrExpression", v );
                } 

AndExpression:
    EqualityExpression
|   AndExpression AND EqualityExpression {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "AndExpression", v );
                } 

EqualityExpression:
    RelationalExpression
|   EqualityExpression EQUAL RelationalExpression {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "EqualityExpression", v );
                } 
|   EqualityExpression NEQ RelationalExpression  {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "EqualityExpression", v );
                } 

RelationalExpression:
    ShiftExpression
|   RelationalExpression LESSER ShiftExpression  {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "<", v );
                } 
|   RelationalExpression GREATER ShiftExpression  {
                    vector<Node*> v{$1,$3};
                    $$=createNode( ">", v );
                } 
|   RelationalExpression LEQ ShiftExpression  {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "<=", v );
                } 
|   RelationalExpression GEQ ShiftExpression  {
                    vector<Node*> v{$1,$3};
                    $$=createNode( ">=", v );
                } 
|   InstanceofExpression

InstanceofExpression:
    RelationalExpression INSTANCEOF ReferenceType  {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "InstanceofExpression", v );
                } 
|   RelationalExpression INSTANCEOF Pattern {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "InstanceofExpression", v );
                } 

ShiftExpression:
    AdditiveExpression
|   ShiftExpression LSHIFT AdditiveExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "<<", v );
                } 
|   ShiftExpression RSHIFT AdditiveExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( ">>", v );
                } 
|   ShiftExpression URSHIFT AdditiveExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( ">>>", v );
                } 

AdditiveExpression:
    MultiplicativeExpression
|   AdditiveExpression ADD MultiplicativeExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "+", v );
                } 
|   AdditiveExpression SUB MultiplicativeExpression  {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "-", v );
                } 

MultiplicativeExpression:
    UnaryExpression
|   MultiplicativeExpression MUL UnaryExpression  {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MultiplicativeExpression", v );
                } 
|   MultiplicativeExpression DIV UnaryExpression {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MultiplicativeExpression", v );
                } 
|   MultiplicativeExpression MOD UnaryExpression {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MultiplicativeExpression", v );
                } 

UnaryExpression:
    PreIncrementExpression
|   PreDecrementExpression
|   ADD UnaryExpression {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "UnaryExpression", v );
                } 
|   SUB UnaryExpression {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "UnaryExpression", v );
                } 
|   UnaryExpressionNotPlusMinus

PreIncrementExpression:
    INC UnaryExpression {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "PreIncrementExpression", v );
                } 

PreDecrementExpression:
    DEC UnaryExpression {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "PreDecrementExpression", v );
                } 

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
    PostfixExpression INC {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "PostIncrementExpression", v );
                } 

PostDecrementExpression:
    PostfixExpression DEC  {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "PostDecrementExpression", v );
                } 

CastExpression:
    BRACESTART BOOLEAN BRACEEND UnaryExpression {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "CastExpression", v );
                } 
|   BRACESTART PrimitiveType BRACEEND UnaryExpression {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "CastExpression", v );
                } 
|   BRACESTART ReferenceType BRACEEND UnaryExpressionNotPlusMinus {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "CastExpression", v );
                } 
|   BRACESTART ReferenceType  BRACEEND LambdaExpression {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "CastExpression", v );
                } 

SwitchExpression:
    SWITCH BRACESTART Expression BRACEEND SwitchBlock {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "SwitchExpression", v );
                } 
    

ArrayInitializer:
    CURLYBRACESTART CURLYBRACEEND 
|   CURLYBRACESTART VariableInitializerList CURLYBRACEEND  {
                    vector<Node*> v{$2};
                    $$=createNode( "ArrayInitializer", v );
                } 
|   CURLYBRACESTART COMMA CURLYBRACEEND {
                    vector<Node*> v{$2};
                    $$=createNode( "ArrayInitializer", v );
                } 
|   CURLYBRACESTART VariableInitializerList COMMA CURLYBRACEEND {
                    vector<Node*> v{$2,$3};
                    $$=createNode( "ArrayInitializer", v );
                } 
    
VariableInitializerList:
    VariableInitializer
|   VariableInitializer CommaVariableInitializer0 {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "VariableInitializerList", v );
                } 
    
CommaVariableInitializer0:
    COMMA VariableInitializer
|   CommaVariableInitializer0 COMMA VariableInitializer  {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "CommaVariableInitializer0", v );
                } 

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
|   ClassOrInterfaceType PERIOD TypeIdentifier  {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ClassType", v );
                } 
|   TypeIdentifier TypeArguments {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "ClassType", v );
                } 
|   ClassOrInterfaceType PERIOD TypeIdentifier TypeArguments {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ClassType", v );
                } 

ArrayType:
    BOOLEAN SQUAREBRACESTART SQUAREBRACEEND  {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ArrayType", v );
                } 
|   BOOLEAN SQUAREBRACESTART SQUAREBRACEEND Dims  {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ArrayType", v );
                } 
|   PrimitiveType SQUAREBRACESTART SQUAREBRACEEND   {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ArrayType", v );
                } 
|   PrimitiveType SQUAREBRACESTART SQUAREBRACEEND Dims  {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "ArrayType", v );
                } 
|   ClassOrInterfaceType Dims  {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "ArrayType", v );
                } 

Dims:
    SQUAREBRACESTART SQUAREBRACEEND   {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "Dims", v );
                } 
|   SQUAREBRACESTART SQUAREBRACEEND Dims {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "Dims", v );
                } 

TypeParameter:
    TypeIdentifier
|   TypeIdentifier TypeBound {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "TypeParameter", v );
                } 


TypeBound:
    EXTENDS ClassOrInterfaceType  {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "TypeBound", v );
                } 

TypeArguments:
    LESSER TypeArgumentList GREATER {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "TypeArguments", v );
                } 

TypeArgumentList:
    TypeArgument
|   TypeArgument CommaTypeArgument0 {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "TypeArgumentList", v );
                } 
    
CommaTypeArgument0:
    COMMA TypeArgument {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "CommaTypeArgument0", v );
                } 
|   CommaTypeArgument0 COMMA TypeArgument     {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "CommaTypeArgument0", v );
                } 

TypeArgument:
    ReferenceType
|   Wildcard

Wildcard:
    QUESTION 
|   QUESTION WildcardBounds  {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "Wildcard", v );
                } 
    
WildcardBounds:
    EXTENDS ReferenceType  {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "WildcardBounds", v );
                } 
|   SUPER ReferenceType {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "WildcardBounds", v );
                } 

TypeName:
    TypeIdentifier
|   IDENTIFIER PERIOD TypeIdentifier {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "TypeName", v );
                } 

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

int main(int argc, char *argv[]) {
    yydebug = 1;
    yyin = fopen(argv[1],"r");
    dotfile=fopen("output.txt","w");
    fprintf(dotfile,"digraph {\n");
    yyparse();
    buildTree(root,-1,0);
    fprintf(dotfile," }\n");
    fclose(yyin);
    return 0;
}