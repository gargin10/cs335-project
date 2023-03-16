#pragma once

#include "SymbolEntry.cpp"
#include "SymbolTable.cpp"
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

    bool scope_created=0;

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
        validstartscopes.insert("CURLYBRACESTART");
    }
    bool validstartscope(Node* root)
    {
        if(validstartscopes.find(root->val)!=validstartscopes.end())
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
        vector<string> id_list;
        if(!scope_created && validstartscope(root))
        {
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable(root->val);
            curr_symtable -> setParent(prev_symtable);
        }

        if(root->val=="NormalClassDeclaration" || root->val=="MethodDeclaration")
        {
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable(root->val);
            curr_symtable -> setParent(prev_symtable);
            scope_created=1;
        }
        if(!scope_created && root->val == "CURLYBRACEEND")
        {
            assert(curr_symtable!=NULL);
            curr_symtable = curr_symtable -> parent;
            type="";
        }
            
        for(auto child_node: root-> children)
        {
            build(child_node);
            // if(is_modifier(child_node->val))
            //     modifiers.push_back(child_node->val);
            if(validtypes.find(child_node->lexeme)!=validtypes.end())
                type= child_node->lexeme;
            if(child_node->token=="IDENTIFIER")
                id_list.push_back(child_node->lexeme);
            if(child_node->val=="MethodDeclarator")
            {
                id_list.push_back(child_node->lexeme);
                typeargs=child_node->tempargs;
            }
            if(child_node->val=="FormalParameter")
                typeargs.push_back(child_node->lexeme);
            if(child_node->val=="VariableDeclaratorList")
                id_list=child_node->tempargs;
        }

        if(root->val=="VariableDeclaratorList")
        {
            root->tempargs=id_list;
        }
        if(root->val=="FormalParameter")
        {
            root->lexeme=type;
            SymbolEntry* entry = new SymbolEntry("IDENTIFIER", id_list[0]);
            entry->type=type;
            addEntry(entry);
        }
        if(root->val=="MethodDeclarator")
        {
            root->lexeme=id_list[0];
            root->tempargs=typeargs;
        }
        if(root->val=="NormalClassDeclaration")
        {
            scope_created=0;
            assert(curr_symtable!=NULL);
            curr_symtable -> scope = id_list[0];
            curr_symtable = curr_symtable -> parent;
            SymbolEntry* entry = new SymbolEntry("IDENTIFIER", id_list[0]);
            entry->type="class";
            addEntry(entry);
        }
        if(root->val=="MethodDeclaration")
        {
            scope_created=0;
            assert(curr_symtable!=NULL);
            curr_symtable -> scope = id_list[0];
            curr_symtable = curr_symtable -> parent;
            SymbolEntry* entry = new SymbolEntry("IDENTIFIER", id_list[0]);
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
                SymbolEntry* entry = new SymbolEntry("IDENTIFIER", ele);
                entry->type=type;
                addEntry(entry);
            }
        }
    }
};