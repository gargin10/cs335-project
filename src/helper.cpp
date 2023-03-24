
#include <bits/stdc++.h>
#include "SymbolTable.h"
using namespace std;

class Helper
{
public:
    int display_flag=1;
    // returns "" if no definite type can be produced
    string biggertype( string arg1, string arg2){
        if( arg1 == "STRING" || arg2 == "STRING")
        {
            return "STRING";
        }
        if( arg1 == "BOOLEAN")
        {
            if(arg2 == "BOOLEAN") return "BOOLEAN";
        }
        if( arg2 == "BYTE" )
        {
            if( arg1 == "BYTE" ) return "BYTE";
            // else return false;
        }
        if( arg2 == "SHORT" )
        {
            if( arg1 == "BYTE" || arg1 == "SHORT" ) return "SHORT";
            // else return false;
        }
        if( arg2 == "CHAR" )
        {
            if( arg1 == "CHAR" ) return "CHAR";
            // return false;
        }
        if( arg2 == "INT" )
        {
            if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "CHAR" ) return "INT";
            // else return false;
        }
        if( arg2 == "LONG" )
        {
            if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "LONG" || arg1 == "CHAR"  ) return "LONG";
            // else return false;
        }
        if( arg2 == "FLOAT" )
        {
            if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "LONG" || arg1 == "FLOAT" || arg1 == "CHAR"  ) return "FLOAT";
            // else return false;
        }
        if( arg2 == "DOUBLE" )
        {
            if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "LONG" || arg1 == "FLOAT" || arg1 == "DOUBLE" || arg1 == "CHAR" ) return "DOUBLE";
            // Error else 
        }
        return "";
    }


    // arg1 is where it is used and arg2 is the entry type inside the symbol table i.e. type during declaration time.
    bool castit( string arg1, string arg2){
        if( arg1 == arg2 ) return true;
        if( arg1 == "STRING"|| arg2 == "STRING")
        {
            return true;
        }
        if( arg1 == "BOOLEAN")
        {
            if(arg2 == "BOOLEAN") return true;
            else return false;
        }
        if( arg2 == "BYTE" )
        {
            if( arg1 == "BYTE" ) return true;
            else return false;
        }
        if( arg2 == "SHORT" )
        {
            if( arg1 == "BYTE" || arg1 == "SHORT" ) return true;
            else return false;
        }
        if( arg2 == "CHAR" )
        {
            if( arg1 == "CHAR" ) return true;
            return false;
        }
        if( arg2 == "INT" )
        {
            if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "CHAR" ) return true;
            else return false;
        }
        if( arg2 == "LONG" )
        {
            if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "LONG" || arg1 == "CHAR"  ) return true;
            else return false;
        }
        if( arg2 == "FLOAT" )
        {
            if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "LONG" || arg1 == "FLOAT" || arg1 == "CHAR"  ) return true;
            else return false;
        }
        if( arg2 == "DOUBLE" )
        {
            if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "LONG" || arg1 == "FLOAT" || arg1 == "DOUBLE" || arg1 == "CHAR" ) return true;
            else return false;
        }
        return false;
    }

    // bool typecheckvariable(SymbolTable* temp, string lexeme, string type){
    //     vector<SymbolEntry*> entries = temp->lookup(lexeme);
    //     for(auto entry : entries){
    //         if( entry->entry_type != "variable" ) continue;
    //         if( castit( type, entry->type) ) return true;
    //     }
    //     return false;
    // }

    bool Assign_Operator(string str)
    {
         vector<string> v{"+=","-=","*=","&=","/=","|=","^=","%=","<<=",">>=",">>>="};

        set<string> s;
        for(auto ele:v)
        {
            s.insert(ele);
        }

        if(s.find(str)!=s.end())
            return true;
        return false;
    }

    bool isUnaryOperator(string str)
    {
        vector<string> v{"!", "++", "~", "--"};
        set<string> s;
        for(auto ele:v)
        {
            s.insert(ele);
        }

        if(s.find(str)!=s.end())
            return true;
        return false;
    }

    bool isOperator(string str)
    {
        vector<string> v{"=",">","<","?",":","->","==",">=","<=","!=","&&","||","+","-","*",
        "/","&","|","^","%","<<",">>",">>>"};

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
        if(display_flag)
        cout<<str<<"\n";
    }

    vector<SymbolEntry*> checkvariable(string lexeme, SymbolTable* symbol_table, int lineno)
    {
        assert(symbol_table!=NULL);
        // vector<SymbolEntry*> list_entries;
        vector<SymbolEntry*> list_entries=symbol_table->lookup(lexeme);
        if(list_entries.size()==0)
        {
            // symbol_table->display();
            throwerror("Line number: "+to_string(lineno)+" Identifier not declared: "+lexeme);
            return {NULL};
        }
        return list_entries;
    }

    SymbolEntry* checkarray(string array_identifier, int dims,SymbolTable* symbol_table, int lineno)
    {
        assert(symbol_table!=NULL);
        // vector<SymbolEntry*> list_entries;
        vector<SymbolEntry*> list_entries=symbol_table->lookup(array_identifier);
        if(list_entries.size()==0)
        {
            // symbol_table->display();
            throwerror("Line number: "+to_string(lineno)+" Array identifier not declared: "+array_identifier);
            return NULL;
        }
        if(list_entries[0]->no_dimensions!=dims)
        {
            throwerror("Line number: "+to_string(lineno)+" Required array access dimensions as "+to_string(list_entries[0]->no_dimensions)+" but found "+to_string(dims));
        }
        return list_entries[0];
    }
    bool checktypearrayacess(SymbolEntry* entry, string type, int lineno)
    {
        if( entry->entry_type != "array" ) 
        {
            throwerror("Line number: "+to_string(lineno)+" Identifier '"+entry->lexeme+"' used as a array access however declared as type "+entry->entry_type);
            return false;
        }
        if( !castit( type, entry->type) ) 
        {
            throwerror("Line number: "+to_string(lineno)+" Incorrect type conversion of Identifier '"+entry->lexeme+"' declared as "+entry->type+" to type as "+ type+ " Line number: "+to_string(lineno));
            return false;
        }
        return true;
    }

    bool checktypevariable(SymbolEntry* entry, string type, int lineno)
    {
        if( entry->entry_type != "variable" ) 
        {
            throwerror("Line number: "+to_string(lineno)+" Identifier '"+entry->lexeme+"' used as a variable however declared as type "+entry->entry_type);
            return false;
        }
        if( !castit( type, entry->type) ) 
        {
            throwerror("Line number: "+to_string(lineno)+" Incorrect type conversion of Identifier '"+entry->lexeme+"' declared as "+entry->type+" to type as "+ type+ " Line number: "+to_string(lineno));
            return false;
        }
        return true;
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
    SymbolEntry* checkmethod(string method_name, vector<string> type_arguments,SymbolTable* symbol_table, int lineno)
    {
        int no_arguments=type_arguments.size();
        assert(symbol_table!=NULL);
        // vector<SymbolEntry*> list_entries;
        vector<SymbolEntry*> list_entries=symbol_table->lookup(method_name);
        int flag = 1;
        for(auto entry : list_entries){
            flag = 1;
            if( entry->entry_type != "method" ) continue;
            if( entry->no_arguments != no_arguments ) continue;
            for( int i = 0 ; i < no_arguments ; i++ ){
                if( !castit( type_arguments[i], entry->type_arguments[i]) ) flag = 0;
            }
            if( flag == 0 ) continue;
            return entry;
        }
        throwerror("Line number: "+to_string(lineno)+" No such matching function found '"+method_name+"' with the given arguments Line number: "+to_string(lineno));
        return NULL;
    }

    bool typecast(Node* root, string type)
    {
        if(root->type==type)
        return true;
        if(castit(root->type,type))
        {
            root->type=type;
            return true;
        }
        return false;
    }

    bool checkclass(string type, SymbolTable* symtable){
        vector<SymbolEntry*> entries = symtable->lookup(type);
        for( auto entry : entries )
        {
            if( entry->type == "class" ){
                    return true;
            }
        }
        return false;
    }
};