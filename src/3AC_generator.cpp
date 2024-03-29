#pragma once

#include "SymbolEntry.cpp"
#include "SymbolTable.cpp"
#include "helper.cpp"
#include "3AC.cpp"

#include <map>
#include <iostream>
#include <cstdio>
using namespace std;

map<string, int> func_offset; // Stores total offset of local variables for each function.
int offset_block_function;  // Calculating total offset for all the local+temp variables inside a block.

class ThreeAddressCodeGenerator {

public:
    SymbolTable* curr_symtable;
    Helper* helper;
    ThreeAddressCodeBuilder* builder;
    int co_labels=0;
    int co_temps=0;
    int array_size=0;
    string class_scope="";
    string method_file="";

    string currclass_this="";
    ThreeAddressCodeGenerator()
    {
        curr_symtable=NULL;
        helper=new Helper();
        builder=new ThreeAddressCodeBuilder();
    }

    void set_method_file(string filename)
    {
        method_file="./output/"+filename+".3ac";
        co_labels=0;
        array_size=0;
    }
    string generatelabel()
    {
        co_labels++;
        string temp=".L"+to_string(co_labels);
        return temp;
    }

    string generatetemp()
    {
        co_temps++;
        string temp="$t"+to_string(co_temps);
        return temp;
    }

    int getsize(string type){
        if(type=="INT" || type=="FLOAT" || type =="BYTE")
            return 4;
        else if(type=="DOUBLE" || type=="LONG")
            return 8;
        else if(type=="CHAR" || type=="BYTE")
            return 1;
        else if(type=="BOOLEAN")
            return 1;
        else if(type=="VOID")
            return 0;
        else if(type=="SHORT")
            return 2;
        return 8;
    }
    void set_break_gotos(Node* node, string label)
    {
        for(auto ele: node->code_entries)
        {
            if(ele->type=="breakgoto" && ele->arg2.first=="")
                ele->arg2.first=label;
        }
    }
    void set_continue_gotos(Node* node, string label)
    {
        for(auto ele: node->code_entries)
        {
            if(ele->type=="continuegoto" && ele->arg2.first=="")
                ele->arg2.first=label;
        }
    }
    void build (Node* root)
    {
        if(root->symtable)
        curr_symtable=root->symtable;
        if(root->val=="NormalClassDeclaration")
        {
            co_temps = 0;
            class_scope=root->identifier;
            root->label_entry=root->identifier;
            
            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            entry->arg1.first=root->label_entry;
            entry->type="classdecl";
            root->code_entries.push_back(entry);

            for(auto child_node: root-> children)
            {
                build(child_node); 
                builder->merge_entries(root,child_node->code_entries); 
            }
        }
        else if(root->val=="MethodDeclaration" || root->val=="ConstructorDeclaration")
        {
            co_temps = 0;
            root->label_entry=root->identifier;
            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            entry->arg1.first=root->label_entry;
            entry->type="funcdecl";
            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->type = "stack";
            entry->arg1.first = "beginfunc";
            root->code_entries.push_back(entry);

            root->size = 16 + getsize(root->type);

            entry = new ThreeAddressCodeEntry();
            entry->type = "comment";
            entry->arg1.first = "PROLOGUE";
            root->code_entries.push_back(entry);

            string temp = generatetemp(); // offset_block_function += 4;
            entry = new ThreeAddressCodeEntry();
            entry->arg1.first = temp ;
            entry->arg2.first = "load";
            entry->arg3.first = to_string(root->size)+"(stackpointer)";
            entry->comment ="// Get object reference, implicit this pointer";
            root->code_entries.push_back(entry);

            currclass_this = temp; //set the this pointer for this function

            offset_block_function = 0;

            Node* block;
            for(auto child_node: root-> children)
            {
                if(child_node->val == "Block")
                {
                    block=child_node;
                    continue;
                }
                child_node->size=root->size;
                build(child_node);
                builder->merge_entries(root,child_node->code_entries); 
                root->size = child_node->size;
            }

            entry = new ThreeAddressCodeEntry();
            entry->type = "stack";
            entry->arg1.first = "push";
            entry->arg2.first = "basepointer";
            entry->comment ="// Push base pointer to the stack";
            root->code_entries.push_back(entry);

            // entry= new ThreeAddressCodeEntry();
            // entry->type="stack";
            // entry->arg1.first="sub";
            // entry->arg2.first="stackpointer";
            // entry->arg3.first="8";
            // entry->comment ="// Allocate space in stack for base pointer";
            // root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->arg1.first="stackpointer";
            entry->arg2.first="basepointer";
            entry->comment ="// Update the base pointer to the current stack pointer";
            root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->type="localvar_allocate";
            entry->arg1.first="sub";
            entry->arg2.first="stackpointer";
            entry->arg3.first=to_string(root->sym_entry->offset);
            entry->comment ="// Allocate space in stack for the local variables";
            root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->type="stack";
            entry->arg1.first="sub";
            entry->arg2.first="stackpointer";
            entry->arg3.first="size(saved_registers)";
            entry->comment ="// Allocate space in stack for saved registers";
            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->type = "comment";
            entry->arg1.first = "PROLOGUE";
            root->code_entries.push_back(entry);

            // offset_block_function = 0;

            build(block);
            builder->merge_entries(root,block->code_entries);

            func_offset[root->label_entry] = offset_block_function;

            entry = new ThreeAddressCodeEntry();
            entry->type = "comment";
            entry->arg1.first = "EPILOGUE";
            root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->arg1.first="basepointer";
            entry->arg2.first="stackpointer";
            entry->comment ="// Restore the stack pointer to the callee base pointer";
            root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->type="stack";
            entry->arg1.first="add";
            entry->arg2.first="stackpointer";
            entry->arg3.first="8";
            entry->comment ="// Pop the base pointer pushed to the stack";
            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->type = "comment";
            entry->arg1.first = "EPILOGUE";
            root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->type="stack";
            entry->arg1.first="return";
            entry->comment ="// Return instruction to the saved return address";
            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->type = "funcend";
            entry->arg1.first = "endfunc";
            entry->arg2.first = root->type; // endfunc entry return type in arg2.first
            root->code_entries.push_back(entry);

            // set_method_file(class_scope+"."+root->identifier);
            // builder->display(root,method_file);
            // root->code_entries.clear();
            // func_offset[root->label_entry] = root->sym_entry->offset;
        }
        else if(root->val == "MethodDeclarator" || root->val == "ConstructorDeclarator")
        {
            for(auto child_node: root-> children)
            {
                child_node->size = root ->size;
                build(child_node);
                builder->merge_entries(root,child_node->code_entries); 
                root->size = child_node->size;
            }
        }
        else if(root->val == "FormalParameter")
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
            }
            root->size += getsize(root->type);
            // string temp = generatetemp();
            // ThreeAddressCodeEntry* entry= new ThreeAddressCodeEntry();
            // entry->arg1.first=temp;
            // entry->arg2.first="PopParameter";

