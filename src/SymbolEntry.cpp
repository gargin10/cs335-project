#pragma once

#include <iostream>
#include <cstdio>
using namespace std;


class SymbolEntry {

public:
    string token;
    string lexeme;
    string type;
    string entry_type;
    string hash_key;

    bool temp;
    int line_number;
    int size;
    int offset;

    int no_arguments;
    vector<string> type_arguments;

    int no_dimensions;
    
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
    }

    string hash() 
    {
        string s= this->lexeme+ this->token + this->type;

        if(entry_type=="method")
        {
            s+=this->no_arguments;
            for(auto ele: this->type_arguments)   
                s+=ele;
        }
        if(entry_type=="array")
        {
            s+=this->no_dimensions; 
        }
        return s;
    }

    void display(std::ofstream& ofs)
    {
        ofs<< this->lexeme<<"\t"<<this->token <<"\t"<< this->type << "\t"
                    << this->line_number << "\t" << this->size <<"\t" << this->offset<<"\t";   

        if(entry_type=="method")
        {
            ofs<< this->no_arguments << "\t"; 
            for(auto ele: type_arguments)   
                ofs << ele << " ";
        }
        
        if(entry_type=="array")
        {
            ofs<< this->no_dimensions<< "\t"; 
        }
        ofs<<"\n";
    }
};

// class SymbolMethodEntry: public SymbolEntry
// {

// public:
//     string returntype;
//     int no_arguments;
//     vector<string> type_arguments;

//     SymbolMethodEntry() : SymbolEntry()
//     {
//     }
//     SymbolMethodEntry(string token, string lexeme) : SymbolEntry(token,lexeme)
//     {
//     }
//     void display(std::ofstream& ofs)
//     {
//         this->SymbolEntry::display(ofs);
//         ofs<< this->returntype<<"\t"<<this->no_arguments << "\t"; 
//         for(auto ele: type_arguments)   
//             ofs << ele << " ";
//         ofs <<"\n";
//     }
// };

// class SymbolArrayEntry: public SymbolEntry
// {

// public:
//     int no_dimensions;
//     vector<int> dim_size;

//     SymbolArrayEntry() : SymbolEntry()
//     {
//     }
//     SymbolArrayEntry(string token, string lexeme) : SymbolEntry(token,lexeme)
//     {
//     }
//     void display(std::ofstream& ofs)
//     {
//         this->SymbolEntry::display(ofs);
//         ofs<< this->no_dimensions<< "\t"; 
//         for(auto ele: dim_size)   
//             ofs << ele << " ";
//         ofs <<"\n";
//     }
// };