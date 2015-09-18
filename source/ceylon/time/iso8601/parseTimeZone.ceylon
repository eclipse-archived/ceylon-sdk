import ceylon.time.base { ms = milliseconds }
import ceylon.time.timezone {
    timeZone,
    TimeZone
}



"Timezone offset parser based on ISO-8601, currently it accepts the following 
 time zone offset patterns:
 
 - &plusmn;`[hh]:[mm]`, 
 - &plusmn;`[hh][mm]`, and 
 - &plusmn;`[hh]`.
 
 In addition, the special code `Z` is recognized as a shorthand for `+00:00`"
shared TimeZone|ParserError parseTimeZone( String offset ) {
    variable State state = Initial();
    for( character in offset ) {
        state = state.next( Chunk( character ) );
    }
    state = state.next( eof );
    if ( is Final final = state ) {
        value result = final.evaluate();
        if ( result == 0 && offset.contains('-') ) {
            return ParserError("Pattern not allowed by ISO-8601: '``offset``'!");
        }
        return timeZone.offset{ hours=0; milliseconds=result; };
    }

    assert ( is Error error = state );
    return ParserError(error.message);
}


"Represents each element or the end of the parser"
abstract class Input() of Chunk | EOF {}

"Represents each character"
class Chunk( character ) extends Input() {
    shared Character character;
    shared actual Boolean equals( Object other ) {
        if ( is Character other ) {
            return this.character == other;
        }
        return false;
    }

    shared actual Integer hash {
        return character.hash;
    }
}

"Represents the end of the parser"
abstract class EOF() of eof extends Input() {}

"Singleton implementation to represent the end of the parser"
object eof extends EOF() {}

"All states available for the parser"
abstract class State() of Initial | Zulu | Sign | Hours | Minutes | Final | Error | Colon {

    "Each state is responsible to check if the next state is valid and call it"
    shared formal State next( Input input );

}

"Represents the init of the parser"
class Initial() extends State() {
    shared actual State next( Input input ) {
        switch( input )
        case ( is Chunk ) {
            if ( input == 'Z' ) {
                return Zulu();
            }
            if ( input == '+' ) {
                return Sign( +1 );
            }
            if ( input == '-' ) {
                return Sign( -1 );
            }
            return Error( "Unexpected character! Got '``input.character``' but expected: 'Z', '+' or '-'" );
        }
        case( is EOF ) {
            return Error( "Unexpected end of input! Empty time zone." );
        }
    }
}

"Represents the UTC"
class Zulu() extends State() {
    shared actual State next( Input input ) {
        switch( input )
        case ( is Chunk ) { return Error( "Unexpected character! Got '``input.character``' but expected end of input after 'Z'" ); }
        case ( is EOF ) { return Final(); }
    }
}

"Represents +1 case the time is ahead of UTC, otherwise its -1"
class Sign( Integer sign ) extends State() {
    shared actual State next( Input input ) {
        switch( input )
        case ( is Chunk ) {
            return input.character.digit 
                   then Hours( sign, characterToInteger( input.character ) )
                   else Error( "Unexpected character! Got '``input.character``' but expected a digit [0..9] after '``sign > 0 then "+" else "-"``'" ); 
        }
        case ( is EOF ) {
            return Error( "Unexpected end of input! Expecting a digit [0..9] after '``sign > 0 then "+" else "-"``'" );
        }
    }
}

"Represents the hours, the accepted pattern is two digit hours"
class Hours( Integer sign, hours, digits = 1 ) extends State() {
    Integer digits;
    Integer hours;
    shared actual State next( Input input ) {
        switch( input )
        case ( is Chunk ) {
            if( input.character.digit ) {
                return digits == 2 
                       then Minutes( sign, hours, characterToInteger(input.character) )	 
                       else Hours( sign, hours * 10 + characterToInteger(input.character), 2 );
            }
            else if ( input == ':' ) {
                return Colon( sign, hours );
            }
            else {
                return Error( "Unexpected character! Got '``input.character``' but expected a digit [0..9]" ); 
            }
        }
        case( is EOF ) {
            return digits == 2 
                   then Final( sign, hours ) 
                   else Error( "Unexpected end of input! Expected at two digits for hours but got one." );
        }
    }
    
}

"Represents the minutes, the accepted pattern is two digit minutes"
class Minutes( Integer sign, Integer hours, minutes, digits = 1 ) extends State() {
    Integer digits;
    Integer minutes;
    shared actual State next( Input input ) {
        switch( input )
        case ( is Chunk ) {
            if( input.character.digit ) {
                return digits == 2 
                        then Error( "Unexpected character! Got '``input.character``' but expected end of input" )	
                        else Minutes( sign, hours, minutes * 10 + characterToInteger(input.character), 2 );
            }
            else {
                return digits == 2 
                        then Error( "Unexpected character! Got '``input.character``' but expected end of input" )
                        else Error( "Unexpected character! Got '``input.character``' but expected a digit [0..9]" ); 
            }
        }
        case ( is EOF ) {
            return digits == 2 
                       then Final( sign, hours, minutes ) 
                       else Error( "Unexpected end of input! Expected two digits for minutes but got one." );
        }
    }

}

"Represents the colon as some patterns accepts for example 'hh:mm'"
class Colon( Integer sign, Integer hours ) extends State() {
    shared actual State next( Input input ) {
        switch( input )
        case ( is Chunk ) {
            return input.character.digit 
                   then Minutes( sign, hours, characterToInteger( input.character ) )
                   else Error( "Unexpected character! Got '``input.character``' but expected a digit [0..9] after ':'" ); 
        }
        case ( is EOF ) {
            return Error( "Unexpected end of input! Expecting a digit [0..9] after ':'" );
        }
    }
}

"Represents the parser successfully finished"
class Final( Integer sign = 1, Integer hours = 0, Integer minutes = 0 ) extends State() {
    shared actual State next(Input character) => this;
    shared Integer evaluate() {
        return sign * ( hours * ms.perHour + minutes * ms.perMinute );
    }
}

"Represents the parser unsuccessfully finished and hold the error message"
class Error( message ) extends State() {
    shared String message;
    shared actual State next( Input character ) => this;
}

Integer characterToInteger( Character digit ) {
    return digit.integer - '0'.integer; 
}
