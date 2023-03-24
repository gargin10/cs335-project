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
    set<string> validtypes;
    SymbolTable* curr_symtable;
    SymbolTable* prev_symtable;
    Helper* helper;
    ThreeAddressCodeBuilder* builder;
    int nextinstr=0;

    SymbolTableBuilder()
    {
        createValidTypes();
        curr_symtable=NULL;
        prev_symtable=NULL;
        helper=new Helper();
        builder=new ThreeAddressCodeBuilder();
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
            for(auto child_node: root-> children)
            {
                build(child_node);                
            }
        }
        else if(root->val=="NormalClassDeclaration")
        {

            string identifier_class="";
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="IDENTIFIER")
                    identifier_class=child_node->lexeme;
                       
            }
        }
        else if(root->val=="MethodDeclaration"|| root->val=="ConstructorDeclaration")
        {
        }
        else if(strcmp(root->val,"{")==0)
        {     
        }
        else if(strcmp(root->val,"}")==0)
        {
        }
        else if(root->val=="MethodDeclarator"|| root->val=="ConstructorDeclarator" )
        {
        }
        else if(root->val=="FormalParameter")
        {
        }
        else if(root->val=="VariableDeclaratorId")
        {
        }
        else if(root->val=="FieldDeclaration" || root->val=="LocalVariableDeclaration")
        {
        }
        else if(root->val=="VariableDeclaratorList")
        {
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
                SymbolEntry* entry= helper->checkvariable(identifier1,curr_symtable,root->lineno);
                if(entry)
                {
                    bool check = helper->checktypevariable(entry,righthand_type, root->lineno);
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
        else if(root->val == "Expression")
        {
            string exp_type="";
            int dims=0;
            for(auto child_node: root-> children)
            {
                build(child_node);      
                if(helper->isOperator(child_node->val))
                {
                    exp_type=child_node->type;
                    // root->code_entry=child_node->code_entry;
                }    
                if(child_node->token=="IDENTIFIER")
                {
                    SymbolEntry* entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                    if(entry)
                        exp_type=entry->type;
                    // root->code_entry=child_node->lexeme;
                }   
                if(child_node->token=="LITERAL")
                {
                    exp_type=child_node->type;
                    // root->code_entry=child_node->code_entry;
                } 
                if(child_node->token=="ArrayAccess")
                {
                    SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                    if(entry)
                    {
                        exp_type=entry->type;
                    }
                    // root->code_entry=child_node->code_entry;
                }   
                if(child_node->token=="ArrayCreationExpression")
                {
                    exp_type=child_node->type;
                    dims=child_node->dims;
                } 
                if(child_node->val=="MethodInvocation")
                {
                    exp_type=child_node->type;
                    // root->code_entry=child_node->code_entry;
                }
                root->label_entry=child_node->label_entry;
                root->truelist=child_node->truelist;
                root->falselist=child_node->falselist;
                root->nextlist=child_node->nextlist;
            }
            root->type=exp_type;
            root->dims=dims;
        }
        else if(root->val == "Statement")
        {
            string exp_type="";
            int dims=0;
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(child_node->token=="IDENTIFIER")
                {
                    SymbolEntry* entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                    if(entry)
                        exp_type=entry->type;
                    // root->code_entry=child_node->lexeme;
                }   
                else if(child_node->token=="ArrayAccess")
                {
                    SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                    if(entry)
                    {
                        exp_type=entry->type;
                    }
                    // root->code_entry=child_node->code_entry;
                }   
                else
                    exp_type=child_node->type;
                dims=child_node->dims;
                root->label_entry=child_node->label_entry;
            }
            root->type=exp_type;
            root->dims=dims;
        }
        else if(strcmp(root->val,"&&")==0)
        {
            string type1="";
            string type2="";
            Node* arg1=NULL;
            Node* arg2=NULL;
            int M_instr=0;
            for(auto child_node: root-> children)
            {
                build(child_node);   
                if(child_node->token=="IDENTIFIER")
                {
                    if(type1=="")
                    {
                        SymbolEntry* entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                        if(entry)
                            type1=entry->type;
                        arg1=child_node;
                    }
                    else
                    {
                        SymbolEntry* entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                        if(entry)
                            type2=entry->type;
                        arg2=child_node;
                    }     
                }
                if(child_node->val=="ArrayAccess")
                {
                    SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                    if(entry)
                    {
                        if(type1=="")
                        {
                            type1=child_node->type;
                            arg1=child_node;
                        }
                        else
                        {
                            type2=child_node->type;
                            arg2=child_node;
                        }
                    }
                }
                if(helper->isOperator(child_node->val))
                {
                    if(type1=="")
                    {
                        type1=child_node->type;
                        arg1=child_node;
                    }
                    else
                    {
                        type2=child_node->type;
                        arg2=child_node;
                    }
                }   
                if(child_node->val=="Expression")
                {
                    if(type1=="")
                    {
                        type1=child_node->type;
                        arg1=child_node;
                    }
                    else
                    {
                        type2=child_node->type;
                        arg2=child_node;
                    }
                }  
                if(child_node->token=="LITERAL")
                {
                    if(type1=="")
                    {
                        type1=child_node->type;
                        arg1=child_node;
                    }
                    else
                    {
                        type2=child_node->type;
                        arg2=child_node;
                    }
                }  
                if(M_instr==0)
                    M_instr=nextinstr;
            }
            if(!helper->castit(type1,type2))
            {
                helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible types i.e. conversion from "+type1 + " to "+type2);
            }
            assert(arg1!=NULL);
            assert(arg2!=NULL);
            cout<<"here4"<<endl;
            builder->backpatch(arg1->truelist,M_instr);
            root->truelist=arg2->truelist;
            root->falselist=builder->merge(arg1->falselist,arg2->falselist);
            // root->code_entry=builder->generateExpression(root->val,arg1,arg2);
            cout<<"here5"<<endl;
            root->type=type1;
        }
        else if(strcmp(root->val,"||")==0)
        {
            string type1="";
            string type2="";
            Node* arg1=NULL;
            Node* arg2=NULL;
            int M_instr=0;
            for(auto child_node: root-> children)
            {
                build(child_node);   
                if(child_node->token=="IDENTIFIER")
                {
                    if(type1=="")
                    {
                        SymbolEntry* entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                        if(entry)
                            type1=entry->type;
                        arg1=child_node;
                    }
                    else
                    {
                        SymbolEntry* entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                        if(entry)
                            type2=entry->type;
                        arg2=child_node;
                    }     
                }
                if(child_node->val=="ArrayAccess")
                {
                    SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                    if(entry)
                    {
                        if(type1=="")
                        {
                            type1=child_node->type;
                            arg1=child_node;
                        }
                        else
                        {
                            type2=child_node->type;
                            arg2=child_node;
                        }
                    }
                }
                if(helper->isOperator(child_node->val))
                {
                    if(type1=="")
                    {
                        type1=child_node->type;
                        arg1=child_node;
                    }
                    else
                    {
                        type2=child_node->type;
                        arg2=child_node;
                    }
                }   
                if(child_node->val=="Expression")
                {
                    if(type1=="")
                    {
                        type1=child_node->type;
                        arg1=child_node;
                    }
                    else
                    {
                        type2=child_node->type;
                        arg2=child_node;
                    }
                }  
                if(child_node->token=="LITERAL")
                {
                    if(type1=="")
                    {
                        type1=child_node->type;
                        arg1=child_node;
                    }
                    else
                    {
                        type2=child_node->type;
                        arg2=child_node;
                    }
                }  
                if(M_instr==0)
                    M_instr=nextinstr;
            }
            if(!helper->castit(type1,type2))
            {
                helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible types i.e. conversion from "+type1 + " to "+type2);
            }
            assert(arg1!=NULL);
            assert(arg2!=NULL);
            builder->backpatch(arg1->falselist,M_instr);
            root->truelist=builder->merge(arg1->truelist,arg2->truelist);
            root->falselist=arg2->falselist;
            // root->code_entry=builder->generateExpression(root->val,arg1,arg2);
            root->type=type1;
        }
        else if(helper->isOperator(root->val))
        {
            string type1="";
            string type2="";
            string op="";
            Node* arg1=NULL;
            Node* arg2=NULL;
            for(auto child_node: root-> children)
            {
                build(child_node);   
                if(child_node->token=="IDENTIFIER")
                {
                    if(type1=="")
                    {
                        SymbolEntry* entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                        if(entry)
                            type1=entry->type;
                        arg1=child_node;
                    }
                    else
                    {
                        SymbolEntry* entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                        if(entry)
                            type2=entry->type;
                        arg2=child_node;
                    }     
                }
                if(child_node->val=="ArrayAccess")
                {
                    SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                    if(entry)
                    {
                        if(type1=="")
                        {
                            type1=child_node->type;
                            arg1=child_node;
                        }
                        else
                        {
                            type2=child_node->type;
                            arg2=child_node;
                        }
                    }
                }
                if(helper->isOperator(child_node->val))
                {
                    if(type1=="")
                    {
                        type1=child_node->type;
                        arg1=child_node;
                    }
                    else
                    {
                        type2=child_node->type;
                        arg2=child_node;
                    }
                }   
                if(child_node->val=="Expression")
                {
                    if(type1=="")
                    {
                        type1=child_node->type;
                        arg1=child_node;
                    }
                    else
                    {
                        type2=child_node->type;
                        arg2=child_node;
                    }
                }  
                if(child_node->token=="LITERAL")
                {
                    if(type1=="")
                    {
                        type1=child_node->type;
                        arg1=child_node;
                    }
                    else
                    {
                        type2=child_node->type;
                        arg2=child_node;
                    }
                }  
            }
            if(!helper->castit(type1,type2))
            {
                helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible types i.e. conversion from "+type1 + " to "+type2);
            }
            root->type=type1;
            if(strcmp(root->val,">")==0|| strcmp(root->val,">")==0|| strcmp(root->val,">=")==0 || strcmp(root->val,">=")==0|| strcmp(root->val,"==")==0|| strcmp(root->val,"!=")==0)
            {
                root->truelist=builder->makelist(nextinstr);
                root->falselist=builder->makelist(nextinstr+1);
                assert(arg1!=NULL);
                assert(arg2!=NULL);
                builder->emit("if","",root->val,arg1->label_entry,arg2->label_entry,0);
                builder->emit("goto","","","","",0);
                nextinstr+=2;
            }
            else
            {
                string label=builder->getlabel();
                builder->emit("relation",label,root->val,arg1->label_entry,arg2->label_entry,0);
                nextinstr++;
                root->label_entry=label;
            }
            // root->code_entry=builder->generateExpression(root->val,arg1,arg2);
            
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
            SymbolEntry* entry = helper->checkmethod(identifier,arguments_type,curr_symtable,root->lineno);
            if(entry)
                root->type=entry->type;
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
        else if(root->token=="LITERAL")
        {
            if(root->lexeme=="0"|| root->lexeme=="false")
            {
                root->falselist=builder->makelist(nextinstr);
                builder->emit("goto","","","","",0);
                nextinstr++;
            }
            else
            {
                root->truelist=builder->makelist(nextinstr);
                builder->emit("goto","","","","",0);
                nextinstr++;
            }
        }
        else if(root->token=="IfThenStatement")
        {
            int M_instr=0;
            Node* B=NULL;
            Node* S1=NULL;
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(strcmp(child_node->val,")")==0)      
                {
                    M_instr=nextinstr;
                }   
                if(child_node->val=="Statement")
                {
                    S1=child_node;
                }   
                if(child_node->val=="Expression")
                {
                    B=child_node;
                }    
            }
            assert(B!=NULL);
            assert(S1!=NULL);
            cout<<"here2 "<<M_instr<< endl;
            builder->backpatch(B->truelist,M_instr);
            root->nextlist=builder->merge(B->falselist,S1->nextlist);
            cout<<"here3"<<endl;
            // root->code_entry=builder->generateExpression("","",root->lexeme);
        }
        else if(root->token=="IfThenElseStatement")
        {
            int M1_instr=0, M2_instr=0;
            Node* B=NULL;
            Node* S1=NULL;
            Node* S2=NULL;
            Node* N=NULL;
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(strcmp(child_node->val,")")==0)       
                {
                    M1_instr=nextinstr;
                }   
                if(child_node->val=="Statement")
                {
                    S2=child_node;
                }   
                if(child_node->val=="Expression")
                {
                    B=child_node;
                    N=new Node();
                    N->nextlist=builder->makelist(nextinstr);
                    builder->emit("goto","","","","",0);
                    nextinstr++;
                }    
                if(child_node->val=="ELSE")
                {
                    M2_instr=nextinstr;
                }     
                if(child_node->val=="StatementNoShortIf")
                    S1=child_node;
            }
            assert(B!=NULL);
            assert(S1!=NULL);
            assert(S2!=NULL);
            assert(N!=NULL);
            builder->backpatch(B->truelist,M1_instr);
            builder->backpatch(B->falselist,M2_instr);
            auto temp=builder->merge(S1->nextlist,N->nextlist);
            root->nextlist=builder->merge(temp,S2->nextlist);
            // root->code_entry=builder->generateExpression("","",root->lexeme);
        }
        else if(root->token=="IfThenElseStatementNoShortIf")
        {
            int M1_instr=0, M2_instr=0;
            Node* B=NULL, *S1=NULL,*S2=NULL;
            Node* N=NULL;
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(strcmp(child_node->val,")")==0)       
                {
                    M1_instr=nextinstr;
                }   
                if(child_node->val=="Expression")
                {
                    B=child_node;
                    N=new Node();
                    N->nextlist=builder->makelist(nextinstr);
                    builder->emit("goto","","","","",0);
                    nextinstr++;
                }    
                if(child_node->val=="ELSE")
                {
                    M2_instr=nextinstr;
                }     
                if(child_node->val=="StatementNoShortIf")
                {
                    if(!S1)
                        S1=child_node;
                    else    
                        S2=child_node;
                }  
            }
            assert(B!=NULL);
            assert(S1!=NULL);
            assert(S2!=NULL);
            assert(N!=NULL);
            builder->backpatch(B->truelist,M1_instr);
            builder->backpatch(B->falselist,M2_instr);
            auto temp=builder->merge(S1->nextlist,N->nextlist);
            root->nextlist=builder->merge(temp,S2->nextlist);
            // root->code_entry=builder->generateExpression("","",root->lexeme);
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