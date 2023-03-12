#pragma once

#include <iostream>
#include <cstdio>
using namespace std;


class SymbolEntry {

public:
    string token;
    string lexeme;
    string type;
    int line_number;
    int size;
    int offset;

    SymbolEntry()
    {
        token="";
        lexeme="";
        type="";
        line_number=0;
        size=0;
        offset=0;
    }

    SymbolEntry(string token, string lexeme)
    {
        this->token=token;
        this->lexeme=lexeme;
        this->type="";
        this->line_number=0;
        this->size=0;
        this->offset=0;
    }

    void display()
    {
        cout<< this->lexeme<<"\t"<<this->token <<"\t"<< this->type << "\t"
            << this->line_number << "\t" << this->size <<"\t" << this->offset;
    }

};