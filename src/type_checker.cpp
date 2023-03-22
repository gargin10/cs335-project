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
            vector<pair<string,int>> identifier_list;
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
                    identifier_list=child_node->identifier_list;
            }
            for(auto ele: identifier_list)
            {
                SymbolEntry* entry = new SymbolEntry("IDENTIFIER", ele.first);
                entry->type=field_type;
                if(ele.second>0)
                {
                    entry->entry_type="array";
                    entry->no_dimensions=ele.second;
                }
                addEntry(entry);
            }
        }
        else if(root->val=="VariableDeclaratorList")
        {
            vector<pair<string,int>> identifier_list;
            for(auto child_node: root-> children)
            {
                build(child_node);       
                if(child_node->val=="VariableDeclaratorId")
                {
                    identifier_list.push_back({child_node->identifier,child_node->dims});
                }  
                if(strcmp(child_node->val,"=")==0)
                {
                    identifier_list.push_back({child_node->identifier,child_node->dims});
                }
            }
            root->identifier_list=identifier_list;
        }
        else if(strcmp(root->val,"=")==0)
        {
            string identifier="";
            int variable_dims=0;
            for(auto child_node: root-> children)
            {
                build(child_node);    
                if(child_node->token=="VariableDeclaratorId")
                {
                    identifier=child_node->identifier;
                    variable_dims=child_node->dims;
                }            
            }
            root->identifier=identifier;  
            root->dims=variable_dims; 
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