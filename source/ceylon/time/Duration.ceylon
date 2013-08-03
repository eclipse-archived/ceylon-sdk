import ceylon.time.base { ReadableDuration }

"Duration specifies a discreet amount of milliseconds between two instances of time."
shared class Duration(milliseconds) satisfies ReadableDuration {

    "Number of milliseconds of this duration."
    shared actual Integer milliseconds;

    "Returns this duration as a period of milliseconds."
    shared Period period => Period { milliseconds = milliseconds; }; 

    "Returns the string representation of this duration."
    shared actual String string => "``milliseconds``ms";

    "Duration is considered equal when type and milliseconds are the same."
    shared actual Boolean equals( Object other ) {
        if ( is Duration other ) {
            return milliseconds == other.milliseconds;
        }
        return false;
    }
}
