#pragma once

#include <bits/stdc++.h>

class ThreeAddressCodeEntry
{
public:

    int indexno=0;
    string val="";
    string op="";
    string arg1="";
    string arg2="";
    int goto_addr=0;
    string entry_type="";
    string assign_arg="";

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
        if(this->entry_type=="if")
        {
            ofs<<"if "<< this->arg1 << " "<< this->op << " "<< this->arg2 << " goto "<< this->goto_addr;
        }
        else if(this->entry_type=="goto")
        {
            ofs << "goto "<< this->goto_addr;
        }
        else if(this->entry_type=="relation")
        {
            ofs << this->assign_arg << " = "<< this->arg1<< " "<<this->op << " " << this->arg2;
        }
        ofs << endl;
    }
};