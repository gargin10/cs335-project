#pragma once

#include "SymbolEntry.cpp"
#include "SymbolTable.cpp"
#include "helper.cpp"
#include "3AC.cpp"

#include <map>
#include <iostream>
#include <cstdio>
using namespace std;

class SymbolTableBuilder1 {

public:
    set<string> validtypes;
    set<string> validmodifiers;
    SymbolTable* curr_symtable;
    SymbolTable* prev_symtable;
    Helper* helper;
    int offset=0, class_offset = 0;
    SymbolTableBuilder1(Helper* helper)
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
        if(entry->type != "class")
            entry->size=type_to_size(entry->type);
        entry->line_number=line_number;
        if(entry->entry_type == "array")
            entry->size=8;
        if(entry->entry_type!="method"&& entry->type!="class")
        {
            class_offset+=entry->size;
            entry->offset=class_offset;
        }
        // if(entry->type=="class" || entry->entry_type != "method")
        //     cout<<entry->lexeme<<" "<<entry->offset<<" "<<entry->size<<endl;
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
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable(root->val);
            // offset=0;
            curr_symtable -> setParent(prev_symtable);
            root->symtable=curr_symtable;
            for(auto child_node: root-> children)
            {
                build(child_node);                
            }
            // curr_symtable->children.clear();
        }
        else if(root->val=="NormalClassDeclaration")
        {

            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable(root->val);
            class_offset=0;
            curr_symtable -> setParent(prev_symtable);
            root->symtable=curr_symtable;
            SymbolTable *thissymtable = curr_symtable;

            string identifier_class="";
            vector<string> modifiers;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="IDENTIFIER")
                    identifier_class=child_node->lexeme;
                if(validmodifiers.find(child_node->val)!=validmodifiers.end())
                    modifiers.push_back(child_node->val);
            }
            curr_symtable->children.clear();

            assert(curr_symtable!=NULL);
            curr_symtable -> scope = identifier_class;
            helper->class_fields[curr_symtable->scope]=curr_symtable;
            helper->class_methods[curr_symtable->scope]=curr_symtable;
            curr_symtable = curr_symtable -> parent;
            
            SymbolEntry* entry = new SymbolEntry("CLASS", identifier_class);
            entry->type="class";
            entry->modifiers=modifiers;
            entry->size=class_offset;
            entry->offset=class_offset;
            addEntry(entry, root->lineno);
            root->identifier=identifier_class;
        }
        else if(root->val=="MethodDeclaration"|| root->val=="ConstructorDeclaration")
        {
            prev_symtable = curr_symtable;
            curr_symtable = new SymbolTable(root->val);
            // offset=0;
            curr_symtable -> setParent(prev_symtable);

            string identifier_method="";
            string method_type="";
            int method_type_dims=0;
            vector<string> arguments_type;
            vector<string> modifiers;
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
                if(validmodifiers.find(child_node->lexeme)!=validmodifiers.end())
                    modifiers.push_back(child_node->lexeme);
            }
            
            assert(curr_symtable!=NULL);
            curr_symtable -> scope = identifier_method;
            curr_symtable = curr_symtable -> parent;

            SymbolEntry* entry = new SymbolEntry("METHOD", identifier_method);
            entry->type=method_type;
            entry->type_arguments=arguments_type;
            entry->no_arguments=arguments_type.size();
            entry->entry_type="method";
            entry->modifiers=modifiers;
            addEntry(entry, root->lineno);

            root->identifier=identifier_method;
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
            // addEntry(entry, root->lineno);
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
                if( validmodifiers.find(child_node->lexeme)!=validmodifiers.end() ){
                    modifiers.push_back(child_node->lexeme);
                }
            }
            // if( arguments_type.size() > 0 ){
            //     if( ! helper->castit( arguments_type[0], field_type) ){
            //         helper->throwerror("line number "+to_string(root->lineno)+": Incompatible conversion from "+arguments_type[0]+" to "+field_type);
            //     } else if( ! helper->castit( arguments_type[1], field_type) ){
            //         helper->throwerror("line number "+to_string(root->lineno)+": Incompatible conversion from "+arguments_type[1]+" to "+field_type);
            //     } 
            // }
            for(auto [ele_identifier, ele_dims,ele_type, ele_assign ]: identifier_type_list)
            {
                if( field_type != ele_type and validtypes.find(field_type) == validtypes.end() )
                {
                    // if( ele_assign ) helper->throwerror("Line number: " +to_string(root->lineno)+ " Type "+field_type+" doesn't match with "+ele_type);
                } 
                else 
                {   
                    if( !helper->castit(ele_type, field_type) )
                    {
                        // if( ele_assign ) helper->throwerror("Line number "+to_string(root->lineno)+": Implicit Conversion not possible from "+ele_type+" to "+field_type);
                    }
                    SymbolEntry* entry = new SymbolEntry("IDENTIFIER", ele_identifier);
                    entry->type=field_type;
                    entry->modifiers=modifiers;
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
                        //    helper->checktypevariable(entry,field_type,root->lineno);
                        }
                    }
                    if(root->val == "FieldDeclaration")
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
                    type = child_node->lexeme;
                }
            }
            // if( !helper->checkclass( type, curr_symtable) )
            // {
            //     helper->throwerror("Line number: "+to_string(root->lineno)+" No Reference Type "+type+" found.");
            // }
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
                        // helper->throwerror("Line number: "+to_string(root->lineno)+" Required array access dimensions as "+to_string(variable_dims)+" but found "+to_string(righthand_dims));
                    }
                }
            }
            else if(array_dims>0)
            {
                // SymbolEntry* entry= helper->checkarray(identifier1,array_dims,curr_symtable,root->lineno);
                // if(entry)
                // {
                //     bool check = helper->checktypearrayacess(entry,righthand_type, root->lineno);
                //     if(check)
                //         root->type=righthand_type;
                // }
            }
            else if(f==2)
            {
                // cout<<"here 7 "<<endl;
                // if( !helper->castit( righthand_type, lefthand_type) ) 
                // {
                //     helper->throwerror("Line number: "+to_string(root->lineno)+" Incorrect type conversion of Identifier '"+identifier1+"' declared as "+lefthand_type+" to type as "+ righthand_type);
                // }
                // cout<<"here 8 "<<endl;
                root->type=lefthand_type;
            }
            else
            {
                // vector<SymbolEntry*> entry= helper->checkvariable(identifier1,curr_symtable,root->lineno);
                // if(entry[0])
                // {
                //     bool check = helper->checktypevariable(entry[0],righthand_type, root->lineno);
                //     if(check)
                //         root->type=righthand_type;
                // }
            }
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
                }    
                if(child_node->token=="IDENTIFIER")
                {
                    // vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                    // if(entry[0])
                    //     if( entry[0]->type == "class" ) exp_type=entry[0]->lexeme;
                    //     else exp_type=entry[0]->type;
                }   
                if(child_node->token=="LITERAL")
                {
                    exp_type=child_node->type;
                } 
                if(child_node->val=="ArrayAccess")
                {
                    // SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                    // if(entry)
                    // {
                    //     exp_type=entry->type;
                    // }
                    // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                }   
                if(child_node->val=="ArrayCreationExpression")
                {
                    exp_type=child_node->type;
                    dims=child_node->dims;
                } 
                if(child_node->val=="MethodInvocation")
                    exp_type=child_node->type;
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
                    // cout << "EXPERSSION " << exp_type << endl;
                    // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                }
                if( child_node->val == "Expression" )
                {
                    exp_type = child_node->type;
                    // cout << "EXPERSSION Expression " << exp_type << endl;
                    // if( child_node->definite_literal_used == false ) root->definite_literal_used = false;
                }
            }
            if( new_used )
            {
                root->expression_new_used = true;
            }
            root->type=exp_type;
            root->dims=dims;
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
                   type1=child_node->type;
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
                // helper->throwerror("Line Number: "+to_string(root->lineno)+" Incorrect type conversion from "+type2+" to "+type1);
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
                    vector<SymbolEntry*> entries = curr_symtable->lookup(child_node->lexeme);
                    for( auto entry : entries )
                    {
                        if( entry->entry_type == "variable" )
                        {
                            type = entries[0]->type;
                            isIdentifier = true;
                        }  
                    }
                }
            }
            if( isIdentifier )
            {
                if( type == "CHAR" || type == "BYTE" || type == "SHORT" || type == "INT" || type == "FLOAT" || type == "LONG" || type == "DOUBLE" )
                {
                    ;
                }
                else 
                {
                    // helper->throwerror("Line number "+to_string(root->lineno)+": only numeric type variable expected with the given unary operator");
                }
            } 
            else
            {
                // helper->throwerror("Line number "+to_string(root->lineno)+": variable expected with the given unary operator");
            }
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
        else if(helper->isOperator(root->val))
        {
            string type1="";
            string type2="";
            for(auto child_node: root-> children)
            {
                build(child_node);   
                if(child_node->token=="IDENTIFIER")
                {
                    if(type1=="")
                    {
                        // vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                        // if(entry[0])
                        //     type1=entry[0]->type;
                    }
                    else
                    {
                        // vector<SymbolEntry*> entry= helper->checkvariable(child_node->lexeme,curr_symtable,root->lineno);
                        // if(entry[0])
                        //     type2=entry[0]->type;
                    }     
                }
                if(child_node->val=="ArrayAccess")
                {
                    // SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                    // if(entry)
                    // {
                    //     if(type1=="")
                    //         type1=entry->type;
                    //     else
                    //         type2=entry->type;
                    // } // SymbolEntry* entry= helper->checkarray(child_node->identifier,child_node->dims,curr_symtable,root->lineno);
                    // if(entry)
                    // {
                    //     if(type1=="")
                    //         type1=entry->type;
                    //     else
                    //         type2=entry->type;
                    // }
                }
                if(helper->isOperator(child_node->val))
                {
                    if(type1=="")
                        type1=child_node->type;
                    else
                        type2=child_node->type;
                }   
                if(child_node->val=="Expression")
                {
                    if(type1=="")
                    {
                        type1=child_node->type;
                    }
                    else
                    {
                        type2=child_node->type;
                    }
                }  
                if(child_node->token=="LITERAL")
                {
                    if(type1=="")
                    {
                        type1=child_node->type;
                    }
                    else
                    {
                        type2=child_node->type;
                    }
                }  
            }
            if( root->children.size() == 1 )
            {
                type2 = type1;
            }
            if(!helper->castit(type1,type2))
            {
                // helper->throwerror("Line number: "+to_string(root->lineno)+" Incompatible types i.e. conversion from "+type1 + " to "+type2);
            }
            root->type=type1;
        }
        else if(root->val=="ArrayAccess")
        {
            string identifier="";
            int array_dims= 0;
            for(auto child_node: root-> children)
            {
                build(child_node);  
                if(child_node->token=="IDENTIFIER")
                    identifier=child_node->identifier;
                if(child_node->val=="Expression")
                {
                    array_dims++;
                    bool ans = helper->typecast(child_node,"INT");
                    // if(!ans)
                    //     helper->throwerror("Line number: "+to_string(root->lineno)+" Incorrect type in array access expression");
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
                    // if(!ans)
                    //     helper->throwerror("Line number: "+to_string(root->lineno)+" Incorrect type in dimensions specification expression");
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
            // SymbolEntry* entry = helper->checkmethod(identifier,arguments_type,curr_symtable,root->lineno);
            // if(entry)
            //     root->type=entry->type;
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
                if(child_node->val=="ArgumentList"){
                    arguments_type.insert(arguments_type.end(),child_node->arguments_type.begin(),child_node->arguments_type.end());
                }
            }
            root->arguments_type=arguments_type;
        }
        else if(root->token=="IDENTIFIER")
        {
            root->identifier=root->lexeme;
        }
        else
        {
            for(auto child_node: root-> children)
            {
                build(child_node);                
            }
        }
        // root->symtable=curr_symtable;
    }
};