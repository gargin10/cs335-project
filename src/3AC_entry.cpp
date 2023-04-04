#pragma once

#include <bits/stdc++.h>

class ThreeAddressCodeEntry
{
public:

    string arg1="";
    string arg2="";
    string arg3="";
    string arg4="";
    string type="";
    string comment="";
    ThreeAddressCodeEntry()
    {

    }

    void output_code_entry(ofstream& ofs)
    {
        if(this->type == "comment")
            ofs<<"\t"<<"-----------------"<<this->arg1<<"-----------------";
        else if(this->type=="label")
            ofs<<this->arg1<<":";
        else if(this->type=="pointer")
            ofs<<"\t*"<<this->arg1<<" = "<<this->arg2;
        else if(this->type=="param")
            ofs<<"\t"<<this->arg1<<" "<<this->arg2;
        else if(this->arg1=="goto")
            ofs<<"\t"<<"goto "<<this->arg2;
        else if(this->type=="if")
            ofs<<"\t"<<this->arg1 << " "<<this->arg2<<" "<< this->arg3 << " "<< this->arg4;
        else if(this->type=="else")
            ofs<<"\t"<<this->arg1 << " "<<this->arg2<<" "<< this->arg3;
        else if(this->type=="stack")
            ofs<<"\t"<<this->arg1 << " "<<this->arg2<<" "<< this->arg3;
        else 
            ofs<<"\t"<<this->arg1 << " = "<<this->arg2<<" "<< this->arg3 << " "<< this->arg4;
        ofs << "\t\t\t\t"<<this->comment << endl;
    }
};