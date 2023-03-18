%{
    #pragma once
    #include <bits/stdc++.h>
    #include "AST.cpp"
    #include "builder.cpp"
    
    extern int lineno;
    FILE* dotfile;
    extern FILE * yyin;
    extern "C" {
        int yyparse();
        int yylex(void);
        int yyerror(char* s)
        {
            printf("ERROR: %s Line Number: %d\n",s, lineno);
            return 0;
        }
    }
    
    Node* root;
    using namespace std;
    
%}
%code requires {
    #include <bits/stdc++.h>
    #include "SymbolTable.cpp"
    #include "SymbolEntry.cpp"
    #include "AST.h"
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
%type<node> SwitchRule0 BarClassType0 VariableModifier0 classmethod PArgumentList ClassOrInterfaceTypeToInstantiate

%type<node> NormalClassDeclaration EnumDeclaration TypeIdentifier ClassBody TypeParameters ClassExtends  ClassPermits ClassModifier RecordComponent VariableArityRecordComponent 
%type<node> TypeParameterList TypeNames TypeName ClassBodyDeclaration ClassMemberDeclaration InstanceInitializer  RecordBodyDeclaration CompactConstructorDeclaration
%type<node> StaticInitializer ConstructorDeclaration FieldDeclaration MethodDeclaration ClassDeclaration  UnannType VariableDeclaratorList VariableDeclarator  EnumConstantList EnumBodyDeclarations ReceiverParameter
%type<node> VariableDeclaratorId VariableInitializer UnannPrimitiveType UnannReferenceType UnannArrayType UnannClassType 
%type<node> MethodHeader MethodBody Result MethodDeclarator Throws FormalParameterList ConstructorDeclarator ConstructorBody ConstructorModifier SimpleTypeName ExplicitConstructorInvocation ExpressionName Primary ArgumentList
%type<node> FormalParameter VariableArityParameter VariableModifier ExceptionTypeList ExceptionType EnumConstant RecordDeclaration RecordHeader RecordBody RecordComponentList EnumBody

%type<node> ClassModifier0 ClassBodyDeclaration0 FieldModifier0 MethodModifier0 
%type<node>  RecordBodyDeclaration0 NormalClassDeclaration0 TypeArgumentsOrDiamond

%type<node> MethodInvocation MethodReference ArrayCreationExpression
%type<node> DimExprs DimExpr Expression LambdaExpression LambdaParameters LambdaParameterList CommaLambdaParameter0 CommaIdentifier0 LambdaParameter
%type<node> LambdaParameterType LambdaBody AssignmentExpression Assignment AssignmentOperator ConditionalExpression ConditionalOrExpression ConditionalAndExpression InclusiveOrExpression
%type<node> ExclusiveOrExpression AndExpression EqualityExpression RelationalExpression InstanceofExpression ShiftExpression AdditiveExpression MultiplicativeExpression UnaryExpression
%type<node> PreIncrementExpression PreDecrementExpression UnaryExpressionNotPlusMinus PostfixExpression PostIncrementExpression PostDecrementExpression CastExpression SwitchExpression
%type<node> ArrayInitializer VariableInitializerList PrimitiveType NumericType IntegralType FloatingPointType
%type<node> ReferenceType  ClassType ArrayType Dims TypeParameter TypeBound
%type<node> TypeArguments TypeArgumentList TypeArgument WildcardBounds TopLevelClassOrInterfaceDeclaration0 ImportDeclaration0
%type<node> MethodName LeftHandSide SquareBracePeriod StaticFinal0 fieldclassmethod
%type<node> PrimaryNoNewArray ClassLiteral SquareBrace0 ClassInstanceCreationExpression UnqualifiedClassInstanceCreationExpression 

%type<node>  CompilationUnit OrdinaryCompilationUnit TopLevelClassOrInterfaceDeclaration
%type<node> UnannClassOrInterfaceType FieldModifier MethodModifier FieldAccess ArrayAccess ClassOrInterfaceType UnqualifiedMethodIdentifier
%type<node> VariableAccess Wildcard ContextualExceptYield ContextualExceptPRS MethodNameBrace
%type<node> ImportDeclaration SingleTypeImportDeclaration TypeImportOnDemandDeclaration SingleStaticImportDeclaration StaticImportOnDemandDeclaration PackageOrTypeName

%%

CompilationUnit: {  
                    vector<Node*> v;
                    $$=createNode("CompilationUnit",v);
                    // $$->symbol_table = new SymbolTable("CompilationUnit"); 
                    root=$$;
                }
|   OrdinaryCompilationUnit {  
                                vector<Node*> v{$1};
                                $$=createNode("CompilationUnit",v);
                                // $$->symbol_table = new SymbolTable("CompilationUnit");
                                // $$->moveEntries();
                                root=$$; 
                            }

OrdinaryCompilationUnit: 
    TopLevelClassOrInterfaceDeclaration0 {
                                            vector<Node*> v{$1};
                                            $$=createNode("OrdinaryCompilationUnit",v);
                                        }
|   ImportDeclaration0 {
                            vector<Node*> v{$1};
                            $$=createNode("OrdinaryCompilationUnit",v);
                        }
|   ImportDeclaration0 TopLevelClassOrInterfaceDeclaration0  {
                                                                vector<Node*> v{$1,$2};
                                                                $$=createNode("OrdinaryCompilationUnit",v);
                                                            }

ImportDeclaration0:
    ImportDeclaration {
                        vector<Node*> v{$1};
                        $$=createNode("ImportDeclaration",v);
                    }
|   ImportDeclaration0 ImportDeclaration {
                                            vector<Node*> v($1->children);
                                            v.push_back($2);
                                            $$=createNode( $1->val,v);
                                        }

TopLevelClassOrInterfaceDeclaration0:
    TopLevelClassOrInterfaceDeclaration {
                        vector<Node*> v{$1};
                        $$=createNode("TopLevelClassOrInterfaceDeclaration",v);
                    }
|   TopLevelClassOrInterfaceDeclaration0 TopLevelClassOrInterfaceDeclaration {
                           vector<Node*> v($1->children);
                            v.push_back($2);
                            $$=createNode( $1->val,v);
                        }

ImportDeclaration:
    SingleTypeImportDeclaration { $$=$1;}
|   TypeImportOnDemandDeclaration { $$=$1;}
|   SingleStaticImportDeclaration { $$=$1;}
|   StaticImportOnDemandDeclaration { $$=$1;}

SingleTypeImportDeclaration:
    IMPORT TypeName SEMICOLON {
                                    vector<Node*> v{$1,$2};
                                    $$=createNode("SingleTypeImportDeclaration",v);
                                }

TypeImportOnDemandDeclaration:
    IMPORT IDENTIFIER PERIOD MUL SEMICOLON {
                                    vector<Node*> v{$1,$2,$3,$4};
                                    $$=createNode("TypeImportOnDemandDeclaration",v);
                                }
|   IMPORT PackageOrTypeName PERIOD MUL SEMICOLON {
                                    vector<Node*> v{$1,$2,$3,$4};
                                    $$=createNode("TypeImportOnDemandDeclaration",v);
                                }


SingleStaticImportDeclaration:
    IMPORT STATIC TypeName PERIOD IDENTIFIER SEMICOLON {
                                    vector<Node*> v{$1,$2,$3,$4,$5};
                                    $$=createNode("SingleStaticImportDeclaration",v);
                                }

StaticImportOnDemandDeclaration:
    IMPORT STATIC TypeName PERIOD MUL SEMICOLON {
                                    vector<Node*> v{$1,$2,$3,$4,$5};
                                    $$=createNode("StaticImportOnDemandDeclaration",v);
                                }

TopLevelClassOrInterfaceDeclaration:
    ClassDeclaration {  $$=$1; }
|   StaticFinal0 NormalClassDeclaration {
                            vector<Node*> v{$1->children};
                            v.insert(v.end(),$2->children.begin(),$2->children.end());
                            $$=createNode($2->val,v);
                        }
|   ABSTRACT NormalClassDeclaration {
                            vector<Node*> v{$1};
                            v.insert(v.end(),$2->children.begin(),$2->children.end());
                            $$=createNode($2->val,v);
                        }
|   ConstructorModifier StaticFinal0 NormalClassDeclaration {
                            vector<Node*> v{$1,$2};
                            v.insert(v.end(),$3->children.begin(),$3->children.end());
                            $$=createNode($3->val,v);
                        }
|   ConstructorModifier ABSTRACT NormalClassDeclaration{
                            vector<Node*> v{$1,$2};
                            v.insert(v.end(),$3->children.begin(),$3->children.end());
                            $$=createNode($3->val,v);
                        }
|   SEMICOLON {  $$=$1; }

ClassDeclaration:
    NormalClassDeclaration {  $$=$1; }
|   EnumDeclaration {  $$=$1; }
|   RecordDeclaration {  $$=$1; }

NormalClassDeclaration:
    NormalClassDeclaration0 { 
                                vector<Node*> v{$1};
                                $$=createNode("NormalClassDeclaration",v); 
                            }
|   ClassModifier0 NormalClassDeclaration0 {
                                                vector<Node*> v{$1,$2};
                                                $$=createNode("NormalClassDeclaration",v);
                                            }

NormalClassDeclaration0:
    CLASS TypeIdentifier ClassBody {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode(NULL,v);
                                        // $$->symbol_table=$3->symbol_table;
                                        // $$->symbol_table->scope=$2->tempval;
                                        // $$->addTypeEntry($2->entries,"class");
                                    }
|   CLASS TypeIdentifier ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4};
                                                $$=createNode( NULL,v);
                                                // $$->symbol_table=$4->symbol_table;
                                                // $$->symbol_table->scope=$2->tempval;
                                                // $$->addTypeEntry($2->entries,"class");
                                            }
