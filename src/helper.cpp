
#include <bits/stdc++.h>
#include "SymbolTable.h"
using namespace std;

bool castit( string arg1, string arg2){
    if( arg2 == "BYTE" ){
        if( arg1 == "BYTE" ) return true;
        else return false;
    }
    if( arg2 == "SHORT" ){
        if( arg1 == "BYTE" || arg1 == "SHORT" ) return true;
        else return false;
    }
    if( arg2 == "INT" ){
        
    }
    if( arg1 == "LONG" ){
        if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "LONG" ){
            return true;
        } else return false;
    }
    if( arg2 == "FLOAT" ){
        if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "LONG" || arg1 == "FLOAT" ){
            return true;
        } else return false;
    }
    if( arg2 == "DOUBLE" ){
        if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "LONG" || arg1 == "FLOAT" || arg1 == "DOUBLE"){
            return true;
        } else return false;
    }
}

bool typecheckmethod(SymbolTable* temp, string lexeme, int no_arguments, vector<string> type_arguments){
    vector<SymbolEntry*> entries = temp->lookup(lexeme);
    int flag = 0;
    for(auto entry : entries){
        flag = 0;
        if( entry->entry_type != "method" ) continue;
        if( entry->no_arguments != no_arguments ) continue;
        for( int i = 0 ; i < no_arguments ; i++ ){
            if( castit( type_arguments[i], entry->type_arguments[i]) ) flag = 1;
        }
        if( flag == 1 ) continue;
        return true;
    }
    return false;
}

bool typecheckvariable(SymbolTable* temp, string lexeme, string type){
    vector<SymbolEntry*> entries = temp->lookup(lexeme);
    for(auto entry : entries){
        if( entry->entry_type != "variable" ) continue;
        if( castit( type, entry->type) ) return true;
    }
    return false;
}

bool isOperator(string str)
{
    vector<string> v{"=",">","<","!","~","?",":","->","==",">=","<=","!=","&&","||","+","-","*",
    "/","&","|","^","%","<<",">>",">>>","+=","-=","*=","&=","/=","|=","^=","%=","<<=",">>=",">>>="};

    set<string> s;
    for(auto ele:v)
    {
        s.insert(ele);
    }

    if(s.find(str)!=s.end())
        return true;
    return false;
}

void throwerror(string str)
{
    cout<<str<<"\n";
}

SymbolEntry* checkvariable(string lexeme, SymbolTable* symbol_table, int lineno)
{
    assert(symbol_table!=NULL);
    // vector<SymbolEntry*> list_entries;
    vector<SymbolEntry*> list_entries=symbol_table->lookup(lexeme);
    if(list_entries.size()==0)
    {
        // symbol_table->display();
        throwerror("Identifier not declared: "+lexeme+" Line number: "+to_string(lineno));
        return NULL;
    }
    return list_entries[0];
}

bool checktypevariable(SymbolEntry* entry, string type, int lineno)
{
    if( entry->entry_type != "variable" ) 
    {
        throwerror("Identifier '"+entry->lexeme+"' used as a variable however declared as type "+entry->entry_type+" Line number: "+to_string(lineno));
        return false;
    }
    if( !castit( type, entry->type) ) 
    {
        throwerror("Incorrect type conversion of Identifier '"+entry->lexeme+"' declared as "+entry->type+" to type as "+ type+ " Line number: "+to_string(lineno));
        return false;
    }
    return true;
}