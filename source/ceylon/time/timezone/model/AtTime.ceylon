import ceylon.time {
    Time
}

shared class AtTime(time, timeDefinition) {
    
    shared Time time;
    shared AtTimeDefinition timeDefinition;
    
    shared actual Boolean equals(Object other) {
        if(is AtTime other) {
            return time == other.time 
                    && timeDefinition == other.timeDefinition;
        }
        return false;
    }
    
    string => "time: '``time``', timeDefinition: '``timeDefinition``'";
    
}

"First, the time that something happens (in the AT column) is not necessarily the local wall clock time. 
 
 The time can be suffixed with ‘s’ (for “standard”) to mean local standard time (different from wall clock time when observing daylight saving time); 
 or it can be suffixed with ‘g’, ‘u’, or ‘z’, all three of which mean the standard time at the prime meridan. 
 ‘g’ stands for “GMT”; 
 ‘u’ stands for “UT” or “UTC” (whichever was official at the time); 
 ‘z’ stands for the nautical time zone Z (a.k.a. “Zulu” which, in turn, stands for ‘Z’). 
 The time can also be suffixed with ‘w’ meaning “wall clock time;” 
 but it usually isn’t because that’s the default.
 
 All the models are intended to be unrelated of the database origin.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared abstract class AtTimeDefinition() 
        of   standardTimeDefinition | utcTimeDefinition | wallClockDefinition {
}

shared object standardTimeDefinition extends AtTimeDefinition(){}
shared object utcTimeDefinition extends AtTimeDefinition(){}
shared object wallClockDefinition extends AtTimeDefinition(){}
