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

    ThreeAddressCodeEntry()
    {

    }
    // ThreeAddressCodeEntry(int indexno)
    // {
    //     this->indexno=indexno;
    //     this->val="$"+to_string(indexno);
    // }
    // ThreeAddressCodeEntry(int indexno, string op, string arg1, string arg2)
    // {
    //     this->indexno=indexno;
    //     this->arg1=arg1;
    //     this->arg2=arg2;
    //     this->op=op;
    //     this->val="$"+to_string(indexno);
    // }
    void output_code_entry(ofstream& ofs)
    {
        if(this->type=="label")
            ofs<<this->arg1<<":"<<endl;
        else if(this->arg1=="goto")
            ofs<<"goto "<<this->arg2<<endl;
        else if(this->type=="if")
            ofs<<"\t"<<this->arg1 << " "<<this->arg2<<" "<< this->arg3 << " "<< this->arg4<<endl;
        else if(this->type=="else")
            ofs<<"\t"<<this->arg1 << " "<<this->arg2<<" "<< this->arg3 <<endl;
        else 
            ofs<<"\t"<<this->arg1 << " = "<<this->arg2<<" "<< this->arg3 << " "<< this->arg4<<endl;
    //     if(this->entry_type=="if")
    //     {
    //         ofs<<"if "<< this->arg1 << " "<< this->op << " "<< this->arg2 << " goto "<< this->goto_addr;
    //     }
    //     else if(this->entry_type=="goto")
    //     {
    //         ofs << "goto "<< this->goto_addr;
    //     }
    //     else if(this->entry_type=="relation")
    //     {
    //         ofs << this->assign_arg << " = "<< this->arg1<< " "<<this->op << " " << this->arg2;
    //     }
    //     ofs << endl;
    }
};