|   CLASS TypeIdentifier ClassExtends ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4};
                                                $$=createNode(NULL,v);
                                                // $$->symbol_table=$4->symbol_table;
                                                // $$->symbol_table->scope=$2->tempval;
                                                // $$->addTypeEntry($2->entries,"class");
                                            }
|   CLASS TypeIdentifier ClassExtends ClassPermits ClassBody {
                                               vector<Node*> v{$1,$2,$3,$4,$5};
                                                $$=createNode( NULL,v);
                                                // $$->symbol_table=$5->symbol_table;
                                                // $$->symbol_table->scope=$2->tempval;
                                                // $$->addTypeEntry($2->entries,"class");
                                            }
|   CLASS TypeIdentifier TypeParameters ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4};
                                                $$=createNode( NULL,v);
                                                // $$->symbol_table=$4->symbol_table;
                                                // $$->symbol_table->scope=$2->tempval;
                                                // $$->addTypeEntry($2->entries,"class");
                                            }
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4, $5};
                                                $$=createNode( NULL,v);
                                                // $$->symbol_table=$5->symbol_table;
                                                // $$->symbol_table->scope=$2->tempval;
                                                // $$->addTypeEntry($2->entries,"class");
                                            }
|   CLASS TypeIdentifier TypeParameters ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4, $5};
                                                $$=createNode( NULL,v);
                                                // $$->symbol_table=$5->symbol_table;
                                                // $$->symbol_table->scope=$2->tempval;
                                                // $$->addTypeEntry($2->entries,"class");
                                            }
|   CLASS TypeIdentifier TypeParameters ClassExtends ClassPermits ClassBody {
                                                vector<Node*> v{$1,$2,$3,$4,$5, $6};
                                                $$=createNode( NULL,v);
                                                // $$->symbol_table=$6->symbol_table;
                                                // $$->symbol_table->scope=$2->tempval;
                                                // $$->addTypeEntry($2->entries,"class");
                                            }

ClassModifier0:
    ClassModifier { $$ = $1; }
|   ConstructorModifier { $$ = $1; }
|   ConstructorModifier ClassModifier {
                                            vector<Node*> v{$1,$2};
                                            $$=createNode( NULL,v);
                                        }

StaticFinal0:
    STATIC { $$ = $1; }
|   FINAL { $$ = $1; }
|   STATIC FINAL  {
    vector<Node*> v{$1,$2};
    $$ = createNode(NULL, v); 
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
    TypeParameter {         
                    vector<Node*> v{$1};
                    $$=createNode( "TypeParameterList",v); 
                }
|   TypeParameterList COMMA TypeParameter {
                                                vector<Node*> v($1->children);
                                                v.push_back($3);
                                                $$=createNode( $1->val,v);
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
    TypeName {vector<Node*> v{$1};
                            $$=createNode( "TypeNames",v); }
|   TypeNames COMMA TypeName {
                           vector<Node*> v($1->children);
                            v.push_back($3);
                            $$=createNode( $1->val,v);
                        }

ClassBody:
    CURLYBRACESTART CURLYBRACEEND {
                           vector<Node*> v;
                            $$=createNode( "ClassBody",v);
                            // $$->symbol_table = new SymbolTable("ClassBody");
                        }
|   CURLYBRACESTART ClassBodyDeclaration0 CURLYBRACEEND {
                           vector<Node*> v{$2};
                            $$=createNode( "ClassBody",v);
                            // $$->symbol_table = new SymbolTable("ClassBody");
                            // $$->moveEntries();
                            // $$->symbol_table->setChild($2->symbol_table);
                        }

ClassBodyDeclaration0: 
    ClassBodyDeclaration  {
                           vector<Node*> v{$1};
                            $$=createNode( NULL,v);
                        }
|   ClassBodyDeclaration0 ClassBodyDeclaration {
                            vector<Node*> v{$1, $2};
                            $$=createNode( NULL,v);
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
                            vector<Node*> v{$1};
                            v.insert(v.end(),$2->children.begin(),$2->children.end());
                            $$=createNode($2->val,v);
                        }
|   ABSTRACT classmethod {
                            vector<Node*> v{$1};
                            v.insert(v.end(),$2->children.begin(),$2->children.end());
                            $$=createNode($2->val,v);
                        }
|   ConstructorModifier ABSTRACT classmethod {
                            vector<Node*> v{$1,$2};
                            v.insert(v.end(),$3->children.begin(),$3->children.end());
                            $$=createNode($3->val,v);
                        }
|   ConstructorModifier StaticFinal0 fieldclassmethod  {
                            vector<Node*> v{$1,$2};
                            v.insert(v.end(),$3->children.begin(),$3->children.end());
                            $$=createNode($3->val,v);
                        }
|   SEMICOLON { $$ = $1; }

classmethod:
    MethodHeader MethodBody {
                                vector<Node*> v{$1,$2};
                                $$=createNode( "MethodDeclaration",v);

                                // $$->symbol_table = $2->symbol_table;
                                // $$->symbol_table->scope=$1->tempentry->lexeme;
                                // $$->moveEntries();
                                // $$->entries.push_back($1->tempentry);
                            }
|   UnannType MethodDeclarator MethodBody {
                                    vector<Node*> v{$1,$2,$3};
                                    $$=createNode( "MethodDeclaration",v);

                                    // $$->symbol_table = $3->symbol_table;
                                    // $$->symbol_table->scope=$2->tempentry->lexeme;
                                    // $$->moveEntries();
                                    // $$->addReturntypeEntry($2->tempentry,$1->tempval);

                                }
|   UnannType MethodDeclarator Throws MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "MethodDeclaration",v);

                                        // $$->symbol_table = $4->symbol_table;
                                        // $$->symbol_table->scope=$2->tempentry->lexeme;
                                        // $$->moveEntries();
                                        // $$->addReturntypeEntry($2->tempentry,$1->tempval);
                                    }
