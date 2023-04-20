#pragma once

#include "SymbolEntry.cpp"
#include "SymbolTable.cpp"
#include "helper.cpp"
#include "3AC.cpp"

#include <map>
#include <iostream>
#include <cstdio>
using namespace std;

class SymbolTableBuilder {

public:
    set<string> validtypes;
    set<string> validmodifiers;
    SymbolTable* curr_symtable;
    SymbolTable* prev_symtable;
    string curr_class="";
    Helper* helper;
    int offset=0;
    SymbolTableBuilder(Helper* helper)
    {
        createValidTypes();
        createValidModifiers();
        curr_symtable=new SymbolTable();
        addprintmethods("STRING");
        addprintmethods("BOOLEAN");
        addprintmethods("CHAR");
        addprintmethods("INT");
        addprintmethods("LONG");
        addprintmethods("FLOAT");
        addprintmethods("DOUBLE");
        addemptyprint();
        prev_symtable=NULL;
        this->helper=helper;
    }

    void addprintmethods(string type)
    {
        SymbolEntry* entry = new SymbolEntry("IDENTIFIER", "println");
        entry->type_arguments={type};
        entry->no_arguments=1;
        entry->entry_type="method";
        addEntry(entry, 0);

        SymbolEntry* entry1 = new SymbolEntry("IDENTIFIER", "print");
        entry1->type_arguments={type};
        entry1->no_arguments=1;
        entry1->entry_type="method";
        addEntry(entry1,0);
    }

    int type_to_size(string type){
        if(type=="INT" || type=="FLOAT")
            return 4;
        else if(type=="DOUBLE" || type=="LONG")
            return 8;
        else if(type=="CHAR")
            return 1;
        else if(type=="BOOLEAN")
            return 1;
        else if(type=="VOID")
            return 0;
        return 4;
    }
    void addemptyprint()
    {
        SymbolEntry* entry = new SymbolEntry("IDENTIFIER", "println");
        entry->entry_type="method";
        addEntry(entry,0);

        SymbolEntry* entry1 = new SymbolEntry("IDENTIFIER", "print");
        entry1->entry_type="method";
        addEntry(entry1,0);
    }
    void addEntry(SymbolEntry* entry, int line_number)
    {
        assert(curr_symtable!=NULL);
        entry->size=type_to_size(entry->type);
        entry->line_number=line_number;
        if(entry->entry_type == "array")
            entry->size=8;
        if(entry->entry_type!="method"&& entry->entry_type!="class")
        {
            offset+=entry->size;
            entry->offset=offset;
        }
        curr_symtable->insert(entry);
    }
    void createValidTypes()
    {
        validtypes.insert("BYTE");
        validtypes.insert("SHORT");
        validtypes.insert("INT");
        validtypes.insert("LONG");
        validtypes.insert("CHAR");
        validtypes.insert("BOOLEAN");
        validtypes.insert("VOID");
        validtypes.insert("FLOAT");
        validtypes.insert("DOUBLE");
        validtypes.insert("VAR");
        validtypes.insert("STRING");
    }

    void createValidModifiers()
    {
        validmodifiers.insert("PUBLIC");
        validmodifiers.insert("PRIVATE");
        validmodifiers.insert("PROTECTED");
        validmodifiers.insert("ABSTRACT");
        validmodifiers.insert("FINAL");
        validmodifiers.insert("STATIC");
    }
    void build (Node* root)
    {
        if(root->val=="CompilationUnit")
        {
            // prev_symtable = curr_symtable;
            // curr_symtable = new SymbolTable(root->val);
            // curr_symtable -> setParent(prev_symtable);
            curr_symtable=root->symtable;
            curr_symtable->table_type="cunit";
            curr_symtable->line_number=root->lineno;

            for(auto child_node: root-> children)
            {
                build(child_node);                
            }
            assert(curr_symtable == root->symtable);

            // curr_symtable=root->symtable;
        }
        else if(root->val=="NormalClassDeclaration")
        {
            // prev_symtable = curr_symtable;
            // curr_symtable = new SymbolTable(root->val);
            // curr_symtable -> setParent(prev_symtable);
            curr_symtable=root->symtable;
            curr_symtable->table_type="class";
            curr_symtable->line_number=root->lineno;
            curr_class=curr_symtable->scope;
            ((curr_symtable->parent->entries)[curr_symtable->scope][0])->symtab = curr_symtable;
            // curr_symtable->children.clear();

            string identifier_class="";
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="IDENTIFIER")
                    identifier_class=child_node->identifier;
                       
            }

            assert(curr_symtable!=NULL);
            assert(curr_symtable == root->symtable);
            curr_symtable -> scope = identifier_class;
            curr_symtable = curr_symtable -> parent;

            // SymbolEntry* entry = new SymbolEntry("IDENTIFIER", identifier_class);
            // entry->type="class";
            // addEntry(entry, root->lineno);
            root->identifier=identifier_class;

