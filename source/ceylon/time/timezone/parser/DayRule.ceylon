import ceylon.time.base {
    DayOfWeek
}
import ceylon.collection {

    StringBuilder
}

"Alias to represent a specific day."
shared alias Day => Integer;

"Model that represents the DayRule from #Rule, it takes the token/string and
 parse it as Day, DayOfWeek and Comparison values.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class DayRule(String token) {

    variable [Day?, DayOfWeek?, Comparison] result = [null,null, equal];
    if (token.startsWith("last")) {
        result = [null, findDayOfWeek(token.spanFrom(4)), larger];
    } else {
        value gtIdx = token.firstInclusion(">=");
        value stIdx = token.firstInclusion("<=");
        if (exists gtIdx , gtIdx > 0) {
            result = [parseInteger(token.spanFrom(gtIdx + 2).trimmed), findDayOfWeek(token.span(0, gtIdx -1)), larger];
        } else if( exists stIdx, stIdx > 0) {
            result = [parseInteger(token.spanFrom(stIdx + 2)), findDayOfWeek(token.span(0, stIdx-1)), smaller];
        } else {
            result = [parseInteger(token), null, equal];
        }
    }
    
    shared Day? day = result[0];
    shared DayOfWeek? dayOfWeek = result[1];
    shared Comparison comparison = result[2];
    
    shared actual Boolean equals(Object other) {
        if(is DayRule other) {
            variable value days = equalWithNull(day, other.day);
            variable value daysOfWeek = equalWithNull(day, other.day);
            
            return days && daysOfWeek && (comparison == other.comparison);
        }
        return false;
    }
    
    Boolean equalWithNull(DayOfWeek|Day? first, DayOfWeek|Day? second) {
        if(exists first, exists second) {
            return first == second;
        } 
        
        if(! first exists && ! second exists) {
            return true;
        }
        
        return false;
    }
    
    shared actual String string {
        return StringBuilder()
                .append("day: ``day else "null"``,")
                .append(", dayOfWeek: ``dayOfWeek else "null"``")
                .append(", comparison: ``comparison.string``")
                .string;
    }

}