|   NormalClassDeclaration0 {
                                vector<Node*> v{$1};
                                $$=createNode("NormalClassDeclaration",v); 
                            }

fieldclassmethod:
    UnannType VariableDeclaratorList SEMICOLON{
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( "FieldDeclaration",v);

                                        // $$->addTypeEntry($2->entries, $1->tempval);
                                    }
|   classmethod { $$ = $1; }

FieldDeclaration:
    UnannType VariableDeclaratorList SEMICOLON {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( "FieldDeclaration",v);

                                        // $$->addTypeEntry($2->entries, $1->tempval);
                                    }
|   FieldModifier0 UnannType VariableDeclaratorList SEMICOLON {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "FieldDeclaration",v);

                                        // $$->addTypeEntry($3->entries, $2->tempval);
                                    }
|   ConstructorModifier UnannType VariableDeclaratorList SEMICOLON {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "FieldDeclaration",v);

                                        // $$->addTypeEntry($3->entries, $2->tempval);
                                    }
|   ConstructorModifier FieldModifier UnannType VariableDeclaratorList SEMICOLON {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "FieldDeclaration",v);

                                        // $$->addTypeEntry($4->entries, $3->tempval);
                                    }

FieldModifier0: 
    FieldModifier { $$ = $1; }
|   FieldModifier ConstructorModifier {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode(NULL,v);
                                    }

FieldModifier:
    TRANSIENT { $$ = $1; }
|   VOLATILE { $$ = $1; }

MethodDeclaration:
    MethodHeader MethodBody {
                                vector<Node*> v{$1,$2};
                                $$=createNode( "MethodDeclaration",v);
                                
                                // $$->symbol_table = $2->symbol_table;
                                // $$->symbol_table->scope=$1->tempentry->lexeme;
                                // $$->moveEntries();
                                // $$->entries.push_back($1->tempentry);
                            }
|   UnannType MethodDeclarator Throws MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "MethodDeclaration",v);

                                        // $$->symbol_table = $4->symbol_table;
                                        // $$->symbol_table->scope=$2->tempentry->lexeme;
                                        // $$->moveEntries();
                                        // $$->addReturntypeEntry($2->tempentry,$1->tempval);
                                    }
|   UnannType MethodDeclarator MethodBody  {
                                    vector<Node*> v{$1,$2,$3};
                                    $$=createNode( "MethodDeclaration",v);
                                    
                                    // $$->symbol_table = $3->symbol_table;
                                    // $$->symbol_table->scope=$2->tempentry->lexeme;
                                    // $$->moveEntries();
                                    // $$->addReturntypeEntry($2->tempentry,$1->tempval);
                                }
|   MethodModifier0 MethodHeader MethodBody {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "MethodDeclaration",v);
                                        
                                        // $$->symbol_table = $3->symbol_table;
                                        // $$->symbol_table->scope=$2->tempentry->lexeme;
                                        // $$->moveEntries();
                                        // $$->entries.push_back($2->tempentry);
                                    }
|   ConstructorModifier MethodHeader MethodBody {
                                        vector<Node*> v{$1,$2,$3};
                                        $$=createNode( "MethodDeclaration",v);
                                        
                                        // $$->symbol_table = $3->symbol_table;
                                        // $$->symbol_table->scope=$2->tempentry->lexeme;
                                        // $$->moveEntries();
                                        // $$->entries.push_back($2->tempentry);
                                    }
|   ConstructorModifier MethodModifier MethodHeader MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "MethodDeclaration",v);

                                        // $$->symbol_table = $4->symbol_table;
                                        // $$->symbol_table->scope=$3->tempentry->lexeme;
                                        // $$->moveEntries();
                                        // $$->entries.push_back($3->tempentry);
                                    }
|   MethodModifier0 UnannType MethodDeclarator Throws MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4,$5};
                                        $$=createNode( "MethodDeclaration",v);
                                        
                                        // $$->symbol_table = $5->symbol_table;
                                        // $$->symbol_table->scope=$3->tempentry->lexeme;
                                        // $$->moveEntries();
                                        // $$->addReturntypeEntry($3->tempentry,$2->tempval);
                                    }
|   ConstructorModifier UnannType MethodDeclarator Throws MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4,$5};
                                        $$=createNode( "MethodDeclaration",v);
                                        
                                        // $$->symbol_table = $5->symbol_table;
                                        // $$->symbol_table->scope=$3->tempentry->lexeme;
                                        // $$->moveEntries();
                                        // $$->addReturntypeEntry($3->tempentry,$2->tempval);
                                    }
|   ConstructorModifier MethodModifier UnannType MethodDeclarator Throws MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4,$5,$6};
                                        $$=createNode( "MethodDeclaration",v);
                                        
                                        // $$->symbol_table = $6->symbol_table;
                                        // $$->symbol_table->scope=$4->tempentry->lexeme;
                                        // $$->moveEntries();
                                        // $$->addReturntypeEntry($4->tempentry,$3->tempval);
                                    }
|   MethodModifier0 UnannType MethodDeclarator MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "MethodDeclaration",v);
                                        
                                        // $$->symbol_table = $4->symbol_table;
                                        // $$->symbol_table->scope=$3->tempentry->lexeme;
                                        // $$->moveEntries();
                                        // $$->addReturntypeEntry($3->tempentry,$2->tempval);
                                    }
|   ConstructorModifier UnannType MethodDeclarator MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4};
                                        $$=createNode( "MethodDeclaration",v);
                                        
                                        // $$->symbol_table = $4->symbol_table;
                                        // $$->symbol_table->scope=$3->tempentry->lexeme;
                                        // $$->moveEntries();
                                        // $$->addReturntypeEntry($3->tempentry,$2->tempval);
                                    }
|   ConstructorModifier MethodModifier UnannType MethodDeclarator MethodBody {
                                        vector<Node*> v{$1,$2,$3,$4,$5};
                                        $$=createNode( "MethodDeclaration",v);
                                        
                                        // $$->symbol_table = $5->symbol_table;
                                        // $$->symbol_table->scope=$4->tempentry->lexeme;
                                        // $$->moveEntries();
                                        // $$->addReturntypeEntry($4->tempentry,$3->tempval);
                                    }


MethodModifier0: 
    MethodModifier { $$ = $1; }
|   MethodModifier ConstructorModifier {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( NULL,v);
                                    }
|   ABSTRACT ConstructorModifier {
                                        vector<Node*> v{$1,$2};
                                        $$=createNode( NULL,v);
                                    }

MethodModifier:
    SYNCHRONIZED  { $$ = $1; }
|   NATIVE  { $$ = $1; }
|   STRICTFP { $$ = $1; }

VariableDeclaratorList:
    VariableDeclarator {
                            vector<Node*> v{$1};
                            $$=createNode( "VariableDeclaratorList",v);
                        }
