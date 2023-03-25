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
    int co_labels=0;
    int co_temps=0;
    int array_size=0;
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
        array_size=0;
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
        string temp="$t"+to_string(co_temps);
        return temp;
    }

    int getsize(string type){
        if(type=="INT" || type=="FLOAT")
            return 4;
        else if(type=="DOUBLE" || type=="LONG")
            return 8;
        else if(type=="CHAR")
            return 1;
        else if(type=="BOOLEAN")
            return 1;
        return 4;
    }
    void set_break_gotos(Node* node, string label)
    {
        for(auto ele: node->code_entries)
        {
            if(ele->type=="breakgoto" && ele->arg2=="")
                ele->arg2=label;
        }
    }
    void set_continue_gotos(Node* node, string label)
    {
        for(auto ele: node->code_entries)
        {
            if(ele->type=="continuegoto" && ele->arg2=="")
                ele->arg2=label;
        }
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
        else if(root->val=="MethodDeclaration" || root->val=="ConstructorDeclaration")
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
        else if(root->val == "FormalParameter")
        {
            Node* node;
            for(auto child_node: root-> children)
            {
                build(child_node);         
                if(child_node->val=="VariableDeclaratorId")    
                {
                    node=child_node;
                } 
            }
            string temp = generatetemp();
            ThreeAddressCodeEntry* entry= new ThreeAddressCodeEntry();
            entry->arg1=temp;
            entry->arg2="PopParameter";

            root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->arg1=node->label_entry;
            entry->arg2=temp;

            root->code_entries.push_back(entry);
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
        else if(helper->Assign_Operator(root->val))
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);
            }
            Node* node1=root->children[0];
            Node* node2=root->children[1];

            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            string label1=generatetemp();
            entry->arg1=label1;
            entry->arg2=node1->label_entry;

            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->arg1=node1->label_entry;
            entry->arg2=label1;
            entry->arg3=root->val[0];
            entry->arg4=node2->label_entry;

            root->code_entries.push_back(entry);
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

                string label=generatetemp();
                entry->arg1=label;
                entry->arg2=root->val;
                entry->arg3=node->label_entry;

                builder->merge_entries(root,node->code_entries);
                root->code_entries.push_back(entry);
                root->label_entry=label;
                return;
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
            label_entry_2->arg1=else_label;
            label_entry_2->type="label";

            string end_label=generatelabel();
            ThreeAddressCodeEntry* label_entry_3= new ThreeAddressCodeEntry();
            label_entry_3->arg1=end_label;
            label_entry_3->type="label";
            
            ThreeAddressCodeEntry* entry1= new ThreeAddressCodeEntry();
            entry1->type="if";
            entry1->arg1="IfFalse";
            entry1->arg2=condition->label_entry;
            entry1->arg3="goto";
            entry1->arg4=else_label;

            ThreeAddressCodeEntry* entry2= new ThreeAddressCodeEntry();
            entry2->type="goto";
            entry2->arg1="goto";
            entry2->arg2=end_label;

            string temp=generatetemp();
            ThreeAddressCodeEntry* entry3= new ThreeAddressCodeEntry();
            entry3->arg1=temp;
            entry3->arg2=trueexp->label_entry;

            ThreeAddressCodeEntry* entry4= new ThreeAddressCodeEntry();
            entry4->arg1=temp;
            entry4->arg2=falseexp->label_entry;

            root->code_entries.push_back(entry3);
            root->code_entries.push_back(entry1);
            root->code_entries.push_back(label_entry_2);
            root->code_entries.push_back(entry4);
            root->code_entries.push_back(entry2);
            root->code_entries.push_back(label_entry_3);

            root->label_entry=temp;
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
            label_entry_3->arg1=end_label;
            label_entry_3->type="label";
            
            ThreeAddressCodeEntry* entry1= new ThreeAddressCodeEntry();
            entry1->type="if";
            entry1->arg1="IfFalse";
            entry1->arg2=condition->label_entry;
            entry1->arg3="goto";
            entry1->arg4=end_label;

            ThreeAddressCodeEntry* entry2= new ThreeAddressCodeEntry();
            entry2->type="goto";
            entry2->arg1="goto";
            entry2->arg2=end_label;

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
            label_entry_2->arg1=else_label;
            label_entry_2->type="label";

            string end_label=generatelabel();
            ThreeAddressCodeEntry* label_entry_3= new ThreeAddressCodeEntry();
            label_entry_3->arg1=end_label;
            label_entry_3->type="label";
            
            ThreeAddressCodeEntry* entry1= new ThreeAddressCodeEntry();
            entry1->type="if";
            entry1->arg1="IfFalse";
            entry1->arg2=condition->label_entry;
            entry1->arg3="goto";
            entry1->arg4=else_label;

            ThreeAddressCodeEntry* entry2= new ThreeAddressCodeEntry();
            entry2->type="goto";
            entry2->arg1="goto";
            entry2->arg2=end_label;

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
            entry->arg1="goto";
            entry->arg2="";

            root->code_entries.push_back(entry);
        }
        else if(root->val=="ContinueStatement")
        {
            ThreeAddressCodeEntry* entry= new ThreeAddressCodeEntry();
            entry->type="continuegoto";
            entry->arg1="goto";
            entry->arg2="";

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

            root->code_entries.push_back(label_entry_1);
            builder->merge_entries(root,expression->code_entries);
            root->code_entries.push_back(entry1);
            root->code_entries.push_back(entry2);
            root->code_entries.push_back(label_entry_2);
            set_break_gotos(statement,label3);
            set_continue_gotos(statement,label1);
            builder->merge_entries(root,statement->code_entries);
            root->code_entries.push_back(entry3);
            root->code_entries.push_back(label_entry_3);
        }
        else if(root->val=="ArgumentList")
        {
            Node* expression;
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);
                if(child_node->val=="Expression")
                    expression=child_node;               
            }

            ThreeAddressCodeEntry* entry= new ThreeAddressCodeEntry();
            entry->type="param";
            entry->arg1="pushparam";
            entry->arg2=expression->label_entry;

            root->code_entries.push_back(entry);
        }
        else if(root->val=="MethodInvocation")
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);
            }
            root->label_entry=root->identifier;

            string temp=generatetemp();
            ThreeAddressCodeEntry* entry= new ThreeAddressCodeEntry();
            entry->type="param";
            entry->arg1="CALL";
            entry->arg2=root->label_entry;

            root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->arg1=temp;
            entry->arg2="PopParameter";

            root->code_entries.push_back(entry);

            entry= new ThreeAddressCodeEntry();
            entry->type="param";
            entry->arg1="PopParameters";

            root->code_entries.push_back(entry);
            root->label_entry=temp;
        }
        else if(root->val=="ReturnStatement")
        {
            Node* expression;
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(child_node->val=="Expression")
                    expression=child_node;
            }

            ThreeAddressCodeEntry* entry= new ThreeAddressCodeEntry();
            entry->type="param";
            entry->arg1="pushparam";
            entry->arg2=expression->label_entry;

            root->code_entries.push_back(entry);
        }
        else if(root->val=="PostIncrementExpression"|| root->val=="PostDecrementExpression")
        {
            for(auto child_node: root-> children)
            {
                build(child_node);
            }
            Node* node = root->children[0];

            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            string label1=generatetemp();
            entry->arg1=label1;
            entry->arg2=node->label_entry;

            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->arg1=node->label_entry;
            entry->arg2=label1;
            entry->arg3="+";
            entry->arg4="1";

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

            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            string label1=generatetemp();
            entry->arg1=label1;
            entry->arg2=node->label_entry;

            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->arg1=node->label_entry;
            entry->arg2=label1;
            entry->arg3="+";
            entry->arg4="1";

            root->code_entries.push_back(entry);
            root->label_entry=label1;
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
            if(arrayaccess!=NULL)
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
            else if(identifier!=NULL)
            {
                build(identifier);
                build(expression);
                builder->merge_entries(root,expression->code_entries);
                root->array_invocation.push_back(expression->label_entry);

                // cout<<"here"<<endl;
                SymbolEntry* sym_entry=curr_symtable->lookup(identifier->lexeme)[0];
                int dims=sym_entry->no_dimensions;
                string size=to_string(getsize(sym_entry->type));
                // cout<<"here2"<<endl;

                ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
                string ans=generatetemp();
                entry->arg1=ans;
                entry->arg2=identifier->lexeme;
                entry->type="pointer";
                // cout<<"here3"<<endl;

                root->code_entries.push_back(entry);

                for(int i=0;i<sym_entry->no_dimensions;i++)
                {
                    entry = new ThreeAddressCodeEntry();
                    string t2=generatetemp();
                    entry->arg1=t2;
                    entry->arg2=root->array_invocation[i];
                    entry->arg3="*";
                    entry->arg4=size;
                    root->code_entries.push_back(entry);

                    entry = new ThreeAddressCodeEntry();
                    entry->arg1=ans;
                    entry->arg2=ans;
                    entry->arg3="+";
                    entry->arg4=t2;
                    root->code_entries.push_back(entry);

                    if(i<sym_entry->no_dimensions-1)
                    {
                        entry = new ThreeAddressCodeEntry();
                        string t3=generatetemp();
                        entry->arg1=t3;
                        entry->arg2=root->array_invocation[i];
                        entry->arg3="*";
                        entry->arg4="dimension_size"+to_string(sym_entry->no_dimensions-i);
                        root->code_entries.push_back(entry);

                        size=t3;
                    }
                }
                // cout<<"here4"<<endl;

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

            string size_temp=generatetemp();
            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            entry->arg1=size_temp;
            entry->arg2=node1->label_entry;
            entry->arg3="*";
            entry->arg4=to_string(size);
            root->code_entries.push_back(entry);

            string token=generatetemp();
            entry = new ThreeAddressCodeEntry();
            entry->arg1=token;
            entry->arg2="alloc_memory";
            entry->arg3=size_temp;
            root->code_entries.push_back(entry);

            root->label_entry=token;
        }
        else if(root->val=="UnqualifiedClassInstanceCreationExpression")
        {
            Node* node1;
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries);
            }
            Node* node2=root->children[1];

            string size_temp=generatetemp();
            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            entry->arg1=size_temp;
            entry->arg2="size_of_"+node2->lexeme;
            root->code_entries.push_back(entry);

            string temp=generatetemp();
            entry = new ThreeAddressCodeEntry();
            entry->arg1=temp;
            entry->arg2="alloc_memory";
            entry->arg3=size_temp;
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
                string temp=generatetemp();
                entry->arg1=temp;
                entry->arg2=node1->label_entry;
                entry->arg3="*";
                entry->arg4=node2->label_entry;

                root->code_entries.push_back(entry);
                root->label_entry=temp;
            }
            else
            {
                node1=root->children[0];
                ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
                string temp=generatetemp();
                entry->arg1=temp;
                entry->arg2=node1->label_entry;

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
            string temp=generatetemp();
            entry->arg1=temp;
            entry->arg2=cast_string;
            entry->arg3=exp->label_entry;

            root->code_entries.push_back(entry);
            root->label_entry=temp;
        }
        else if(root->val=="FieldAccess"|| root->val=="ExpressionName")
        {
            Node* object_access;
            Node* object_field;
            for(auto child_node: root-> children)
            {
                build(child_node);
                builder->merge_entries(root,child_node->code_entries); 
                if(child_node->token=="IDENTIFIER")
                    object_field=child_node;              
            }
            object_access=root->children[0];

            string temp = generatetemp();
            ThreeAddressCodeEntry* entry = new ThreeAddressCodeEntry();
            entry->type="pointer";
            entry->arg1=temp;
            entry->arg2=object_access->identifier;
            root->code_entries.push_back(entry);

            entry = new ThreeAddressCodeEntry();
            entry->arg1=temp;
            entry->arg2=temp;
            entry->arg3="OFFSET_"+object_field->lexeme;
            root->code_entries.push_back(entry);

            root->label_entry="*"+temp;
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