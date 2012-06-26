Iterable<String> split(String val, String separators){
    object iterable satisfies Iterable<String>{
        Iterable<String> iterableWithTokens = val.split((Character c) c in separators, false);
        shared actual Boolean empty = iterableWithTokens.empty;
        shared actual Iterator<String> iterator {
            object iterator satisfies Iterator<String> {
                Iterator<String> withTokens = iterableWithTokens.iterator;
                variable Boolean lastWasToken := true;
                variable Boolean first := true;
                shared actual String|Finished next() {
                    String|Finished next = withTokens.next();
                    switch(next)
                    case (is Finished) {
                        if(first){
                            return exhausted;
                        }
                        first := false;
                        if(lastWasToken){
                            lastWasToken := false;
                            return "";
                        }
                    }
                    case (is String) {
                        first := false;
                        if(next == separators){
                            if(!lastWasToken){
                                lastWasToken := true;
                                // eat up the separator, last token was not a separator 
                                return this.next();
                            }else{
                                // last token was a separator, return an empty token
                                return "";
                            }
                        }
                        lastWasToken := false;
                    }
                    return next;
                }
            }
            return iterator;
        }
    }
    return iterable;
}