|   VariableDeclaratorList COMMA VariableDeclarator {
                                                    vector<Node*> v($1->children);
                                                    v.push_back($3);
                                                    $$=createNode( $1->val,v);
                                                }

VariableDeclarator:
    VariableDeclaratorId  { $$ = $1; }
|   VariableDeclaratorId ASSIGN VariableInitializer {
                                        vector<Node*> v{$1,$3};
                                        $$=createNode( $2->val,v);
                                    }

VariableDeclaratorId:
    IDENTIFIER { 
                    $$=$1; 
                    // SymbolEntry* entry = new SymbolEntry($1->token, $1->lexeme);
                    // entry->temp=true;
                    // $$->entries.push_back(entry);
                }   
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
|   BOOLEAN { $$ = $1; $$->tempval="boolean"; }

UnannReferenceType:
    UnannClassOrInterfaceType { $$ = $1; }
|   UnannArrayType { $$ = $1; }

UnannClassOrInterfaceType:
    UnannClassType { $$ = $1; }

UnannClassType:
    TypeIdentifier { $$ = $1; $$->tempval= $1->tempval;}
|   TypeIdentifier TypeArguments {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "UnannClassType",v);
                        $$->tempval= $1->tempval;
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
                        $$=createNode( NULL,v);
                    }
|   UnannClassOrInterfaceType Dims {
                        vector<Node*> v{$1,$2};
                        $$=createNode( NULL,v);
                    }




MethodHeader:
    VOID MethodDeclarator {
                        vector<Node*> v{$1,$2};
                        $$=createNode( NULL,v);
                        // $$->tempentry=$2->tempentry;
                        // $$->tempentry->type="void";
                    }
|   TypeParameters Result MethodDeclarator {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( NULL,v);
                        // $$->tempentry=$3->tempentry;
                        // $$->tempentry->type=$2->tempval;
                    }
|   VOID MethodDeclarator Throws {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( NULL,v);
                        // $$->tempentry=$2->tempentry;
                        // $$->tempentry->type="void";
                    }
|   TypeParameters Result MethodDeclarator Throws {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( NULL,v);
                        // $$->tempentry=$3->tempentry;
                        // $$->tempentry->type=$2->tempval;
                    }


Result:
    UnannType { $$ = $1; }
|   VOID { $$ = $1; $$->tempval="void";}

MethodDeclarator:
    IDENTIFIER BRACESTART BRACEEND {
                        vector<Node*> v{$1};
                        $$=createNode( "MethodDeclarator",v);

                        // SymbolEntry* entry = new SymbolEntry($1->token, $1->lexeme);
                        // entry->entry_type="method";
                        // $$->tempentry=entry;
                    }
|   IDENTIFIER BRACESTART FormalParameterList BRACEEND {
                        vector<Node*> v{$1,$3};
                        $$=createNode( "MethodDeclarator",v);

                        // SymbolEntry* entry = new SymbolEntry($1->token, $1->lexeme);
                        // entry->no_arguments=$3->tempargs.size();
                        // entry->type_arguments=$3->tempargs;
                        // entry->entry_type="method";
                        // $$->tempentry=entry;
                    }
|   IDENTIFIER BRACESTART ReceiverParameter COMMA BRACEEND {
                        vector<Node*> v{$1,$3,$4};
                        $$=createNode( "MethodDeclarator",v);

                        // SymbolEntry* entry = new SymbolEntry($1->token, $1->lexeme);
                        // entry->entry_type="method";
                        // $$->tempentry=entry;
                    }
|   IDENTIFIER BRACESTART ReceiverParameter COMMA FormalParameterList BRACEEND {
                        vector<Node*> v{$1,$3,$4,$5};
                        $$=createNode( "MethodDeclarator",v);

                        // SymbolEntry* entry = new SymbolEntry($1->token, $1->lexeme);
                        // entry->entry_type="method";
                        // $$->tempentry=entry;
                    }
|   IDENTIFIER BRACESTART BRACEEND Dims {
                        vector<Node*> v{$1,$4};
                        $$=createNode( "MethodDeclarator",v);

                        // SymbolEntry* entry = new SymbolEntry($1->token, $1->lexeme);
                        // entry->entry_type="method";
                        // $$->tempentry=entry;
                    }
|   IDENTIFIER BRACESTART FormalParameterList BRACEEND Dims {
                        vector<Node*> v{$1,$3,$5};
                        $$=createNode( "MethodDeclarator",v);

                        // SymbolEntry* entry = new SymbolEntry($1->token, $1->lexeme);
                        // entry->no_arguments=$3->tempargs.size();
                        // entry->type_arguments=$3->tempargs;
                        // entry->entry_type="method";
                        // $$->tempentry=entry;
                    }
|   IDENTIFIER BRACESTART ReceiverParameter COMMA BRACEEND Dims {
                        vector<Node*> v{$1,$3,$4,$6};
                        $$=createNode( "MethodDeclarator",v);

                        // SymbolEntry* entry = new SymbolEntry($1->token, $1->lexeme);
                        // entry->entry_type="method";
                        // $$->tempentry=entry;
                    }
|   IDENTIFIER BRACESTART ReceiverParameter COMMA FormalParameterList BRACEEND Dims {
                        vector<Node*> v{$1,$3,$4,$5,$7};
                        $$=createNode( "MethodDeclarator",v);

                        // SymbolEntry* entry = new SymbolEntry($1->token, $1->lexeme);
                        // entry->entry_type="method";
                        // $$->tempentry=entry;
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
    FormalParameter {
                        vector<Node*> v{$1};
                        $$=createNode( NULL,v);
                        // $$->tempargs.push_back($1->tempval);
                    }
|   FormalParameterList COMMA FormalParameter {
                        vector<Node*> v($1->children);
                        v.push_back($3);
                        $$=createNode( $1->val,v);
                        // $$->tempargs.insert($$->tempargs.end(),$1->tempargs.begin(),$1->tempargs.end());
                        // $$->tempargs.push_back($3->tempval);
                    }

FormalParameter:
    UnannType VariableDeclaratorId {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "FormalParameter",v);

                        // $$->addTypeEntry($2->entries,$1->tempval);
                        // $$->tempval=$1->tempval;
                    }
|   VariableModifier0 UnannType VariableDeclaratorId {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "FormalParameter",v);

                        // $$->addTypeEntry($3->entries,$2->tempval);
                        // $$->tempval=$1->tempval;
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
                        $$=createNode( NULL,v);
                    }

VariableModifier:
    FINAL { $$ = $1; }

Throws:
    THROWS ExceptionTypeList {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "Throws",v);
                    }

ExceptionTypeList:
    ExceptionType {
                    vector<Node*> v{$1};
                    $$=createNode( "ExceptionTypeList",v);
                }
