#include"codegen_helper.cpp"
class CodeGenerator {

public:
    // SymbolTable* curr_symtable;
    map<string, set<pair<string, SymbolEntry*>>> reg_desc; // register descriptio
    map<SymbolEntry*, set<string>> addr_desc;   // address description of a variable
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
            if(entry->type == "assign")
                assign_op(entry);
            else if(entry->type == "funcdecl")
                func_decl(entry);
            else if(entry->type == "funcend")
                func_end(entry);
            else if(entry -> type == "funcparam")
                func_param(entry);
            else if(entry->type == "label")
                asm_out << entry->arg1.first << ": " << endl;
        }
    }
    void func_decl(ThreeAddressCodeEntry* entry)
    {
        asm_out << "\t" << ".globl " << entry->arg1.first << endl;
        asm_out << "\t" << ".type " << entry->arg1.first << ", @function"<< endl;
        asm_out << entry->arg1.first << ": " << endl;
        asm_out << "\t" << "endbr64" << endl;
        asm_out << "\t" << "pushq %rbp" << endl;
        asm_out << "\t" << "movq %rsp, %rbp" <<endl;
        no_callee_params=0;
    }

    void func_param(ThreeAddressCodeEntry* entry)
    {
        no_callee_params++;
        string src = get_arg_reg();
        int stack_offset = entry->arg1.second->offset;
        string dest = "-" +to_string( stack_offset )+ "(%rbp)";
        asm_out << "\t" << "movq " << src << ", "<< dest << endl;
        reg_desc["get_arg_reg"].insert(entry->arg1);
        addr_desc[entry->arg1.second].insert(dest);
    }

    void func_end(ThreeAddressCodeEntry* entry)
    {
        asm_out << "\t" << "movl $0, %eax" << endl;
        // asm_out << "\t" << "popq %rbp" << endl;
        asm_out << "\t" << "leave" << endl;
        asm_out << "\t" << "ret" << endl;
    }

    void assign_op(ThreeAddressCodeEntry* entry)
    {
        string arg1 = getaddr("arg1", entry);
        string arg2 = getaddr("arg2", entry);
        asm_out << "movq " << arg2 << ", " << arg1 << endl; 
    }

    void add_sub_mul_div_op(ThreeAddressCodeEntry* entry){
        string arg1 = getaddr("arg1", entry);
        string arg2 = getaddr("arg2", entry);
        if( entry->arg3.first == "+" ) asm_out << "addl " << arg2 << ", " << arg1 << endl;
        if( entry->arg3.first == "-" ) asm_out << "subl " << arg2 << ", " << arg1 << endl;
        if( entry->arg3.first == "*" ) asm_out << "imull " << arg2 << ", " << arg1 << endl;
        if( entry->arg3.first == "/" ) asm_out << "idivl " << arg2 << ", " << arg1 << endl;
    }
};