import ceylon.json {
    ParseException,
    Tokenizer,
    parseNumber,
    parseNull,
    parseTrue,
    parseFalse,
    parseKeyOrString,
    Positioned
}

"Package-private class used by [[StreamParser]] to track state."
class StreamState(parent, last) {
    
    "The number of events yielded so far"
    shared variable Integer num = 0;
    
    shared variable Event? last;
    
    shared StreamState? parent;
    
    shared actual String string {
        return "``parent else "<top>"``, ``last else "<null>"``";
    }
}


"""A parser for JSON data as specified by 
   [RFC 7159] [1] which produces a stream of [[events|Event]] 
   to be handled by the caller. The parser produces events as it reads the 
   source [[input]], so it's possible to start parsing JSON while it's 
   still being received.
   
   This parser does not enforce the uniqueness of keys within 
   JSON objects. It is usually not onerous for the caller to do so if 
   they require such enforcement. Alternatively you can use [[uniqueKeys]] to 
   decorate a StreamParser so it detects duplicate keys in a JSON object and 
   throws.
   
   By default [[ParseException]]s will propagate out of calls to [[next]] 
   when a error is detected. You can use [[errorReporting]] 
   to report errors as [[Exception]]s within the stream.
   
   ## Example
   
   Suppose we have the domain model:
   
       class Person(name, address) {
           shared String name;
           shared Address address;
       }
       class Address(lines) {
           shared String street;
           shared String city;
       }
       
    And we want to parse JSON that looks like this:
    
    ```javascript
    {
        "name":"Grocer Cat",
        "address": {
            "street":"1 Acacia Avenue",
            "city":"Busytown"
        }
    }
    ```
    
    Then we might write a parser like this:
    
        TODO
      
   [1]: https://tools.ietf.org/html/rfc7159
   """