|   ExceptionTypeList COMMA ExceptionType {
                        vector<Node*> v($1->children);
                        v.push_back($3);
                        $$=createNode( $1->val,v);
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
                        vector<Node*> v{$1};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   SimpleTypeName BRACESTART ReceiverParameter COMMA BRACEEND {
                        vector<Node*> v{$1,$3,$4};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   SimpleTypeName BRACESTART FormalParameterList BRACEEND {
                        vector<Node*> v{$1,$3};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   SimpleTypeName BRACESTART ReceiverParameter COMMA FormalParameterList BRACEEND {
                        vector<Node*> v{$1,$3,$4,$5};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   TypeParameters SimpleTypeName BRACESTART BRACEEND {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   TypeParameters SimpleTypeName BRACESTART ReceiverParameter COMMA BRACEEND {
                        vector<Node*> v{$1,$2,$4,$5};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   TypeParameters SimpleTypeName BRACESTART FormalParameterList BRACEEND {
                        vector<Node*> v{$1,$2,$4};
                        $$=createNode( "ConstructorDeclarator",v);
                    }
|   TypeParameters SimpleTypeName BRACESTART ReceiverParameter COMMA FormalParameterList BRACEEND {
                        vector<Node*> v{$1,$2,$4,$5,$6};
                        $$=createNode( "ConstructorDeclarator",v);
                    }

SimpleTypeName:
    TypeIdentifier  { $$ = $1; }

ConstructorBody:
    CURLYBRACESTART CURLYBRACEEND {
                        vector<Node*> v;
                        $$=createNode( "ConstructorBody",v);
                    }
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
|   CURLYBRACESTART CURLYBRACEEND {
                        vector<Node*> v;
                        $$=createNode( "EnumBody",v);
                    }
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
    EnumConstant {
                    vector<Node*> v{$1};
                    $$=createNode( "EnumConstantList",v);
                }
|   EnumConstantList COMMA EnumConstant {
                        vector<Node*> v($1->children);
                        v.push_back($3);
                        $$=createNode( $1->val,v);
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
                        vector<Node*> v;
                        $$=createNode( "PArgumentList",v);
                    }
|   BRACESTART ArgumentList BRACEEND {
                        vector<Node*> v{$2};
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
                        vector<Node*> v;
                        $$=createNode( "RecordHeader",v);
                    }
|   BRACESTART RecordComponentList BRACEEND {
                        vector<Node*> v{$2};
                        $$=createNode( "RecordHeader",v);
                    }

RecordComponentList:
    RecordComponent {
                        vector<Node*> v{$1};
                        $$=createNode( "RecordComponentList",v);
                    }
|   RecordComponentList COMMA RecordComponent {
                        vector<Node*> v($1->children);
                        v.push_back($3);
                        $$=createNode( $1->val,v);
                    }

RecordComponent:
    UnannType IDENTIFIER {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "RecordComponent",v);
                    }
|   VariableArityRecordComponent {
                        $$=$1;
                    }

VariableArityRecordComponent:
    UnannType ELLIPSIS IDENTIFIER {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "VariableArityRecordComponent", v );
                    }

RecordBody:
    CURLYBRACESTART CURLYBRACEEND  {
                        vector<Node*> v;
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
                        $$=createNode(NULL, v );
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
    CURLYBRACESTART CURLYBRACEEND {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "Block", v );

                        $$->symbol_table = new SymbolTable("Block");
                    }
|   CURLYBRACESTART BlockStatements CURLYBRACEEND {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "Block", v );

                        // $$->symbol_table = new SymbolTable("Block");
                        // $$->symbol_table->setChild($2->symbol_table);
                    }

BlockStatements: 
    BlockStatement {
                        vector<Node*> v{$1};
                        $$=createNode( "BlockStatements", v );
                    }
|   BlockStatements BlockStatement {
                        vector<Node*> v($1->children);
                        v.push_back($2);
                        $$=createNode( $1->val,v);
                    }

BlockStatement:
    LocalClassOrInterfaceDeclaration  { $$ = $1; }
|   LocalVariableDeclarationStatement  { $$ = $1; }
|   Statement  { $$ = $1; }

LocalClassOrInterfaceDeclaration:
    ClassDeclaration  { $$ = $1; }

LocalVariableDeclarationStatement:
    LocalVariableDeclaration SEMICOLON {
                        $$=$1;
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

EmptyStatement: SEMICOLON  { vector<Node*> v;
                        $$=createNode( "EmptyStatement", v ); }

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
                        $$=$1;
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
                        vector<Node*> v{$1,$3,$5};
                        $$=createNode( "IfThenStatement", v );
                    }

IfThenElseStatement:
    IF BRACESTART Expression BRACEEND StatementNoShortIf ELSE Statement {
                        vector<Node*> v{$1,$3,$5,$6,$7};
                        $$=createNode( "IfThenElseStatement", v );
                    }

IfThenElseStatementNoShortIf:
    IF BRACESTART Expression BRACEEND StatementNoShortIf ELSE StatementNoShortIf {
                        vector<Node*> v{$1,$3,$5,$6,$7};
                        $$=createNode( "IfThenElseStatementNoShortIf", v );
                    }

AssertStatement:
    ASSERT Expression SEMICOLON {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "AssertStatement", v );
                    }
|   ASSERT Expression COLON Expression SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$4};
                        $$=createNode( "AssertStatement", v );
                    }

SwitchStatement:
    SWITCH BRACESTART Expression BRACEEND SwitchBlock {
                        vector<Node*> v{$1,$3,$5};
                        $$=createNode( "SwitchStatement", v );
                    }

SwitchBlock:
    CURLYBRACESTART SwitchRule0 CURLYBRACEEND {
                        vector<Node*> v{$2};
                        $$=createNode( "SwitchBlock", v );
                    }
|   CURLYBRACESTART CURLYBRACEEND {
                        vector<Node*> v;
                        $$=createNode( "SwitchBlock", v );
                    }
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
                        $$=createNode(NULL, v );
                    }

SwitchBlockStatementGroup0: 
    SwitchBlockStatementGroup  { $$ = $1; }
|   SwitchBlockStatementGroup0 SwitchBlockStatementGroup {
                        vector<Node*> v{$1,$2};
                        $$=createNode(NULL, v );
                    }

SwitchColonLabel0:
    SwitchLabel COLON {
                        vector<Node*> v{$1,$2};
                        $$=createNode(NULL, v );
                    }
|   SwitchColonLabel0 SwitchLabel COLON {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode(NULL, v );
                    }

SwitchRule:
    SwitchLabel PTR Expression SEMICOLON {
                        vector<Node*> v{$1,$2,$3};
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
    SwitchColonLabel0 {
                        vector<Node*> v{$1};
                        $$=createNode( "SwitchBlockStatementGroup", v );
                    }
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
|   CASE CaseConstant CommaCaseConstant0{
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( "SwitchLabel", v );
                    }
|   DEFAULT

CommaCaseConstant0:
    COMMA CaseConstant {
                        vector<Node*> v{$1,$2};
                        $$=createNode( NULL, v );
                    }
|   CommaCaseConstant0 COMMA CaseConstant {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( NULL, v );
                    }

CaseConstant:
ConditionalExpression  { $$ = $1; }

WhileStatement:
WHILE BRACESTART Expression BRACEEND Statement {
                        vector<Node*> v{$1,$3,$5};
                        $$=createNode( "WhileStatement", v );
                    }

WhileStatementNoShortIf:
WHILE BRACESTART Expression BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$3,$5};
                        $$=createNode( "WhileStatementNoShortIf", v );
                    }

DoStatement:
DO Statement WHILE BRACESTART Expression BRACEEND SEMICOLON {
                        vector<Node*> v{$1,$2,$3,$5};
                        $$=createNode( "DoStatement", v );
                    }

ForStatement:
    BasicForStatement  {
                        vector<Node*> v{$1};
                        $$=createNode( "ForStatement", v ); 
                    }
|   EnhancedForStatement  {
                        vector<Node*> v{$1};
                        $$=createNode( "ForStatement", v ); 
                    }

ForStatementNoShortIf:
    BasicForStatementNoShortIf  { $$ = $1; }
