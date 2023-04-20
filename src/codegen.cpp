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
    map<string, map<string, set<string>>> func_addr_desc;
    int func_total_offset = -1; // The total offset for local variables in function.
    int func_curr_offset = -1; // The current offset being specified for local variables at the time of going through the function.
    string latest_conditional_op = "";
    string var_latest_conditional_op = "";
    string latest_func_name = "";
    ofstream asm_out;
    int no_callee_params;
    int no_caller_params;
    int stack_caller_params;
    int callee_params_offset;
    bool scope_print = 0;
    CodeGenerator(string filename) {
        no_callee_params=0;
        no_caller_params = 0;
        callee_params_offset = 0;
        stack_caller_params = 0;
        asm_out.open(filename,ios::out | std::ofstream::trunc);
    }

    int digit(){
        return ++univ_counter;
    }

    string get_arg_reg()
    {
        if(no_callee_params == 1)
            return "%edi";
        else if(no_callee_params == 2)
            return "%esi";
        else if(no_callee_params == 3)
            return "%edx";
        else if(no_callee_params == 4)
            return "%ecx";
        else if(no_callee_params == 5)
            return "%r8d";
        else if(no_callee_params == 6)
            return "%r9d";
        else 
            return "stack";
    }
    string get_formalparam_reg(ThreeAddressCodeEntry* entry)
    {
        int param_index=entry->param_index;
        if(param_index> 6)
            param_index-=6;
        if(param_index == 1)
            return "%edi";
        else if(param_index == 2)
            return "%esi";
        else if(param_index == 3)
            return "%edx";
        else if(param_index == 4)
            return "%ecx";
        else if(param_index == 5)
            return "%r8d";
        else if(param_index == 6)
            return "%r9d";
        else 
            return "stack";
    }
    void generate (Node* root)
    {
        asm_out << ".printlnint:" << endl;
        asm_out << "\t" << ".string " << "\"%d \\n\"" << endl;
        asm_out << ".printint:" << endl;
        asm_out << "\t" << ".string " << "\"%d \"" << endl;
        asm_out << ".printlnchar:" << endl;
        asm_out << "\t" << ".string " << "\"%c \\n\"" << endl;
        asm_out << ".printchar:" << endl;
        asm_out << "\t" << ".string " << "\"%c \"" << endl;
        for(auto entry: root->code_entries)
        {
            if(entry->type == "")
                assign_op(entry);
            else if(entry->type == "funcdecl"){
                // address_descriptor.clear();
                func_decl(entry);
                func_total_offset = func_offset[entry->arg1.first];
                func_curr_offset = func_total_offset;
                int size = func_total_offset;
                int x = ceil(size/(float)16);
                asm_out << "\tsubq    " << "$" << to_string(x*16) << ", %rsp" << endl;
            } 
            else if ( entry -> type == "funcreturn")
                func_end(entry);
            else if(entry->type == "funcend"){
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
            else if(entry->type == "param" || entry ->type == "param_stack")
            {
                push_param(entry);
            }
            else if (entry->type == "call")
            {
                if(entry->arg2.first == "System.out.print")
                {
                    asm_out << "\t" << "leaq    .printint(%rip), %rax" << endl;
                    asm_out << "\t" << "movq    %rax, %rdi" << endl;
                    asm_out << "\t" << "movl    $0, %eax" << endl;
                    asm_out << "\t" << "call    " << "printf@PLT" << endl;
                }
                else if(entry->arg2.first == "System.out.println")
                {
                    asm_out << "\t" << "leaq    .printlnint(%rip), %rax" << endl;
                    asm_out << "\t" << "movq    %rax, %rdi" << endl;
                    asm_out << "\t" << "movl    $0, %eax" << endl;
                    asm_out << "\t" << "call    " << "printf@PLT" << endl;
                }
                else 
                {
                    asm_out << "\t" << "call    " << entry->arg2.first << endl;
                    if(stack_caller_params > 0)
                        asm_out << "\t" << "addq    " << "$" << to_string(8*stack_caller_params) << ", %rsp" << endl;
                }
            }
            else if (entry->type == "precall")
            {
                if(entry -> is_print == 1)
                    scope_print = 1;
            }
            else if (entry->type == "postcall")
            {
                if(entry -> is_print == 1)
                    scope_print = 0;
            }
            else if(entry-> type == "return_value")
            {
                handle_return_value(entry);
            }
            else if(entry->type == "return_assign")
            {
                string src = getaddr("arg1", entry, address_descriptor, func_total_offset, func_curr_offset);
                asm_out << "\t" << "movl    "<< "%eax, " << src << endl;
            }
            // else if(entry->type == "localvar_deallocate")
            // {
            //     asm_out << "\taddq    " << "$" << to_string(64+2*func_total_offset) << ", %rsp" << endl;
            // }
            // else
            //     asm_out << "\tnop" << endl;
        }
    }
    void handle_return_value(ThreeAddressCodeEntry* entry)
    {
        string src = getaddr("arg3", entry, address_descriptor, func_total_offset, func_curr_offset);
        asm_out << "\t" << "movl    "<< src << ", %eax" << endl;
    }
    void push_param(ThreeAddressCodeEntry* entry)
    {
        string src = getaddr("arg2", entry, address_descriptor, func_total_offset, func_curr_offset);
        if(scope_print)
        {
            asm_out << "\t" << "movl    " << src << ", %esi" << endl;
            return;
        }
        if(entry -> type == "param_stack")
        {
            stack_caller_params ++;
            asm_out << "\t" << "pushl   " << src << endl;
        }
        else
        {
            string dest = get_formalparam_reg(entry);
            asm_out << "\t" << "movl    " << src << ", " << dest << endl;
        }
        // asm_out << "\t" << "movl    " << src << ", %eax" << endl;
        // asm_out << "\t" << "movl    " << "%eax" << ", " << dest << endl;
    }
    void func_decl(ThreeAddressCodeEntry* entry)
    {
        latest_func_name = entry->arg1.first;
        asm_out << "\t" << ".text" << endl;
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
        no_callee_params++;
        string src = get_arg_reg();
        string dest = "-"+to_string(func_curr_offset)+"(%rbp)";
        func_curr_offset -= 4;
        asm_out << "\tmovl    " << src << ", " << dest << endl;
        func_addr_desc[latest_func_name][entry->arg1.first].insert(dest);
        address_descriptor = func_addr_desc[latest_func_name];
        // int stack_offset = entry->arg1.second->offset;
        // string dest = "-" +to_string( stack_offset )+ "(%rbp)";
        // asm_out << "\t" << "movq    " << src << ", "<< dest << endl;
        // reg_desc["get_arg_reg"].insert(entry->arg1);
        // addr_desc[entry->arg1.second].insert(dest);
    }

    void func_end(ThreeAddressCodeEntry* entry)
    {
        
        asm_out << "\t" << "movq    %rbp, %rsp" << endl;
        asm_out << "\t" << "popq    %rbp" << endl;
        // asm_out << "\t" << "leave" << endl;
        // asm_out << "\t" << "movl	$0, %eax" << endl;
        if( entry->arg2.first == "VOID" ){
            asm_out << "\t" << "movq    $0, %rax" << endl;
        }
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
            if( !check_char(entry->arg2.first) and !check_literal(entry->arg2.first) ){
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
                string reg3 = "%esi";
                string reg4 = "%ecx";
                if( entry->arg3.first == "<<" ){
                    asm_out << "\t" << "movl    " << arg2 << ", " << reg1 << endl;
                    asm_out << "\t" << "sall    " << arg4 << ", " << reg1 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg1 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == ">>" ){
                    asm_out << "\t" << "movl    " << arg2 << ", " << reg1 << endl;
                    asm_out << "\t" << "sarl    " << arg4 << ", " << reg1 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg1 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == "+" ){
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    if( (entry->arg4.first[0] >= '0' and entry->arg4.first[0] <= '9') and (entry->arg1.first == entry->arg2.first) ){
                        asm_out << "\t" << "addl    " << "$" << entry->arg4.first << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                    }  else if( check_literal(entry->arg2.first) and check_literal(entry->arg4.first) ){
                        asm_out << "\t" << "movl    $" << to_string(stoi(entry->arg2.first)+stoi(entry->arg4.first)) << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                    } else {
                        asm_out << "\t" << "movl    " << arg2 << ", " << reg1 << endl;
                        asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                        asm_out << "\t" << "addl    " << reg1 << ", " << reg2 << endl;
                        asm_out << "\t" << "movl    " << reg2 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                    }
                }
                if( entry->arg3.first == "-" ){
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    if( (entry->arg4.first[0] >= '0' and entry->arg4.first[0] <= '9') and (entry->arg1.first == entry->arg2.first) ){
                        asm_out << "\t" << "subl    " << "$" << entry->arg4.first << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                    } else if( check_literal(entry->arg2.first) and check_literal(entry->arg4.first) ){
                        asm_out << "\t" << "movl    $" << to_string(stoi(entry->arg2.first)-stoi(entry->arg4.first)) << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                    } else {
                        asm_out << "\t" << "movl    " << arg2 << ", " << reg1 << endl;
                        asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                        asm_out << "\t" << "subl    " << reg2 << ", " << reg1 << endl;
                        asm_out << "\t" << "movl    " << reg1 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                    }
                }
                if( entry->arg3.first == "*" ){
                     if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    if( check_literal(entry->arg2.first) and check_literal(entry->arg4.first) ){
                        asm_out << "\t" << "movl    $" << to_string(stoi(entry->arg2.first)*stoi(entry->arg4.first)) << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                    } else {
                        asm_out << "\t" << "movl    " << arg2 << ", " << reg1 << endl;
                        asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                        asm_out << "\t" << "imull   " << reg1 << ", " << reg2 << endl;
                        asm_out << "\t" << "movl    " << reg2 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                    }
                }
                if( entry->arg3.first == "/" || entry->arg3.first == "%" ){
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    if( check_literal(entry->arg2.first) and check_literal(entry->arg4.first) ){
                        if(  entry->arg3.first == "/" ) asm_out << "\t" << "movl    $" << to_string(stoi(entry->arg2.first)/stoi(entry->arg4.first)) << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                        else asm_out << "\t" << "movl    $" << to_string(stoi(entry->arg2.first)%stoi(entry->arg4.first)) << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                    } else if( !check_literal(entry->arg4.first) ){
                        asm_out << "\t" << "movl    " << arg2 << ", " << reg2 << endl;
                        asm_out << "\t" << "cltd" << endl;
                        asm_out << "\t" << "idivl   " << arg4 << endl;
                        // asm_out << "\t" << "idivl   " << reg1 << ", " << reg2 << endl;
                        if(  entry->arg3.first == "/" ) asm_out << "\t" << "movl    " << reg2 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                        else asm_out << "\t" << "movl    " << reg1 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                    } else {
                        string addr1 = *(address_descriptor[entry->arg1.first].begin());
                        asm_out << "\t" << "movl    " << arg2 << ", " << reg2 << endl;
                        asm_out << "\t" << "movl    " << arg4 << ", " << addr1 << endl;
                        asm_out << "\t" << "cltd" << endl;
                        asm_out << "\t" << "idivl   " << addr1 << endl;
                        if(  entry->arg3.first == "/" ) asm_out << "\t" << "movl    " << reg2 << ", " << addr1 << endl;
                        else asm_out << "\t" << "movl    " << reg1 << ", " << addr1 << endl;
                    }
                }
                if( entry->arg3.first == "^" ){
                    asm_out << "\t" << "movl    " << arg2 << ", " << reg1 << endl;
                    asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                    asm_out << "\t" << "xorl    " << reg1 << ", " << reg2 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg2 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == "|" ){
                    asm_out << "\t" << "movl    " << arg2 << ", " << reg1 << endl;
                    asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                    asm_out << "\t" << "orl     " << reg1 << ", " << reg2 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg2 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == "&" ){
                    asm_out << "\t" << "movl    " << arg2 << ", " << reg1 << endl;
                    asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                    asm_out << "\t" << "andl    " << reg1 << ", " << reg2 << endl;
                    if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << reg2 << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                }
                if( entry->arg3.first == ">" || entry->arg3.first == "<" || entry->arg3.first == ">=" || entry->arg3.first == "<=" ){
                    if( address_descriptor.find(entry->arg2.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg2.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    if( (entry->arg4.first[0] >= '0' and entry->arg4.first[0] <= '9') ){
                        asm_out << "\t" << "cmpl    " << "$" << entry->arg4.first << ", " << *(address_descriptor[entry->arg2.first].begin()) << endl;
                    } else {
                        asm_out << "\t" << "movl    " << arg2 << ", " << reg1 << endl;
                        asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                        asm_out << "\t" << "cmpl    " << reg2 << ", " << reg1 << endl;
                    }
                    latest_conditional_op = entry->arg3.first;
                }
                if( entry->arg3.first == "==" || entry->arg3.first == "!=" ){
                    if( address_descriptor.find(entry->arg2.first) == address_descriptor.end() ){
                        address_descriptor[entry->arg2.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                        func_curr_offset -= 4;
                    }
                    asm_out << "\t" << "movl    " << arg4 << ", " << reg1 << endl;
                    asm_out << "\t" << "cmpl    " << arg2 << ", " << reg1 << endl;
                    latest_conditional_op = entry->arg3.first;
                }
                // if( entry->arg3.first == ">>>" ){
                //     asm_out << "\t" << "movl    " << arg2 << ", " << reg1 << endl;
                //     asm_out << "\t" << "sarl    " << arg4 << ", " << reg1 << endl;
                //     asm_out << "\t" << "cmpl    " << "$0" << ", " << reg1 << endl;
                //     asm_out << "\t" << "jge     " << ".Lurs" + to_string(digit()) << endl;
                //     // add 2 << ~ arg4
                //     asm_out << "\t" << "movl    " << arg4 << ", " << reg2 << endl;
                //     asm_out << "\t" << "notl    " << reg2 << endl;
                //     asm_out << "\t" << "movl    " << "$2" << ", " << reg3 << endl;
                //     asm_out << "\t" << "movl    " << reg2 << ", " << reg4 << endl;
                //     asm_out << "\t" << "sall    " << "%cl" << ", " << reg3 << endl;
                //     asm_out << "\t" << "movl    " << reg3 << ", " << reg2 << endl;
                //     asm_out << "\t" << "addl    " << reg1 << ", " << reg2 << endl;
                //     asm_out << ".Lurs" + to_string(univ_counter) + ":" << endl;
                //     if( address_descriptor.find(entry->arg1.first) == address_descriptor.end() ){
                //         address_descriptor[entry->arg1.first].insert("-"+to_string(func_curr_offset)+"(%rbp)");
                //         func_curr_offset -= 4;
                //     }
                //     asm_out << "\t" << "movl    " << "%eax" << ", " << *(address_descriptor[entry->arg1.first].begin()) << endl;
                // }
            }
        }
    }

    void branch_if(ThreeAddressCodeEntry* entry){
        if( latest_conditional_op == ">" ) asm_out << "\t" << "jle     " << entry->arg4.first << endl;
        if( latest_conditional_op == ">=" ) asm_out << "\t" << "jl      " << entry->arg4.first << endl;
        if( latest_conditional_op == "<=" ) asm_out << "\t" << "jg      " << entry->arg4.first << endl;
        if( latest_conditional_op == "<" ) asm_out << "\t" << "jge     " << entry->arg4.first << endl;
        if( latest_conditional_op == "==" ) asm_out << "\t" << "jne     " << entry->arg4.first << endl;
        if( latest_conditional_op == "!=" ) asm_out << "\t" << "je     " << entry->arg4.first << endl;
        latest_conditional_op = "";
        var_latest_conditional_op = "";
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