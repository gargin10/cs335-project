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

    SymbolTable(SymbolTable* parent)
    {
        this->parent=parent;
    }

    void insert(string lexeme, SymbolEntry* entry)
    {
        entries[lexeme]=entry;
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

    void display()
    {
        for(auto ele: entries)
        {
            ele.second->display();
            cout<<"\n";
        }
        cout<<"\n";
        if(parent)
            parent->display();
    }
};