|   EnhancedForStatementNoShortIf  { $$ = $1; }

BasicForStatement:
    FOR BRACESTART SEMICOLON SEMICOLON BRACEEND Statement {
                        vector<Node*> v{$1,$6};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART ForInit SEMICOLON SEMICOLON BRACEEND Statement {
                        vector<Node*> v{$1,$3,$7};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART SEMICOLON Expression SEMICOLON BRACEEND Statement {
                        vector<Node*> v{$1,$4,$7};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART ForInit SEMICOLON Expression SEMICOLON BRACEEND Statement {
                        vector<Node*> v{$1,$3,$5,$8};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART SEMICOLON SEMICOLON ForUpdate BRACEEND Statement {
                        vector<Node*> v{$1,$5,$7};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART ForInit SEMICOLON SEMICOLON ForUpdate BRACEEND Statement {
                        vector<Node*> v{$1,$3,$6,$8};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART SEMICOLON Expression SEMICOLON ForUpdate BRACEEND Statement {
                        vector<Node*> v{$1,$4,$6,$8};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART ForInit SEMICOLON Expression SEMICOLON ForUpdate BRACEEND Statement {
                        vector<Node*> v{$1,$3,$5,$7,$9};
                        $$=createNode(NULL, v );
                    }

BasicForStatementNoShortIf:
    FOR BRACESTART SEMICOLON SEMICOLON BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$6};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART ForInit  SEMICOLON SEMICOLON BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$3,$7};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART SEMICOLON Expression SEMICOLON BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$4,$7};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART ForInit  SEMICOLON Expression SEMICOLON BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$3,$5,$8};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART SEMICOLON SEMICOLON ForUpdate BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$5,$7};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART ForInit  SEMICOLON SEMICOLON ForUpdate BRACEEND StatementNoShortIf  {
                        vector<Node*> v{$1,$2,$3,$4,$5,$6,$7,$8};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART SEMICOLON Expression SEMICOLON ForUpdate BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$4,$6,$8};
                        $$=createNode(NULL, v );
                    }
|   FOR BRACESTART ForInit  SEMICOLON Expression SEMICOLON ForUpdate BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$3,$5,$7,$9};
                        $$=createNode(NULL, v );
                    }


ForInit:
    StatementExpressionList {
                        vector<Node*> v{$1};
                        $$=createNode( "ForInit", v );
                    }
|   LocalVariableDeclaration {
                        vector<Node*> v{$1};
                        $$=createNode( "ForInit", v );
                    }

ForUpdate:
StatementExpressionList {
                        vector<Node*> v{$1};
                        $$=createNode( "ForUpdate", v );
                    }

StatementExpressionList:
    StatementExpression {
                        vector<Node*> v{$1};
                        $$=createNode( "StatementExpressionList", v );
                    }
|   StatementExpressionList COMMA StatementExpression {
                        vector<Node*> v($1->children);
                        v.push_back($3);
                        $$=createNode( $1->val,v);
                    }

EnhancedForStatement:
FOR BRACESTART LocalVariableDeclaration COLON Expression BRACEEND Statement {
                        vector<Node*> v{$1,$3,$4,$5,$7};
                        $$=createNode( NULL, v );
                    }

EnhancedForStatementNoShortIf:
FOR BRACESTART LocalVariableDeclaration COLON Expression BRACEEND StatementNoShortIf {
                        vector<Node*> v{$1,$3,$4,$5,$7};
                        $$=createNode( NULL, v );
                    }

BreakStatement: 
    BREAK SEMICOLON  {
                        vector<Node*> v{$1};
                        $$=createNode( "BreakStatement", v );
                    }
|   BREAK IDENTIFIER SEMICOLON  {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "BreakStatement", v );
                    }

YieldStatement:
YIELD Expression SEMICOLON {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "YieldStatement", v );
                    }

ContinueStatement: 
    CONTINUE SEMICOLON {
                        vector<Node*> v{$1};
                        $$=createNode( "ContinueStatement", v );
                    }
|   CONTINUE IDENTIFIER SEMICOLON {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "ContinueStatement", v );
                    }

ReturnStatement: 
    RETURN SEMICOLON  {
                        vector<Node*> v{$1};
                        $$=createNode( "ReturnStatement", v );
                    }
|   RETURN Expression SEMICOLON {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "ReturnStatement", v );
                    }

ThrowStatement:
THROW Expression SEMICOLON {
                        vector<Node*> v{$1,$2};
                        $$=createNode( "ThrowStatement", v );
                    }

SynchronizedStatement:
SYNCHRONIZED BRACESTART Expression BRACEEND Block  {
                        vector<Node*> v{$1,$3,$5};
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
    CatchClause {
                    vector<Node*> v{$1};
                    $$=createNode( "Catches", v );
                }
|   Catches CatchClause{
                        vector<Node*> v($1->children);
                        v.push_back($2);
                        $$=createNode( $1->val,v);
                    }

CatchClause:
CATCH BRACESTART CatchFormalParameter BRACEEND Block {
                        vector<Node*> v{$1,$3,$5};
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
                        $$=createNode( NULL, v );
                    }
|   BarClassType0 OR ClassType  {
                        vector<Node*> v{$1,$2,$3};
                        $$=createNode( NULL, v );
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
                    vector<Node*> v{$2};
                    $$=createNode( "ResourceSpecification", v );
                }
|   BRACESTART IDENTIFIER SEMICOLON BRACEEND  {
                    vector<Node*> v{$2};
                    $$=createNode( "ResourceSpecification", v );
                }
|   BRACESTART ResourceList BRACEEND  {
                    vector<Node*> v{$2};
                    $$=createNode( "ResourceSpecification", v );
                }
|   BRACESTART ResourceList SEMICOLON BRACEEND  {
                    vector<Node*> v{$2};
                    $$=createNode( "ResourceSpecification", v );
                }

ResourceList:
    Resource {
                vector<Node*> v{$1};
                $$=createNode( "ResourceList", v );
            }
|   ResourceList SEMICOLON IDENTIFIER {
                        vector<Node*> v($1->children);
                        v.push_back($3);
                        $$=createNode( $1->val,v);
                    }
|   ResourceList SEMICOLON Resource  {
                        vector<Node*> v($1->children);
                        v.push_back($3);
                        $$=createNode( $1->val,v);
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
                    $$=$2;
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
                    $$=createNode( NULL, v );
                }

SquareBrace0:
    SQUAREBRACESTART SQUAREBRACEEND {
                    vector<Node*> v{$1,$2};
                    $$=createNode(NULL, v );
                }
|   SquareBrace0 SQUAREBRACESTART SQUAREBRACEEND  {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( NULL, v );
                } 

ClassInstanceCreationExpression:
    UnqualifiedClassInstanceCreationExpression
|   IDENTIFIER PERIOD UnqualifiedClassInstanceCreationExpression {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ClassInstanceCreationExpression", v );
                } 
|   ExpressionName PERIOD UnqualifiedClassInstanceCreationExpression {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ClassInstanceCreationExpression", v );
                } 
|   Primary PERIOD UnqualifiedClassInstanceCreationExpression {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "ClassInstanceCreationExpression", v );
                } 

