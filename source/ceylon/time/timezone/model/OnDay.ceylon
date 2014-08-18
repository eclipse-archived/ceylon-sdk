import ceylon.time.base {
    DayOfWeek,
    Month
}
import ceylon.time {
    Date,
    newDate = date
}
import ceylon.time.chronology {
	gregorian
}

"Alias to represent a specific day."
shared alias DayOfMonth => Integer;

shared abstract class OnDay() of OnFixedDay | OnFirstOfMonth | OnLastOfMonth {
    
    shared formal Date date(Year year, Month month);
    
}

"Represents a fixed day without any other rule, for example:
 * 3
 * 15
 * 30"
shared class OnFixedDay(fixedDate) extends OnDay() {
    shared DayOfMonth fixedDate;
    
    shared actual Boolean equals(Object other) {
        if(is OnFixedDay other) {
            return fixedDate == other.fixedDate;
        }
        return false;
    }
    
    shared actual Date date(Year year, Month month) {
        return newDate(year, month, fixedDate);
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
    
    shared actual Date date(Year year, Month month) {
        value initial = newDate(year, month, onDateOrAfter);
        
        "onDateOrAfter should always be a valid day for the month"
        assert(exists result = initial.rangeTo(initial.withDay(month.numberOfDays(initial.leapYear))).find(matchesDayOfWeekAndDay));
        return result;
    }
    
    Boolean matchesDayOfWeekAndDay(Date dateTime) {
        return         dateTime.day >= onDateOrAfter
                &&     dateTime.dayOfWeek == dayOfWeek;
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
    shared actual Date date(Year year, Month month) {
        value initial = newDate(year, month, month.numberOfDays(gregorian.leapYear(year)));
        
        Date? result =
                initial.rangeTo(initial.withDay(1))
                .find((Date element) => element.dayOfWeek == dayOfWeek);
        assert(exists result);
        
        return result;
    }

}