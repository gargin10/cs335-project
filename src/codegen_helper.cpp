bool check_literal(string s){
    if( s[0] >= '0' and s[0] <= '9' ) return true;
    return false;
}
bool check_char(string s){
    if( s[0] == '\'' ) return true;
    return false;
}
string getaddr(string arg, ThreeAddressCodeEntry* entry, map<string, set<string>>& address_descriptor, int func_total_offset, int& func_curr_offset){
    string s = "";
    if( arg == "arg1" ){
        if( check_literal( entry->arg1.first ) ){
            s += '$';
            s += entry->arg1.first;
        } else {
            if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                auto it = address_descriptor[entry->arg1.first].begin();
                s += *it;
                func_curr_offset -= 4;
            } else {
                auto it = address_descriptor[entry->arg1.first].begin();
                s += *it;
            }
        }
    } else if( arg == "arg2" ){
        if( check_literal( entry->arg2.first ) ){
            s += '$';
            s += entry->arg2.first;
        }  else if( check_char( entry->arg2.first ) ){
            s += '$';
            s += to_string((int)entry->arg2.first[1]);
            // cout << s << endl;
        } else {
            if( address_descriptor.find(entry->arg2.first) == address_descriptor.end() ){
                address_descriptor[entry->arg2.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                auto it = address_descriptor[entry->arg2.first].begin();
                s += *it;
                func_curr_offset -= 4;
            } else {
                auto it = address_descriptor[entry->arg2.first].begin();
                s += *it;
            }
        }
    } else if( arg == "arg3" ){
        if( check_literal( entry->arg3.first ) ){
            s += '$';
            s += entry->arg3.first;
        } else {
            if( address_descriptor.find(entry->arg3.first) == address_descriptor.end() ){
                address_descriptor[entry->arg3.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                auto it = address_descriptor[entry->arg3.first].begin();
                s += *it;
                func_curr_offset -= 4;
            } else {
                auto it = address_descriptor[entry->arg3.first].begin();
                s += *it;
            }
        }
    } else if( arg == "arg4" ){
        if( check_literal( entry->arg4.first ) ){
            s += '$';
            s += entry->arg4.first;
        } else {
            if( address_descriptor.find(entry->arg4.first) == address_descriptor.end() ){
                address_descriptor[entry->arg4.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                auto it = address_descriptor[entry->arg4.first].begin();
                s += *it;
                func_curr_offset -= 4;
            } else {
                auto it = address_descriptor[entry->arg4.first].begin();
                s += *it;
            }
        }
    }
    return s;
}