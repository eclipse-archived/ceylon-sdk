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
   
   This parser does not enforce uniqueness of keys within 
   JSON objects. It is usually not onerous for the caller to do so if 
   they require such enforcement.
   
   By default [[ParseException]]s will propagate out of calls to [[next]] 
   when a error is detected. You can use [[errorReporting]] 
   to report errors as [[Exception]]s within the stream.
   
   ## Example
   
   Suppose we have the domain model:
   
       class Order(address, items) {
           shared String address;
           shared Item[] items;
       }
       class Item(sku, quantity) {
           shared String sku;
           shared Integer quantity;
       }
       
    And we want to parse JSON that looks like this:
    
    ```javascript
       {
         "address":"",
         "items":[
           {
             "sku":"123-456-789",
             "quantity":4
           },
           {
             "sku":"456-789",
             "quantity":20
           }
         ]
       }
    ```
    
    Then we might write a parser like this:
    
        class OrderParser() {
            
            late variable Peek<Event> stream;
           
            String missingKey(String container, String key) {
                return "``container``: '``key``' missing at line ``stream.line``'";
            }
            String duplicateKey(String container, String key) {
                return "``container``: '``key``' occurs more than once at line ``stream.line``'";
            }
            String keyType(String container, String key, String expectedType) {
                return "``container``: '``key``' key is supposed to be of ``expectedType`` type at line ``stream.line``";
            }
            String unexpectedKey(String container, String key) {
                return "``container``: '``key``' key not supported at line ``stream.line``";
            }
            String unexpectedEvent(String container, Event|Finished event) {
                return "``container``: unexpected event ``event else "null"`` at line ``stream.line``";
            }
            
            "Parses an item from events read from the given parser.
             Returns the item or an error explanation."
            Item|String parseItem() {
                if (!(stream.next() is ObjectStartEvent)) {
                    return "Item: should be a JSON object";
                }
                variable String? sku = null;
                variable Integer? quantity = null;
                while(true) {
                    switch(event=stream.next())
                    case (is KeyEvent) {
                        switch(key=event.key) 
                        case ("sku") {
                            if (is String s = stream.next()) {
                                if (sku exists) {
                                    return duplicateKey("Item", "sku");
                                }
                                sku = s;
                            } else {
                                return keyType("Item", "sku", "String");
                            }
                        }
                        case ("quantity") {
                            if (is Integer s = stream.next()) {
                                if (quantity exists) {
                                    return duplicateKey("Item", "quantity");
                                }
                                quantity = s;
                            } else {
                                return keyType("Item", "sku", "Integer");
                            }
                        }
                        else {
                            return unexpectedKey("Item", key);
                        }
                    }
                    case (is ObjectEndEvent) {
                        if (exists s=sku) {
                            if (exists q=quantity) {
                                return Item(s, q);
                            }
                            return missingKey("Item", "quantity");
                        }
                        return missingKey("Item", "sku");
                    }
                    else {
                        return unexpectedEvent("Item", event);
                    }
                }
            }
            
            "Parses an order from events read from the given parser.
             Returns the order or an error explanation."
            Order|String parseOrder() {
                if (!(stream.next() is ObjectStartEvent)) {
                    return "Order: should be a JSON object";
                }
                variable String? address = null;
                value items = ArrayList<Item>();
                while(true) {
                    switch(event=stream.next())
                    case (is KeyEvent) {
                        switch(key=event.key) 
                        case ("address") {
                            if (is String s = stream.next()) {
                                if (address exists) {
                                    return duplicateKey("Order", "address");
                                }
                                address = s;
                            } else {
                                return keyType("Order", "address", "String");
                            }
                        }
                        case ("items") {
                            if (!items.empty) {
                                return duplicateKey("Order", "items");
                            }
                            if (!stream.next() is ArrayStartEvent) {
                                return keyType("Order", "items", "Array");
                            }
                            while (stream.peek() is ObjectStartEvent) {
                                switch (item=parseItem())
                                case (is String) {
                                    return item;
                                }
                                case (is Item) {
                                    items.add(item);
                                }
                            }
                            assert(stream.next() is ArrayEndEvent);
                        }
                        else {
                            return unexpectedKey("Order", key);
                        }
                    }
                    case (is ObjectEndEvent) {
                        if (exists a=address) {
                            return Order(a, items.sequence());
                        }
                        return missingKey("Order", "address");
                    }
                    else {
                        return unexpectedEvent("Item", event);
                    }
                }
            }
            
            shared Order|String parse(String json) {
                stream = Peek(StreamParser(StringTokenizer(json)));
                return parseOrder();
            }
        }
   
   While this is certainly verbose it's extremely readable and regular.
   
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

shared class Peek<T>(Iterator<T>&Positioned stream) satisfies Iterator<T>&Positioned {
    variable Boolean havePeek = false;
    variable T|Finished? peeked = null;
    late variable Integer col;
    late variable Integer lin;
    late variable Integer pos;
    
    shared T|Finished peek() {
        if (!havePeek) {
            havePeek = true;
            peeked = stream.next();
        } 
        assert(is T|Finished p=peeked);
        return p;
    }
    
    shared actual T|Finished next() {
        T|Finished result;
        if (havePeek) {
            havePeek = false;
            assert(is T|Finished p=peeked);
            result = p;
        } else {
            result = stream.next();
        }
        col = stream.column;
        lin = stream.line;
        pos = stream.position;
        return result;
    }
    
    shared actual Integer column => col;
    
    shared actual Integer line => lin;
    
    shared actual Integer position => pos;
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