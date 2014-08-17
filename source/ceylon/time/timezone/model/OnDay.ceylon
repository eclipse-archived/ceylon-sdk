import ceylon.time.base {
    DayOfWeek,
	Month
}
import ceylon.time {
    Date,
	date
}

"Alias to represent a specific day."
shared alias DayOfMonth => Integer;

shared abstract class OnDay() of OnFixedDay | OnFirstOfMonth | OnLastOfMonth {

    "True, if the provided date matches the given rule"
    shared formal Boolean matches(Date date);
    
}

"Represents a fixed day without any other rule, for example:
 * 3
 * 15
 * 30
 
 All them without day of week and comparison."
shared class OnFixedDay(fixedDate) extends OnDay() {
    shared DayOfMonth fixedDate;
    
    shared actual Boolean equals(Object other) {
        if(is OnFixedDay other) {
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
 * Sat>=25"
shared class OnFirstOfMonth(dayOfWeek, onDateOrAfter) extends OnDay() {
    
    shared DayOfWeek dayOfWeek;
    shared DayOfMonth onDateOrAfter;
    
    shared actual Boolean equals(Object other) {
        if(is OnFirstOfMonth other) {
            return         onDateOrAfter == other.onDateOrAfter
                    &&     dayOfWeek == other.dayOfWeek;
        }
        return false;
    }
    
    shared actual Boolean matches(Date date) {
        value result = firstOfMonth(date.year, date.month);
        return date >= result;
    }
    
    shared Date firstOfMonth(Year year, Month month) {
        Boolean matchesDayOfWeekAndDay(Date dateTime) {
            return         dateTime.day >= onDateOrAfter
                    &&     dateTime.dayOfWeek == dayOfWeek;
        }
        
        value initial = date(year, month, 1);
        
        "onDateOrAfter should always be a valid day for the month"
        assert(exists result = initial.rangeTo(initial.withDay(month.numberOfDays(initial.leapYear))).find(matchesDayOfWeekAndDay));
        return result;
    }
    
}

"Represents the last day of week, for example:
 * lastSun
 * lastSat"
shared class OnLastOfMonth(dayOfWeek) extends OnDay() {
    
    shared DayOfWeek dayOfWeek;
    
    shared actual Boolean equals(Object other) {
        if(is OnLastOfMonth other) {
            return dayOfWeek == other.dayOfWeek;
        }
        return false;
    }
    shared actual Boolean matches(Date date) {
        return date >= lastOfMonth(date.year, date.month);
    }
    
    shared Date lastOfMonth(Year year, Month month) {
        value initial = date(year, month, 1);

        Date? result =
                initial.rangeTo(initial.withDay(initial.month.numberOfDays(initial.leapYear)))
                .findLast((Date element) => element.dayOfWeek == dayOfWeek);
        assert(exists result);
        
        return result;
    }
    
}
