#pragma once

#include "SymbolEntry.cpp"
#include "SymbolTable.cpp"
#include "helper.cpp"
#include <map>
#include <iostream>
#include <cstdio>
using namespace std;

class SymbolTableBuilder {

public:
    set<string> validtypes;
    SymbolTable* curr_symtable;
    SymbolTable* prev_symtable;
    Helper* helper;
    int method_invocation_flag=0;

    SymbolTableBuilder()
    {
        createValidTypes();
        curr_symtable=NULL;
        prev_symtable=NULL;
        helper=new Helper();
        helper->display_flag=0;
    }

    void setMethodInvocationFlag(int method_invocation_flag)
    {
        this->method_invocation_flag=method_invocation_flag;
        if(!method_invocation_flag)
            helper->display_flag=0;
        else
            helper->display_flag=1;
    }
    void addEntry(SymbolEntry* entry)
    {
        if(method_invocation_flag)
            return;
        assert(curr_symtable!=NULL);
        curr_symtable->insert(entry);
    }
    // bool presentEntry(SymbolEntry* entry)
    // {
    //     if(method_invocation_flag)
    //         return true;
    //     // assert(curr_symtable!=NULL);
    //     vector<SymbolEntry*> entries = curr_symtable->lookup(entry->lexeme);
    //     for( auto symboltable_entry : entries )
    //     {
    //         if( symboltable_entry->token == entry->token and symboltable_entry->type == entry->type ) return true;
    //     }
    //     return false;
    // }
    void createValidTypes()
    {
        validtypes.insert("BYTE");
        validtypes.insert("SHORT");
        validtypes.insert("INT");
        validtypes.insert("LONG");
        validtypes.insert("CHAR");
        validtypes.insert("BOOLEAN");
        validtypes.insert("VOID");
        validtypes.insert("FLOAT");
        validtypes.insert("DOUBLE");
        validtypes.insert("VAR");
        validtypes.insert("STRING");
    }
    void build (Node* root)
    {
        if(method_invocation_flag)
            curr_symtable=root->symtable;
        if(root->val=="CompilationUnit")
        {
            if(!method_invocation_flag)
            {
                prev_symtable = curr_symtable;
                curr_symtable = new SymbolTable(root->val);
                curr_symtable -> setParent(prev_symtable);
            }

            for(auto child_node: root-> children)
            {
                build(child_node);                
            }
        }
        // else if(root->val=="ClassBody")
        // {
        //     if(!method_invocation_flag)
        //     {
        //         prev_symtable = curr_symtable;
        //         curr_symtable = new SymbolTable(root->val);
        //         curr_symtable -> setParent(prev_symtable);
        //     }
        //     string identifier_class="";
        //     for(auto child_node: root-> children)
        //     {
        //         build(child_node); 
        //         if( child_node->val == "NormalClassDeclaration")
        //         {
        //             // if( identifier_class == "" ) continue;
        //             vector<SymbolEntry*> entries = curr_symtable->lookup(identifier_class);
        //             for( auto entry : entries )
        //             {
        //                 helper->throwerror("Class Redeclared " + identifier_class);
        //             }
        //             if( entries[0] == NULL )
        //             {
        //                 SymbolEntry* entry = new SymbolEntry("IDENTIFIER", identifier_class);
        //                 entry->type="class";
        //                 cout << "Addng Entry" << endl;
        //                 addEntry(entry);
        //             }
        //         }
        //     }

        //     assert(curr_symtable!=NULL);
        //     curr_symtable -> scope = identifier_class;
        //     curr_symtable = curr_symtable -> parent;

        // }
        else if(root->val=="NormalClassDeclaration")
        {
            if(!method_invocation_flag)
            {
                prev_symtable = curr_symtable;
                curr_symtable = new SymbolTable(root->val);
                curr_symtable -> setParent(prev_symtable);
            }

            string identifier_class="";
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="IDENTIFIER")
                    identifier_class=child_node->lexeme;
                       
            }

            assert(curr_symtable!=NULL);
            curr_symtable -> scope = identifier_class;
            curr_symtable = curr_symtable -> parent;

            // if( !method_invocation_flag )
            // {
            //     vector<SymbolEntry*> entries = curr_symtable->lookup(identifier_class);
            //     for( auto entry : entries )
            //     {
            //         helper->throwerror("Class Redeclared " + identifier_class);
            //     }
                // if( entries[0] == NULL )
                // {
                //     SymbolEntry* entry = new SymbolEntry("IDENTIFIER", identifier_class);
                //     entry->type="class";
                //     cout << "Addng Entry" << endl;
                //     addEntry(entry);
                // }
            // }

