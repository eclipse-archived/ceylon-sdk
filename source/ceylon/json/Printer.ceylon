by "Stéphane Épardaud"
doc "A JSON Printer"
shared abstract class Printer(Boolean pretty = false){
    
    variable Integer level = 0;
    
    void enter(){
        level++;
    }
    
    void leave(){
        level--;
    }
    
    void indent(){
        if(pretty){
            print("\n");
            if(level > 0){
                for(i in 0..level-1){
                    print(" ");
                }
            }
        }
    }
    
    doc "Override to implement the printing part"
    shared formal void print(String string);

    doc "Prints an `Object`"
    shared default void printObject(Object o){
        print("{");
        enter();
        variable Boolean once = true; 
        for(entry in o){
            if(once){
                once = false;
            }else{
                print(",");
            }
            indent();
            printString(entry.key);
            print(":");
            if(pretty){
                print(" ");
            }
            printValue(entry.item);
        }
        leave();
        if(!once){
            indent();
        }
        print("}");
    }

    doc "Prints an `Array`"
    shared default void printArray(Array o){
        print("[");
        enter();
        variable Boolean once = true; 
        for(elem in o){
            if(once){
                once = false;
            }else{
                print(",");
            }
            indent();
            printValue(elem);
        }
        leave();
        if(!once){
            indent();
        }
        print("]");
    }

    doc "Prints a `String`"
    shared default void printString(String s){
        print("\"");
        for(c in s){
            if(c == '"'){
                print("\\" + "\"");
            }else if(c == '\\'){
                print("\\\\");
            }else if(c == '/'){
                print("\\" + "/");
            }else if(c == 8.character){
                print("\\" + "b");
            }else if(c == 12.character){
                print("\\" + "f");
            }else if(c == 10.character){
                print("\\" + "n");
            }else if(c == 13.character){
                print("\\" + "r");
            }else if(c == 9.character){
                print("\\" + "t");
            }else{
                print(c.string);
            }
        }
        print("\"");
    }

    doc "Prints an `Integer|Float`"
    shared default void printNumber(Number n){
        print(n.string);
    }

    doc "Prints a `Boolean`"
    shared default void printBoolean(Boolean v){
        print(v.string);
    }

    doc "Prints `null`"
    shared default void printNull(){
        print("null");
    }
    
    doc "Prints a JSON value"
    shared default void printValue(String|Boolean|Integer|Float|Object|Array|NullInstance val){
        switch(val)
        case (is String){
            printString(val);
        }
        case (is Integer){
            printNumber(val);
        }
        case (is Float){
            printNumber(val);
        }
        case (is Boolean){
            printBoolean(val);
        }
        case (is Object){
            printObject(val);
        }
        case (is Array){
            printArray(val);
        }
        case (is NullInstance){
            printNull();
        }
    }
}