            // curr_symtable=root->symtable;
        }
        else if(root->val=="MethodDeclaration"|| root->val=="ConstructorDeclaration")
        {
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable(root->val);
            curr_symtable->table_type="method";
            curr_symtable->line_number=root->lineno;
            offset=0;
            curr_symtable -> setParent(prev_symtable);

            string identifier_method="";
            string method_type="";
            int method_type_dims=0;
            vector<string> arguments_type;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="IDENTIFIER")
                    identifier_method=child_node->identifier;
                if(child_node->val=="MethodDeclarator"|| child_node->val=="ConstructorDeclarator")
                {
                    identifier_method=child_node->identifier;
                    arguments_type=child_node->arguments_type;
                }
                if(validtypes.find(child_node->lexeme)!=validtypes.end())
                    method_type= child_node->lexeme;
                if(child_node->val=="UnannReferenceType")
                {
                    method_type=child_node->type;
                    method_type_dims=child_node->dims;
                }
            }
            
            assert(curr_symtable!=NULL);
            curr_symtable -> scope = identifier_method;
            curr_symtable = curr_symtable -> parent;
            SymbolEntry* entry = helper->checkmethod(identifier_method, arguments_type,curr_symtable,root->lineno);
            if(entry)
            {
                entry -> offset = offset;
                root -> sym_entry= entry;
            }
            // SymbolEntry* entry = new SymbolEntry("IDENTIFIER", identifier_method);
            // entry->type=method_type;
            // entry->type_arguments=arguments_type;
            // entry->no_arguments=arguments_type.size();
            // entry->entry_type="method";
            // addEntry(entry, root->lineno);

            root->identifier=identifier_method;
            root->type = method_type;
        }
        else if(strcmp(root->val,"{")==0)
        {
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable("Block Line number "+to_string(root->lineno));
            curr_symtable -> setParent(prev_symtable);                
        }
        else if(strcmp(root->val,"}")==0)
        {
            assert(curr_symtable!=NULL);
            curr_symtable = curr_symtable -> parent;
        }
        else if(root->val=="MethodDeclarator"|| root->val=="ConstructorDeclarator" )
        {
            string identifier="";
            vector<string> arguments_type;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="IDENTIFIER")
                    identifier=child_node->identifier;
                if(child_node->val=="FormalParameter")
                    arguments_type.push_back(child_node->type);
            }
            root->identifier=identifier;
            root->arguments_type=arguments_type;
        }
        else if(root->val=="FormalParameter")
        {
            string identifier="";
            string parameter_type="";
            int parameter_type_dims= 0;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->val=="VariableDeclaratorId")
                {
                    identifier=child_node->identifier;
                    parameter_type_dims=child_node->dims;
                }
                if(validtypes.find(child_node->lexeme)!=validtypes.end())
                    parameter_type= child_node->lexeme;
                if(child_node->val=="UnannReferenceType")
                {
                    parameter_type=child_node->type;
                    parameter_type_dims=child_node->dims;
                }
            }
            root->type=parameter_type;
            root->dims=parameter_type_dims;

            SymbolEntry* entry = new SymbolEntry("IDENTIFIER", identifier);
            entry->type=parameter_type;
            if(parameter_type_dims>0)
            {
                entry->entry_type="array";
                entry->no_dimensions=root->dims;
                entry->token="ARRAY";
            }
            addEntry(entry, root->lineno);
            // root -> offset = entry -> offset;
            // offset = 0;
        }
        else if(root->val=="VariableDeclaratorId")
        {
            string identifier="";
            int variable_dims= 0;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="IDENTIFIER")
                    identifier=child_node->identifier;
                if(strcmp(child_node->val,"[]")==0)
                {
                    variable_dims++;
                }
            }
            root->identifier=identifier;
            root->dims=variable_dims;
        }
        else if(root->val=="FieldDeclaration" || root->val=="LocalVariableDeclaration")
        {
            string identifier="";
            string field_type="";
            SymbolTable* symtab= NULL;
            int field_type_dims= 0;
            bool new_used = false;
            // bool assign_used = false;
            vector<string> arguments_type;
            // string left_type="", right_type="";
            vector<tuple<string,int,string, bool>> identifier_type_list;
            vector<string> modifiers;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(validtypes.find(child_node->lexeme)!=validtypes.end())
                    field_type= child_node->lexeme;
                if(child_node->val=="UnannReferenceType")
                {
                    // left_type=child_node->type;
                    field_type=child_node->type;
                    field_type_dims=child_node->dims;
                }
                if(child_node->val=="VariableDeclaratorList"){
                    identifier_type_list=child_node->identifier_type_list;
                    if( child_node->expression_new_used )
                    {
                        new_used = true;
                    }
                    // assign_used = child_node->assign;
                    arguments_type = child_node->arguments_type; 
                }
                if(validmodifiers.find(child_node->lexeme)!=validmodifiers.end())
                    modifiers.push_back(child_node->lexeme);
            }
            if( arguments_type.size() > 0 ){
                if( ! helper->castit( arguments_type[0], field_type) ){
                    helper->throwerror("line number "+to_string(root->lineno)+": Incompatible conversion from "+arguments_type[0]+" to "+field_type);
                } else if( ! helper->castit( arguments_type[1], field_type) ){
                    helper->throwerror("line number "+to_string(root->lineno)+": Incompatible conversion from "+arguments_type[1]+" to "+field_type);
                } 
            }
            // want symboltable of class field_type for object invocation
            SymbolTable* temp = curr_symtable;
            auto m =temp->entries;
            while(temp)
            {
                m =temp->entries;
                if(m.find(field_type)!=m.end()) break;
                temp=temp->parent;
            }
            if(m.find(field_type)!=m.end()){
                vector<SymbolEntry*> entries = m[field_type];
                for( auto entry : entries ){
                    if( entry->type != "class" ) continue;
                    symtab = entry->symtab;
                    break;
                }
            }
            for(auto [ele_identifier, ele_dims,ele_type, ele_assign ]: identifier_type_list)
            {
                // cout << "1" << ele_identifier << " " << ele_type << " " << ele_assign << " " << field_type << ""<<new_used<<endl;
                // if( ele_type == field_type ) cout << "YES"<< endl;
                if(validtypes.find(field_type) == validtypes.end() )
                {
                    if(ele_type!=field_type && ele_assign ) helper->throwerror("Line number: " +to_string(root->lineno)+ " Type "+field_type+" doesn't match with "+ele_type);
                    SymbolEntry* entry = new SymbolEntry("OBJECT", ele_identifier);
                    entry->type=field_type;
                    entry->modifiers=modifiers;
                    entry->symtab = symtab;
                    if(ele_dims>0)
                    {
                        entry->entry_type="objectarray";
                        entry->no_dimensions=ele_dims;
                        // helper->checktypearrayacess(entry,field_type,root->lineno);
                        entry->token="OBJECTARRAY";
                    }
                    else 
                    {
                       if( not new_used )
                        {
                           helper->checktypevariable(entry,field_type,root->lineno);
                        }
                    }
                    if(root->val!="FieldDeclaration")
                        addEntry(entry, root->lineno);
                } 
                else 
                {   
                    if( !helper->castit(ele_type, field_type) )
                    {
                        if( ele_assign ) helper->throwerror("Line number "+to_string(root->lineno)+": Implicit Conversion not possible from "+ele_type+" to "+field_type);
                    }
                    SymbolEntry* entry = new SymbolEntry("IDENTIFIER", ele_identifier);
                    entry->type=field_type;
                    entry->modifiers=modifiers;
                    entry->symtab = symtab;
                    // cout << field_type << endl;
                    if(ele_dims>0)
                    {
                        entry->entry_type="array";
                        entry->no_dimensions=ele_dims;
                        // helper->checktypearrayacess(entry,field_type,root->lineno);
                        entry->token="ARRAY";
                    }
                    else 
                    {
                       if( not new_used )
                        {
                           helper->checktypevariable(entry,field_type,root->lineno);
                        }
                    }
                    if(root->val!="FieldDeclaration")
                        addEntry(entry, root->lineno);
                }
            }
        }
        else if( root->val == "UnannReferenceType" )
        {
            string type="";
            for(auto child_node: root-> children)
            {
                build(child_node); 
                // Nested class support is not mandatory
                if( child_node->token == "IDENTIFIER" )
                {
                    type = child_node->identifier;
                }
            }
            helper->checkclass( type, curr_symtable, root->lineno);
            root->type = type;
            // array of reference type not required to support.
            root->dims = 0;
        }
        else if(root->val=="VariableDeclaratorList")
        {
            vector<tuple<string,int,string,bool>> identifier_type_list;
            string type="";
            bool new_used = false;
            // bool assign_used = false;
            vector<string> arguments_type;
            for(auto child_node: root-> children)
            {
                build(child_node);       
                if(child_node->val=="VariableDeclaratorId")
                {
                    identifier_type_list.push_back({child_node->identifier,child_node->dims,"", false});
                }  
                if(strcmp(child_node->val,"=")==0)
                {
                    identifier_type_list.push_back({child_node->identifier,child_node->dims,child_node->type, true});
                    type=child_node->type;
                    if( child_node->expression_new_used )
                    {
                        new_used = true;
                    }
                    // assign_used = true;
                    if( child_node->arguments_type.size() > 0 )
                    {
                        arguments_type = child_node->arguments_type;
                    }
                    // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                }
            }
            if( new_used )
            {
                root->expression_new_used = true;
                // cout << get<0>(identifier_type_list[0]) <<" "<<get<1>(identifier_type_list[0]) << " "<< get<2>(identifier_type_list[0])<<endl; 
            }
            root->arguments_type = arguments_type;
            root->identifier_type_list=identifier_type_list;
            root->type=type;
            // root->assign = assign_used;
        }
        else if(strcmp(root->val,"=")==0)
        {
            string identifier1="";
            string righthand_type="", lefthand_type="";
            int variable_dims=0;
            int array_dims=0;
            int f=0;
            int righthand_dims=0;
            bool new_used = false;
            vector<string> arguments_type;
            for(auto child_node: root-> children)
            {
                build(child_node);    
                if(child_node->val=="VariableDeclaratorId")
                {
                    f=1;
                    identifier1=child_node->identifier;
                    variable_dims=child_node->dims;
                    // cout<<child_node->identifier<<" "<<child_node->dims<<endl;
                }            
                if(child_node->token=="IDENTIFIER")
                {
                    vector<SymbolEntry*> entry= helper->checkvariable(root->children[0]->lexeme,curr_symtable,root->lineno);
                    if(entry.size()>0)
                    {
                        child_node->type=entry[0]->type;
                    }
                    identifier1=child_node->identifier;
                }
                if(child_node->val=="Expression")
                {
                    righthand_type=child_node->type;
                    righthand_dims=child_node->dims;
                    if( child_node->arguments_type.size() > 0 )
                    {
                        // check for ?: operator
                        arguments_type = child_node->arguments_type;
                    }
                    if( child_node->expression_new_used )
                    {
                        new_used = true;
                    }
                    // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                }
                if(child_node->val=="ArrayAccess")
                {
                    identifier1=child_node->identifier;
                    array_dims=child_node->dims;
                    SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                    if(entry)
                    {
                        child_node->type=entry->type;
                    }
                }     
                if(child_node-> val == "FieldAccess" || child_node->val=="ExpressionName")
                {
                    identifier1=child_node->identifier;
                    lefthand_type=child_node->type;
                    f=2;
                }
            }
            if( new_used )
            {
                root->expression_new_used = true;
            }
            if(f==1)
            {
                root->identifier=identifier1;  
                root->dims=variable_dims; 
                root->type=righthand_type;
                // cout<<child_node->identifier<<" "<<child_node->dims<<endl;
                if(righthand_dims>0)
                {
                    if(variable_dims!=righthand_dims)
                    {
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Required array access dimensions as "+to_string(variable_dims)+" but found "+to_string(righthand_dims));
                    }
                }
                // cout << identifier1 << " " << root->type << endl;
            }
            else if(array_dims>0)
            {
                SymbolEntry* entry= helper->checkarray(identifier1,array_dims,curr_symtable,root->lineno);
                if(entry)
                {
                    bool check = helper->checktypearrayacess(entry,righthand_type, root->lineno);
                    if(check)
                        root->type=righthand_type;
                }
            }
            else if(f==2)
            {
                // cout<<"here 7 "<<endl;
                if( !helper->castit( righthand_type, lefthand_type) ) 
                {
                    helper->throwerror("Line number: "+to_string(root->lineno)+" Incorrect type conversion of Identifier '"+identifier1+"' declared as "+lefthand_type+" to type as "+ righthand_type);
                }
                // cout<<"here 8 "<<endl;
                root->type=lefthand_type;
            }
            else 
            {
                vector<SymbolEntry*> entry= helper->checkvariable(identifier1,curr_symtable,root->lineno);
                if(entry.size()>0)
                {
                    bool check = helper->checktypevariable(entry[0],righthand_type, root->lineno);
                    if(check)
                        root->type=righthand_type;
                }
            }
            root->arguments_type = arguments_type;
        }
        else if(root->val == "ForStatement")
        {
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable(root->val);
            curr_symtable -> setParent(prev_symtable);

            for(auto child_node: root-> children)
            {
                build(child_node);                
            }
            curr_symtable = curr_symtable -> parent;
        }
        else if(root->val == "Expression" || root->val  == "Statement")
        {
            string exp_type="";
            int dims=0;
            bool new_used = false;
            // bool definite_literal_used = true;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if( child_node->lexeme=="NEW")
                {
                    new_used = true;
                }    
                if(helper->isOperator(child_node->val))
                {
                    exp_type=child_node->type;
                    // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                }    
                if(child_node->token=="IDENTIFIER")
                {
                    vector<SymbolEntry*> entry= helper->checkvariable(child_node->identifier,curr_symtable,root->lineno);
                    if(entry.size()>0)
                    {
                        if( entry[0]->type == "class" ) exp_type=entry[0]->lexeme;
                        else exp_type=entry[0]->type;
                        child_node->type=exp_type;
                    }
                        
                    // child_node->definite_literal_used = false;
                }   
                if(child_node->token=="LITERAL")
                {
                    exp_type=child_node->type;
                    // cout << exp_type << endl;
                } 
                if(child_node->val=="ArrayAccess")
                {
                    SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                    if(entry)
                    {
                        exp_type=entry->type;
                        child_node->type=exp_type;
                    }
                    // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                }   
                if(child_node->val=="ArrayCreationExpression")
                {
                    exp_type=child_node->type;
                    dims=child_node->dims;
                    // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                } 
                if(child_node->val=="MethodInvocation")
                {
                    exp_type=child_node->type;
                    // cout << exp_type << endl;
                    // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                }
                if( child_node->val == "PreIncrementExpression" || child_node->val == "PostIncrementExpression" || child_node->val == "PreDecrementExpression" || child_node->val == "PostDecrementExpression" )
                {
                    exp_type = child_node->type;
                    // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                }
                if(child_node->val=="ExpressionName" || child_node->type=="FieldAccess")
                    exp_type=child_node->type;
                if( strcmp(child_node->val,"?:")==0 || strcmp(child_node->val,"||")==0 || strcmp(child_node->val,"&&")==0 || strcmp(child_node->val,"^")==0 || strcmp(child_node->val, "|")==0 || strcmp(child_node->val, "&")==0 || strcmp(child_node->val, "!=")==0 || strcmp(child_node->val, "==")==0 || strcmp(child_node->val, "<=")==0 || strcmp(child_node->val, ">=")==0 || strcmp(child_node->val, "<")==0 || strcmp(child_node->val,">")==0 || strcmp(child_node->val, "<<")==0 || strcmp(child_node->val, ">>")==0 || strcmp(child_node->val, ">>>")==0 || strcmp(child_node->val,"~")==0 || strcmp(child_node->val,"!")==0 || strcmp(child_node->val,"%")==0 )
                {
                    exp_type = child_node->type;
                    root->arguments_type = child_node->arguments_type;
                    // cout << "EXPERSSION " << exp_type << endl;
                    // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                }
                if( child_node->val == "Expression" )
                {
                    exp_type = child_node->type;
                    // cout << "EXPERSSION Expression " << exp_type << endl;
                    // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                }
                if(child_node->val == "UnqualifiedClassInstanceCreationExpression")
                {
                    exp_type = child_node->type;
                    new_used=true;
                }
            }
            if( new_used )
            {
                root->expression_new_used = true;
            }
            root->type=exp_type;
            root->dims=dims;
            // cout << root->expression_new_used << " " << exp_type << endl;
        }
        else if(root->val == "UnqualifiedClassInstanceCreationExpression")
        {
            string identifier="";
            vector<string> arguments_type;

            string exp_type="";
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(child_node->token=="IDENTIFIER")
                {
                    identifier=child_node->identifier;
                    
                }   
                if(child_node->val=="ArgumentList")
                {
                    arguments_type=child_node->arguments_type;
                }
            }
            root->expression_new_used = true;
            root->type=identifier;
            root->identifier=identifier;
            root->arguments_type=arguments_type;

            SymbolEntry* entry;
            if(arguments_type.size()>0)
                entry = helper->checkmethod(identifier,arguments_type, curr_symtable,root->lineno);
            else
                entry = helper->checkclass(identifier,curr_symtable,root->lineno);
            entry = helper->checkclass(identifier,curr_symtable,root->lineno);
            root->sym_entry=entry;
        }
        // else if( root->val == "Assignment" )
        // {
        //     for( auto child_node : root->children )
        //     {
        //         build(child_node);
        //         if( strcmp( root->val,"=")==0 )
        //         {
        //             // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
        //             ;
        //         }
        //     }
        // }
        else if( strcmp(root->val,"||")==0 || strcmp(root->val,"&&")==0 || strcmp(root->val,"^")==0 || strcmp(root->val, "|")==0 || strcmp(root->val, "&")==0 || strcmp(root->val, "!=")==0 || strcmp(root->val, "==")==0 || strcmp(root->val, ">=")==0 || strcmp(root->val, "<=")==0 || strcmp(root->val,">")==0 || strcmp(root->val,"<")==0 || strcmp(root->val, "<<")==0 || strcmp(root->val, ">>")==0 || strcmp(root->val, ">>>")==0 || strcmp(root->val,"+")==0 || strcmp(root->val,"-")==0 || strcmp(root->val,"*")==0 || strcmp(root->val,"/")==0 || strcmp(root->val,"%")==0 )
        {
            if( root->children.size() == 1 )
            {
                build(root->children[0]);
                string type = ""; // root->children[0]->type;
                if( root->children[0]->token == "IDENTIFIER" ){
                    vector<SymbolEntry*> entry= helper->checkvariable(root->children[0]->lexeme,curr_symtable,root->lineno);
                    if(entry.size()>0)
                    {
                        type=entry[0]->type;
                        root->children[0]->type=type;
                    }
                } 
                else 
                    type = root->children[0]->type;
                if( type == "CHAR" || type == "BYTE" || type == "SHORT" || type == "INT" || type == "LONG" || type == "FLOAT" || type == "DOUBLE" )
                {
                    root->type = type;
                } else {
                    helper->throwerror("Line number "+to_string(root->lineno)+": Numeric type expected with the unary operator");
                    root->type = type;
                }
                // if( root->children[0]->definite_literal_used == false ) root->definite_literal_used = false;
            } else {
                string type1="";
                string type2="";
                for(auto child_node: root-> children)
                {
                    build(child_node);   
                    if(child_node->token=="IDENTIFIER") 
                    { 
                        if(type1=="") 
                        { 
                            vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                            if(entry.size()>0)
                            {
                                type1=entry[0]->type;
                                child_node->type=type1;
                            }
                        }
                        else
                        {
                            vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                            if(entry.size()>0)
                            {
                                type2=entry[0]->type;
                                child_node->type=type2;
                            }
                                
                        }    
                        // child_node->definite_literal_used = false; 
                    }
                    if(child_node->val=="ArrayAccess")
                    {
                        SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                        if(entry)
                        {
                            if(type1=="")
                                type1=entry->type;
                            else
                                type2=entry->type;
                            child_node->type=entry->type;
                        }
                        // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                    }
                    if(helper->isOperator(child_node->val)|| child_node->val=="Expression"|| child_node->token=="LITERAL")
                    {
                        if(type1=="")
                            type1=child_node->type;
                        else
                            type2=child_node->type;
                        // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                    }   
                    if( child_node->val == "PreIncrementExpression" || child_node->val == "PostDecrementExpression" || child_node->val == "PreDecrementExpression" || child_node->val == "PostIncrementExpression" )
                    {
                        if(type1=="")
                            type1=child_node->type;
                        else
                            type2=child_node->type;
                        // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                    }
                    if( child_node->val == "MethodInvocation" ){
                        if(type1=="")
                            type1=child_node->type;
                        else
                            type2=child_node->type;
                    }
                }
                string type = helper->biggertype(type1,type2);
                if( strcmp(root->val,"/")==0 )
                {
                    if( type == "DOUBLE" || type == "FLOAT" || type == "STRING" || type == "" || type == "BOOLEAN" )
                    {
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible operation / on "+type1 + " and "+type2);
                    }
                }
                if( strcmp(root->val,"+")==0 )
                {
                    if( type == "" || type == "BOOLEAN" )
                    {
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible operation + on "+type1 + " and "+type2);
                    }
                }
                if( strcmp(root->val,"*")==0 )
                {
                    if( type == "STRING" || type == "" || type == "BOOLEAN" )
                    {
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible operation * on "+type1 + " and "+type2);
                    }
                }
                if( strcmp(root->val,"-")==0 )
                {
                    if( type == "STRING" || type == "" || type == "BOOLEAN" )
                    {
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible operation - on "+type1 + " and "+type2);
                    }
                }
                if( strcmp(root->val,"%")==0 )
                {
                    if( type == "STRING" || type == "" || type == "BOOLEAN" )
                    {
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible operation % on "+type1 + " and "+type2);
                    }
                }
                if( strcmp(root->val, "<<")==0 || strcmp(root->val, ">>")==0 || strcmp(root->val, ">>>")==0 )
                {
                    if( type1 == "" || type2 == "" || type1 == "STRING" || type2 == "STRING" || type1 == "FLOAT" || type1 == "DOUBLE" || type1 == "BOOLEAN" || type2 == "BOOLEAN" || type2 == "FLOAT" || type2 == "DOUBLE" )
                    {
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible shift operator on "+type1 + " and "+type2);
                    }
                    type = "INT";
                }
                if( strcmp(root->val, ">=")==0 || strcmp(root->val, "<=")==0 || strcmp(root->val,">")==0 || strcmp(root->val,"<")==0 )
                {
                    if( type1 == "" || type2 == "" || type1 == "STRING" || type2 == "STRING" || type1 == "BOOLEAN" || type2 == "BOOLEAN" )
                    {
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible relational operator on "+type1 + " and "+type2);
                    }
                    type = "BOOLEAN";
                }
                if( strcmp(root->val, "!=")==0 || strcmp(root->val, "==")==0 )
                {
                    if( ( not (type1 == "CHAR" || type1 == "BYTE" || type1 == "SHORT" || type1 == "INT" || type1 == "LONG" || type1 == "FLOAT" || type1 == "DOUBLE" ) || not (type2 == "CHAR" || type2 == "BYTE" || type2 == "SHORT" || type2 == "INT" || type2 == "LONG" || type2 == "FLOAT" || type2 == "DOUBLE" ) ) and (type1 != type2) ) 
                    {
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible relational operator on "+type1 + " and "+type2);
                    }
                    type = "BOOLEAN";
                }
                if( strcmp(root->val, "^")==0 || strcmp(root->val, "|")==0 || strcmp(root->val, "&")==0 )
                {
                    if( type1 == "BOOLEAN" and type2 == "BOOLEAN" ) type = "BOOLEAN";
                    else if( (type1 == "CHAR" || type1 == "BYTE" || type1 == "SHORT" || type1 == "INT" || type1 == "LONG") and (type2 == "CHAR" || type2 == "BYTE" || type2 == "SHORT" || type2 == "INT" || type2 == "LONG") ){
                        type = helper->biggertype(type1, type2);
                    } else {
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible bitwise operator on "+type1 + " and "+type2);
                    }
                }
                if(  strcmp(root->val,"||")==0 || strcmp(root->val,"&&")==0  )
                {
                    if( type1 == "BOOLEAN" and type2 == "BOOLEAN" ) type = "BOOLEAN";
                    else {
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible conditional operator on "+type1 + " and "+type2);
                    }
                }
                root->type = type;
                // cout << root->val << " " << type << " " << type1 << " " << type2 << endl;
                // cout << root->val << " " << type << " " << type1 << " " << type2 << endl;
            }
        }
        else if(strcmp(root->val,"?:")==0)
        {
            string type1 = "", type2 = "";
            int i = 1;
            int dims=0;
            bool new_used = false;
            vector<string> arguments_type; 
            for( auto child_node : root->children ){
                build(child_node);
                if( i == 1 )
                {
                    if( child_node->val == "Expression" )
                    {
                        // type = child_node->type;
                        if( child_node->type != "BOOLEAN" )
                        {
                            helper->throwerror("Line number "+to_string(root->lineno)+": Boolean type expected before ?.");
                        }
                    }
                } else if( i == 2 ){
                    if( child_node->val == "Expression" )
                    {
                        type1 = child_node->type ;
                        // cout << "1 1" << type1 << endl;
                    }
                } else if( i == 3 ){
                    if( child_node->lexeme=="NEW")
                    {
                        new_used = true;
                    }    
                    if(helper->isOperator(child_node->val))
                    {
                        type2=child_node->type;
                        // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                    }    
                    if(child_node->token=="IDENTIFIER")
                    {
                        vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                        if(entry.size()>0)
                        {
                            if( entry[0]->type == "class" ) type2=entry[0]->lexeme;
                            else type2=entry[0]->type;

                            child_node->type=entry[0]->type;
                        }
                            
                    // child_node->definite_literal_used = false;
                    }   
                    if(child_node->token=="LITERAL")
                    {
                        type2=child_node->type;
                        // cout << exp_type << endl;
                    } 
                    if(child_node->token=="ArrayAccess")
                    {
                        SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                        if(entry)
                        {
                            type2=entry->type;
                            child_node->type=type2;
                        }
                        // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                    }   
                    if(child_node->token=="ArrayCreationExpression")
                    {
                        type2=child_node->type;
                        dims=child_node->dims;
                        // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                    } 
                    if(child_node->val=="MethodInvocation")
                    {
                        type2=child_node->type;
                        // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                    }
                    if( child_node->val == "PreIncrementExpression" || child_node->val == "PostIncrementExpression" || child_node->val == "PreDecrementExpression" || child_node->val == "PostDecrementExpression" )
                    {
                        type2 = child_node->type;
                        // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                    }
                    if( strcmp(child_node->val,"||")==0 || strcmp(child_node->val,"&&")==0 || strcmp(child_node->val,"^")==0 || strcmp(child_node->val, "|")==0 || strcmp(child_node->val, "&")==0 || strcmp(child_node->val, "!=")==0 || strcmp(child_node->val, "==")==0 || strcmp(child_node->val, "<=")==0 || strcmp(child_node->val, ">=")==0 || strcmp(child_node->val, "<")==0 || strcmp(child_node->val,">")==0 || strcmp(child_node->val, "<<")==0 || strcmp(child_node->val, ">>")==0 || strcmp(child_node->val, ">>>")==0 || strcmp(child_node->val,"~")==0 || strcmp(child_node->val,"!")==0 || strcmp(child_node->val,"%")==0 )
                    {
                        type2 = child_node->type;
                        // cout << "EXPERSSION " << exp_type << endl;
                        // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                    }
                    if( child_node->val == "Expression" )
                    {
                        type2 = child_node->type;
                        // cout << "EXPERSSION Expression " << exp_type << endl;
                        // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                    }
                }
                i++;
            }
            if( new_used )
            {
                root->expression_new_used = true;
            }
            // root->dims=dims;
            // cout << type1 << " " << type2 << endl;
            arguments_type.push_back(type1);
            arguments_type.push_back(type2);
            root->type = helper->biggertype(type1, type2);
            root->arguments_type = arguments_type;

        }
        else if(strcmp(root->val,"~")==0)
        {
            string type = "";
            for( auto child_node : root->children )
            {   
                build(child_node);
                if( child_node->token == "IDENTIFIER" )
                {
                    vector<SymbolEntry*> entry = helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                    if(entry.size()>0)
                    {
                        type = entry[0]->type;
                        child_node->type=type;
                    }
                    
                    // else cout << "Sumbol Table not giving entry for variable. " << endl;
                    // cout << "Identifier " << type << endl;
                }
                if( child_node->token == "LITERAL" || child_node->token == "Expression" || child_node->val == "PreIncrementExpression" || child_node->val == "PostDecrementExpression" || child_node->val == "PreDecrementExpression" || child_node->val == "PostIncrementExpression" )
                {
                    type = child_node->type;
                }
                // cout<<type<<endl;
            }
            if( not (type == "CHAR" || type == "BYTE" || type == "SHORT" || type == "INT" || type == "LONG") )
            {
                helper->throwerror("Line number "+to_string(root->lineno)+": Primitive Integer type expected with the ~ unary operator");
            }
            root->type = type;
        }
        else if(strcmp(root->val,"!")==0)
        {
            string type = "";
            for( auto child_node : root->children )
            {   
                build(child_node);
                if( child_node->val == "IDENTIFIER" )
                {
                    vector<SymbolEntry*> entry = helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                    if(entry.size()>0)
                    type = entry[0]->type;
                }
                if( child_node->token == "LITERAL" || child_node->token == "Expression" || child_node->val == "PreIncrementExpression" || child_node->val == "PostDecrementExpression" || child_node->val == "PreDecrementExpression" || child_node->val == "PostIncrementExpression" )
                {
                    type = child_node->type;
                }
            }
            if( type != "BOOLEAN" )
            {
                helper->throwerror("Line number "+to_string(root->lineno)+": Boolean type expected with the ! unary operator");
            }
            root->type = type;
        }
        else if( helper->Assign_Operator(root->val) )
        {
            string type1="";
            string type2="";
            // For E1 and E2, E2 can be any value which can be Type casted( implicit or explicit) into E1.
            for( auto child_node : root->children )
            {
                build(child_node);
                if( child_node->token == "IDENTIFIER" )
                {
                    vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                    if(entry.size()>0)
                    {
                        type1=entry[0]->type;
                        child_node->type=type1;
                    }
                //    cout << "Identifier *= " << type1 << endl;
                }
                if( child_node->val == "ExpressionName" )
                {
                   type1=child_node->type;
                }
                if( child_node->val == "FieldAccess" )
                {
                   type1=child_node->type;
                }
                if( child_node->val == "ArrayAccess" )
                {
                    SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                    if(entry)
                    {
                        child_node->type=entry->type;
                    }
                    type1=child_node->type;
                }
                if( child_node->val == "Expression" )
                {
                    type2=child_node->type;
                }
            }
            // if( root->val == "=" and !castit( type2, type1) ){
            //     throwerror("Error: Incorrect type Conversion from "+type2+" to "+type1+" for assignment not possible.");
            // } else 
            if( type1 == "BOOLEAN" || type2 == "BOOLEAN" )
            {
                string opr = root->val;
                helper->throwerror("Line Number: "+to_string(root->lineno)+" Incorrect type conversion from "+type2+" to "+type1);
            }
        }
        else if( root->val == "PreIncrementExpression" || root->val == "PostDecrementExpression" || root->val == "PreDecrementExpression" || root->val == "PostIncrementExpression" )
        {
            bool isIdentifier = false;
            string type="";
            for( auto child_node : root->children )
            {
                build(child_node);
                if( child_node->token == "IDENTIFIER" )
                {
                    vector<SymbolEntry*> entries = helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                    if(entries.size()==0 ) continue; // check for NULL 
                    for( auto entry : entries )
                    {
                        if( entry->entry_type == "variable" )
                        {
                            type = entries[0]->type;
                            isIdentifier = true;
                            child_node->type=type;
                        }  
                    }
                }
            }
            if( isIdentifier )
            {
                if( not ( type == "CHAR" || type == "BYTE" || type == "SHORT" || type == "INT" || type == "FLOAT" || type == "LONG" || type == "DOUBLE") )
                {
                    helper->throwerror("Line number "+to_string(root->lineno)+": only numeric type variable expected with the given unary operator");
                }
            } 
            else
            {
                helper->throwerror("Line number "+to_string(root->lineno)+": variable expected with the given unary operator");
            }
            // cout << "PostIncrementExpression " << type << endl;
            root->type = type;
        }
        // else if(helper->isUnaryOperator(root->val))
        // {
        //     string type1="";
        //     string type2="";
        //     for(auto child_node: root-> children)
        //     {
        //         build(child_node);   
        //         if(child_node->token=="IDENTIFIER")
        //         {
        //             if(type1=="")
        //             {
        //                 vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
        //                 if(entry[0])
        //                     type1=entry[0]->type;
        //             }
        //             else
        //             {
        //                 vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
        //                 if(entry[0])
        //                     type2=entry[0]->type;
        //             }     
        //         }
        //         if(child_node->val=="ArrayAccess")
        //         {
        //             SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
        //             if(entry)
        //             {
        //                 if(type1=="")
        //                     type1=entry->type;
        //                 else
        //                     type2=entry->type;
        //             }
        //         }
        //         if(helper->isOperator(child_node->val)|| child_node->val=="Expression"|| child_node->token=="LITERAL")
        //         {
        //             if(type1=="")
        //                 type1=child_node->type;
        //             else
        //                 type2=child_node->type;
        //         }   
        //     }
        //     if(!helper->castit(type1,type2))
        //     {
        //         helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible types i.e. conversion from "+type1 + " to "+type2);
        //     }
        //     root->type=type1;
        // }
        // else if(helper->isOperator(root->val))
        // {
        //     string type1="";
        //     string type2="";
        //     for(auto child_node: root-> children)
        //     {
        //         build(child_node);   
        //         if(child_node->token=="IDENTIFIER")
        //         {
        //             if(type1=="")
        //             {
        //                 vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
        //                 if(entry[0])
        //                     type1=entry[0]->type;
        //             }
        //             else
        //             {
        //                 vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
        //                 if(entry[0])
        //                     type2=entry[0]->type;
        //             }     
        //         }
        //         if(child_node->val=="ArrayAccess")
        //         {
        //             SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
        //             if(entry)
        //             {
        //                 if(type1=="")
        //                     type1=entry->type;
        //                 else
        //                     type2=entry->type;
        //             }
        //         }
        //         if(helper->isOperator(child_node->val)|| child_node->val=="Expression"|| child_node->token=="LITERAL")
        //         {
        //             if(type1=="")
        //                 type1=child_node->type;
        //             else
        //                 type2=child_node->type;
        //         }   
        //     }
        //     if( root->children.size() == 1 )
        //     {
        //         type2 = type1;
        //     }
        //     if(!helper->castit(type1,type2))
        //     {
        //         helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible types i.e. conversion from "+type1 + " to "+type2);
        //     }
        // }
        else if(root->val=="ArrayAccess")
        {
            string identifier="";
            int array_dims= 0;
            string type="";
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="IDENTIFIER")
                {
                    identifier=child_node->identifier;
                    // vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                    // if(entry.size()>0)
                    // {
                    //     type=entry[0]->type;
                    //     child_node->type=type;
                    // }
                }
                if(child_node->val=="Expression")
                {
                    array_dims++;
                    bool ans = helper->typecast(child_node,"INT");
                    if(!ans)
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incorrect type in array access expression");
                }
                if(child_node->val=="ArrayAccess")
                {
                    identifier=child_node->identifier;
                    array_dims+=child_node->dims;
                }
            }
            root->identifier=identifier;
            root->dims=array_dims;
        }
        else if(root->val=="ArrayCreationExpression")
        {
            string array_type="";
            int type_dims=0;
            int variable_dims = 0;
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(validtypes.find(child_node->lexeme)!=validtypes.end())
                    array_type= child_node->lexeme;
                if(child_node->val=="UnannReferenceType")
                {
                    array_type=child_node->type;
                    type_dims=child_node->dims;
                }
                if(child_node->val=="DimExprs")
                {
                    variable_dims += child_node->dims;    
                }
                if(child_node->val=="[]")
                {
                    variable_dims++;    
                }
            }
            root->type=array_type;
            root->dims=variable_dims;
        }
        else if(root->val=="DimExprs")
        {
            int variable_dims = 0;
            for(auto child_node: root-> children)
            {
                build(child_node);
                if(child_node->val=="Expression")
                {
                    bool ans = helper->typecast(child_node,"INT");
                    variable_dims++;
                    if(!ans)
                        helper->throwerror("Line number: "+to_string(root->lineno)+" Incorrect type in dimensions specification expression");
                }
                if(child_node->val=="DimExprs")
                {
                    variable_dims+=child_node->dims;
                }
            }
            root->dims = variable_dims;
        }
        else if(root->val=="MethodInvocation")
        {
            if(root->children[0]->val=="." && (root->children[0]->children[1]->identifier=="println" || root->children[0]->children[1]->identifier=="print"))
            {
                if(root->children[0]->children[0]->children.size()>0 && root->children[0]->children[0]->children[0]->val=="." )
                {
                    // cout<<"here 2"<<endl;
                    Node* x=root->children[0]->children[0]->children[0];
                    if(x->children[0]->identifier=="System" && x->children[1]->identifier=="out")
                    {
                        // cout<<"here 1"<<endl;
                        if(root->children[0]->children[3]->arguments_type.size()>=2)
                            helper->throwerror("Line number: "+to_string(root->lineno)+" Incorrect number of arguments in print function call");
                        if(root->children[0]->children[1]->identifier=="println")
                        {
                            root->children[0]->identifier="System.out.println";
                            root->identifier ="System.out.println";
                        }
                        else
                        {
                            root->children[0]->identifier="System.out.print";
                            root->identifier ="System.out.print";
                        }
                        
                        build(root->children[0]->children[3]);
                        return;
                    }
                }
            }
            string identifier="";
            vector<string> arguments_type;
            int dot_flag=0;
            for(auto child_node: root-> children)
            {
                build(child_node);       
                if(child_node->token=="IDENTIFIER")
                {
                    identifier=child_node->identifier;
                }  
                if(child_node->val=="ArgumentList")
                {
                    arguments_type=child_node->arguments_type;
                }
                if(child_node->val==".")
                {
                    dot_flag=1;
                    root->identifier=child_node->identifier;
                    root->type=child_node->type;
                }
            }
            if(dot_flag)
                return;
            root->identifier=identifier;
            root->arguments_type=arguments_type;
            SymbolEntry* entry = helper->checkmethod(identifier,arguments_type,curr_symtable,root->lineno);
            if(entry)
                root->type=entry->type;
        }
        else if(root->val=="ArgumentList")
        {
            vector<string> arguments_type;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if( child_node->val=="Expression")
                {
                    arguments_type.push_back(child_node->type);
                }
                // if(child_node->val=="ArgumentList"){
                //     arguments_type.insert(arguments_type.end(),child_node->arguments_type.begin(),child_node->arguments_type.end());
                // }
            }
            root->arguments_type=arguments_type;
        }
        else if(root->val == ".")
        {
            string exp_type="";
            // cout<<"here4"<<endl;
            for(auto child_node: root-> children)
            {
                build(child_node);    
            }
            if(root->children.size()==2)
            {
                Node* left_node=root->children[0];
                Node* right_node=root->children[1];

                // cout<<"here\n";
                // cout<<left_node->identifier<<" "<<right_node->identifier<<" "<<root->lineno<< endl;
                string object_type="";
                
                string class_name=left_node->identifier;
                if(class_name.length()>=5 && class_name.substr(class_name.length()-4,4)=="this")
                    object_type=class_name;
                else
                {
                    vector<SymbolEntry*> entries= helper->checkvariable(left_node->identifier,curr_symtable,root->lineno);
                    if(entries.size()>0)
                    {
                        object_type=entries[0]->type;
                        left_node->type=object_type;
                    }
                    // vector<SymbolEntry*> modifier_entries = curr_symtable->lookup(left_node->lexeme); // symtable->display();
                    // if(modifier_entries.size()==0)
                    //     modifier_entries = curr_symtable->lookupclass(left_node->lexeme);
                    // assert(modifier_entries.size()>0);
                    // assert(modifier_entries[0]->symtab != NULL);
                    // vector<SymbolEntry*> ents = modifier_entries[0]->symtab->entries[right_node->lexeme];
                    // assert(ents.size()>0);
                    // for( auto modifier : ents[0]->modifiers ){
                    //     if( modifier == "PRIVATE" ) helper->throwerror("Line number: "+to_string(root->lineno)+" Variable declared as private cannot be accessed outside the class.");
                    // }
                }
                SymbolEntry* entry= helper->checkfieldaccess(object_type,right_node->identifier,curr_symtable,root->lineno);
                if(entry)
                    exp_type=entry->type;
                // cout<<"here2 "<< exp_type<<endl;
                root->type=exp_type;
                // root->identifier=left_node->identifier + "." + right_node->identifier;
                root->identifier=left_node->identifier;

            }
            else
            {
                // cout<<"here"<<endl;
                Node* left_node=root->children[0];
                Node* right_node=root->children[1];
                Node* arguments=root->children[3];
                vector<string> arguments_type;
                // cout<<"here2"<<endl;
                if(arguments!=NULL)
                    arguments_type=arguments->arguments_type;

                string object_type="";
                string class_name=left_node->identifier;
                if(class_name.length()>=5 && class_name.substr(class_name.length()-4,4)=="this")
                    object_type=class_name;
                else
                {
                    vector<SymbolEntry*> entries= helper->checkvariable(left_node->identifier,curr_symtable,root->lineno);
                    if(entries.size()>0)
                    {
                        object_type=entries[0]->type;
                        left_node->type=object_type;
                    }
                    // vector<SymbolEntry*> modifier_entries = curr_symtable->lookup(left_node->lexeme);
                    // if(modifier_entries.size()==0)
                    //     modifier_entries = curr_symtable->lookupclass(left_node->lexeme);
                    // assert(modifier_entries.size()>0);
                    // assert(modifier_entries[0]->symtab != NULL);
                    // vector<SymbolEntry*> ents = modifier_entries[0]->symtab->entries[right_node->lexeme];
                    // assert(ents.size()>0);
                    // for( auto modifier : ents[0]->modifiers ){
                    //     if( modifier == "PRIVATE" ) helper->throwerror("Line number: "+to_string(root->lineno)+" Method declared as private cannot be accessed outside the class.");
                    // }
                }
                // cout<<"here3"<<endl;
                SymbolEntry* entry= helper->checkmethodaccess(object_type,right_node->identifier,arguments_type,curr_symtable,root->lineno);
                if(entry)
                    exp_type=entry->type;
                // cout<<"here2 "<< exp_type<<endl;
                root->type=exp_type;
                // root->identifier=left_node->identifier + "." + right_node->identifier;
                root->identifier=left_node->identifier;    
                root->arguments_type=arguments_type;        
            }
            // cout<<root->identifier<<endl;
        }
        else if(root->val=="FieldAccess" || root->val == "ExpressionName")
        {
            Node* node=root->children[0];

            for(auto child_node: root-> children)
            {
                build(child_node);    
            }
            root->type=node->type;
            root->identifier=node->identifier;

            // cout<<"here1 "<<root->identifier<<endl;
        }
        else if(root->token=="IDENTIFIER")  
        {
            root->identifier=root->lexeme;
        }
        else if(strcmp(root->val,"THIS")==0)
        {
            root->identifier=curr_class+".this";
            root->token="IDENTIFIER";
            root->lexeme=curr_class+".this";
        }
        else
        {
            for(auto child_node: root-> children)
            {
                build(child_node);                
            }
        }
        root->symtable=curr_symtable;
    }
};