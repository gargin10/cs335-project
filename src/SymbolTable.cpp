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

    SymbolTable()
    {

    }
    SymbolTable(SymbolTable* parent)
    {
        this->parent=parent;
    }

    void insert(string lexeme, SymbolEntry* entry)
    {
        entries[lexeme]=entry;
    }

    void insert(vector<SymbolEntry*> entries)
    {
        for(auto ele:entries)
        {
            this->entries[ele->lexeme]=ele;
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
        for(auto ele: entries)
        {
            ele.second->display(ofs);
            ofs<<"\n";
        }
        ofs<<"\n";
        // if(parent)
        //     parent->display(outputfile);
    }
};