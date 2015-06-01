"An event produced by a [[StreamParser]] while parsing JSON data."
shared sealed interface Event{
    
}
"An [[Event]] that has an associated value."
shared sealed interface ValueEvent<out Value> {
    
    "The value associated with this event"
    shared formal Value eventValue;
}

"An [[Event]] that has an associated value."
shared sealed interface NestingEvent<Self, out Other> 
        given Other satisfies NestingEvent<Other, Self>
        given Self satisfies NestingEvent<Self, Other> {
    "The value associated with this event"
    shared formal Other pair;
}

"The start of a JSON object/hash, emitted when `{` is parsed."
shared abstract class ObjectStartEvent()
        of objectStart
        satisfies Event&NestingEvent<ObjectStartEvent,ObjectEndEvent>{
}
shared object objectStart extends ObjectStartEvent() {
    shared actual String string => "{";
    shared actual ObjectEndEvent pair => objectEnd;
    
}

"The end of a JSON object/hash, emitted when `}` is parsed."
shared abstract class ObjectEndEvent() 
        of objectEnd
        satisfies Event & NestingEvent<ObjectEndEvent,ObjectStartEvent>{
}
shared object objectEnd extends ObjectEndEvent() {
    shared actual String string => "}";
    shared actual ObjectStartEvent pair => objectStart;
    
}

"The start of a JSON array, emitted when `[` is parsed."
shared abstract class ArrayStartEvent() 
        of arrayStart
        satisfies Event & NestingEvent<ArrayStartEvent,ArrayEndEvent> {
}
shared object arrayStart extends ArrayStartEvent() {
    shared actual String string => "[";
    shared actual ArrayEndEvent pair => arrayEnd;
    
}

"The end of a JSON array, emitted when `]` is parsed."
shared abstract class ArrayEndEvent() 
        of arrayEnd
        satisfies Event & NestingEvent<ArrayEndEvent,ArrayStartEvent>{
}
shared object arrayEnd extends ArrayEndEvent() {
    shared actual String string => "]";
    shared actual ArrayStartEvent pair => arrayStart;
    
}

shared sealed class KeyEvent(eventValue) 
        satisfies ValueEvent<String> {
    shared actual String eventValue;
    shared actual String string => "\"``eventValue``\":";
}


"Event representing an error during parsing 
 (such as the underlying stream finishing unexpectedly).
 Emitted as soon as the error is detected. 
 Once an error event has been returned the [[StreamParser]] 
 will only return `finished` and `next()` will not be called 
 on the underlying stream.
 
 The [[eventValue]] is the an [[Exception]]."
shared sealed class ExceptionEvent(Exception exception) 
        satisfies Event&ValueEvent<Exception> {
    
    "The exception."
    shared actual Exception eventValue => exception;
    
    "The exception's message"
    shared String message => exception.message;
    
    shared actual String string => "ExceptionEvent(``message``)";
}
