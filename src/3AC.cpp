#include <bits/stdc++.h>
#include "3AC_entry.cpp"


class ThreeAddressCodeBuilder {

public:
    ofstream ofs;
    vector<ThreeAddressCodeEntry*> code_entries;
    int co_labels=0;
    ThreeAddressCodeBuilder()
    {
        co_labels=0;
        ofs.open("3AC.txt");
    }

    string getlabel()
    {
        co_labels++;
        string label="$"+to_string(co_labels);
        return label;
    }
    // string generateExpression(string op, string arg1, string arg2)
    // {
    //     int no=code_entries.size()+1;
    //     ThreeAddressCodeEntry* code_entry = new ThreeAddressCodeEntry(no, op, arg1, arg2);
    //     code_entries.push_back(code_entry);
    //     // if(display_flag)
    //     // code_entry->output_code_entry(ofs);
    //     return code_entry->val;
    // }

    vector<int> merge(vector<int>& list1, vector<int>& list2)
    {
        vector<int> newList;
        for(auto ele: list1)
            newList.push_back(ele);
        for(auto ele: list2)
            newList.push_back(ele);
    }

    vector<int> makelist(int instr_id)
    {
        vector<int> newList;
        newList.push_back(instr_id);
        return newList;
    }

    void backpatch(vector<int>& list, int instr_id)
    {
        for(auto ele:list)
        {
            code_entries[ele]->goto_addr=instr_id;
        }
    }

    void emit(string type, string assign_arg,string op, string addr1, string addr2,int goto_addr )
    {
        ThreeAddressCodeEntry* entry=new ThreeAddressCodeEntry();
        entry->indexno=code_entries.size()+1;
        code_entries.push_back(entry);
        if(type=="if")
        {
            entry->entry_type="if";
            entry->op=op;
            entry->arg1=addr1;
            entry->arg2=addr2;
            entry->goto_addr=goto_addr;
        }
        else if(type=="goto")
        {
            entry->entry_type="goto";
            entry->goto_addr=goto_addr;
        }
        else if(type=="relation")
        {
            entry->entry_type="relation";
            entry->op=op;
            entry->arg1=addr1;
            entry->arg2=addr2;
            entry->assign_arg=assign_arg;
        }
        else if(type=="assign")
        {
            entry->entry_type="assign";
            entry->assign_arg=assign_arg;
            entry->arg1=addr1;
        }
    }

    void display()
    {
        for(auto ele: code_entries)
        {
            ele->output_code_entry(ofs);
        }
    }
};
