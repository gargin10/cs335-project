#pragma once

#include "SymbolEntry.cpp"
#include <map>
#include <iostream>
#include <cstdio>
using namespace std;

class SymbolTable {

public:

    map<string, SymbolEntry*> entries;
    SymbolTable* parent;
    string scope;

    SymbolTable()
    {

    }
    SymbolTable(string scope)
    {
        this->scope=scope;
    }
    void insert(string lexeme, SymbolEntry* entry)
    {
        entries[entry->hash()]=entry;
    }

    void insert(vector<SymbolEntry*> entries)
    {
        for(auto ele:entries)
        {
            if(!ele->temp)
            this->entries[ele->hash()]=ele;
        }
    }

    SymbolEntry* lookup(string lexeme)
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
        return NULL;
    }

    void display(std::ofstream& ofs)
    {
        ofs << "Scope : "<<this->scope<<"\n";
        for(auto [_, entry]: entries)
        {
            entry->display(ofs);
        }
        ofs<<"\n";
        // if(parent)
        //     parent->display(outputfile);
    }

    void setChild(SymbolTable* child)
    {
        if(child!=NULL)
        child->parent=this;
    }
};