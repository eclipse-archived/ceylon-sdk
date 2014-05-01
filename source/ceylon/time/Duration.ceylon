import ceylon.time.base { ReadableDuration }

"Duration specifies a discreet amount of milliseconds between two instances of time."
shared class Duration(milliseconds) satisfies ReadableDuration & Scalable<Integer, Duration> {

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
    
    "This implementation respect the constraint that if `x==y` then `x.hash==y.hash`."
    shared actual Integer hash {
        value prime = 11;
        value result = 3;
        return prime * result + milliseconds.hash;
    }

    "Returns a new [[Duration]] with it´s milliseconds scaled."
    shared actual Duration scale(Integer scale) => Duration( scale * milliseconds );
    
}
