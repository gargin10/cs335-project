#include <bits/stdc++.h>
#include "3AC_entry.cpp"


class ThreeAddressCodeBuilder {

public:
    ofstream ofs;
    int display_flag=0;
    vector<ThreeAddressCodeEntry*> code_entries;
    ThreeAddressCodeBuilder()
    {
        ofs.open("3AC.txt");
    }

    string generateExpression(string op, string arg1, string arg2)
    {
        int no=code_entries.size()+1;
        ThreeAddressCodeEntry* code_entry = new ThreeAddressCodeEntry(no, op, arg1, arg2);
        code_entries.push_back(code_entry);
        if(display_flag)
        code_entry->output_code_entry(ofs);
        return code_entry->val;
    }
};
