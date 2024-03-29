#pragma once

#include <iostream>
#include <cstdio>
#include <vector>
#include "SymbolTable.h"
using namespace std;


class SymbolEntry {

public:
    string token;
    string lexeme;
    string type;
    string entry_type;
    string hash_key;
    vector<string> modifiers;

    bool temp;
    int line_number=0;
    int size=0;
    int offset=0;
    SymbolTable* symtab;

    int no_arguments=0;
    vector<string> type_arguments;

    int no_dimensions=0;
    
    SymbolEntry()
    {
        token="";
        lexeme="";
        type="";
        line_number=0;
        size=0;
        offset=0;
        temp=false;
        entry_type="variable";
        hash_key="";
        symtab = NULL;
    }

    SymbolEntry(string token, string lexeme)
    {
        this->token=token;
        this->lexeme=lexeme;
        this->type="";
        this->line_number=0;
        this->size=0;
        this->offset=0;
        this->temp=false;
        entry_type="variable";
        hash_key="";
        symtab=NULL;
    }

    string hash() 
    {
        // string s= this->lexeme+ this->token + this->type;
        string s= this->lexeme;

        // if(entry_type=="method")
        // {
        //     s+=this->no_arguments;
        //     for(auto ele: this->type_arguments)   
        //         s+=ele;
        // }
        // if(entry_type=="array")
        // {
        //     s+=this->no_dimensions; 
        // }
        return s;
    }

    void display(std::ofstream& ofs)
    {
        ofs<< this->lexeme<<"\t"<<this->token <<"\t"<< this->type << "\t"
                    << this->line_number << "\t" << this->size <<"\t" << this->offset<<"\t";   

        for(auto ele: modifiers)
        {
            ofs << ele << "\t";
        }
        if(entry_type=="method")
        {
            ofs<< this->no_arguments << "\t"; 
            for(auto ele: type_arguments)   
                ofs << ele << "\t";
        }
        
        if(entry_type=="array")
        {
            ofs<< this->no_dimensions<< "\t"; 
        }
        ofs<<"\n";
    }
    void display()
    {
        cout<< this->lexeme<<"\t"<<this->token <<"\t"<< this->type << "\t"
                    << this->line_number << "\t" << this->size <<"\t" << this->offset<<"\t";   

        if(entry_type=="method")
        {
            cout<< this->no_arguments << "\t"; 
            for(auto ele: type_arguments)   
                cout << ele << " ";
        }
        
        if(entry_type=="array")
        {
            cout<< this->no_dimensions<< "\t"; 
        }
        cout<<"\n";
    }
};