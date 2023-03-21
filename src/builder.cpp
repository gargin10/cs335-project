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
    set<string> validstartscopes;
    set<string> validtypes;
    set<string> validmodifiers;
    SymbolTable* curr_symtable;
    SymbolTable* prev_symtable;

    SymbolTableBuilder()
    {
        createvalidstartscopes();
        createValidTypes();
        curr_symtable=NULL;
        prev_symtable=NULL;
    }
    void addEntry(SymbolEntry* entry)
    {
        assert(curr_symtable!=NULL);
        curr_symtable->insert(entry);
    }
    void createvalidstartscopes()
    {
        validstartscopes.insert("CompilationUnit");
        validstartscopes.insert("NormalClassDeclaration");
        validstartscopes.insert("MethodDeclaration");
        validstartscopes.insert("ForStatement");
        validstartscopes.insert("ConstructorDeclaration");
    }
    bool validstartscope(Node* root)
    {
        string s(root->val);
        if(validstartscopes.find(s)!=validstartscopes.end())
            return true;
        return false;
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
    }

    void build (Node* root)
    {
        string type="";
        vector<string> modifiers;
        vector<string> typeargs;
        vector<pair<string,int>> id_list;
        string temp_identifier="";
        string literal_type="";
        int dims=0;
        if(validstartscope(root))
        {
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable(root->val);
            curr_symtable -> setParent(prev_symtable);
        }
        if(strcmp(root->val,"{")==0)
        {
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable("Block Line number "+to_string(root->lineno));
            curr_symtable -> setParent(prev_symtable);
        }
        if(strcmp(root->val,"}")==0)
        {
            assert(curr_symtable!=NULL);
            curr_symtable = curr_symtable -> parent;
        }
            
        for(auto child_node: root-> children)
        {
            build(child_node);
            
            // if(is_modifier(child_node->val))
            //     modifiers.push_back(child_node->val);
            if(validtypes.find(child_node->lexeme)!=validtypes.end())
                type= child_node->lexeme;
            
            if(child_node->val=="MethodDeclarator"|| child_node->val=="ConstructorDeclarator")
            {
                temp_identifier=child_node->lexeme;
                typeargs=child_node->typeargs;
            }
            if(child_node->val=="FormalParameter")
                typeargs.push_back(child_node->lexeme);
            if(child_node->val=="VariableDeclaratorList")
            {
                id_list=child_node->tempargs;
            }
            if(child_node->val=="VariableDeclaratorId")
            {
                temp_identifier=child_node->lexeme;
                dims=child_node->dims;
                id_list.push_back({temp_identifier,dims});
            }
            if(strcmp(child_node->val,"=")==0)
            {
                id_list.push_back({child_node->lexeme,child_node->dims});  
                dims=child_node->dims; 
            }
            if(strcmp(child_node->val,"[]")==0)
                dims++; 

            if(isOperator(child_node->val))
                literal_type=child_node->type;
            if(child_node->token=="LITERAL")
                literal_type=child_node->type;
            if(isOperator(child_node->val))
            {
                temp_identifier=child_node->lexeme;
                literal_type=child_node->type;
            }
            if(child_node->val=="Expression")
                literal_type=child_node->type;
            if(child_node->token=="IDENTIFIER")
            {
                temp_identifier=child_node->lexeme;
                id_list.push_back({child_node->lexeme,0});
                // cout<<"here for "<<root->val<<" "<<temp_identifier<<"\n";
            } 
        }
        // cout<<temp_identifier<<" ";
        if(isOperator(root->val))
        {
            root->lexeme=temp_identifier;
            root->type=literal_type;
        }
        if(strcmp(root->val,"=")==0)
        {
            root->lexeme=temp_identifier;  
            root->dims=dims; 
        }
        if(root->val=="VariableDeclaratorId")
        {
            root->lexeme=temp_identifier;
            root->dims=dims;
        }
        if(root->val=="VariableDeclaratorList")
        {
            root->tempargs=id_list;
        }
        if(root->val=="FormalParameter")
        {
            if(type=="")
                type=id_list[0].first;
            root->lexeme=type;
            root->dims=dims;
            SymbolEntry* entry = new SymbolEntry("IDENTIFIER", temp_identifier);
            entry->type=type;
            if(dims>0)
            {
                entry->entry_type="array";
                entry->no_dimensions=dims;
            }
            addEntry(entry);
        }
        if(root->val=="MethodDeclarator"|| root->val=="ConstructorDeclarator")
        {
            root->lexeme=temp_identifier;
            root->typeargs=typeargs;
        }
        if(root->val=="NormalClassDeclaration")
        {
            assert(curr_symtable!=NULL);
            curr_symtable -> scope = temp_identifier;
            curr_symtable = curr_symtable -> parent;
            SymbolEntry* entry = new SymbolEntry("IDENTIFIER", temp_identifier);
            entry->type="class";
            addEntry(entry);
        }
        if(root->val=="MethodDeclaration"|| root->val=="ConstructorDeclaration")
        {
            assert(curr_symtable!=NULL);
            curr_symtable -> scope = temp_identifier;
            curr_symtable = curr_symtable -> parent;
            SymbolEntry* entry = new SymbolEntry("IDENTIFIER", temp_identifier);
            entry->type=type;
            entry->type_arguments=typeargs;
            entry->no_arguments=typeargs.size();
            entry->entry_type="method";
            addEntry(entry);
        }
        if(root->val=="FieldDeclaration")
        {
            for(auto ele: id_list)
            {
                SymbolEntry* entry = new SymbolEntry("IDENTIFIER", ele.first);
                entry->type=type;
                if(ele.second>0)
                {
                    entry->entry_type="array";
                    entry->no_dimensions=ele.second;
                }
                addEntry(entry);
            }
        }
        if(root->val=="LocalVariableDeclaration")
        {
            if(type=="")
                type=temp_identifier;
            for(auto ele: id_list)
            {
                SymbolEntry* entry = new SymbolEntry("IDENTIFIER", ele.first);
                entry->type=type;
                if(ele.second>0)
                {
                    entry->entry_type="array";
                    entry->no_dimensions=ele.second;
                }
                addEntry(entry);
            }
        }
        if(root->val == "ForStatement")
        {
            curr_symtable = curr_symtable -> parent;
        }
        if((root->val == "Expression" || root->val  == "Statement")&& temp_identifier!="")
        {
            SymbolEntry* entry= checkvariable(temp_identifier,curr_symtable,root->lineno);
            if(entry && literal_type!="")
            {
                bool check = checktypevariable(entry,literal_type, root->lineno);
                if(check)
                root->type=entry->type;
            }
        }
        if(root->val == "Assignment"|| root->val == "ArrayAccess")
        {
            SymbolEntry* entry= checkvariable(temp_identifier,curr_symtable,root->lineno);
            if(entry && literal_type!="")
            {
                bool check = checktypevariable(entry,literal_type, root->lineno);
                if(check)
                root->type=entry->type;
            }
        }
        if(root->val == "PostIncrementExpression"|| root->val == "PreIncrementExpression" || root->val == "PostDecrementExpression"|| root->val == "PreDecrementExpression")
        {
            SymbolEntry* entry= checkvariable(temp_identifier,curr_symtable,root->lineno);
            if(entry && literal_type!="")
            {
                bool check = checktypevariable(entry,literal_type, root->lineno);
                if(check)
                root->type=entry->type;
            }
        }
    }
};