UnqualifiedClassInstanceCreationExpression:
    NEW ClassOrInterfaceTypeToInstantiate BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW ClassOrInterfaceTypeToInstantiate BRACESTART BRACEEND ClassBody {
                    vector<Node*> v{$1,$2,$5};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW ClassOrInterfaceTypeToInstantiate BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$4};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW ClassOrInterfaceTypeToInstantiate BRACESTART ArgumentList BRACEEND ClassBody {
                    vector<Node*> v{$1,$2,$4,$6};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW TypeArguments ClassOrInterfaceTypeToInstantiate BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW TypeArguments ClassOrInterfaceTypeToInstantiate BRACESTART BRACEEND ClassBody {
                    vector<Node*> v{$1,$2,$3,$6};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW TypeArguments ClassOrInterfaceTypeToInstantiate BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$5};
                    $$=createNode( "UnqualifiedClassInstanceCreationExpression", v );
                } 
|   NEW TypeArguments ClassOrInterfaceTypeToInstantiate BRACESTART ArgumentList BRACEEND ClassBody {
                    vector<Node*> v{$1,$2,$3,$5,$7};
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
                    vector<Node*> v{$1,$3};
                    $$=createNode( "[]", v );
                } 
|   ExpressionName SQUAREBRACESTART Expression SQUAREBRACEEND {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "[]", v );
                } 
|   PrimaryNoNewArray SQUAREBRACESTART Expression SQUAREBRACEEND {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "[]", v );
                } 

MethodInvocation:
    MethodNameBrace BRACEEND {
                    vector<Node*> v{$1};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MethodInvocation", v );
                } 
|   IDENTIFIER PERIOD IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MethodInvocation", v );
                } 
|   ExpressionName PERIOD IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MethodInvocation", v );
                } 
|   Primary PERIOD IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MethodInvocation", v );
                } 
|   SUPER PERIOD IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD SUPER PERIOD IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "MethodInvocation", v );
                } 
|   IDENTIFIER PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "MethodInvocation", v );
                } 
|   ExpressionName PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "MethodInvocation", v );
                } 
|   Primary PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "MethodInvocation", v );
                } 
|   SUPER PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD SUPER PERIOD TypeArguments IDENTIFIER BRACESTART BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   MethodNameBrace ArgumentList BRACEEND {
                    vector<Node*> v{$1,$3};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$5};
                    $$=createNode( "MethodInvocation", v );
                } 
|   IDENTIFIER PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$5};
                    $$=createNode( "MethodInvocation", v );
                } 
|   ExpressionName PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$5};
                    $$=createNode( "MethodInvocation", v );
                } 
|   Primary PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$5};
                    $$=createNode( "MethodInvocation", v );
                } 
|   SUPER PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$5};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD SUPER PERIOD IDENTIFIER BRACESTART ArgumentList BRACEEND {
                    vector<Node*> v{$1,$2,$3,$4,$5,$7};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   IDENTIFIER PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   ExpressionName PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   Primary PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   SUPER PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4,$6};
                    $$=createNode( "MethodInvocation", v );
                } 
|   TypeName PERIOD SUPER PERIOD TypeArguments IDENTIFIER BRACESTART ArgumentList BRACEEND  {
                    vector<Node*> v{$1,$2,$3,$4,$5,$6,$8};
                    $$=createNode( "MethodInvocation", v );
                } 

MethodNameBrace:
    IDENTIFIER BRACESTART {
                    vector<Node*> v{$1,$2};
                    $$=createNode(NULL, v );
                } 
|   MethodName BRACESTART  {
                    vector<Node*> v{$1,$2};
                    $$=createNode(NULL, v );
                } 

ArgumentList:
    Expression {
                    vector<Node*> v{$1};
                    $$=createNode( "ArgumentList", v );
                } 
|   ArgumentList COMMA Expression {
                        vector<Node*> v($1->children);
                        v.push_back($3);
                        $$=createNode( $1->val,v);
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
    DimExpr {
                vector<Node*> v{$1};
                $$=createNode( "DimExprs", v );
            } 
|   DimExprs DimExpr {
                        vector<Node*> v($1->children);
                        v.push_back($2);
                        $$=createNode( $1->val,v);
                    }

DimExpr:
    SQUAREBRACESTART Expression SQUAREBRACEEND {
                    $$=$2;
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
                    vector<Node*> v;
                    $$=createNode( "LambdaParameters", v );
                } 
|   BRACESTART IDENTIFIER BRACEEND {
                    $$=$2;
                } 
|   BRACESTART LambdaParameterList BRACEEND {
                    $$=$2;
                } 
    
LambdaParameterList:
    LambdaParameter
|   LambdaParameter CommaLambdaParameter0 {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "LambdaParameterList", v );
                } 
|   IDENTIFIER CommaIdentifier0 {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "LambdaParameterList", v );
                } 

CommaLambdaParameter0:
    COMMA LambdaParameter  {
                    vector<Node*> v{$2};
                    $$=createNode( NULL, v );
                } 
|   CommaLambdaParameter0 COMMA LambdaParameter  {
                    vector<Node*> v{$1,$3};
                    $$=createNode(NULL, v );
                } 
   
CommaIdentifier0:
    COMMA IDENTIFIER {
                    vector<Node*> v{$2};
                    $$=createNode(NULL, v );
                } 
|   CommaIdentifier0 COMMA IDENTIFIER {
                    vector<Node*> v{$1,$3};
                    $$=createNode( NULL, v );
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
   IDENTIFIER AssignmentOperator Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( $2->val, v );
                }
|  LeftHandSide AssignmentOperator Expression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( $2->val, v );
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
                    vector<Node*> v{$1,$3,$5};
                    $$=createNode( "?:", v );
                } 
|   ConditionalOrExpression QUESTION Expression COLON LambdaExpression {
                    vector<Node*> v{$1,$3,$5};
                    $$=createNode( "?:", v );
                } 

ConditionalOrExpression:
    ConditionalAndExpression
|   ConditionalOrExpression OR_OR ConditionalAndExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( $2->val, v );
                } 
    
ConditionalAndExpression:
    InclusiveOrExpression
|   ConditionalAndExpression AND_AND InclusiveOrExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( $2->val, v );
                } 

InclusiveOrExpression:
    ExclusiveOrExpression
|   InclusiveOrExpression OR ExclusiveOrExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( $2->val, v );
                } 

ExclusiveOrExpression:
    AndExpression
|   ExclusiveOrExpression XOR AndExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( $2->val, v );
                } 

AndExpression:
    EqualityExpression
|   AndExpression AND EqualityExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( $2->val, v );
                } 

EqualityExpression:
    RelationalExpression
|   EqualityExpression EQUAL RelationalExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode( $2->val, v );
                } 
|   EqualityExpression NEQ RelationalExpression  {
                    vector<Node*> v{$1,$3};
                    $$=createNode( $2->val, v );
                } 

RelationalExpression:
    ShiftExpression
