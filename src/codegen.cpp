#include"codegen_helper.cpp"
#include"3AC_generator.cpp"
#include"AST.cpp"

int univ_counter = 0;

class CodeGenerator {

public:
    // SymbolTable* curr_symtable;
    map<string, set<pair<string, SymbolEntry*>>> reg_desc; // register descriptio
    map<SymbolEntry*, set<string>> addr_desc;   // address description of a variable
    map<string, set<string>> address_descriptor;
    int func_total_offset = -1; // The total offset for local variables in function.
    int func_curr_offset = -1; // The current offset being specified for local variables at the time of going through the function.
    string latest_conditional_op = "";
    ofstream asm_out;
    int no_callee_params;
    int no_caller_params;
    int callee_params_offset;
    CodeGenerator(string filename) {
        no_callee_params=0;
        no_caller_params = 0;
        callee_params_offset = 0;
        asm_out.open(filename,ios::out | std::ofstream::trunc);
    }

    int digit(){
        return ++univ_counter;
    }

    string get_arg_reg()
    {
        if(no_callee_params == 1)
            return "%rdi";
        else if(no_callee_params == 2)
            return "%rsi";
        else if(no_callee_params == 3)
            return "%rdx";
        else if(no_callee_params == 4)
            return "%rcx";
        else if(no_callee_params == 5)
            return "%r8";
        else if(no_callee_params == 6)
            return "%r9";
        else 
            return "stack";
    }
    void generate (Node* root)
    {
        asm_out << "\t" << ".text" << endl;
        for(auto entry: root->code_entries)
        {
            if(entry->type == "")
                assign_op(entry);
            else if(entry->type == "funcdecl"){
                // address_descriptor.clear();
                func_decl(entry);
                func_total_offset = func_offset[entry->arg1.first];
                func_curr_offset = func_total_offset;
            } else if(entry->type == "funcend"){
                func_end(entry);
                address_descriptor.clear();
            } else if(entry -> type == "funcparam")
                func_param(entry);
            else if(entry->type == "label")
                asm_out << entry->arg1.first << ": " << endl;
            else if(entry->type == "if"){
                branch_if( entry);
            } else if( entry->type == "goto" ){
                branch_goto(entry);
            }
        }
    }
    void func_decl(ThreeAddressCodeEntry* entry)
    {
        asm_out << "\t" << ".globl  " << entry->arg1.first << endl;
        asm_out << "\t" << ".type   " << entry->arg1.first << ", @function"<< endl;
        asm_out << entry->arg1.first << ": " << endl;
        asm_out << "\t" << "endbr64" << endl;
        asm_out << "\t" << "pushq   %rbp" << endl;
        asm_out << "\t" << "movq    %rsp, %rbp" <<endl;
        no_callee_params=0;
    }

    void func_param(ThreeAddressCodeEntry* entry)
    {
        // no_callee_params++;
        // string src = get_arg_reg();
        // int stack_offset = entry->arg1.second->offset;
        // string dest = "-" +to_string( stack_offset )+ "(%rbp)";
        // asm_out << "\t" << "movq    " << src << ", "<< dest << endl;
        // reg_desc["get_arg_reg"].insert(entry->arg1);
        // addr_desc[entry->arg1.second].insert(dest);
    }

    void func_end(ThreeAddressCodeEntry* entry)
    {
        if( entry->arg2.first == "VOID" ){
            asm_out << "\t" << "nop" << endl;
        } else {
            asm_out << "\t" << "movq    $0, %rax" << endl;
        }
        asm_out << "\t" << "movq    %rbp, %rsp" << endl;
        asm_out << "\t" << "popq    %rbp" << endl;
        // asm_out << "\t" << "leave" << endl;
        asm_out << "\t" << "ret" << endl;
    }

