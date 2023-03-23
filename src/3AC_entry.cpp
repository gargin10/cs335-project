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

    ThreeAddressCodeEntry(int indexno)
    {
        this->indexno=indexno;
        this->val="$"+to_string(indexno);
    }
    ThreeAddressCodeEntry(int indexno, string op, string arg1, string arg2)
    {
        this->indexno=indexno;
        this->arg1=arg1;
        this->arg2=arg2;
        this->op=op;
        this->val="$"+to_string(indexno);
    }
    void output_code_entry(ofstream& ofs)
    {
        ofs<<this->val<<" =";
        if(arg1!="")
            ofs << " " << arg1;
        ofs<<" "<<this->op<<" "<<arg2<<endl;
    }
};