|   RelationalExpression LESSER ShiftExpression  {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 
|   RelationalExpression GREATER ShiftExpression  {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 
|   RelationalExpression LEQ ShiftExpression  {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 
|   RelationalExpression GEQ ShiftExpression  {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 
|   InstanceofExpression

InstanceofExpression:
    RelationalExpression INSTANCEOF ReferenceType  {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 
|   RelationalExpression INSTANCEOF Pattern {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 

ShiftExpression:
    AdditiveExpression
|   ShiftExpression LSHIFT AdditiveExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 
|   ShiftExpression RSHIFT AdditiveExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 
|   ShiftExpression URSHIFT AdditiveExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 

AdditiveExpression:
    MultiplicativeExpression
|   AdditiveExpression ADD MultiplicativeExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 
|   AdditiveExpression SUB MultiplicativeExpression  {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 

MultiplicativeExpression:
    UnaryExpression
|   MultiplicativeExpression MUL UnaryExpression  {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 
|   MultiplicativeExpression DIV UnaryExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 
|   MultiplicativeExpression MOD UnaryExpression {
                    vector<Node*> v{$1,$3};
                    $$=createNode($2->val, v );
                } 

UnaryExpression:
    PreIncrementExpression
|   PreDecrementExpression
|   ADD UnaryExpression {
                    vector<Node*> v{$2};
                    $$=createNode( $1->val, v );
                } 
|   SUB UnaryExpression {
                    vector<Node*> v{$2};
                    $$=createNode( $1->val, v );
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
|   TILDE UnaryExpression {
                    vector<Node*> v{$2};
                    $$=createNode( $1->val, v );
                } 
|   NOT UnaryExpression {
                    vector<Node*> v{$2};
                    $$=createNode( $1->val, v );
                } 
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
                    vector<Node*> v{$2,$4};
                    $$=createNode( "CastExpression", v );
                } 
|   BRACESTART PrimitiveType BRACEEND UnaryExpression {
                    vector<Node*> v{$2,$4};
                    $$=createNode( "CastExpression", v );
                } 
|   BRACESTART ReferenceType BRACEEND UnaryExpressionNotPlusMinus {
                    vector<Node*> v{$2,$4};
                    $$=createNode( "CastExpression", v );
                } 
|   BRACESTART ReferenceType  BRACEEND LambdaExpression {
                    vector<Node*> v{$2,$4};
                    $$=createNode( "CastExpression", v );
                } 

SwitchExpression:
    SWITCH BRACESTART Expression BRACEEND SwitchBlock {
                    vector<Node*> v{$1,$3,$5};
                    $$=createNode( "SwitchExpression", v );
                } 
    

ArrayInitializer:
    CURLYBRACESTART CURLYBRACEEND {
                    vector<Node*> v;
                    $$=createNode( "ArrayInitializer", v );
                } 
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
    VariableInitializer {
                            vector<Node*> v{$1};
                            $$=createNode( "VariableInitializerList", v );
                        } 
|   VariableInitializerList COMMA VariableInitializer {
                                                        vector<Node*> v($1->children);
                                                        v.push_back($3);
                                                        $$=createNode( $1->val,v);
                                                    }

PrimitiveType:
    NumericType
|   BOOLEAN {$$->tempval="boolean";}

NumericType:
    IntegralType
|   FloatingPointType

IntegralType:
    BYTE {$$->tempval="byte";}
|   SHORT {$$->tempval="short";}
|   INT {$$->tempval="int";}
|   LONG {$$->tempval="long";}
|   CHAR {$$->tempval="char";}

FloatingPointType:
    FLOAT {$$->tempval="float";}
|   DOUBLE {$$->tempval="double";}

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
    BOOLEAN Dims  {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "ArrayType", v );
                } 
|   PrimitiveType Dims   {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "ArrayType", v );
                } 
|   ClassOrInterfaceType Dims  {
                    vector<Node*> v{$1,$2};
                    $$=createNode( "ArrayType", v );
                } 

Dims:
    SQUAREBRACESTART SQUAREBRACEEND   {
                                            vector<Node*> v;
                                            v.push_back(createNode("[]"));
                                            $$=createNode( NULL, v );
                                        }
|   SQUAREBRACESTART SQUAREBRACEEND Dims {
                                            vector<Node*> v($3->children);
                                            v.push_back(createNode("[]"));
                                            $$=createNode( NULL, v );
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
    TypeArgument {
                    vector<Node*> v{$1};
                    $$=createNode( "TypeArgumentList", v );
                } 
|   TypeArgumentList COMMA TypeArgument {
                                            vector<Node*> v($1->children);
                                            v.push_back($3);
                                            $$=createNode( $1->val,v);
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
|   PackageOrTypeName PERIOD TypeIdentifier {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "TypeName", v );
                } 

PackageOrTypeName:
    IDENTIFIER PERIOD IDENTIFIER {
                    vector<Node*> v{$1,$2,$3};
                    $$=createNode( "TypeName", v );
                } 
|   PackageOrTypeName PERIOD IDENTIFIER {
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
    IDENTIFIER {
        $$=$1; 
        // SymbolEntry* entry = new SymbolEntry($1->token, $1->lexeme);
        // entry->temp=true;
        // $$->entries.push_back(entry);
        // $$->tempval=$1->lexeme;
    }
|    ContextualExceptPRS

%%

int main(int argc, char *argv[]) {
    int input_file = 0, output_file = 0;
    char *input_file_name, *output_file_name;
    if( argc == 1 ){
        printf("ERROR: No input file/options specified.\n\tUse --help to get more info\n");
        return -1;
    }
    for( int i = 1 ; i < argc ; i++ ){
        if( input_file == 1 && argv[i][0] != '-' ){
            printf("ERROR: More than 1 input file not allowed.\n");
            return -1;
        } 
        if( argv[i][0] != '-' ){
            input_file = 1;
            input_file_name = argv[i];
            continue;
        }
        if( !strcmp(argv[i], "--help") ) {
            if( argc > i+1 ){
                printf("ERROR: No manual entry for ./myASTGenerator%s\n", argv[i+1]);
                return -1;
            }
            printf("usage: ./myASTGenerator [options] file\n");
            printf("Options:\n");
            printf("--help                To print this message.\n"); 
            printf("--input=<file name>   To specify the input file name.\n");
            printf("                      By default, the name of the input file can be specified directly.\n");
            printf("--output=<file name>  To specify the output file name.\n");
            printf("                      By default, the name of the output file is 'output.dot'\n");
            printf("Do not use --input=<file name> flag if you have specified the input file name directly.\n");
            printf("--verbose             It outputs the stack trace.\n"); 
            return 0;
        }
        char temp = argv[i][7];
        argv[i][7] = '\0';
        if( !strcmp( argv[i], "--input") ){
            if( input_file == 1 ){
                printf("ERROR: More than 1 input file not allowed.\n");
                return -1;
            }
            input_file = 1;
            input_file_name = argv[i]+8;
            continue;
        }
        argv[i][7] = temp;
        temp = argv[i][8];
        argv[i][8] = '\0';
        if( !strcmp( argv[i], "--output") ){
            if( output_file == 1 ){
                printf("ERROR: More than 1 output file not allowed.\n");
                return -1;
            }
            output_file_name = argv[i]+9;
            output_file = 1;
            continue;
        }
        argv[i][8] = temp;
        if( !strcmp( argv[i], "--verbose") ){
            yydebug = 1;
            continue;
        }
        printf("ERROR: Unknown option.\n");
        return -1;
    }
    if( input_file == 0 ){
        printf("ERROR: No Input file Specified.\n");
        return -1;
    }
    if( output_file == 0 ) output_file_name = "output.dot";
    yyin = fopen(input_file_name,"r");
    dotfile = fopen(output_file_name,"w");

    fprintf(dotfile,"digraph {\n");
    yyparse();

    // ofstream ofs("symbol_table1.txt");
    // displaySymbolTable(ofs,root,NULL);

    buildTree(dotfile,root,-1,0);

    ofstream ofs1("symbol_table.txt");

    SymbolTableBuilder* builder = new SymbolTableBuilder();
    builder->build(root);
    display(builder->curr_symtable,ofs1);

    fprintf(dotfile," }\n");
    fclose(yyin);
    return 0;
}