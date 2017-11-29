/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    ArrayList,
    HashSet
}
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
class StreamState(parent, last, keys) {
    
    "The number of events yielded so far"
    shared variable Integer num = 0;
    
    shared variable Event? last;
    
    shared StreamState? parent;
    
    shared HashSet<String>? keys;
    
    shared actual String string 
        => "``parent else "<top>"``, ``last else "<null>"``";
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
            
            late variable LookAhead<Event> stream;
           
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
                    case (KeyEvent) {
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
                    case (ObjectEndEvent) {
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
                    case (KeyEvent) {
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
                                case (String) {
                                    return item;
                                }
                                case (Item) {
                                    items.add(item);
                                }
                            }
                            assert(stream.next() is ArrayEndEvent);
                        }
                        else {
                            return unexpectedKey("Order", key);
                        }
                    }
                    case (ObjectEndEvent) {
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
                stream = LookAhead(StreamParser(StringTokenizer(json)));
                return parseOrder();
            }
        }
   
   While this is certainly verbose it's extremely readable and regular.
   
   [1]: https://tools.ietf.org/html/rfc7159
   """
shared class StreamParser(input, trackKeys=false) 
        satisfies Iterator<Event>&Positioned {
    
    "The tokenizer to read input from"
    Tokenizer input;
    
    "Whether to validate the uniqueness of keys"
    Boolean trackKeys;
    
    StreamState pushState(StreamState? parent, Event? last) {
        HashSet<String>? keys;
        if (trackKeys && last is ObjectStartEvent) {
            keys= HashSet<String>();
        } else { 
            keys = null;
        }
        StreamState result = StreamState(parent, last, keys);
        if (trackKeys, is KeyEvent l=last) {
            assert (exists p=parent);
            if (exists k=p.keys, !k.add(l.key)) {
                throw ParseException("Duplicate key: '``l.key``'", input.line, input.column);
            }
        }
        return result;
    }
    
    "A stack (singly linked list) of states for all objects and arrays which 
     have been started, but not finished."
    variable value state = pushState(null, null);
    
    
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
        case (ObjectStartEvent) {
            if (is KeyEvent last) {
                if (exists p = state.parent) {
                    state = p;
                } else {
                    throw input.unexpectedCharacter(input.character());
                }
            }
            state = pushState(state, yielding);
        }
        case (KeyEvent) {
            if (!is ObjectStartEvent last) {
                throw ParseException("Key not expected", input.line, input.column);
            }
            state = pushState(state, yielding);
        }
        case (ObjectEndEvent) {
            if (is ObjectStartEvent last) {
                if (exists p=state.parent) {
                    state = p;
                } else {
                    throw input.unexpectedCharacter(input.character());
                }
            } else {
                throw ParseException("Got '`` yielding ``' but in ``last else "null"`` not in object", 
                    input.line, input.column);
            }
        }
        case (ArrayStartEvent) {
            if (is KeyEvent last) {
                if (exists p = state.parent) {
                    state = p;
                } else {
                    throw input.unexpectedCharacter(input.character());
                }
            }
            state = pushState(state, yielding);
        }
        case (ArrayEndEvent) {
            if (is ArrayStartEvent last) {
                if (exists p=state.parent) {
                    state = p;
                } else {
                    throw input.unexpectedCharacter(input.character());
                }
            } else {
                throw ParseException("Got '`` yielding ``' but in ``last else "null"`` not array", 
                    input.line, input.column);
            }
        }
        case (String|Float|Integer|Boolean|Null) {
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

"A look-ahead buffer wrapping a stream"
shared class LookAhead<T>(Iterator<T>&Positioned stream, lookAhead=1) satisfies Iterator<T>&Positioned {
    "The maximum number of elements we can look ahead, or null for unbounded lookahead."
    Integer? lookAhead;
    "The buffer"
    ArrayList<T|Finished> peeked = ArrayList<T|Finished>(lookAhead else 2);
    "The column number of the last element returned from next()"
    late variable Integer col;
    "The line number of the last element returned from next()"
    late variable Integer lin;
    "The position of the last element returned from next()"
    late variable Integer pos;
    
    "Get the *n*th element ahead"
    shared T|Finished peek(Integer n=1) {
        assert(n >= 1);
        if(exists lookAhead, n > lookAhead) {
            throw AssertionError("lookahead limited to ``lookAhead`` elements");
        }
        while (peeked.size < n) {
            peeked.offer(stream.next());
        } 
        assert(is T|Finished p=peeked[n-1]);
        return p;
    }
    
    shared actual T|Finished next() {
        T|Finished result;
        if (peeked.size > 0) {
            assert(is T|Finished p=peeked.accept());
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
