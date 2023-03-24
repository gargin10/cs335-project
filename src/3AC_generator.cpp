#pragma once

#include "SymbolEntry.cpp"
#include "SymbolTable.cpp"
#include "helper.cpp"
#include "3AC.cpp"

#include <map>
#include <iostream>
#include <cstdio>
using namespace std;

class ThreeAddressCodeGenerator {

public:
    SymbolTable* curr_symtable;
    Helper* helper;
    ThreeAddressCodeBuilder* builder;
    int nextinstr=0;
    int co_labels=0;
    int co_temps=0;
    string class_scope="";
    string method_file="";
    ThreeAddressCodeGenerator()
    {
        curr_symtable=NULL;
        helper=new Helper();
        builder=new ThreeAddressCodeBuilder();
    }

    void set_method_file(string filename)
    {
        method_file=filename;
        co_labels=0;
        co_temps=0;
    }
    string generatelabel()
    {
        co_labels++;
        string temp="$L"+to_string(co_labels);
        return temp;
    }

    string generatetemp()
    {
        co_temps++;
        string temp="$"+to_string(co_temps);
        return temp;
    }
    void build (Node* root)
    {
        curr_symtable=root->symtable;
        if(root->val=="NormalClassDeclaration")
        {
            class_scope=root->identifier;
            for(auto child_node: root-> children)
            {
                build(child_node); 
            }
        }
        else if(root->val=="MethodDeclaration")
        {
            Node* methodDeclarator;
            root->label_entry=root->identifier;
            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            entry->arg1=root->label_entry;
            entry->entry_type="label";
            root->code_entries.push_back(entry);
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);               
            }
            set_method_file(class_scope+"."+root->identifier);
            builder->display(root,method_file);
            root->code_entries.clear();
        }
        else if(root->val=="VariableDeclaratorId")
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);               
            }
            root->label_entry=root->identifier;
        }
        else if(strcmp(root->val,"=")==0)
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
            }
            Node* node1=root->children[0];
            Node* node2=root->children[1];
            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();

            entry->arg1=node1->label_entry;
            entry->arg2=node2->label_entry;

            builder->merge_entries(root,node1->code_entries);
            builder->merge_entries(root,node2->code_entries);
            root->code_entries.push_back(entry);
            root->label_entry=node1->label_entry;

            //temporarily
            // builder->display(root);
        }
        else if(helper->isOperator(root->val))
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
            }
            Node* node1=root->children[0];
            Node* node2=root->children[1];
            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();

            string label=generatetemp();
            entry->arg1=label;
            entry->arg2=node1->label_entry;
            entry->arg3=root->val;
            entry->arg4=node2->label_entry;

            builder->merge_entries(root,node1->code_entries);
            builder->merge_entries(root,node2->code_entries);
            root->code_entries.push_back(entry);
            root->label_entry=label;

            //temporarily
            // builder->display(root);
        }
        else if(root->val=="Expression")
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);               
            }
            root->label_entry=root->children[0]->label_entry;
        }
        else if(root->token=="LITERAL")
        {
            root->label_entry=root->lexeme;
        }
        else if(root->token=="IDENTIFIER")
        {
            root->label_entry=root->lexeme;
        }
        else
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);               
            }
        }
        root->symtable=curr_symtable;
    }
};