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
    // writeln(cast(int) c, ";", cast(long) c, ";",  cast(short) c, ";", stdin.eof);
    return stdin.eof ? -1 : cast(long) c;
}

// !@#$%^&*()_+
class EcndpcaalrlpState {
    private {
        string          code;
        size_t          ptr;
        Atom[]          stack;
        size_t[size_t]  jumpPositions;
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
    
    auto popFrom(size_t ind) {
        auto res = stack[ind];
        stack = stack.remove(ind);
        return res;
    }
    
    this(string input) {
        code = input;
        push(0);
        // parse jumpPositions
        size_t[] positionStack;
        foreach(i, c; code) {
            if(c == '(') {
                positionStack ~= i;
            }
            else if(c == ')') {
                if(positionStack.length == 0) {
                    throw new Error("Unmatched parentheses");
                }
                auto start = positionStack.back;
                jumpPositions[start] = i;
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
            
            // sends top to the bottom of the stack
            case '%':
                bringToFront(stack[1..$], stack[0..1]);
                break;
            
            // increments the top of stack
            case '^':
                top++;
                break;
            
            // stack index
            case '&':
                auto indexRaw = pop;
                while(indexRaw < 0) {
                    indexRaw += stack.length;
                }
                uint index = cast(uint) indexRaw;
                push(popFrom(index));
                break;
            
            // stack index (old)
            case '=':
                auto indexRaw = pop;
                while(indexRaw < 0) {
                    indexRaw += stack.length;
                }
                uint index = cast(uint) indexRaw;
                push(stack[index]);
                break;
            
            // prints info
            case '?':
                info;
                break;
            
            // getchar
            case '*':
                top += getchar;
                break;
            
            // open loop
            case '(':
                if(top == 0) {
                    ptr = jumpPositions[ptr];
                }
                break;
            
            // close loop
            case ')':
                ptr = jumpPositions[ptr];
                advance = false;
                break;
            
            // negate tos
            case '_':
                top = -top;
                break;
            
            // add top two
            case '+':
                auto v = pop;
                top += v;
                break;
            
            // push value
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
            if(32 <= reg && reg <= 126) {
                writefln("%s: %s ('%c)", i, reg, cast(dchar) reg);
            }
            else {
                writefln("%s: %s", i, reg);
            }
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