    void assign_op(ThreeAddressCodeEntry* entry)
    {
        if( entry->arg2.first == "load" || entry->arg2.first == "basepointer" || entry->arg2.first == "stackpointer" ) return;
        // cout << " You are inside assign" << endl; 
        if( entry->arg3.first == "" ){
            string arg1 = getaddr("arg1", entry, address_descriptor, func_total_offset, func_curr_offset);
            string arg2 = getaddr("arg2", entry, address_descriptor, func_total_offset, func_curr_offset);
            // int stack_offset = entry->arg1.second->offset;
            // string dest = "-" +to_string( stack_offset )+ "(%rbp)";
            if( !check_literal(entry->arg1.first) and !check_literal(entry->arg2.first) ){
                asm_out << "\t" << "movl    " << arg2 << ", %eax" << endl;
                asm_out << "\t" << "movl    " << "%eax, " << arg1 << endl;
            } else {
                asm_out << "\t" << "movl    " << arg2 << ", " << arg1 << endl;  
            }
        } else {
            if( entry->arg2.first == "-" ){
                string arg1 = getaddr("arg1", entry, address_descriptor, func_total_offset, func_curr_offset);
                if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                    address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                    func_curr_offset -= 4;
                }
                string arg3 = getaddr("arg3", entry, address_descriptor, func_total_offset, func_curr_offset);
                asm_out << "\t" << "movl    " << arg3 << ", %edx" << endl;
                asm_out << "\t" << "negl    " << "%edx" << endl;
                asm_out << "\t" << "movl    " << "%edx, " << arg1 << endl;
            } else if( entry->arg2.first == "~" ){
                string arg1 = getaddr("arg1", entry, address_descriptor, func_total_offset, func_curr_offset);
                if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                    address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                    func_curr_offset -= 4;
                }
                string arg3 = getaddr("arg3", entry, address_descriptor, func_total_offset, func_curr_offset);
                asm_out << "\t" << "movl    " << arg3 << ", %edx" << endl;
                asm_out << "\t" << "notl    " << "%edx" << endl;
                asm_out << "\t" << "movl    " << "%edx, " << arg1 << endl;
            } else {
                string arg2 = getaddr("arg2", entry, address_descriptor, func_total_offset, func_curr_offset);
                string arg4 = getaddr("arg4", entry, address_descriptor, func_total_offset, func_curr_offset);
                string reg1 = "%edx";
                string reg2 = "%eax";
                asm_out << "\t" << "movl    " << arg2 << ", " << reg1 << endl;
                if( entry->arg3.first == "<<" ){
                    asm_out << "\t" << "sall    " << arg4 << ", " << reg1 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg1 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == ">>" ){
                    asm_out << "\t" << "sarl    " << arg4 << ", " << reg1 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg1 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == "+" ){
                    asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                    asm_out << "\t" << "addl    " << reg1 << ", " << reg2 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg2 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == "-" ){
                    asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                    asm_out << "\t" << "subl    " << reg1 << ", " << reg2 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg2 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == "*" ){
                    asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                    asm_out << "\t" << "imull   " << reg1 << ", " << reg2 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg2 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == "/" ){
                    asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                    asm_out << "\t" << "idivl   " << reg1 << ", " << reg2 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg2 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == "^" ){
                    asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                    asm_out << "\t" << "xorl    " << reg1 << ", " << reg2 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg2 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == "|" ){
                    asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                    asm_out << "\t" << "orl     " << reg1 << ", " << reg2 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg2 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == "&" ){
                    asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                    asm_out << "\t" << "andl    " << reg1 << ", " << reg2 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg2 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == ">" || entry->arg3.first == "<" || entry->arg3.first == ">=" || entry->arg3.first == "<=" ){
                    asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                    asm_out << "\t" << "cmpl    " << reg2 << ", " << reg1 << endl;
                    latest_conditional_op = entry->arg3.first;
                }  
                if( entry->arg3.first == ">>>" ){
                    asm_out << "\t" << "sarl    " << arg4 << ", " << reg1 << endl;
                    asm_out << "\t" << "cmpl    " << "$0" << ", " << reg1 << endl;
                    asm_out << "\t" << "jge     " << "$Lurs" + to_string(digit()) << endl;
                    // add 2 << ~ arg4
                    asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                    asm_out << "\t" << "notl    " << reg2 << endl;
                    asm_out << "\t" << "sall    " << reg2 << ", " << "$2" << endl;
                    asm_out << "\t" << "addl    " << reg2 << ", " << reg1 << endl;
                    asm_out << "$Lurs" + to_string(univ_counter) + ":" << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg1 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
            }
        }
    }

    void branch_if(ThreeAddressCodeEntry* entry){
        if( latest_conditional_op == ">" ) asm_out << "\t" << "jle     " << entry->arg4.first << endl;
        if( latest_conditional_op == ">=" ) asm_out << "\t" << "jl      " << entry->arg4.first << endl;
        if( latest_conditional_op == "<=" ) asm_out << "\t" << "jg      " << entry->arg4.first << endl;
        if( latest_conditional_op == "<" ) asm_out << "\t" << "jge     " << entry->arg4.first << endl;
    }

    void branch_goto(ThreeAddressCodeEntry* entry){
        asm_out << "\t" << "jmp     " << entry->arg2.first << endl;
    }

    // void add_sub_mul_div_op(ThreeAddressCodeEntry* entry){
    //     string arg1 = getaddr("arg1", entry, address_descriptor, func_total_offset, func_curr_offset);
    //     string arg2 = getaddr("arg2", entry, address_descriptor, func_total_offset, func_curr_offset);
    //     if( entry->arg3.first == "+" ) asm_out << "\t" << "addq    " << arg2 << ", " << arg1 << endl;
    //     if( entry->arg3.first == "-" ) asm_out << "\t" << "subq    " << arg2 << ", " << arg1 << endl;
    //     if( entry->arg3.first == "*" ) asm_out << "\t" << "imulq   " << arg2 << ", " << arg1 << endl;
    //     if( entry->arg3.first == "/" ) asm_out << "\t" << "idivq   " << arg2 << ", " << arg1 << endl;
    // }
};