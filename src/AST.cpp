#include <bits/stdc++.h>
#include "SymbolTable.cpp"
#include "SymbolEntry.cpp"

using namespace std;

struct Node{
    char* val;
    string lexeme;
    string token;
    int lineno;

    string tempval;
    SymbolEntry* tempentry;
    vector<string> tempargs;

    SymbolTable* symbol_table;
    vector<SymbolEntry*> entries;
    vector<Node*> children;

    void addTypeEntry(vector<SymbolEntry*> entries, string type)
    {
        for(auto ele: entries)
        {
            ele->type=type;
            ele->temp=false;
            this->entries.push_back(ele);
        }
    }
    void addReturntypeEntry(vector<SymbolEntry*> entries, string returntype)
    {
        for(auto ele: entries)
        {
            ele->type=returntype;
            ele->temp=false;
            this->entries.push_back(ele);
        }
    }
    void addReturntypeEntry(SymbolEntry* entry, string returntype)
    {
        assert(entry!=NULL);
        // cout<<"Tempentry:"<<"\n";
        // cout<< entry->lexeme<<"\t"<<entry->token <<"\t"<< entry->type << "\t"
        //             << entry->line_number << "\t" << entry->size <<"\t" << entry->offset<<"\n";  

        entry->type=returntype;
        entry->temp=false;
        // cout<< entry->lexeme<<"\t"<<entry->token <<"\t"<< entry->type << "\t"
        //             << entry->line_number << "\t" << entry->size <<"\t" << entry->offset<<"\n";  

        this->entries.push_back(entry);
    }

    void pushEntriestoUSTE(vector<Node*> v)
    {
        for(auto node: v)
        {
            for(auto ele: node->entries)
            {
                this->entries.push_back(ele);
            }
        }
    }

    void addEntriestoST(vector<SymbolEntry*> childentries)
    {
        this->symbol_table->insert(childentries);
    }

    void moveEntries()
    {
        assert(this->symbol_table!=NULL);
        this->symbol_table->insert(this->entries);
        vector<SymbolEntry*> temp;
        this->entries=temp;
    }

    void setChildren()
    {
        for(auto node: this->children)
        {
            if(node->symbol_table)
            {
                this->symbol_table->setChild(node->symbol_table);
            }
        }
    }
};


void display(SymbolTable* curr, std::ofstream& ofs)
{
    assert(curr!=NULL);
    curr->display(ofs);
    for(auto ele:curr->children)
    {
        display(ele,ofs);
    }
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
    temp->pushEntriestoUSTE(v);
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
    temp1->token=token;
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
    temp1->token=token;
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

void displaySymbolTable(std::ofstream& ofs, Node* node,Node* parent)
{
    if(node==NULL)
    return;

    
    if(node->symbol_table && (!parent || node->symbol_table!=parent->symbol_table))
    {    
        ofs <<"SymbolTable:"<<"\n";
        node->symbol_table->display(ofs);
        ofs<<"\n";
    }
    // if(node->tempentry)
    // {
    //     ofs<<"Tempentry:"<<"\n";
    //     node->tempentry->display(ofs);
    // }
    
    // ofs<<"Nodeentries:"<<"\n";
    // for(auto ele: node->entries)
    // {
    //     ele->display(ofs);
    // }
    // ofs<<"\n";
    int n=node->children.size();
    vector<Node*> children=node->children;
    for(int i=0;i<n;i++)
    {
        displaySymbolTable(ofs,children[i],node);
    }
    return;
}