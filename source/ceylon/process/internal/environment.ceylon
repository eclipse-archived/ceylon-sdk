import java.lang { System { getenv } }

shared object environment 
        satisfies Iterable<String->String> {    
    
    shared actual Iterator<String->String> iterator() {
        object iterator satisfies Iterator<String->String> {   
            value env = getenv().entrySet().iterator();
            shared actual <String->String>|Finished next() {
                if (env.hasNext()) {
                    value entry = env.next();
                    return entry.key.string->entry.\ivalue.string;
                }
                else {
                    return finished;
                }
            }
        }
        return iterator; 
    }
    
}





