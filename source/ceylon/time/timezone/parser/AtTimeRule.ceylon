import ceylon.time {
    Time
}

"Model that represents the TimeRule from #Rule.
 
 All the models are intended to be unrelated of the database.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class AtTimeRule(time, timeDefinition) {
    
    shared Time time;
    shared AtTimeRuleDefinition timeDefinition;
    
    shared actual Boolean equals(Object other) {
        if(is AtTimeRule other) {
            return time == other.time 
                   && timeDefinition == other.timeDefinition;
        }
        return false;
    }
    
}

"First, the time that something happens (in the AT column) is not necessarily the local wall clock time. 
 
 The time can be suffixed with ‘s’ (for “standard”) to mean local standard time (different from wall clock time when observing daylight saving time); 
 or it can be suffixed with ‘g’, ‘u’, or ‘z’, all three of which mean the standard time at the prime meridan. 
 ‘g’ stands for “GMT”; 
 ‘u’ stands for “UT” or “UTC” (whichever was official at the time); 
 ‘z’ stands for the nautical time zone Z (a.k.a. “Zulu” which, in turn, stands for ‘Z’). 
 The time can also be suffixed with ‘w’ meaning “wall clock time;” 
 but it usually isn’t because that’s the default."
shared abstract class AtTimeRuleDefinition() 
        of   StandardTimeDefinition | GmtTimeDefinition | UtcTimeDefinition 
           | ZuluTimeDefinition | WallClockDefinition {
}

shared class StandardTimeDefinition() extends AtTimeRuleDefinition(){}
shared class GmtTimeDefinition() extends AtTimeRuleDefinition(){}
shared class UtcTimeDefinition() extends AtTimeRuleDefinition(){}
shared class ZuluTimeDefinition() extends AtTimeRuleDefinition(){}
shared class WallClockDefinition() extends AtTimeRuleDefinition(){}

shared object standardTimeDefinition extends StandardTimeDefinition(){}
shared object gmtTimeDefinition extends StandardTimeDefinition(){}
shared object utcTimeDefinition extends StandardTimeDefinition(){}
shared object zuluTimeDefinition extends StandardTimeDefinition(){}
shared object wallClockDefinition extends StandardTimeDefinition(){}
