import ceylon.json {
    Visitor,
    JsonValue=Value,
    JsonArray=Array,
    JsonObject=Object
}
import ceylon.collection {
    ArrayList
}
"Calls a visitor according to the events obtained from a stream."
shared void streamToVisitor(Iterator<Event> stream, Visitor visitor) {
    while (!is Finished event=stream.next()) {
        switch(event)
        case (is ObjectStartEvent) {
            visitor.onStartObject();
        }
        case (is KeyEvent) {
            visitor.onKey(event.key);
        }
        case (is ObjectEndEvent) {
            visitor.onEndObject();
        }
        case (is ArrayStartEvent) {
            visitor.onStartArray();
        }
        case (is ArrayEndEvent) {
            visitor.onEndArray();
        }
        case (is String) {
            visitor.onString(event);
        }
        case (is Boolean) {
            visitor.onBoolean(event);
        }
        case (is Integer|Float) {
            visitor.onNumber(event);
        }
        case (null) {
            visitor.onNull();
        }
    }
}

"A unit type used internally because we can't use null"
abstract class None() of none {}
object none extends None() {}

class PushIterator<out T>(Iterator<T> it) satisfies Iterator<T> {
    variable T|None pushed = none;
    shared void push(Anything pushed) {
        "cannot push more than one item"
        assert (is None p=pushed);
        assert (is T p);
        this.pushed = p;
    }
    shared actual T|Finished next() {
        if (!is None p=pushed) {
            pushed = none;
            return p;
        } else {
            return it.next();
        }
    }
}

"Produces a stream of events from the descendents of the given root value."
shared class StreamingVisitor(JsonValue root) satisfies Iterator<Event> {
    value stack = ArrayList<PushIterator<JsonValue|<String->JsonValue>>>();
    value pi = PushIterator<JsonValue|<String->JsonValue>>(emptyIterator);
    pi.push(root);
    stack.push(pi);
    shared actual Event|Finished next() {
        if (exists p = stack.pop()) {
            value n = p.next();
            switch(n)
            case (is String|Boolean|Integer|Float|Null) {
                return n;
            }
            case (is JsonObject) {
                stack.push(PushIterator(n.iterator()));
                return objectStart;
            } 
            case (is JsonArray) {
                stack.push(PushIterator(n.iterator()));
                return arrayStart;
            }
            case (is String->JsonValue) {
                p.push(n.item);
                return KeyEvent(n.key);
            }
            case (is Finished) {
                switch (p)
                case (is Iterator<String|Boolean|Integer|Float|JsonObject|JsonArray|Null>) {
                    return arrayEnd;
                }
                else {
                    return objectEnd;
                }
                
            }
        } else {
            return finished;
        }
    }
}