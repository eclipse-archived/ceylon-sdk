import ceylon.time { offsetTime }

abstract class Input<out Data>() of Chunk<Data> | EOF | Empty 
                                 given Data satisfies Anything {}

class Chunk<out Data>(data) extends Input<Data>() {
    shared Data data;
}

abstract class EOF() of eof extends Input<Nothing>() {}
object eof extends EOF() {}

abstract class Empty() of empty extends Input<Nothing>() {}
object empty extends Empty() {} 



abstract class State() of Initial | Zulu | Sign() | Final | Error {
    shared formal State next(Input<Character> input);
}

abstract class Initial() of zone extends State() {}
object zone extends Initial() {
    shared actual State next(Input<Character> character) {
        if (character == 'Z') {
            return zulu;
        }
        if (character == '+') {
            return Sign( +1 );
        }
        if (character == '-') {
            return Sign( -1 );
        }
        return Error("Unexpected character at initial position!");
    }
}

abstract class Zulu() of zulu extends State(){}
object zulu extends Zulu(){
    shared actual State next(Input<Character> input) {
        switch(input)
        case (is EOF) { return Final(0); }
        case (is Empty) { return this; }
        else { return Error("""Unexpected characters after "Z"!"""); }
    }
}

class Final(result) extends State() {
    shared Integer result;
    shared actual State next(Input<Character> character) => this;
}

class Error(message) extends State() {
    shared String message;
    shared actual State next(Input<Character> character) => this;
}


shared TimeZone parseTimeZone(String zoneId) {
    variable State state = initial;
    for(character in zoneId) {
        state = state.next(character);
    }
    return nothing;
}
