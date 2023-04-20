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
    bool is_print = 0;
    SymbolEntry* symentry;
    int param_index =0;
    ThreeAddressCodeEntry()
    {
        arg1 = {"", NULL};
        arg2 = {"", NULL};
        arg3 = {"", NULL};
        arg4 = {"", NULL};
    }

    void output_code_entry(ofstream& ofs)
    {
        if(this->type == "comment" || this->type == "precall" || this->type == "postcall")
            ofs<<"\t"<<"-----------------"<<this->arg1.first<<"-----------------";
        else if(this->type=="label" || this->type == "funcdecl" || this->type == "classdecl")
            ofs<<this->arg1.first<<":";
        else if(this->type=="pointer")
            ofs<<"\t*"<<this->arg1.first<<" = "<<this->arg2.first;
        else if(this->type=="param" || this->type == "param_stack" || this->type == "object_func" || this->type == "return_address")
            ofs<<"\t"<<this->arg1.first<<" "<<this->arg2.first;
        else if(this->arg1.first=="goto")
            ofs<<"\t"<<"goto "<<this->arg2.first;
        else if(this->type=="if")
            ofs<<"\t"<<this->arg1.first << " "<<this->arg2.first<<" "<< this->arg3.first << " "<< this->arg4.first;
        else if(this->type=="else")
            ofs<<"\t"<<this->arg1.first << " "<<this->arg2.first<<" "<< this->arg3.first;
        else if(this->type=="stack" || this->type == "return_value" || this->type == "call" || this->type == "funcend" || this->type == "funcreturn" || this->type == "localvar_allocate" || this->type == "localvar_deallocate")
            ofs<<"\t"<<this->arg1.first << " "<<this->arg2.first<<" "<< this->arg3.first;
        else if(this -> type == "funcparam" || this->type == "return_assign" || this->type == "offset" || this -> type == "")
            ofs<<"\t"<<this->arg1.first << " = "<<this->arg2.first<<" "<< this->arg3.first << " "<< this->arg4.first;
        ofs << "\t\t\t\t"<<this->comment << endl;
    }
};