            // root->code_entries.push_back(entry);

            ThreeAddressCodeEntry* entry= new ThreeAddressCodeEntry();
            entry -> type = "funcparam";
            entry->arg1.first=root->children[1]->label_entry;
            entry->arg1.second = curr_symtable->lookup(entry->arg1.first)[0];
            entry->arg2.first="load";
            entry->arg3.first=to_string(root->size)+"(stackpointer)";
            entry->comment="// Load parameter from the caller saved stack address";
            offset_block_function += 4;
            root->code_entries.push_back(entry);

        }
        else if(root->val=="VariableDeclaratorId")
        {
            Node* node;
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);  
                if(child_node->token=="IDENTIFIER")   
                    node=child_node;
            }
            vector<SymbolEntry*> entry= helper->checkvariable(node->identifier,curr_symtable,root->lineno);
            root->label_entry=root->identifier;
            if(entry.size()>0)
            root->type=entry[0]->type;
            if( root->type == "CHAR" || root->type == "BYTE" || root->type == "SHORT" || root->type == "INT" || root->type == "LONG" || root->type == "BOOLEAN" ){
                offset_block_function += getsize(root->type);
            }
        }
        else if(strcmp(root->val,"=")==0)
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
            }
            Node* node1=root->children[0];
            Node* node2=root->children[1];
            builder->merge_entries(root,node1->code_entries);
            builder->merge_entries(root,node2->code_entries);
            if(node2->type!=node1->type && !(node2->token == "LITERAL" && node2->type == "BYTE" && (node1->type=="INT" ||node1->type =="LONG" || node1->type=="SHORT")))
            {
                // cout<<node1->type << " "<< node2->token << " "<<node2->type<<endl;
                string temp = generatetemp(); offset_block_function += 4;
                ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
                entry->arg1.first=temp;
                // entry->arg2.first="cast_to_"+node1->type;
                // entry->arg3.first=node2->label_entry;
                entry->arg2.first=node2->label_entry;
                root->code_entries.push_back(entry);

                entry = new ThreeAddressCodeEntry();
                entry->arg1.first=node1->label_entry;
                entry->arg2.first=temp;
                root->code_entries.push_back(entry);
            }
            else
            {
                ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
                entry->arg1.first=node1->label_entry;
                entry->arg2.first=node2->label_entry;
                root->code_entries.push_back(entry);
            }      
            root->label_entry=node1->label_entry;
        }
        else if(root->val=="?:")
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries); 
            }
                        
            Node* condition = root->children[0];
            Node* trueexp = root->children[1];
            Node* falseexp = root->children[2];
            
            string else_label=generatelabel();
            ThreeAddressCodeEntry* label_entry_2= new ThreeAddressCodeEntry();
            label_entry_2->arg1.first=else_label;
            label_entry_2->type="label";

            string end_label=generatelabel();
            ThreeAddressCodeEntry* label_entry_3= new ThreeAddressCodeEntry();
            label_entry_3->arg1.first=end_label;
            label_entry_3->type="label";
            
            ThreeAddressCodeEntry* entry1= new ThreeAddressCodeEntry();
            entry1->type="if";
            entry1->arg1.first="IfFalse";
            entry1->arg2.first=condition->label_entry;
            entry1->arg3.first="goto";
            entry1->arg4.first=else_label;

            ThreeAddressCodeEntry* entry2= new ThreeAddressCodeEntry();
            entry2->type="goto";
            entry2->arg1.first="goto";
            entry2->arg2.first=end_label;

            string temp=generatetemp(); offset_block_function += 4;
            ThreeAddressCodeEntry* entry3= new ThreeAddressCodeEntry();
            entry3->arg1.first=temp;
            entry3->arg2.first=trueexp->label_entry;

            ThreeAddressCodeEntry* entry4= new ThreeAddressCodeEntry();
            entry4->arg1.first=temp;
            entry4->arg2.first=falseexp->label_entry;

            root->code_entries.push_back(entry3);
            root->code_entries.push_back(entry1);
            root->code_entries.push_back(label_entry_2);
            root->code_entries.push_back(entry4);
            root->code_entries.push_back(entry2);
            root->code_entries.push_back(label_entry_3);

            root->label_entry=temp;
        }
        else if(helper->Assign_Operator(root->val))
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);
            }
            Node* node1=root->children[0];
            Node* node2=root->children[1];

            if(node2->type!=node1->type && !(node2->token == "LITERAL" && node2->type == "BYTE" && (node1->type=="INT" ||node1->type =="LONG" || node1->type=="SHORT")))
            {
                // cout<<node1->type << " "<< node2->token << " "<<node2->type<<endl;
                string temp=generatetemp(); offset_block_function += 4;
                ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
                entry->arg1.first=temp;
                // entry->arg2.first="cast_to_"+node1->type;
                // entry->arg3.first=node2->label_entry;
                entry->arg2.first=node2->label_entry;
                root->code_entries.push_back(entry);

                entry = new ThreeAddressCodeEntry();
                string label1=generatetemp(); offset_block_function += 4;
                entry->arg1.first=label1;
                entry->arg2.first=temp;
                root->code_entries.push_back(entry);

                entry = new ThreeAddressCodeEntry();
                entry->arg1.first=node1->label_entry;
                entry->arg2.first=label1;
                string op = "";
                int i = 0;
                while( root->val[i] != '=' ) op += root->val[i++];
                // entry->arg3.first=root->val[0];
                entry->arg3.first=op;
                entry->arg4.first=node2->label_entry;
                root->code_entries.push_back(entry);
            }
            else
            {
                ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
                string label1=generatetemp(); offset_block_function += 4;
                entry->arg1.first=label1;
                entry->arg2.first=node1->label_entry;

                root->code_entries.push_back(entry);

                entry = new ThreeAddressCodeEntry();
                entry->arg1.first=node1->label_entry;
                entry->arg2.first=label1;
                string op = "";
                int i = 0;
                while( root->val[i] != '=' ) op += root->val[i++];
                // entry->arg3.first=root->val[0];
                entry->arg3.first=op;
                entry->arg4.first=node2->label_entry;
                root->code_entries.push_back(entry);
            }      

            root->label_entry=node1->label_entry;
        }
        else if(helper->isOperator(root->val))
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
            }
            if(root->children.size()==1)
            {
                Node* node=root->children[0];
                ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();

                string label=generatetemp(); offset_block_function += 4;
                entry->arg1.first=label;
                entry->arg2.first=root->val;
                entry->arg3.first=node->label_entry;

                builder->merge_entries(root,node->code_entries);
                root->code_entries.push_back(entry);
                root->label_entry=label;
                return;
            }
            Node* node1=root->children[0];
            Node* node2=root->children[1];

            string bigger_type=helper->biggertype(node1->type, node2->type);
            if(node1->type!=bigger_type&& !(node1->token=="LITERAL"&& node1->type == "BYTE" && (bigger_type=="INT" ||bigger_type =="LONG" || bigger_type=="SHORT")))
            {
                // cout<<"Node1: "<<node1->type << "big "<< bigger_type<<endl;
                
                string temp=generatetemp(); offset_block_function += 4;
                ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
                entry->arg1.first=temp;
                // entry->arg2.first="cast_to_"+bigger_type;
                // entry->arg3.first=node1->label_entry;
                entry->arg2.first=node1->label_entry;
                root->code_entries.push_back(entry);

                entry = new ThreeAddressCodeEntry();
                entry->arg1.first=node1->label_entry;
                entry->arg2.first=temp;
                root->code_entries.push_back(entry);
            }

            if(node2->type!=bigger_type&& !(node2->token=="LITERAL"&& node2->type == "BYTE" && (bigger_type=="INT" ||bigger_type =="LONG" || bigger_type=="SHORT")))
            {
                // cout<<"Node2: "<<node2->type << "nig "<< bigger_type<<endl;
                
                string temp=generatetemp(); offset_block_function += 4;
                ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
                entry->arg1.first=temp;
                // entry->arg2.first="cast_to_"+bigger_type;
                // entry->arg3.first=node2->label_entry;
                entry->arg2.first=node2->label_entry;
                root->code_entries.push_back(entry);

                entry = new ThreeAddressCodeEntry();
                entry->arg1.first=node2->label_entry;
                entry->arg2.first=temp;
                root->code_entries.push_back(entry);
            }
            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();

            string label=generatetemp(); offset_block_function += 4;
            entry->arg1.first=label;
            entry->arg2.first=node1->label_entry;
            entry->arg3.first=root->val;
            entry->arg4.first=node2->label_entry;

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
            if(root->children[0]->token=="LITERAL")
            root->token = root->children[0]->token;
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

            string end_label=generatelabel();
            ThreeAddressCodeEntry* label_entry_3= new ThreeAddressCodeEntry();
            label_entry_3->arg1.first=end_label;
            label_entry_3->type="label";
            
            ThreeAddressCodeEntry* entry1= new ThreeAddressCodeEntry();
            entry1->type="if";
            entry1->arg1.first="IfFalse";
            entry1->arg2.first=condition->label_entry;
            entry1->arg3.first="goto";
            entry1->arg4.first=end_label;

            ThreeAddressCodeEntry* entry2= new ThreeAddressCodeEntry();
            entry2->type="goto";
            entry2->arg1.first="goto";
            entry2->arg2.first=end_label;

            root->code_entries.push_back(entry1);
            builder->merge_entries(root,thencond->code_entries);  
            root->code_entries.push_back(entry2);
            root->code_entries.push_back(label_entry_3);  
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

            string else_label=generatelabel();
            ThreeAddressCodeEntry* label_entry_2= new ThreeAddressCodeEntry();
            label_entry_2->arg1.first=else_label;
            label_entry_2->type="label";

            string end_label=generatelabel();
            ThreeAddressCodeEntry* label_entry_3= new ThreeAddressCodeEntry();
            label_entry_3->arg1.first=end_label;
            label_entry_3->type="label";
            
            ThreeAddressCodeEntry* entry1= new ThreeAddressCodeEntry();
            entry1->type="if";
            entry1->arg1.first="IfFalse";
            entry1->arg2.first=condition->label_entry;
            entry1->arg3.first="goto";
            entry1->arg4.first=else_label;

            ThreeAddressCodeEntry* entry2= new ThreeAddressCodeEntry();
            entry2->type="goto";
            entry2->arg1.first="goto";
            entry2->arg2.first=end_label;

            root->code_entries.push_back(entry1);
            builder->merge_entries(root,thencond->code_entries);  
            root->code_entries.push_back(entry2);
            root->code_entries.push_back(label_entry_2);
            builder->merge_entries(root,elsestmt->code_entries); 
            root->code_entries.push_back(label_entry_3);
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
                label_entry_1->arg1.first=label1;
                label_entry_1->type="label";

                string label2=generatelabel();
                ThreeAddressCodeEntry* label_entry_2= new ThreeAddressCodeEntry();
                label_entry_2->arg1.first=label2;
                label_entry_2->type="label";

                ThreeAddressCodeEntry* entry3= new ThreeAddressCodeEntry();
                entry3->type="goto";
                entry3->arg1.first="goto";
                entry3->arg2.first=label1;

                if(forinit)
                builder->merge_entries(root,forinit->code_entries);
                root->code_entries.push_back(label_entry_1);
                set_break_gotos(statement,label2);
                set_continue_gotos(statement,label1);
                builder->merge_entries(root,statement->code_entries);
                if(forupdate)
                builder->merge_entries(root,forupdate->code_entries);
                root->code_entries.push_back(entry3);
                root->code_entries.push_back(label_entry_2);
                return;
            }
            string label1=generatelabel();
            ThreeAddressCodeEntry* label_entry_1= new ThreeAddressCodeEntry();
            label_entry_1->arg1.first=label1;
            label_entry_1->type="label";

            string label2=generatelabel();
            ThreeAddressCodeEntry* label_entry_2= new ThreeAddressCodeEntry();
            label_entry_2->arg1.first=label2;
            label_entry_2->type="label";

            string label3=generatelabel();
            ThreeAddressCodeEntry* label_entry_3= new ThreeAddressCodeEntry();
            label_entry_3->arg1.first=label3;
            label_entry_3->type="label";

            ThreeAddressCodeEntry* entry1= new ThreeAddressCodeEntry();
            entry1->type="if";
            entry1->arg1.first="IfFalse";
            entry1->arg2.first=expression->label_entry;
            entry1->arg3.first="goto";
            entry1->arg4.first=label3;

            // ThreeAddressCodeEntry* entry2= new ThreeAddressCodeEntry();
            // entry2->type="if";
            // entry2->arg1.first="Else";
            // entry2->arg2.first="goto";
            // entry2->arg3.first=label3;

            ThreeAddressCodeEntry* entry3= new ThreeAddressCodeEntry();
            entry3->type="goto";
            entry3->arg1.first="goto";
            entry3->arg2.first=label1;

            if(forinit)
                builder->merge_entries(root,forinit->code_entries);

            root->code_entries.push_back(label_entry_1);
            builder->merge_entries(root,expression->code_entries);
            root->code_entries.push_back(entry1);
            // root->code_entries.push_back(entry2);
            root->code_entries.push_back(label_entry_2);
            set_break_gotos(statement,label3);
            set_continue_gotos(statement,label1);
            builder->merge_entries(root,statement->code_entries);
            if(forupdate)
                builder->merge_entries(root,forupdate->code_entries);
            root->code_entries.push_back(entry3);
            root->code_entries.push_back(label_entry_3);
        }
        else if(root->val=="BreakStatement")
        {
            ThreeAddressCodeEntry* entry= new ThreeAddressCodeEntry();
            entry->type="breakgoto";
            entry->arg1.first="goto";
            entry->arg2.first="";

            root->code_entries.push_back(entry);
        }
        else if(root->val=="ContinueStatement")
        {
            ThreeAddressCodeEntry* entry= new ThreeAddressCodeEntry();
            entry->type="continuegoto";
            entry->arg1.first="goto";
            entry->arg2.first="";

            root->code_entries.push_back(entry);
        }
        else if(root->val=="WhileStatement")
        {
            Node* expression;
            Node* statement;
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(child_node->val=="Expression")
                    expression=child_node;
                statement=child_node;
            }
            string label1=generatelabel();
            ThreeAddressCodeEntry* label_entry_1= new ThreeAddressCodeEntry();
            label_entry_1->arg1.first=label1;
            label_entry_1->type="label";

            string label2=generatelabel();
            ThreeAddressCodeEntry* label_entry_2= new ThreeAddressCodeEntry();
            label_entry_2->arg1.first=label2;
            label_entry_2->type="label";

            string label3=generatelabel();
            ThreeAddressCodeEntry* label_entry_3= new ThreeAddressCodeEntry();
            label_entry_3->arg1.first=label3;
            label_entry_3->type="label";

            ThreeAddressCodeEntry* entry1= new ThreeAddressCodeEntry();
            entry1->type="if";
            entry1->arg1.first="IfFalse";
            entry1->arg2.first=expression->label_entry;
            entry1->arg3.first="goto";
            entry1->arg4.first=label3;

            // ThreeAddressCodeEntry* entry2= new ThreeAddressCodeEntry();
            // entry2->type="if";
            // entry2->arg1.first="Else";
            // entry2->arg2.first="goto";
            // entry2->arg3.first=label3;

            ThreeAddressCodeEntry* entry3= new ThreeAddressCodeEntry();
            entry3->type="goto";
            entry3->arg1.first="goto";
            entry3->arg2.first=label1;

            root->code_entries.push_back(label_entry_1);
            builder->merge_entries(root,expression->code_entries);
            root->code_entries.push_back(entry1);
            // root->code_entries.push_back(entry2);
            root->code_entries.push_back(label_entry_2);
            set_break_gotos(statement,label3);
            set_continue_gotos(statement,label1);
            builder->merge_entries(root,statement->code_entries);
            root->code_entries.push_back(entry3);
            root->code_entries.push_back(label_entry_3);
        }
        else if(root->val=="ArgumentList")
        {
            reverse(root->children.begin(),root->children.end());
            Node* expression;
            int argument_count=root->children.size();
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);
                if(child_node->val=="Expression")
                {
                    expression=child_node; 
                    ThreeAddressCodeEntry* entry= new ThreeAddressCodeEntry();
                    entry->type="param";
                    entry->arg1.first="push";
                    entry->arg2.first=expression->label_entry;
                    entry->comment =" // Push formal parameter to the stack";
                    entry->param_index = argument_count;
                    root->code_entries.push_back(entry);

                    int size = getsize(expression->type);
                    if(entry->param_index > 6)
                    {
                        entry->type = "param_stack";
                        offset_block_function += 4;
                    }
                    // cout<< expression->type<<endl;
                    // entry= new ThreeAddressCodeEntry();
                    // entry->type="stack";
                    // entry->arg1.first="sub";
                    // entry->arg2.first="stackpointer";
                    // entry->arg3.first=to_string(size);
                    // entry->comment =" // Decrement stack pointer by size of variable";
                    // root->code_entries.push_back(entry);

                    root->size +=size;
                    argument_count--;
                }            
            }
        }
        else if(root->val=="MethodInvocation")
        {

            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            entry->type = "precall";
            entry->arg1.first = "PRECALL";
            root->code_entries.push_back(entry);

            int no_params=0;
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);
                if(child_node->val == "ArgumentList")
                {
                    root->size = child_node->size;
                    no_params=child_node->arguments_type.size();
                }
                if(child_node->val == ".")
                {
                    root->size = child_node->size;
                    no_params=child_node->arguments_type.size();
                }
            }
            root->label_entry=root->identifier;
            if(root->children[0]->identifier == "System.out.print" || root->children[0]->identifier == "System.out.println" )
            {
                entry->is_print = 1;
            }
            if(root->children[0]->val==".")
            {
                root->label_entry=root->children[0]->label_entry;

                ThreeAddressCodeEntry*  entry= new ThreeAddressCodeEntry();
                entry->type="object_func";
                entry->arg1.first="push";
                entry->arg2.first="*"+root->children[0]->identifier;
                entry->comment =" // Push object address to the stack";
                root->code_entries.push_back(entry); 
            }
            else
            {
                ThreeAddressCodeEntry*  entry= new ThreeAddressCodeEntry();
                entry->type="object_func";
                entry->arg1.first="push";
                entry->arg2.first="*this";
                entry->comment =" // Push curr class object address to the stack";
                root->code_entries.push_back(entry); 
            }

            // cout<< root->type<<endl;
            entry= new ThreeAddressCodeEntry();
            // entry->type="stack";
            // entry->arg1.first="sub";
            // entry->arg2.first="stackpointer";
            // entry->arg3.first="8";
            // entry->comment ="// Allocate space in stack for object address pointer";
            // root->code_entries.push_back(entry);
            root->size+=8;
            int return_size = getsize(root->type);

            entry= new ThreeAddressCodeEntry();
            entry->type="stack";
            entry->arg1.first="sub";
            entry->arg2.first="stackpointer";
            entry->arg3.first=to_string(return_size);
            entry->comment ="// Allocate space in stack for return value";
            root->code_entries.push_back(entry);
            root->size+= return_size;

            entry= new ThreeAddressCodeEntry();
            entry->type="return_address";
            entry->arg1.first="push";
            entry->arg2.first="*ra";
            entry->comment =" // Push return address to the stack";
            root->code_entries.push_back(entry);

            // entry= new ThreeAddressCodeEntry();
            // entry->type="stack";
            // entry->arg1.first="sub";
            // entry->arg2.first="stackpointer";
            // entry->arg3.first="8";
            // entry->comment ="// Allocate space in stack for return address pointer";
            // root->code_entries.push_back(entry);
            root->size+=8;

            entry = new ThreeAddressCodeEntry();
            entry->type = "precall";
            entry->arg1.first = "PRECALL";
            root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->type="call";
            entry->arg1.first="CALL";
            entry->arg2.first=root->identifier;
            entry->arg3.first=to_string(no_params);
            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->type = "postcall";
            entry->arg1.first = "POSTCALL";
            if(root->children[0]->identifier == "System.out.print" || root->children[0]->identifier == "System.out.println" )
            {
                entry->is_print = 1;
            }
            root->code_entries.push_back(entry);

            string temp=generatetemp(); offset_block_function += 4;
            entry= new ThreeAddressCodeEntry();
            entry->type = "return_assign";
            entry->arg1.first=temp;
            entry->arg2.first="load";
            entry->arg3.first=to_string(8+return_size)+"(stackpointer)";
            root->code_entries.push_back(entry);
            

            // entry= new ThreeAddressCodeEntry();
            // entry->type="param";
            // entry->arg1.first="PopParameters";
            // root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->type="localvar_deallocate";
            entry->arg1.first="add";
            entry->arg2.first="stackpointer";
            entry->arg3.first=to_string(root->size);
            entry->comment ="// Restore the stack before function call";
            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->type = "comment";
            entry->arg1.first = "POSTCALL";
            root->code_entries.push_back(entry);

            root->label_entry=temp;
        }
        else if(root->val=="ReturnStatement")
        {
            Node* expression = NULL;
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(child_node->val=="Expression")
                {
                    // cout << "here1" << endl;
                    expression=child_node;
                }
                builder->merge_entries(root,child_node->code_entries);
            }

            // ThreeAddressCodeEntry* entry= new ThreeAddressCodeEntry();
            // entry->type="param";
            // entry->arg1.first="pushparam";
            // entry->arg2.first=expression->label_entry;
            // root->code_entries.push_back(entry);

            ThreeAddressCodeEntry* entry= new ThreeAddressCodeEntry();
            if(!expression)
            {
                entry = new ThreeAddressCodeEntry();
                entry->type = "funcreturn";
                entry->arg1.first = "endfunc";
                entry->arg2.first = "void"; // endfunc entry return type in arg2.first
                root->code_entries.push_back(entry);
            }
            else
            {
                // cout<< expression->type <<endl;
                // cout << expression->label_entry << endl;
                entry->type="return_value";
                entry->arg1.first="store";
                entry->arg2.first=to_string(8+getsize(expression->type)) +"(basepointer)";
                entry->arg3.first=expression->label_entry;
                entry->comment="// Store the returned value at the return address";
                root->code_entries.push_back(entry);

                entry = new ThreeAddressCodeEntry();
                entry->type = "funcreturn";
                entry->arg1.first = "endfunc";
                entry->arg2.first = expression->type; // endfunc entry return type in arg2.first
                root->code_entries.push_back(entry);
            }


        }
        else if(root->val=="PostIncrementExpression"|| root->val=="PostDecrementExpression")
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
            }
            Node* node = root->children[0];

            // ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            // string label1=generatetemp(); offset_block_function += 4;
            // entry->arg1.first=label1;
            // entry->arg2.first=node->label_entry;

            // root->code_entries.push_back(entry);

            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            entry->arg1.first=node->label_entry;
            entry->arg2.first=node->label_entry;
            if(root->val=="PostIncrementExpression") entry->arg3.first="+";
            else entry->arg3.first="-";
            entry->arg4.first="1";

            root->code_entries.push_back(entry);
            root->label_entry=node->label_entry;
        }
         else if(root->val=="PreIncrementExpression"|| root->val=="PreDecrementExpression")
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
            }
            Node* node = root->children[1];

            // ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            // string label1=generatetemp(); offset_block_function += 4;
            // entry->arg1.first=label1;
            // entry->arg2.first=node->label_entry;

            // root->code_entries.push_back(entry);

            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            entry->arg1.first=node->label_entry;
            entry->arg2.first=node->label_entry;
            if(root->val=="PreIncrementExpression") entry->arg3.first="+";
            else entry->arg3.first="-";
            entry->arg4.first="1";

            root->code_entries.push_back(entry);
            root->label_entry=node->label_entry;
        }
        else if(root->val=="ArrayAccess")
        {
            Node* identifier=NULL;
            Node* arrayaccess=NULL;
            Node* expression=NULL;
            for(auto child_node: root-> children)
            {
                if(child_node->token=="IDENTIFIER")
                    identifier=child_node;
                if(child_node->val=="ArrayAccess")
                    arrayaccess=child_node;
                if(child_node->val=="Expression")
                    expression=child_node;
            }
            if(arrayaccess)
            {
                build(expression);
                builder->merge_entries(root,expression->code_entries);
                root->array_invocation.push_back(expression->label_entry);
                arrayaccess->array_invocation=root->array_invocation;
                build(arrayaccess);
                // cout<<"here5"<<endl;
                builder->merge_entries(root,arrayaccess->code_entries);
                root->label_entry=arrayaccess->label_entry;
                // cout<<"here6"<<endl;
                return;
            }
            else if(identifier)
            {
                build(identifier);
                build(expression);
                builder->merge_entries(root,expression->code_entries);
                root->array_invocation.push_back(expression->label_entry);

                // cout<<"here"<<endl;
                // cout<<identifier->lexeme<<" "<<curr_symtable->scope<<endl;
                SymbolEntry* sym_entry=curr_symtable->lookup(identifier->lexeme)[0];
                int dims=sym_entry->no_dimensions;
                string size=to_string(getsize(sym_entry->type));
                // cout<<"here2"<<endl;

                ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
                string ans=generatetemp(); offset_block_function += 4;
                entry->arg1.first=ans;
                entry->arg2.first=identifier->lexeme;
                entry->type="pointer";
                // cout<<"here3"<<endl;

                root->code_entries.push_back(entry);

                for(int i=0;i<sym_entry->no_dimensions;i++)
                {
                    entry = new ThreeAddressCodeEntry();
                    string t2=generatetemp(); offset_block_function += 4;
                    entry->arg1.first=t2;
                    entry->arg2.first=root->array_invocation[i];
                    entry->arg3.first="*";
                    entry->arg4.first=size;
                    root->code_entries.push_back(entry);

                    entry = new ThreeAddressCodeEntry();
                    entry->arg1.first=ans;
                    entry->arg2.first=ans;
                    entry->arg3.first="+";
                    entry->arg4.first=t2;
                    root->code_entries.push_back(entry);

                    if(i<sym_entry->no_dimensions-1)
                    {
                        entry = new ThreeAddressCodeEntry();
                        string t3=generatetemp(); offset_block_function += 4;
                        entry->arg1.first=t3;
                        entry->arg2.first=root->array_invocation[i];
                        entry->arg3.first="*";
                        entry->arg4.first="dimension_size"+to_string(sym_entry->no_dimensions-i);
                        root->code_entries.push_back(entry);

                        size=t3;
                    }
                }
                //cout<<"here4"<<endl;

                root->label_entry=ans;
            }

        }
        else if(root->val=="ArrayCreationExpression")
        {
            Node* node1;
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);
                if(child_node->val=="DimExprs")
                    node1=child_node;
            }
            Node* node2=root->children[1];
            int size=getsize(node2->type);

            string size_temp=generatetemp(); offset_block_function += 4;
            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            entry->arg1.first=size_temp;
            entry->arg2.first=node1->label_entry;
            entry->arg3.first="*";
            entry->arg4.first=to_string(size);
            root->code_entries.push_back(entry);

            string token=generatetemp(); offset_block_function += 4;
            entry = new ThreeAddressCodeEntry();
            entry->arg1.first=token;
            entry->arg2.first="alloc_memory";
            entry->arg3.first=size_temp;
            root->code_entries.push_back(entry);

            root->label_entry=token;
        }
        else if(root->val=="UnqualifiedClassInstanceCreationExpression")
        {
            Node* node2=root->children[1];
            SymbolEntry* sym_entry = root->sym_entry;

            string size_temp=generatetemp(); // offset_block_function += 4;
            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            entry->arg1.first=size_temp;
            entry->arg2.first=to_string(sym_entry->size);
            entry->comment=" // Store the size of the object";
            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->type = "precall";
            entry->arg1.first = "PRECALL";
            root->code_entries.push_back(entry);
            
            entry= new ThreeAddressCodeEntry();
            entry->type="param";
            entry->arg1.first="push";
            entry->arg2.first=size_temp;
            entry->comment =" // Push formal parameter to the stack";
            root->code_entries.push_back(entry); 

            entry= new ThreeAddressCodeEntry();
            entry->type="stack";
            entry->arg1.first="sub";
            entry->arg2.first="stackpointer";
            entry->arg3.first=to_string(8);
            entry->comment ="// Allocate space in stack for return value";
            root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->type="return_address";
            entry->arg1.first="push";
            entry->arg2.first="*ra";
            entry->comment =" // Push return address to the stack";
            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->type = "precall";
            entry->arg1.first = "PRECALL";
            root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->type="call";
            entry->arg1.first="CALL";
            entry->arg2.first="allocmemory";
            entry->arg3.first="1";
            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->type = "comment";
            entry->arg1.first = "POSTCALL";
            root->code_entries.push_back(entry);

            string temp=generatetemp();  offset_block_function += 4;
            entry= new ThreeAddressCodeEntry();
            entry->arg1.first=temp;
            entry->arg2.first="load";
            entry->arg3.first=to_string(16)+"(stackpointer)";
            root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->type="stack";
            entry->arg1.first="add";
            entry->arg2.first="stackpointer";
            entry->arg3.first=to_string(20);
            entry->comment ="// Restore the stack after function call";
            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->type = "comment";
            entry->arg1.first = "POSTCALL";
            root->code_entries.push_back(entry);
            // string temp=generatetemp();
            // entry = new ThreeAddressCodeEntry();
            // entry->arg1.first=temp;
            // entry->arg2.first="alloc_memory";
            // entry->arg3.first=size_temp;
            // root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->type = "precall";
            entry->arg1.first = "PRECALL";
            root->code_entries.push_back(entry);

            int no_params=0;
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(child_node->val == "ArgumentList")
                {
                    root->size = child_node->size;
                    no_params=child_node->arguments_type.size();
                }
                builder->merge_entries(root,child_node->code_entries);
            }
            entry -> param_index = no_params;
            root->label_entry=root->identifier;

            entry= new ThreeAddressCodeEntry();
            entry->type="object_func";
            entry->arg1.first="push";
            entry->arg2.first=temp;
            entry->comment =" // Push curr class object address to the stack";
            root->code_entries.push_back(entry); 


            // cout<< root->type<<endl;
            // ThreeAddressCodeEntry* entry= new ThreeAddressCodeEntry();
            // entry->type="stack";
            // entry->arg1.first="sub";
            // entry->arg2.first="stackpointer";
            // entry->arg3.first="8";
            // entry->comment ="// Allocate space in stack for object address pointer";
            // root->code_entries.push_back(entry);
            root->size+=8;
            int return_size = getsize(root->type);

            entry= new ThreeAddressCodeEntry();
            entry->type="stack";
            entry->arg1.first="sub";
            entry->arg2.first="stackpointer";
            entry->arg3.first=to_string(return_size);
            entry->comment ="// Allocate space in stack for return value";
            root->code_entries.push_back(entry);
            root->size+= return_size;

            entry= new ThreeAddressCodeEntry();
            entry->type="return_address";
            entry->arg1.first="push";
            entry->arg2.first="*ra";
            entry->comment =" // Push return address to the stack";
            root->code_entries.push_back(entry);

            // entry= new ThreeAddressCodeEntry();
            // entry->type="stack";
            // entry->arg1.first="sub";
            // entry->arg2.first="stackpointer";
            // entry->arg3.first="8";
            // entry->comment ="// Allocate space in stack for return address pointer";
            // root->code_entries.push_back(entry);
            root->size+=8;

            entry = new ThreeAddressCodeEntry();
            entry->type = "precall";
            entry->arg1.first = "PRECALL";
            root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->type="call";
            entry->arg1.first="CALL";
            entry->arg2.first=root->label_entry;
            entry->arg3.first=to_string(no_params);
            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->type = "comment";
            entry->arg1.first = "POSTCALL";
            root->code_entries.push_back(entry);

            temp=generatetemp(); offset_block_function += 4;
            entry= new ThreeAddressCodeEntry();
            entry->arg1.first=temp;
            entry->arg2.first="load";
            entry->arg3.first=to_string(8+return_size)+"(stackpointer)";
            root->code_entries.push_back(entry);

            // entry= new ThreeAddressCodeEntry();
            // entry->type="param";
            // entry->arg1.first="PopParameters";
            // root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->type="stack";
            entry->arg1.first="add";
            entry->arg2.first="stackpointer";
            entry->arg3.first=to_string(root->size);
            entry->comment ="// Restore the stack after function call";
            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->type = "comment";
            entry->arg1.first = "POSTCALL";
            root->code_entries.push_back(entry);

            root->label_entry=temp;
        }
        else if(root->val=="DimExprs")
        {
            Node* node1;
            Node* node2;
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);               
            }
            if(root->children.size()>1)
            {
                node1=root->children[0];
                node2=root->children[1];

                ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
                string temp=generatetemp(); offset_block_function += 4;
                entry->arg1.first=temp;
                entry->arg2.first=node1->label_entry;
                entry->arg3.first="*";
                entry->arg4.first=node2->label_entry;

                root->code_entries.push_back(entry);
                root->label_entry=temp;
            }
            else
            {
                node1=root->children[0];
                ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
                string temp=generatetemp(); offset_block_function += 4;
                entry->arg1.first=temp;
                entry->arg2.first=node1->label_entry;

                root->code_entries.push_back(entry);
                root->label_entry=temp;
            }
        }
        else if(root->val=="CastExpression")
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);               
            }
            Node* final_type=root->children[0];
            Node* exp=root->children[1];
            string cast_string="cast_to_"+final_type->lexeme;
            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            string temp=generatetemp(); offset_block_function += 4;
            entry->arg1.first=temp;
            // entry->arg2.first=cast_string;
            // entry->arg3.first=exp->label_entry;
            entry->arg2.first=exp->label_entry;

            root->code_entries.push_back(entry);
            root->label_entry=temp;
        }
        else if(root->val == "ExpressionName" || root->val == "FieldAccess")
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries); 
            }

            root->label_entry=root->children[0]->label_entry;
        }
        else if(root->val==".")
        {
            Node* object_access;
            Node* object_field;
            for(auto child_node: root-> children)
            {
                build(child_node); 
                if(child_node->val == "ArgumentList")
                    root->size = child_node->size;
            }
            object_access=root->children[0];
            object_field=root->children[1];

            builder->merge_entries(root,object_access->code_entries);
            builder->merge_entries(root,object_field->code_entries);

            string classname=object_access->label_entry;
            if(classname.length()>=5 && classname.substr(classname.length()-4,4)=="this")
                classname="this";

            string object_name=classname;
            if(object_name=="this")
                object_name=currclass_this;
            
            // string temp = generatetemp(); 
            // offset_block_function += 4;
            // ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            // entry->type="pointer";
            // entry->arg1.first=temp;
            // entry->arg2.first=object_name;
            // root->code_entries.push_back(entry);

            // entry = new ThreeAddressCodeEntry();
            // entry->type = "offset";
            // entry->arg1.first=temp;
            // entry->arg2.first=temp;
            // entry->arg3.first="+";
            // entry->arg4.first="OFFSET_"+object_field->identifier;
            // root->code_entries.push_back(entry);

            if(root->children.size()>=5)
            {
                builder->merge_entries(root,root->children[3]->code_entries);
            }
            // root->label_entry=temp;
            // root->label_entry=root->val;
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
        // root->symtable=curr_symtable;
    }
};