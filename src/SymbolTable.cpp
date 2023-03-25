#pragma once

#include "SymbolEntry.cpp"
#include <map>
#include <iostream>
#include <cstdio>
using namespace std;

class SymbolTable {

public:

    map<string, vector<SymbolEntry*> > entries;
    vector<string> order_entries;
    SymbolTable* parent;
    vector<SymbolTable*> children;
    string scope = "";

    SymbolTable()
    {
        scope="";
        parent=NULL;
    }
    SymbolTable(string scope)
    {
        this->scope=scope;
    }
    void insert(SymbolEntry* entry)
    {
        string x=entry->hash();
        if(entries.find(x)==entries.end())
        {
            vector<SymbolEntry*> temp;
            entries[x]=temp;
            entries[entry->hash()].push_back(entry);
            order_entries.push_back(entry->hash());
        }
        else
        {
            string type="";
            for(auto ele: entries[x])
            {
                type=ele->entry_type;
            }
            if(type!="method")
                cout<<"Line number: "<<entry->line_number<<" Redeclaration of the variable "<<entry->lexeme<<endl;
            else
            {
                entries[entry->hash()].push_back(entry);
            }
        }
    }

    vector<SymbolEntry*> lookup(string lexeme)
    {
        SymbolTable* temp= this;
        while(temp)
        {
            auto m =temp->entries;
            if(m.find(lexeme)!=m.end())
            {
                return m[lexeme];
            }
            temp=temp->parent;
        }
        return {};
    }

    void display(std::ofstream& ofs)
    {
        ofs << "Scope : "<< scope <<"\n";
        for(auto order_id: order_entries)
        {
            for( auto ele : entries[order_id] ){
                ele->display(ofs);
            }
        }
        ofs<<"\n";
    }
    void display()
    {
        cout << "Scope : "<< scope <<"\n";
        for(auto [_, entry]: entries)
        {
            for( auto ele : entry ){
                ele->display();
            }
        }
        cout<<"\n";
    }

    void setChild(SymbolTable* child)
    {
        if(child!=NULL)
        child->parent=this;
    }

    void setParent(SymbolTable* parent)
    {
        this->parent=parent;
        if(parent)
        {
            parent->children.push_back(this);
        }
    }
};