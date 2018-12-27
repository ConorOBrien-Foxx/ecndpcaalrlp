import std.stdio;
import std.bigint;
import std.range;
import std.array;
import std.algorithm.mutation;
import std.string;

alias Atom = BigInt;

auto getchar() {
    dchar c;
    stdin.readf("%c", &c);
    return cast(uint) c;
}

// !@#$%^&*()_+
class EcndpcaalrlpState {
    private {
        string      code;
        uint        ptr;
        Atom[]      stack;
        uint[uint]  jumpPositions;
    }
    
    void push(T)(T val) {
        stack ~= cast(Atom) val;
    }
    
    auto pop() {
        if(stack.length == 0) {
            return cast(Atom) 0;
        }
        else {
            auto res = stack.back;
            stack.popBack;
            return res;
        }
    }
    
    this(string input) {
        code = input;
        push(0);
        // parse jumpPositions
        uint[] positionStack;
        foreach(i, c; code) {
            if(c == '(') {
                positionStack ~= i;
            }
            else if(c == ')') {
                auto start = positionStack.back;
                jumpPositions[start] = i + 1;
                jumpPositions[i] = start;
                positionStack.popBack;
            }
        }
    }
    
    @property
    bool running() { return ptr < code.length; }
    
    ref auto top() {
        if(stack.length == 0) push(0);
        return stack.back;
    }
    
    void step() {
        dchar cur = code[ptr];
        bool advance = true;
        
        switch(cur) {
            // duplicate value
            case '!':
                push(stack.back);
                break;
            
            // write character
            case '@':
                write(cast(dchar) cast(uint) pop);
                break;
            
            // write number
            case '#':
                write(pop);
                break;
            
            // swap top two
            case '$':
                auto a = pop;
                auto b = pop;
                push(a);
                push(b);
                break;
            
            // 
            case '%':
                bringToFront(stack[1..$], stack[0..1]);
                break;
            
            case '^':
                top++;
                break;
            
            case '&':
                break;
            
            case '?':
                info;
                break;
            
            case '*':
                top += getchar;
                break;
            
            case '(':
                if(top == 0) {
                    ptr = jumpPositions[ptr];
                }
                break;
            
            case ')':
                ptr = jumpPositions[ptr];
                advance = false;
                break;
            
            case '_':
                top = -top;
                break;
            
            case '+':
                auto v = pop;
                top += v;
                break;
            
            default:
                push(cast(uint) cur);
                break;
        }
        if(advance) {
            ptr++;
        }
    }
    
    void run() {
        while(running) {
            step;
        }
    }
    
    void info() {
        foreach(i, reg; stack) {
            writefln("Reg[%s] -> %s", i, reg);
        }
    }
}

void main(string[] argv) {
    import std.file;
    string program;
    try {
        program = argv[1].readText;
    }
    catch(FileException) {
        program = argv[1];
    }
    auto state = new EcndpcaalrlpState(program);
    state.run;
}