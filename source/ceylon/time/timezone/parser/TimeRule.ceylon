import ceylon.time {
    Time
}

"Model that represents the TimeRule from #Rule, it takes the token/string and
 parse it as Time and Signal values.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class TimeRule(String token) {
    
    variable [Time, Signal] result = parseTime(token);
    
    shared Time time = result[0];
    shared Integer signal = result[1];
    
    shared actual Boolean equals(Object other) {
        if(is TimeRule other) {
            return         time == other.time 
                    &&     signal == other.signal;
        }
        return false;
    }
    
}