            SymbolEntry* entry = new SymbolEntry("IDENTIFIER", identifier_class);
            entry->type="class";
            // if( not method_invocation_flag )
            // {
            //     if( not presentEntry(entry) ){
                    addEntry(entry);
                // } else {
            // if( method_invocation_flag ) 
            // {
            //     vector<SymbolEntry*> entries = curr_symtable->lookup(identifier_class);
            //     set<string> s;
            //     for( auto entry : entries )
            //     {
            //         if( s.find(entry->) == s.end() ) s.insert();
            //     }
            // }
            // helper->throwerror("Class "+identifier_class+" Already Declared.");
            //     }
            // }
        }
        else if(root->val=="MethodDeclaration"|| root->val=="ConstructorDeclaration")
        {
            if(!method_invocation_flag)
            {
                prev_symtable = curr_symtable;
                curr_symtable = new SymbolTable(root->val);
                curr_symtable -> setParent(prev_symtable);
            }

            string identifier_method="";
            string method_type="";
            int method_type_dims=0;
            vector<string> arguments_type;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="IDENTIFIER")
                    identifier_method=child_node->lexeme;
                if(child_node->val=="MethodDeclarator"|| child_node->val=="ConstructorDeclarator")
                {
                    identifier_method=child_node->identifier;
                    arguments_type=child_node->arguments_type;
                }
                if(validtypes.find(child_node->lexeme)!=validtypes.end())
                    method_type= child_node->lexeme;
                if(child_node->val=="UnannReferenceType")
                {
                    method_type=child_node->type;
                    method_type_dims=child_node->dims;
                }
            }
            
            assert(curr_symtable!=NULL);
            curr_symtable -> scope = identifier_method;
            curr_symtable = curr_symtable -> parent;

            SymbolEntry* entry = new SymbolEntry("IDENTIFIER", identifier_method);
            entry->type=method_type;
            entry->type_arguments=arguments_type;
            entry->no_arguments=arguments_type.size();
            entry->entry_type="method";
            addEntry(entry);
        }
        else if(strcmp(root->val,"{")==0)
        {
            if(!method_invocation_flag)
            {
                prev_symtable = curr_symtable;
                curr_symtable = new SymbolTable("Block Line number "+to_string(root->lineno));
                curr_symtable -> setParent(prev_symtable);
            }            
        }
        else if(strcmp(root->val,"}")==0)
        {
            assert(curr_symtable!=NULL);
            curr_symtable = curr_symtable -> parent;
        }
        else if(root->val=="MethodDeclarator"|| root->val=="ConstructorDeclarator" )
        {
            string identifier="";
            vector<string> arguments_type;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="IDENTIFIER")
                    identifier=child_node->lexeme;
                if(child_node->val=="FormalParameter")
                    arguments_type.push_back(child_node->type);
            }
            root->identifier=identifier;
            root->arguments_type=arguments_type;
        }
        else if(root->val=="FormalParameter")
        {
            string identifier="";
            string parameter_type="";
            int parameter_type_dims= 0;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="VariableDeclaratorId")
                {
                    identifier=child_node->identifier;
                    parameter_type_dims=child_node->dims;
                }
                if(validtypes.find(child_node->lexeme)!=validtypes.end())
                    parameter_type= child_node->lexeme;
                if(child_node->val=="UnannReferenceType")
                {
                    parameter_type=child_node->type;
                    parameter_type_dims=child_node->dims;
                }
            }
            root->type=parameter_type;
            root->dims=parameter_type_dims;

            SymbolEntry* entry = new SymbolEntry("IDENTIFIER", identifier);
            entry->type=parameter_type;
            if(parameter_type_dims>0)
            {
                entry->entry_type="array";
                entry->no_dimensions=root->dims;
            }
            addEntry(entry);
        }
        else if(root->val=="VariableDeclaratorId")
        {
            string identifier="";
            int variable_dims= 0;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="IDENTIFIER")
                    identifier=child_node->lexeme;
                if(strcmp(child_node->val,"[]")==0)
                {
                    variable_dims++;
                }
            }
            root->identifier=identifier;
            root->dims=variable_dims;
        }
        else if(root->val=="FieldDeclaration" || root->val=="LocalVariableDeclaration")
        {
            string identifier="";
            string field_type="";
            int field_type_dims= 0;
            bool new_used = false;
            string left_type="", right_type="";
            vector<tuple<string,int,string>> identifier_type_list;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(validtypes.find(child_node->lexeme)!=validtypes.end())
                    field_type= child_node->lexeme;
                if(child_node->val=="UnannReferenceType")
                {
                    left_type=child_node->type;
                    field_type=child_node->type;
                    field_type_dims=child_node->dims;
                }
                if(child_node->val=="VariableDeclaratorList"){
                    identifier_type_list=child_node->identifier_type_list;
                    if( child_node->expression_new_used )
                    {
                        new_used = true;
                    }
                }
            }
            for(auto [ele_identifier, ele_dims,ele_type ]: identifier_type_list)
            {
                SymbolEntry* entry = new SymbolEntry("IDENTIFIER", ele_identifier);
                entry->type=field_type;
                cout << field_type << endl;
                if(ele_dims>0)
                {
                    entry->entry_type="array";
                    entry->no_dimensions=ele_dims;
                    helper->checktypearrayacess(entry,field_type,root->lineno);
                }
                else 
                {
                    if( new_used )
                    {
                        if( left_type != ele_type )
                        {
                            helper->throwerror("Line number: " +to_string(root->lineno)+ " ReferenceType "+left_type+" doesn't match with "+ele_type);
                        }
                    } 
                    else 
                    {
                        helper->checktypevariable(entry,field_type,root->lineno);
                    }
                }
                addEntry(entry);
            }
        }
        else if( root->val == "UnannReferenceType" )
        {
            string type="";
            for(auto child_node: root-> children)
            {
                build(child_node); 
                // Nested class support is not mandatory
                if( child_node->token == "IDENTIFIER" )
                {
                    type = child_node->lexeme;
                }
            }
            if( !helper->checkclass( type, curr_symtable) )
            {
                helper->throwerror("Line number: "+to_string(root->lineno)+" No Reference Type "+type+" found.");
            }
            root->type = type;
            // array of reference type not required to support.
            root->dims = 0;
        }
        else if(root->val=="VariableDeclaratorList")
        {
            vector<tuple<string,int,string>> identifier_type_list;
            string type="";
            bool new_used = false;
            for(auto child_node: root-> children)
            {
                build(child_node);       
                if(child_node->val=="VariableDeclaratorId")
                {
                    identifier_type_list.push_back({child_node->identifier,child_node->dims,""});
                }  
                if(strcmp(child_node->val,"=")==0)
                {
                    identifier_type_list.push_back({child_node->identifier,child_node->dims,child_node->type});
                    type=child_node->type;
                    if( child_node->expression_new_used )
                    {
                        new_used = true;
                    }
                }
            }
            if( new_used )
            {
                root->expression_new_used = true;
            }
            root->identifier_type_list=identifier_type_list;
            root->type=type;
        }
        else if(strcmp(root->val,"=")==0)
        {
            string identifier1="";
            string righthand_type="";
            int variable_dims=0;
            int array_dims=0;
            int f=0;
            int righthand_dims=0;
            bool new_used = false;
            for(auto child_node: root-> children)
            {
                build(child_node);    
                if(child_node->token=="VariableDeclaratorId")
                {
                    f=1;
                    identifier1=child_node->identifier;
                    variable_dims=child_node->dims;
                }            
                if(child_node->token=="IDENTIFIER")
                {
                    identifier1=child_node->lexeme;
                }
                if(child_node->val=="Expression")
                {
                    righthand_type=child_node->type;
                    righthand_dims=child_node->dims;
                    if( child_node->expression_new_used )
                    {
                        new_used = true;
                    }
                }
                if(child_node->token=="ArrayAccess")
                {
                    identifier1=child_node->identifier;
                    array_dims=child_node->dims;
                }     
            }
            if( new_used )
            {
                root->expression_new_used = true;
            }
            if(f)
            {
                root->identifier=identifier1;  
                root->dims=variable_dims; 
                root->type=righthand_type;
                if(righthand_dims>0)
                {
                    if(variable_dims!=righthand_dims)
                    {
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Required array access dimensions as "+to_string(variable_dims)+" but found "+to_string(righthand_dims));
                    }
                }
            }
            else if(array_dims>0)
            {
                SymbolEntry* entry= helper->checkarray(identifier1,array_dims,curr_symtable,root->lineno);
                if(entry)
                {
                    bool check = helper->checktypearrayacess(entry,righthand_type, root->lineno);
                    if(check)
                        root->type=righthand_type;
                }
            }
            else
            {
                vector<SymbolEntry*> entry= helper->checkvariable(identifier1,curr_symtable,root->lineno);
                if(entry[0])
                {
                    bool check = helper->checktypevariable(entry[0],righthand_type, root->lineno);
                    if(check)
                        root->type=righthand_type;
                }
            }
        }
        else if(root->val == "ForStatement")
        {
            if(!method_invocation_flag)
            {
                prev_symtable = curr_symtable;
                curr_symtable = new SymbolTable(root->val);
                curr_symtable -> setParent(prev_symtable);
            }

            for(auto child_node: root-> children)
            {
                build(child_node);                
            }
            curr_symtable = curr_symtable -> parent;
        }
        else if(root->val == "Expression" || root->val  == "Statement")
        {
            string exp_type="";
            int dims=0;
            bool new_used = false;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if( child_node->lexeme=="NEW")
                {
                    new_used = true;
                }    
                if(helper->isOperator(child_node->val))
                {
                    exp_type=child_node->type;
                }    
                if(child_node->token=="IDENTIFIER")
                {

                    vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                    if(entry[0])
                        if( entry[0]->type == "class" ) exp_type=entry[0]->lexeme;
                        else exp_type=entry[0]->type;
                }   
                if(child_node->token=="LITERAL")
                {
                    exp_type=child_node->type;
                } 
                if(child_node->token=="ArrayAccess")
                {
                    SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                    if(entry)
                    {
                        exp_type=entry->type;
                    }
                }   
                if(child_node->token=="ArrayCreationExpression")
                {
                    exp_type=child_node->type;
                    dims=child_node->dims;
                } 
                if(child_node->val=="MethodInvocation")
                    exp_type=child_node->type;
            }
            if( new_used )
            {
                root->expression_new_used = true;
            }
            root->type=exp_type;
            root->dims=dims;
        }
        else if( helper->Assign_Operator(root->val) )
        {
            string type1="";
            string type2="";
            // For E1 and E2, E2 can be any value which can be Type casted( implicit or explicit) into E1.
            for( auto child_node : root->children )
            {
                build(child_node);
                if( child_node->token == "IDENTIFIER" )
                {
                   type1=child_node->type;
                   cout << "Identifier *= " << type1 << endl;
                }
                if( child_node->token == "ExpressionName" )
                {
                   type1=child_node->type;
                }
                if( child_node->token == "FieldAccess" )
                {
                   type1=child_node->type;
                }
                if( child_node->token == "ArrayAccess" )
                {
                   type1=child_node->type;
                }
                if( child_node->val == "Expression" )
                {
                    type2=child_node->type;
                }
            }
            // if( root->val == "=" and !castit( type2, type1) ){
            //     throwerror("Error: Incorrect type Conversion from "+type2+" to "+type1+" for assignment not possible.");
            // } else 
            if( type1 == "BOOLEAN" || type2 == "BOOLEAN" )
            {
                string opr = root->val;
                helper->throwerror("Line Number: "+to_string(root->lineno)+" Incorrect type conversion from "+type2+" to "+type1);
            }
        }
        else if( root->val == "PreIncrementExpression" || root->val == "PostDecrementExpression" || root->val == "PreDecrementExpression" || root->val == "PostIncrementExpression" )
        {
            bool isIdentifier = false;
            string type="";
            for( auto child_node : root->children )
            {
                build(child_node);
                if( child_node->token == "IDENTIFIER" )
                {
                    vector<SymbolEntry*> entries = curr_symtable->lookup(child_node->lexeme);
                    for( auto entry : entries )
                    {
                        if( entry->entry_type == "variable" )
                        {
                            type = entries[0]->type;
                            isIdentifier = true;
                        }  
                    }
                }
            }
            if( isIdentifier )
            {
                if( type == "CHAR" || type == "BYTE" || type == "SHORT" || type == "INT" || type == "FLOAT" || type == "LONG" || type == "DOUBLE" )
                {
                    ;
                }
                else 
                {
                    helper->throwerror("Line number "+to_string(root->lineno)+": only numeric type variable expected with the given unary operator");
                }
            } 
            else
            {
                helper->throwerror("Line number "+to_string(root->lineno)+": variable expected with the given unary operator");
            }
        }
        // else if(helper->isUnaryOperator(root->val))
        // {
        //     string type1="";
        //     string type2="";
        //     for(auto child_node: root-> children)
        //     {
        //         build(child_node);   
        //         if(child_node->token=="IDENTIFIER")
        //         {
        //             if(type1=="")
        //             {
        //                 vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
        //                 if(entry[0])
        //                     type1=entry[0]->type;
        //             }
        //             else
        //             {
        //                 vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
        //                 if(entry[0])
        //                     type2=entry[0]->type;
        //             }     
        //         }
        //         if(child_node->val=="ArrayAccess")
        //         {
        //             SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
        //             if(entry)
        //             {
        //                 if(type1=="")
        //                     type1=entry->type;
        //                 else
        //                     type2=entry->type;
        //             }
        //         }
        //         if(helper->isOperator(child_node->val)|| child_node->val=="Expression"|| child_node->token=="LITERAL")
        //         {
        //             if(type1=="")
        //                 type1=child_node->type;
        //             else
        //                 type2=child_node->type;
        //         }   
        //     }
        //     if(!helper->castit(type1,type2))
        //     {
        //         helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible types i.e. conversion from "+type1 + " to "+type2);
        //     }
        //     root->type=type1;
        // }
        else if(helper->isOperator(root->val))
        {
            string type1="";
            string type2="";
            for(auto child_node: root-> children)
            {
                build(child_node);   
                if(child_node->token=="IDENTIFIER")
                {
                    if(type1=="")
                    {
                        vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                        if(entry[0])
                            type1=entry[0]->type;
                    }
                    else
                    {
                        vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                        if(entry[0])
                            type2=entry[0]->type;
                    }     
                }
                if(child_node->val=="ArrayAccess")
                {
                    SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                    if(entry)
                    {
                        if(type1=="")
                            type1=entry->type;
                        else
                            type2=entry->type;
                    }
                }
                if(helper->isOperator(child_node->val)|| child_node->val=="Expression"|| child_node->token=="LITERAL")
                {
                    if(type1=="")
                        type1=child_node->type;
                    else
                        type2=child_node->type;
                }   
            }
            if( root->children.size() == 1 )
            {
                type2 = type1;
            }
            if(!helper->castit(type1,type2))
            {
                helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible types i.e. conversion from "+type1 + " to "+type2);
            }
            root->type=type1;
        }
        else if(root->val=="ArrayAccess")
        {
            string identifier="";
            int array_dims= 0;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="IDENTIFIER")
                    identifier=child_node->lexeme;
                if(child_node->val=="Expression")
                {
                    array_dims++;
                    bool ans = helper->typecast(child_node,"INT");
                    if(!ans)
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incorrect type in array access expression");
                }
                if(child_node->val=="ArrayAccess")
                {
                    identifier=child_node->identifier;
                    array_dims+=child_node->dims;
                }
            }
            root->identifier=identifier;
            root->dims=array_dims;
        }
        else if(root->val=="ArrayCreationExpression")
        {
            string array_type="";
            int type_dims=0;
            int variable_dims = 0;
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(validtypes.find(child_node->lexeme)!=validtypes.end())
                    array_type= child_node->lexeme;
                if(child_node->val=="UnannReferenceType")
                {
                    array_type=child_node->type;
                    type_dims=child_node->dims;
                }
                if(child_node->val=="DimExprs")
                {
                    variable_dims += child_node->dims;    
                }
                if(child_node->val=="[]")
                {
                    variable_dims++;    
                }
            }
            root->type=array_type;
            root->dims=variable_dims;
        }
        else if(root->val=="DimExprs")
        {
            int variable_dims = 0;
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(child_node->val=="Expression")
                {
                    bool ans = helper->typecast(child_node,"INT");
                    variable_dims++;
                    if(!ans)
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incorrect type in dimensions specification expression");
                }
            }
            root->dims = variable_dims;
        }
        else if(root->val=="MethodInvocation")
        {
            string identifier="";
            vector<string> arguments_type;
            for(auto child_node: root-> children)
            {
                build(child_node);       
                if(child_node->token=="IDENTIFIER")
                {
                    identifier=child_node->lexeme;
                }  
                if(child_node->val=="ArgumentList")
                {
                    arguments_type=child_node->arguments_type;
                }
            }
            root->identifier=identifier;
            root->arguments_type=arguments_type;
            if(method_invocation_flag)
            {
                SymbolEntry* entry = helper->checkmethod(identifier,arguments_type,curr_symtable,root->lineno);
                if(entry)
                    root->type=entry->type;
            }
        }
        else if(root->val=="ArgumentList")
        {
            vector<string> arguments_type;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if( child_node->val=="Expression")
                {
                    arguments_type.push_back(child_node->type);
                }
            }
            root->arguments_type=arguments_type;
        }
        else
        {
            for(auto child_node: root-> children)
            {
                build(child_node);                
            }
        }
        root->symtable=curr_symtable;
    }
};