shared class StreamParser(Tokenizer input) 
        satisfies Iterator<Event>&Positioned {
    
    // TODO not yet exception-safe: Should probably return finished once any exception has been thrown
    
    "A stack (singly linked list) of states for all objects and arrays which 
     have been started, but not finished."
    variable value state = StreamState(null, null);
    
    "Parse any JSON value and return an event"
    Event parseValue() {
        input.eatSpaces();
        switch(ch = input.character())
        case ('{') {
            input.moveOne();
            return package.objectStart;
        }
        case ('[') {
            input.moveOne();
            return package.arrayStart;
        }
        case ('"') {
            return parseKeyOrString(input);
        }
        case ('n') {
            parseNull(input);
            checkNext("null");
            return null;
        }
        case ('t') {
            parseTrue(input);
            checkNext("true");
            return true;
        }
        case ('f') {
            parseFalse(input);
            checkNext("false");
            return false;
        }
        case ('-'| '0' | '1' | '2' | '3' | '4' |
                   '5' | '6' | '7' | '8' | '9') {
            return parseNumber(input);
        }
        else {
            throw input.unexpectedCharacter("a value");
        }
    }
    
    void checkNext(String expectedIdent) {
        if (input.hasMore) {
            value ch2=input.character();
            if (ch2 != ',' 
                && ch2 != '}' 
                    && ch2 != ']'
                    && !input.isSpace(ch2)) {
                throw ParseException("Expected ``expectedIdent`` but got ``expectedIdent````ch2``", input.line, input.column);
            }
        }
    }
    
    "Return the next event from the stream, or finished"
    throws(`class ParseException`)
    shared actual Event|Finished next() {
        input.eatSpaces();
        Event|Finished result;
        if (input.hasMore) {
            switch (ch=input.character())
            case (']') {
                input.moveOne();
                result = arrayEnd;
            }
            case ('}') {
                input.moveOne();
                result = objectEnd;
            } 
            case (',') {
                if (state.last is ObjectStartEvent) {
                    input.moveOne();
                    input.eatSpaces();
                    if (input.character() == '"') {
                        result = KeyEvent(parseKeyOrString(input));
                    } else {
                        throw input.unexpectedCharacter("a key");
                    }
                } else if (state.last is ArrayStartEvent) {
                    input.moveOne();
                    input.eatSpaces();
                    result = parseValue();
                } else if (state.last exists){
                    throw input.unexpectedCharacter("a value");// what we expect depends on the state
                } else {
                    throw input.unexpectedCharacter(if (state.num == 0) then "a value" else "end of input");// what we expect depends on the state
                }
            }
            case (':') {
                if (state.last is KeyEvent) {
                    input.moveOne();
                    input.eatSpaces();
                    result = parseValue();
                } else if (state.last exists){
                    throw input.unexpectedCharacter(if (state.num == 0) then "a value" else ',');
                } else {
                    throw input.unexpectedCharacter(if (state.num == 0) then "a value" else "end of input");
                }
            }
            else {
                if (!state.last exists,
                    state.num > 0){
                    throw input.unexpectedCharacter("end of input");
                } else if (state.last is ObjectStartEvent) {
                    if (state.num > 0) {
                        throw input.unexpectedCharacter(',');
                    }
                    result = KeyEvent(parseKeyOrString(input));
                } else if (state.last is ArrayStartEvent) {
                    if (state.num > 0) {
                        throw input.unexpectedCharacter(',');
                    }
                    result = parseValue();
                }
                else {
                    if (state.last is KeyEvent) {
                        throw input.unexpectedCharacter(':');
                    } 
                    result = parseValue();
                }
            }
        } else {
            result = finished;
        }
        return yield(result);
    }
    
    Event|Finished yield(Event|Finished yielding) {
        value last = state.last;
        state.num++;
        switch (yielding)
        case (is ObjectStartEvent) {
            if (is KeyEvent last) {
                if (exists p = state.parent) {
                    state = p;
                } else {
                    throw input.unexpectedCharacter(input.character());
                }
            }
            state = StreamState(state, yielding);
        }
        case (is KeyEvent) {
            if (!is ObjectStartEvent last) {
                throw ParseException("key not expected", input.line, input.column);
            }
            state = StreamState(state, yielding);
        }
        case (is ObjectEndEvent) {
            if (is ObjectStartEvent last) {
                if (exists p=state.parent) {
                    state = p;
                } else {
                    throw input.unexpectedCharacter(input.character());
                }
            } else {
                throw ParseException("Got '`` input.character() ``' but not in object, ``last else "null"``", 
                    input.line, input.column);
            }
        }
        case (is ArrayStartEvent) {
            if (is KeyEvent last) {
                if (exists p = state.parent) {
                    state = p;
                } else {
                    throw input.unexpectedCharacter(input.character());
                }
            }
            state = StreamState(state, yielding);
        }
        case (is ArrayEndEvent) {
            if (is ArrayStartEvent last) {
                if (exists p=state.parent) {
                    state = p;
                } else {
                    throw input.unexpectedCharacter(input.character());
                }
            } else {
                throw ParseException("Got '`` input.character() ``' but not in array, ``last else "null"``", 
                    input.line, input.column);
            }
        }
        case (is String|Float|Integer|Boolean|Null) {
            if (is KeyEvent last) {
                if (exists p = state.parent) {
                    state = p;
                } else {
                    throw input.unexpectedCharacter(input.character());
                }
            }
        }
        case (finished) {
            if (state.parent exists) {
                throw input.unexpectedEnd;
            }
        }
        return yielding;
    }
    
    shared actual String string => input.string;
    
    shared actual Integer column => input.column;
    
    shared actual Integer line => input.line;
    
    shared actual Integer position => input.position;
    
}

"Adapts the given stream so that exceptions thrown while evaluating `next()` get 
 returned from the iterator, rather than propagating."
Iterator<T|Exception>&Positioned errorReporting<T>(Iterator<T>&Positioned stream)
        => object satisfies Iterator<T|Exception>&Positioned {
    variable Exception? error = null;
    shared actual T|Exception|Finished next() {
        if (exists err=error) {
            return err;
        } else {
            try {
                return stream.next();
            } catch (Exception e) {
                return error = e;
            }
        }
    }
    shared actual Integer column => stream.column;
    
    shared actual Integer line => stream.line;
    
    shared actual Integer position => stream.position;
};
/*
class StreamState2(StreamState2? parent, Event? last) extends StreamState(parent, last){
    HashSet<String>? keys = if (last is ObjectStartEvent) then HashSet<String>() else null;
    if (is KeyEvent last) {
        assert (exists parent, exists k=parent.keys);
        if (!k.add(last.key)) {
            // TODO location information!
            throw ParseException("duplicate key ``last.key``", -1, -1);
        }
    }
}

"Adapts the given stream so duplicate keys within an object result in a 
 [[ParseException]] being thrown."
Iterator<T|Exception>&Positioned uniqueKeys<T>(Iterator<T>&Positioned stream) 
        => object satisfies Iterator<T|Exception>&Positioned {
    // TODO I need a stack, just like the StreamIterator does
    // it would be nice if we could abstract the creation of stack elements and their maniplation.
    // => StreamState is probably a default member class
    // except I don't really want clients knowing about it.
    
    shared actual T|Exception|Finished next() {
        return nothing;
    }
    shared actual Integer column => stream.column;
    
    shared actual Integer line => stream.line;
    
    shared actual Integer position => stream.position;
};
*/