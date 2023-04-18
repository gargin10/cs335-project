string getaddr(string arg, ThreeAddressCodeEntry* entry){
    string s = "";
    if( arg == "arg1" ){

    } else if( arg == "arg2" ){
        // arg2 is literal
        if( entry->is_literal ){
            s += "$";
            s += entry->arg2.first;
        } else {
            // store address in s
            s += entry->arg2.first;
            
        }
    }
    return s;
}