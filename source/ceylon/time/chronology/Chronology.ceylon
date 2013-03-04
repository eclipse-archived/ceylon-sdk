import ceylon.time.base { days, ms=milliseconds, years }
import ceylon.time.math { floor, fdiv=floorDiv, mod=floorMod }

doc "Converts _Rata Die_ day number to a fixed date value.
     
     _Rata Die_ is fixed at Monday, January 1st, 1. (Gregorian)."
shared Integer rd( Integer t ) {
    value epoch = 0; // origin of all calculations
    return t - epoch;
}

shared object unixTime {

    doc "Fixed date value of the _Unix time_ epoch (1970-01-01)"
    shared Integer epoch = gregorian.fixedFrom([1970, 1, 1]);

    doc ""
    shared Integer epochTime = epoch * ms.perDay;

    doc "Returns a _fixed date_ from the _unix time_ value."
    shared Integer fixedFromTime(Integer time) {
        return fdiv(time, ms.perDay) + epoch;
    }

    "Return milliseconds elapsed from 1970-01-01 00:00:00"
    shared Integer timeFromFixed( Integer date ) {
        return (date - epoch) * ms.perDay;
    }

    shared Integer timeOfDay( Integer time ) {
        return mod(time, ms.perDay);
    }
}

doc "Generic base interface of a _calendar system_.
     Chronology serves as a computational backend to 
     a Date representation of the same calendar system."
shared interface Chronology<Fields>
       given Fields satisfies Anything[] {
    
    doc "Epoch is the offset of the _fixed date_ day number that defines 
         the beginning of the calendar."
    shared formal Integer epoch;

    doc "Converts date tuple of this calendar system to an equivalent _fixed date_
         representation of the "
    shared formal Integer fixedFrom( Fields date );
    
    doc "Converts a _fixed day_ number to a calendar date tuple"
    shared formal Fields dateFrom( Integer fixed );

    doc "Validate the given date"
    shared formal void checkDate( Fields date );
    
}

doc "An interface for calendar system that defines leap year rules.
     
     *Note:* This interface is meant to convey a Calendar that has some sort of leap year syntax"
shared interface LeapYear<Self, Fields> of Self
       given Self satisfies Chronology<Fields>
       given Fields satisfies Anything[] {
    
    doc "Returns true if the specified year is a leap year according to the leap year rules of the"
    shared formal Boolean leapYear( Integer leapYear );
    
}

doc "Base class for a gregorian calendar chronology."
abstract shared class GregorianCalendar() of gregorian
         satisfies Chronology<[Integer, Integer, Integer]>
                 & LeapYear<GregorianCalendar, [Integer, Integer, Integer]> {
    
}

doc "Represents the implementation of all calculations for
     the rules based on Gregorian Calendar"
shared object gregorian extends GregorianCalendar() {
    
    doc "Epoch of the gregorian calendar"
    shared actual Integer epoch = rd(1);
    
    shared Integer january = 1;
    shared Integer february = 2;
    shared Integer march = 3;
    shared Integer april = 4;
    shared Integer may = 5;
    shared Integer june = 6;
    shared Integer july = 7;
    shared Integer august = 8;
    shared Integer september = 9;
    shared Integer october = 10;
    shared Integer november = 11;
    shared Integer december = 12;
    
    doc "Gregorian leap year rule states that every fourth year
         is a leap year except cenury years not divisible by 400."
    shared actual Boolean leapYear(Integer year) {
        return (year % 100 == 0) then year % 400 == 0
                                 else year % 4 == 0;
    }
    
    Integer fixed(Integer year, Integer month, Integer day) {
        return epoch - 1 + 365 * (year - 1) + floor((year - 1) / 4.0)
               - floor((year - 1) / 100.0) + floor((year - 1) / 400.0)
               + floor((367 * month - 362) / 12.0)
               + ((month > 2) then (leapYear(year) then -1 else -2) else 0)
               + day;
    }
    
    shared actual Integer fixedFrom([Integer, Integer, Integer] date) {
        return unflatten(fixed)(date);
    }
    
    shared actual void checkDate([Integer, Integer, Integer] date) {
        "Invalid year value"
        assert(years.minimum <= date[0] && date[0] <= years.maximum);
        
        "Invalid date value"
        assert( date == dateFrom( fixedFrom(date) ) );
    }
    
    doc "Returns fixed date value of the first day of the gregorian year."
    shared Integer newYear(Integer year){
        return fixed(year, january, 1);
    }
    
    doc "Returns fixed date value of the last day of the gregorian year."
    shared Integer yearEnd(Integer year){
        return fixed(year, december, 31);
    }
    
    doc "Returns a gregorian year number of the fixed date value."
    shared Integer yearFrom(Integer fixed) {
        value d0 = fixed - epoch;
        value n400 = fdiv(d0, days.perFourCenturies);
        value d1 = mod(d0, days.perFourCenturies);
        value n100 = fdiv(d1, days.perCentury);
        value d2 = mod(d1, days.perCentury);
        value n4 = fdiv(d2, days.inFourYears);
        value d3 = mod(d2, days.inFourYears);
        value n1 = fdiv(d3, days.perYear());
        value year = 400 * n400 + 100 * n100 + 4 * n4 + n1;
        return (n100 == 4 || n1 == 4) then year else year + 1;
    }
    
    doc "Converts the fixed date value to an equivalent gregorian date"
    shared actual [Integer, Integer, Integer] dateFrom(Integer date) {
        value year = yearFrom(date);
        value priorDays = date - newYear(year);
        value correction = (date < fixed(year, march, 1)) 
                then 0 else (leapYear(year) then 1 else 2);
        value month = fdiv(12 * (priorDays + correction) + 373, 367);
        value day = 1 + date - fixed(year, month, 1);
        return [year, month, day];
    }
    
    doc "Retunrs the month number of the gregorian calendar from the fixed date value."
    shared Integer monthFrom(Integer date){
        return dateFrom(date)[1];
    }
    
    doc "Returns day of month value of the fixed date value."
    shared Integer dayFrom(Integer date){
        return dateFrom(date)[2];
    }
    
    doc "Returns _day of week_ value for the specified fixed date value."
    shared Integer dayOfWeekFrom(Integer date) {
        return mod(date, 7);
    }
    
}
