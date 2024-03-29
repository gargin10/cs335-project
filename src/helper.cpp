#pragma once

#include <bits/stdc++.h>
#include "SymbolTable.h"
using namespace std;

class Helper
{
public:
    map<string,SymbolTable*> class_fields;
    map<string,SymbolTable*> class_methods;
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
            if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "LONG" || arg1 == "FLOAT" || "DOUBLE" ) return arg1;
            if( arg1 == "CHAR" ) return arg2;
            // else return false;
        }
        if( arg2 == "SHORT" )
        {
            if( arg1 == "CHAR" || "BYTE" || arg1 == "SHORT" ) return "SHORT";
            else if( arg1 == "INT" || arg1 == "LONG" || arg1 == "FLOAT" || "DOUBLE" ) return arg1;
            // else return false;
        }
        if( arg2 == "CHAR" )
        {
            if( arg1 == "CHAR" || arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "LONG" || arg1 == "FLOAT" || "DOUBLE" ) return arg1;
            // return false;
        }
        if( arg2 == "INT" )
        {
            if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "CHAR" ) return "INT";
            if( arg1 == "LONG" || arg1 == "FLOAT" || arg1 == "DOUBLE" ) return arg2;
            // else return false;
        }
        if( arg2 == "LONG" )
        {
            if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "LONG" || arg1 == "CHAR"  ) return "LONG";
            if( arg1 == "FLOAT" || arg1 == "DOUBLE" ) return arg1;
            // else return false;
        }
        if( arg2 == "FLOAT" )
        {
            if( arg1 == "BYTE" || arg1 == "SHORT" || arg1 == "INT" || arg1 == "LONG" || arg1 == "FLOAT" || arg1 == "CHAR"  ) return "FLOAT";
            if( arg1 == "DOUBLE" ) return arg1;
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
        // if( arg1 == "STRING" || arg2 == "STRING")
        // {
        //     return true;
        // }
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
        vector<string> v{"=",">","<","?:","->","==",">=","<=","!=","&&","||","+","-","*",
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
        cout<<str<<"\n";
    }

    vector<SymbolEntry*> checkvariable(string lexeme, SymbolTable* symbol_table, int lineno)
    {
        assert(symbol_table!=NULL);
        if(lexeme.length()>=5 && lexeme.substr(lexeme.length()-4,4)=="this")
            lexeme=lexeme.substr(0, lexeme.length()-5);
        // vector<SymbolEntry*> list_entries;
        vector<SymbolEntry*> list_entries=symbol_table->lookup(lexeme);
        if(list_entries.size()==0)
        {
            // symbol_table->display();
            throwerror("Line number: "+to_string(lineno)+" Identifier not declared: "+lexeme);
        }
        return list_entries;
    }

    SymbolEntry* checkfieldaccess(string class_name,string field_name,SymbolTable* symbol_table, int lineno)
    {
        assert(symbol_table!=NULL);
        if(class_name.length()>=5 && class_name.substr(class_name.length()-4,4)=="this")
            class_name=class_name.substr(0, class_name.length()-5);
        if(class_fields.find(class_name)==class_fields.end())
        {
            throwerror("Line number: "+to_string(lineno)+" No such class type '"+class_name+"' found");
            return NULL;
        }
        SymbolTable* class_symtable=class_fields[class_name];
        for(auto [_,vec]: class_symtable->entries)
        {
            auto ele=vec[0];
            // cout<<ele->lexeme<<" ";
            if(ele->type!="method" && ele->lexeme==field_name)
            {
                return ele;
            }
        }
        throwerror("Line number: "+to_string(lineno)+" No such object field in the class type '"+class_name+"' with field name'"+field_name+"' found");
        return NULL;
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
            throwerror("Line number: "+to_string(lineno)+" Incorrect type conversion of Identifier '"+entry->lexeme+"' declared as "+entry->type+" to type as "+ type);
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
            throwerror("Line number: "+to_string(lineno)+" Incorrect type conversion of Identifier '"+entry->lexeme+"' declared as "+entry->type+" to type as "+ type);
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
        throwerror("Line number: "+to_string(lineno)+" No such matching function found '"+method_name+"' with the given arguments");
        return NULL;
    }

    SymbolEntry* checkmethodaccess(string class_name,string method_name,vector<string> type_arguments,SymbolTable* symbol_table, int lineno)
    {
        assert(symbol_table!=NULL);
        if(class_name.length()>=5 && class_name.substr(class_name.length()-4,4)=="this")
            class_name=class_name.substr(0, class_name.length()-5);
        int no_arguments=type_arguments.size();
        if(class_methods.find(class_name)==class_methods.end())
        {
            throwerror("Line number: "+to_string(lineno)+" No such class type '"+class_name+"' found");
            return NULL;
        }
        SymbolTable* class_symtable=class_methods[class_name];
        auto entries=class_symtable->entries;
        if(entries.find(method_name)==entries.end())
        {
            throwerror("Line number: "+to_string(lineno)+" No such matching function found of class type as'"+class_name+"' with method name '"+method_name);
            return NULL;
        }
        auto list_entries=entries[method_name];
        int flag = 1;
        for(auto entry : list_entries){
            flag = 1;
            // cout<<entry->lexeme<<" "<<entry->entry_type<<endl;
            if(entry->lexeme != method_name) continue;
            if( entry->entry_type != "method" ) continue;
            if( entry->no_arguments != no_arguments ) continue;
            for( int i = 0 ; i < no_arguments ; i++ ){
                // cout<<"here"<<endl;
                // cout<<type_arguments[i]<<" "<<entry->type_arguments[i]<<endl;
                if( !castit( type_arguments[i], entry->type_arguments[i]) ) flag = 0;
            }
            if( flag == 0 ) continue;
            return entry;
        }
        throwerror("Line number: "+to_string(lineno)+" No such matching function found of class type as'"+class_name+"' with method name '"+method_name+"' with the given arguments");
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

    SymbolEntry* checkclass(string type, SymbolTable* symtable, int lineno){
        vector<SymbolEntry*> entries = symtable->lookupclass(type);
        for( auto entry : entries )
        {
            if( entry->type == "class" ){
                    return entry;
            }
        }
        throwerror("Line number: "+to_string(lineno)+" No such reference type "+type+" found");
        return NULL;
    }
};