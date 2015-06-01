import ceylon.json {
    JsonObject=Object,
    JsonArray=Array,
    Value,
    Positioned,
    StringTokenizer
}

"Parse the given string of JSON 
 formatted data into an in-memory model, 
 returning the model."
Value parse(String json) {
    return buildValue(StreamParser(StringTokenizer(json)));
}

"Recursively builds a [[model|Value]] from events produced from the given iterator."
Value buildValue(Iterator<Event>&Positioned events) {
    value event = events.next();
    switch (event)
    case(is String|Integer|Float|Boolean|Null) {
        return event;
    }
    case(is ObjectStartEvent) {
        return buildObject(events);
    }
    case(is KeyEvent) {
        "unexpected key"
        assert(false);
    }
    case(is ObjectEndEvent) {
        "unexpected object end"
        assert(false);
    }
    case(is ArrayStartEvent) {
        return buildArray(events);
    }
    case(is ArrayEndEvent) {
        "unexpected array end"
        assert(false);
    }
    case(is Finished) {
        "unexpected end of input"
        assert(false);
    }
}

JsonObject buildObject(Iterator<Event>&Positioned events) {
    JsonObject result = JsonObject();
    variable String? key=null;
    while (true) {
        value event = events.next();
        switch (event)
        case(is String|Integer|Float|Boolean|Null) {
            "no key in object"
            assert(exists k=key);
            result.put(k, event);
            key = null;
        }
        case(is ObjectStartEvent) {
            "no key in object"
            assert(exists k=key);
            result.put(k, buildObject(events));
            key = null;
        }
        case(is KeyEvent) {
            "two consecutive keys in object"
            assert(!key exists);
            key = event.key;
        }
        case(is ObjectEndEvent) {
            return result;
        }
        case(is ArrayStartEvent) {
            "no key in object"
            assert(exists k=key);
            result.put(k, buildArray(events));
            key = null;
        }
        case(is ArrayEndEvent) {
            "object ended by array end"
            assert(false);
        }
        case(is Finished) {
            "unexpected end of input"
            assert(false);
        }
    }
}
JsonArray buildArray(Iterator<Event>&Positioned events) {
    JsonArray result = JsonArray();
    while (true) {
        value event = events.next();
        switch (event)
        case(is String|Integer|Float|Boolean|Null) {
            result.add(event);
        }
        case(is ObjectStartEvent) {
            result.add(buildObject(events));
        }
        case(is KeyEvent) {
            "key unexpected in array"
            assert(false);
        }
        case(is ObjectEndEvent) {
            "array ended by object end"
            assert(false);
        }
        case(is ArrayStartEvent) {
            result.add(buildArray(events));
        }
        case(is ArrayEndEvent) {
            return result;
        }
        case(is Finished) {
            "unexpected end of input"
            assert(false);
        }
    }
}