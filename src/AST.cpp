#pragma once

#include <bits/stdc++.h>
#include "SymbolTable.cpp"
#include "SymbolEntry.cpp"
#include "3AC_entry.cpp"

using namespace std;

struct Node{
    char* val=NULL;
    string lexeme="";
    string token="";
    int lineno=0;

    int dims=0;
    string type="";
    vector<tuple<string,int,string,bool>> identifier_type_list;
    vector<string> arguments_type; // also, used for storing 2 types of ternary operator
    string identifier="";
    SymbolTable* symtable = NULL;
    vector<ThreeAddressCodeEntry*> code_entries;
    string label_entry="";
    vector<int> array_dims;
    vector<string> array_invocation;

    // bool definite_literal_used = true;
    // bool assign=false;
    bool expression_new_used = false;
    string access_modifier="";
    string tempval="";
    vector<Node*> children;
    SymbolEntry* sym_entry;
    int size=0;
};

string curr_file="";
string class_file="";
std::ofstream ofs;

void display(SymbolTable* curr)
{
    assert(curr!=NULL);
    if(curr->table_type=="cunit")
    {
        curr_file="./output/compilation_unit.csv";
        ofs.close();
        ofs.open(curr_file,ios::out | std::ofstream::trunc);
    }
    else if(curr->table_type=="class")
    {
        curr_file="./output/"+curr->scope+".csv";
        class_file=curr->scope;
        ofs.close();
        ofs.open(curr_file,ios::out | std::ofstream::trunc);
    }
    else if(curr->table_type == "method")
    {
        curr_file="./output/"+class_file+"."+curr->scope+to_string(curr->line_number)+".csv";
        ofs.close();
        ofs.open(curr_file,ios::out | std::ofstream::trunc);
    }
    curr->display(ofs);
    for(auto ele: curr->children)
        display(ele);
}

void str_replace(char *target, const char *needle, const char *replacement)
{
    char buffer[1024] = { 0 };
    char *insert_point = &buffer[0];
    const char *tmp = target;
    size_t needle_len = strlen(needle);
    size_t repl_len = strlen(replacement);
    while (1) {
        const char *p = strstr(tmp, needle);
        if (p == NULL) {
            strcpy(insert_point, tmp);
            break;
        }
        memcpy(insert_point, tmp, p - tmp);
        insert_point += p - tmp;
        memcpy(insert_point, replacement, repl_len);
        insert_point += repl_len;
        tmp = p + needle_len;
    }
    strcpy(target, buffer);
}

Node* createNode(char* value, vector<Node*> children)
{
    Node* temp= new Node();
    temp->val=value;
    if(value)
    {
        temp->lexeme=value;
        temp->token=value;
    }
    
    vector<Node*> v;
    for(int i=0;i<children.size();i++)
    {
        if(!children[i]->val)
        {
            v.insert(v.end(),children[i]->children.begin(),children[i]->children.end());
        }
        else
        {
            v.push_back(children[i]);
        }
    }
    temp->children=v;
    if(v.size()>0)
    temp->lineno=v[0]->lineno;
    return temp;
}
Node* createNode(char* value)
{
    Node* temp= new Node();
    temp->val=value;
    if(value)
    {
        temp->lexeme=value;
        temp->token=value;
    }
    return temp;
}

Node* createNode( char* lexeme, char* token)
{
    Node* temp1= new Node();
    str_replace(lexeme,"\"","\\\"");
    char* ans=new char[strlen(lexeme)+strlen(token)+3];
    strcpy(ans,token);
    strcat(ans,"(");
    strcat(ans,lexeme);
    strcat(ans,")");
    temp1->val=ans;
    temp1->lexeme=lexeme;
    if( strcmp( token, "INT_LITERAL") == 0 ){
        temp1->type = "BYTE";
        temp1->token = "LITERAL";
    } else if( strcmp( token, "FLOAT_LITERAL") == 0 ){
        temp1->type = "FLOAT";
        temp1->token = "LITERAL";
    } else if( strcmp( token, "CHAR_LITERAL") == 0 ){
        temp1->type = "CHAR";
        temp1->token = "LITERAL";
    } else if( strcmp( token, "BOOLEAN_LITERAL") == 0 ){
        temp1->type = "BOOLEAN";
        temp1->token = "LITERAL";
    } else if( strcmp( token, "NULL_LITERAL") == 0 ){
        temp1->type = "NULL";
        temp1->token = "LITERAL";
    } else if( strcmp( token, "STRING_LITERAL") == 0 ){
        temp1->type = "STRING";
        temp1->token = "LITERAL";
    } else temp1->token=token;
    return temp1;
}
Node* createNode( char* lexeme, int lineno)
{
    Node* temp1= new Node();
    temp1->val=lexeme;
    temp1->lexeme=lexeme;
    temp1->token="";
    temp1->lineno=lineno;
    return temp1;
}

Node* createNode( char* lexeme, char* token, int lineno)
{
    Node* temp1= new Node();
    str_replace(lexeme,"\"","\\\"");
    char* ans=new char[strlen(lexeme)+strlen(token)+3];
    strcpy(ans,token);
    strcat(ans,"(");
    strcat(ans,lexeme);
    strcat(ans,")");
    temp1->val=ans;
    temp1->lexeme=lexeme;
    if( strcmp( token, "INT_LITERAL") == 0 ){
        temp1->type = "BYTE";
        temp1->token = "LITERAL";
    } else if( strcmp( token, "FLOAT_LITERAL") == 0 ){
        temp1->type = "FLOAT";
        temp1->token = "LITERAL";
    } else if( strcmp( token, "CHAR_LITERAL") == 0 ){
        temp1->type = "CHAR";
        temp1->token = "LITERAL";
    } else if( strcmp( token, "BOOLEAN_LITERAL") == 0 ){
        temp1->type = "BOOLEAN";
        temp1->token = "LITERAL";
    } else if( strcmp( token, "NULL_LITERAL") == 0 ){
        temp1->type = "NULL";
        temp1->token = "LITERAL";
    } else if( strcmp( token, "STRING_LITERAL") == 0 ){
        temp1->type = "STRING";
        temp1->token = "LITERAL";
    } else temp1->token=token;
    temp1->lineno=lineno;
    return temp1;
}

int buildTree(FILE* dotfile, Node* node, int parentno, int co) 
{
    if(node==NULL)
    return co;

    int nodeno=co++;
    fprintf(dotfile," node%d [label=\"%s\"]\n",nodeno,node->val);
    if(parentno>=0) 
        fprintf(dotfile," node%d -> node%d\n",parentno,nodeno);
    
    int n=node->children.size();
    vector<Node*> children=node->children;
    for(int i=0;i<n;i++)
    {
        co=buildTree(dotfile,children[i],nodeno,co);
    }
    return co;
}