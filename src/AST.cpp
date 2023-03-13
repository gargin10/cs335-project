#include <bits/stdc++.h>
#include "SymbolTable.cpp"
#include "SymbolEntry.cpp"

using namespace std;

struct Node{
    char* val;
    string lexeme;
    string token;
    SymbolTable* symbol_table;
    vector<SymbolEntry*> entries;
    vector<Node*> children;

    void addEntry(vector<SymbolEntry*> entries, string type)
    {
        for(auto ele: entries)
        {
            ele->type=type;
            this->entries.push_back(ele);
        }
    }
};



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
    temp->lexeme="";
    temp->token="";
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
    return temp;
}
Node* createNode(char* value)
{
    Node* temp= new Node();
    temp->val=value;
    temp->lexeme=value;
    temp->token=value;
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
    temp1->token=token;
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

void displaySymbolTable(std::ofstream& ofs, Node* node)
{
    if(node==NULL)
    return;

    if(node->symbol_table)
    {    
        node->symbol_table->display(ofs);
    }
    for(auto ele: node->entries)
    {
        ele->display(ofs);
    }
    int n=node->children.size();
    vector<Node*> children=node->children;
    for(int i=0;i<n;i++)
    {
        displaySymbolTable(ofs,children[i]);
    }
    return;
}