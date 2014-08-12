import ceylon.time.base {
    DayOfWeek
}
import ceylon.time {
    Date
}

"Alias to represent a specific day."
shared alias DayOfMonth => Integer;

"Model to represent #Rule onDay.
 
 All the models are intended to be unrelated of the database.
 "
shared abstract class OnDayRule() of OnFixedDayRule | OnFirstOfMonthRule | OnLastOfMonthRule {

    "True, if the provided date matches the given rule"
    shared formal Boolean matches(Date date);
    
}

"Represents a fixed day without any other rule, for example:
 * 3
 * 15
 * 30
 
 All them without day of week and comparison.
 
   P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class OnFixedDayRule(fixedDate) extends OnDayRule() {
    shared DayOfMonth fixedDate;
    
    shared actual Boolean equals(Object other) {
        if(is OnFixedDayRule other) {
            return fixedDate == other.fixedDate;
        }
        return false;
    }
    
    shared actual Boolean matches(Date date) {
        return date.day >= fixedDate;
    }
    
}

"Represents a day equal or higher than a day of week, for example:
 * Sun>=1
 * Sun>=9
 * Sat>=25
 
   P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class OnFirstOfMonthRule(dayOfWeek, onDateOrAfter) extends OnDayRule() {
    
    shared DayOfWeek dayOfWeek;
    shared DayOfMonth onDateOrAfter;
    
    shared actual Boolean equals(Object other) {
        if(is OnFirstOfMonthRule other) {
            return         onDateOrAfter == other.onDateOrAfter
                    &&     dayOfWeek == other.dayOfWeek;
        }
        return false;
    }
    shared actual Boolean matches(Date date) {
        value result = findFirstOfMonth(dayOfWeek, onDateOrAfter, date);
        if( exists result ){
            return date >= result;
        }
        return false;
    }
    
    Date? findFirstOfMonth(DayOfWeek dow, DayOfMonth day, Date date) {
        Boolean matchesDayOfWeekAndDay(Date dateTime) {
            return         dateTime.day >= day
                    &&     dateTime.dayOfWeek == dow;
        }
        
        return date.withDay(1).rangeTo(date.withDay(date.month.numberOfDays())).find(matchesDayOfWeekAndDay);
    }
    
}

"Represents the last day of week, for example:
 * lastSun
 * lastSat
 
   P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class OnLastOfMonthRule(dayOfWeek) extends OnDayRule() {
    
    shared DayOfWeek dayOfWeek;
    
    shared actual Boolean equals(Object other) {
        if(is OnLastOfMonthRule other) {
            return dayOfWeek == other.dayOfWeek;
        }
        return false;
    }
    shared actual Boolean matches(Date date) {
        return date >= findLastOfMonth(dayOfWeek, date);
    }
    
    Date findLastOfMonth(DayOfWeek dow, Date date) {
        Date? result =
                date.withDay(1).rangeTo(date.withDay(date.month.numberOfDays()))
                .findLast((Date element) => element.dayOfWeek == dow);
        assert(exists result);
        
        return result;
    }
    
}
