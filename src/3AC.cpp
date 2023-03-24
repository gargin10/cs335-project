#pragma once

#include <bits/stdc++.h>
#include "3AC_entry.cpp"


class ThreeAddressCodeBuilder {

public:
    ofstream ofs;
    // vector<ThreeAddressCodeEntry*> code_entries;
    // int co_labels=0;
    ThreeAddressCodeBuilder()
    {
        // co_labels=0;
        // ofs.open("3AC.txt");
    }

    void merge_entries(Node* node, vector<ThreeAddressCodeEntry*>& entries)
    {
        node->code_entries.insert(node->code_entries.end(),entries.begin(),entries.end());
        entries.clear();
    }
    void display(Node* node, string scope)
    {
        ofs.open(scope,ios::out | std::ofstream::trunc);
        for(auto ele: node->code_entries)
        {
            ele->output_code_entry(ofs);
        }
        ofs<<endl;
        ofs.close();
    }
};
