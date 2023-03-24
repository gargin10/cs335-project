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
            entry->type="label";
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
        else if(root->val=="IfThenStatement")
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
            }
            Node* condition = root->children[2];
            Node* thencond = root->children[4];

            builder->merge_entries(root,condition->code_entries);   

            string label=generatelabel();
            ThreeAddressCodeEntry* entry1 = new ThreeAddressCodeEntry();
            entry1->arg1=label;
            entry1->type="label";
            thencond->label_entry=label;

            ThreeAddressCodeEntry* entry2 = new ThreeAddressCodeEntry();
            entry2->type="if";
            entry2->arg1="IfTrue";
            entry2->arg2=condition->label_entry;
            entry2->arg3="goto";
            entry2->arg4=thencond->label_entry;
            root->code_entries.push_back(entry2);

            root->code_entries.push_back(entry1);
            builder->merge_entries(root,thencond->code_entries);   
        }
        else if(root->val=="IfThenElseStatement"||root->val=="IfThenElseStatementNoShortIf")
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
            }
                        
            Node* condition = root->children[2];
            Node* thencond = root->children[4];
            Node* elsestmt = root->children[6];

            builder->merge_entries(root,condition->code_entries);   

            string label=generatelabel();
            ThreeAddressCodeEntry* entry1= new ThreeAddressCodeEntry();
            entry1->arg1=label;
            entry1->type="label";
            thencond->label_entry=label;
            
            ThreeAddressCodeEntry* entry2= new ThreeAddressCodeEntry();
            entry2->type="if";
            entry2->arg1="IfTrue";
            entry2->arg2=condition->label_entry;
            entry2->arg3="goto";
            entry2->arg4=thencond->label_entry;
            root->code_entries.push_back(entry2);

            label=generatelabel();
            ThreeAddressCodeEntry* entry3= new ThreeAddressCodeEntry();
            entry3->arg1=label;
            entry3->type="label";
            elsestmt->label_entry=label; 

            ThreeAddressCodeEntry* entry4= new ThreeAddressCodeEntry();
            entry4->type="else";
            entry4->arg1="Else";
            entry4->arg2="goto";
            entry4->arg3=elsestmt->label_entry;
            root->code_entries.push_back(entry4);
            
            root->code_entries.push_back(entry1);
            builder->merge_entries(root,thencond->code_entries);  
            root->code_entries.push_back(entry3);
            builder->merge_entries(root,elsestmt->code_entries);   
        }
        else if(root->val=="ForStatement")
        {
            Node* forinit;
            Node* expression;
            Node* forupdate;
            Node* statement;
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(child_node->val=="ForInit")
                    forinit=child_node;
                else if(child_node->val=="Expression" || child_node->val=="LocalVariableDeclaration")
                    expression=child_node;
                else if(child_node->val=="ForUpdate")
                    forupdate=child_node;
                statement=child_node;
            }
            if(!expression)
            {
                string label1=generatelabel();
                ThreeAddressCodeEntry* label_entry_1= new ThreeAddressCodeEntry();
                label_entry_1->arg1=label1;
                label_entry_1->type="label";

                string label2=generatelabel();
                ThreeAddressCodeEntry* label_entry_2= new ThreeAddressCodeEntry();
                label_entry_2->arg1=label2;
                label_entry_2->type="label";

                ThreeAddressCodeEntry* entry3= new ThreeAddressCodeEntry();
                entry3->type="goto";
                entry3->arg1="goto";
                entry3->arg2=label1;

                if(forinit)
                builder->merge_entries(root,forinit->code_entries);
                root->code_entries.push_back(label_entry_1);
                builder->merge_entries(root,statement->code_entries);
                if(forupdate)
                builder->merge_entries(root,forupdate->code_entries);
                root->code_entries.push_back(entry3);
                root->code_entries.push_back(label_entry_2);
                return;
            }
            string label1=generatelabel();
            ThreeAddressCodeEntry* label_entry_1= new ThreeAddressCodeEntry();
            label_entry_1->arg1=label1;
            label_entry_1->type="label";

            string label2=generatelabel();
            ThreeAddressCodeEntry* label_entry_2= new ThreeAddressCodeEntry();
            label_entry_2->arg1=label2;
            label_entry_2->type="label";

            string label3=generatelabel();
            ThreeAddressCodeEntry* label_entry_3= new ThreeAddressCodeEntry();
            label_entry_3->arg1=label3;
            label_entry_3->type="label";

            ThreeAddressCodeEntry* entry1= new ThreeAddressCodeEntry();
            entry1->type="if";
            entry1->arg1="IfTrue";
            entry1->arg2=expression->label_entry;
            entry1->arg3="goto";
            entry1->arg4=label2;

            ThreeAddressCodeEntry* entry2= new ThreeAddressCodeEntry();
            entry2->type="if";
            entry2->arg1="Else";
            entry2->arg2="goto";
            entry2->arg3=label3;

            ThreeAddressCodeEntry* entry3= new ThreeAddressCodeEntry();
            entry3->type="goto";
            entry3->arg1="goto";
            entry3->arg2=label1;

            if(forinit)
                builder->merge_entries(root,forinit->code_entries);

            root->code_entries.push_back(label_entry_1);
            builder->merge_entries(root,expression->code_entries);
            root->code_entries.push_back(entry1);
            root->code_entries.push_back(entry2);
            root->code_entries.push_back(label_entry_2);
            builder->merge_entries(root,statement->code_entries);
            if(forupdate)
                builder->merge_entries(root,forupdate->code_entries);
            root->code_entries.push_back(entry3);
            root->code_entries.push_back(label_entry_3);
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