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

    SymbolTableBuilder()
    {
        createValidTypes();
        curr_symtable=NULL;
        prev_symtable=NULL;
    }
    void addEntry(SymbolEntry* entry)
    {
        assert(curr_symtable!=NULL);
        curr_symtable->insert(entry);
    }
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
        if(root->val=="CompilationUnit")
        {
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable(root->val);
            curr_symtable -> setParent(prev_symtable);

            for(auto child_node: root-> children)
            {
                build(child_node);                
            }
        }
        else if(root->val=="NormalClassDeclaration")
        {
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable(root->val);
            curr_symtable -> setParent(prev_symtable);

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

            SymbolEntry* entry = new SymbolEntry("IDENTIFIER", identifier_class);
            entry->type="class";
            addEntry(entry);
        }
        else if(root->val=="MethodDeclaration"|| root->val=="ConstructorDeclaration")
        {
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable(root->val);
            curr_symtable -> setParent(prev_symtable);

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
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable("Block Line number "+to_string(root->lineno));
            curr_symtable -> setParent(prev_symtable);
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
            vector<tuple<string,int,string>> identifier_type_list;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(validtypes.find(child_node->lexeme)!=validtypes.end())
                    field_type= child_node->lexeme;
                if(child_node->val=="UnannReferenceType")
                {
                    field_type=child_node->type;
                    field_type_dims=child_node->dims;
                }
                if(child_node->val=="VariableDeclaratorList")
                    identifier_type_list=child_node->identifier_type_list;
            }
            for(auto [ele_identifier, ele_dims,ele_type ]: identifier_type_list)
            {
                SymbolEntry* entry = new SymbolEntry("IDENTIFIER", ele_identifier);
                entry->type=field_type;
                if(ele_dims>0)
                {
                    entry->entry_type="array";
                    entry->no_dimensions=ele_dims;
                }
                if(ele_type!="")
                    checktypevariable(entry,field_type,root->lineno);
                addEntry(entry);
            }
        }
        else if(root->val=="VariableDeclaratorList")
        {
            vector<tuple<string,int,string>> identifier_type_list;
            string type="";
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
                }
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
                }
                if(child_node->token=="ArrayAccess")
                {
                    identifier1=child_node->identifier;
                    array_dims=child_node->dims;
                }     
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
                        throwerror("Required array access dimensions as "+to_string(variable_dims)+" but found "+to_string(righthand_dims)+" Line number: "+to_string(root->lineno));
                    }
                }
            }
            else if(righthand_dims>0)
            {
                SymbolEntry* entry= checkarray(identifier1,array_dims,curr_symtable,root->lineno);
                if(entry)
                {
                    bool check = checktypearrayacess(entry,righthand_type, root->lineno);
                    if(check)
                        root->type=righthand_type;
                }
            }
            else
            {
                SymbolEntry* entry= checkvariable(identifier1,curr_symtable,root->lineno);
                if(entry)
                {
                    bool check = checktypevariable(entry,righthand_type, root->lineno);
                    if(check)
                        root->type=righthand_type;
                }
            }
        }
        else if(root->val == "ForStatement")
        {
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable(root->val);
            curr_symtable -> setParent(prev_symtable);

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
            for(auto child_node: root-> children)
            {
                build(child_node);      
                if(isOperator(child_node->val))
                {
                    exp_type=child_node->type;
                }    
                if(child_node->token=="IDENTIFIER")
                {
                    SymbolEntry* entry= checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                    exp_type=entry->type;
                }   
                if(child_node->token=="LITERAL")
                {
                    exp_type=child_node->type;
                } 
                if(child_node->token=="ArrayAccess")
                {
                    SymbolEntry* entry= checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
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
            }
            root->type=exp_type;
            root->dims=dims;
        }
        else if(isOperator(root->val))
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
                        SymbolEntry* entry= checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                        if(entry)
                            type1=entry->type;
                    }
                    else
                    {
                        SymbolEntry* entry= checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                        if(entry)
                            type2=entry->type;
                    }     
                }
                // cout<<child_node->token<<" ";
                if(isOperator(child_node->val)|| child_node->val=="Expression" || child_node->token=="LITERAL")
                {
                    
                    if(type1=="")
                        type1=child_node->type;
                    else
                        type2=child_node->type;
                }   
            }
            if(!castit(type1,type2))
            {
                throwerror("Incompatible types i.e. conversion from "+type1 + " to "+type2+" Line number: "+to_string(root->lineno));
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
                    bool ans = typecast(child_node,"INT");
                    if(!ans)
                        throwerror("Incorrect type in array access expression Line number: "+to_string(root->lineno));
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
                    bool ans = typecast(child_node,"INT");
                    variable_dims++;
                    if(!ans)
                        throwerror("Incorrect type in dimensions specification expression");
                }
            }
            root->dims = variable_dims;
        }
        else
        {
            for(auto child_node: root-> children)
            {
                build(child_node);                
            }
        }
    }
};