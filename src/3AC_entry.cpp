#pragma once

#include <bits/stdc++.h>

class ThreeAddressCodeEntry
{
public:

    pair<string, SymbolEntry*> arg1;
    pair<string, SymbolEntry*> arg2;
    pair<string, SymbolEntry*> arg3;
    pair<string, SymbolEntry*> arg4;
    string type="";
    bool is_literal = false;
    string comment="";
    SymbolEntry* symentry;
    ThreeAddressCodeEntry()
    {
        arg1 = {"", NULL};
        arg2 = {"", NULL};
        arg3 = {"", NULL};
        arg4 = {"", NULL};
    }

    void output_code_entry(ofstream& ofs)
    {
        if(this->type == "comment")
            ofs<<"\t"<<"-----------------"<<this->arg1.first<<"-----------------";
        else if(this->type=="label" || this->type == "funcdecl" || this->type == "classdecl")
            ofs<<this->arg1.first<<":";
        else if(this->type=="pointer")
            ofs<<"\t*"<<this->arg1.first<<" = "<<this->arg2.first;
        else if(this->type=="param")
            ofs<<"\t"<<this->arg1.first<<" "<<this->arg2.first;
        else if(this->arg1.first=="goto")
            ofs<<"\t"<<"goto "<<this->arg2.first;
        else if(this->type=="if")
            ofs<<"\t"<<this->arg1.first << " "<<this->arg2.first<<" "<< this->arg3.first << " "<< this->arg4.first;
        else if(this->type=="else")
            ofs<<"\t"<<this->arg1.first << " "<<this->arg2.first<<" "<< this->arg3.first;
        else if(this->type=="stack" || this->type == "funcend")
            ofs<<"\t"<<this->arg1.first << " "<<this->arg2.first<<" "<< this->arg3.first;
        else if(this -> type == "funcparam" || this -> type == "")
            ofs<<"\t"<<this->arg1.first << " = "<<this->arg2.first<<" "<< this->arg3.first << " "<< this->arg4.first;
        ofs << "\t\t\t\t"<<this->comment << endl;
    }
};