import ceylon.time.chronology { gregorian }
import ceylon.time.math { mod=floorMod, fdiv=floorDiv }

"A month in a Gregorian or Julian calendar system."
shared abstract class Month(integer)
       of january | february | march | april | may | june | july | august | september | october | november | december
       satisfies Ordinal<Month> & Comparable<Month>{

        "Ordinal number of the month of year.
         Where:
            january  = 1
            february = 2
            ...
            december = 12"
        shared Integer integer;

    "Returns number of days in this month"
    shared default Integer numberOfDays(Boolean leapYear = false) {
        switch(this)
        case (february) { return leapYear then 29 else 28; }
        case (april,june,september,november) { return 30; } 
        case (january,march,may,july,august,october,december) { return 31; }
    }

    "Returns the _day of year_ value for first of this month"
    shared default Integer fisrtDayOfYear(Boolean leapYear = false){
        assert(exists day = firstDayOfMonth[this.integer-1]);
        if (leapYear && this > february){
            return day + 1;
        }
        return day;
    }

    "Compares ordinal numbers of two instances of `Month`"
    shared actual Comparison compare(Month other)
        => integer.compare(other.integer);

    "Returns month of year that comes specified number of months after this month."
    shared Month plusMonths(Integer number)
        => (number == 0) then this else add(number).month;

    "Returns month of year that comes specified number of months before this month."
    shared Month minusMonths(Integer number) 
        => (number == 0) then this else add(-number).month;

    "A result of adding or subtracting a month to another mont"
    shared class Overflow(month, years){
        "New month value"
        shared Month month;
        
        "Number of years overflowed by calculation"
        shared Integer years;
    }
    
    "Adds number of months to this month and returns the result of 
     as new month value and."
    shared Overflow add(Integer numberOfMonths){
        value next = (integer - 1 + numberOfMonths);
        value nextMonth = mod(next, months.perYear);
        assert (exists month = months.all[nextMonth]);
        
        Integer years = fdiv(next, 12);
        return Overflow(month, years); 
    }
}

"Table of _day of year_ values for the first day of each month"
Integer[] firstDayOfMonth = [1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335];

"Returns month of year specified by the input argument.
 
 If input is an Integer, this method returns a month according to the integer 
 value of the [[MonthOfYear]] (i.e. 1=[[january]], 2=[[february]], ... 12=[[december]])
 Any invalid values will throw an exception.
 
 If the imput value is a [[MonthOfYear]], the input value is returned as is."
shared Month monthOf(Integer|Month month){
    switch (month)
    case (is Month) { return month; }
    case (is Integer) {
        "Invalid month, it should be xx,zz,yy"//TODO: How to use string template?
        assert ( january.integer <= month && month <= december.integer );
        assert ( exists m = months.all[month-1] );
        return m;
    }
}

"January. The first month of a gregorian calendar system."
shared object january extends Month(gregorian.january) {
    shared actual String string = "january";
    shared actual Month predecessor { return december; }  
    shared actual Month successor { return february; }
}

"February. The second month of a gregorian calendar system."
shared object february extends Month(gregorian.february) {
    shared actual String string = "february";
    shared actual Month predecessor { return january; }  
    shared actual Month successor { return march; }
}

"March. The third month of a gregorian calendar system."
shared object march extends Month(gregorian.march) {
    shared actual String string = "march";
    shared actual Month predecessor { return february; }  
    shared actual Month successor { return april; }
}

"April. The fourth month of a gregorian calendar system."
shared object april extends Month(gregorian.april) {
    shared actual String string = "april";
    shared actual Month predecessor { return march; }  
    shared actual Month successor { return may; }
}

"May. The fifth month of a gregorian calendar system."
shared object may extends Month(5) {
    shared actual String string = "may";
    shared actual Month predecessor { return april; }  
    shared actual Month successor { return june; }
}

"June. The sixth month of a gregorian calendar system."
shared object june extends Month(gregorian.june) {
    shared actual String string = "june";
    shared actual Month predecessor { return may; }
    shared actual Month successor { return july; }
}

"July. The seventh month of a gregorian calendar system."
shared object july extends Month(gregorian.july) {
    shared actual shared actual String string = "july";
    shared actual Month predecessor { return june; }  
    shared actual Month successor { return august; }
}

"August. The eigth month of a gregorian calendar system."
shared object august extends Month(gregorian.august) {
    shared actual shared actual String string = "august";
    shared actual Month predecessor { return july; }  
    shared actual Month successor { return september; }
}

"September. The nineth month of a gregorian calendar system."
shared object september extends Month(gregorian.september) {
    shared actual shared actual String string = "september";
    shared actual Month predecessor { return august; }  
    shared actual Month successor { return october; }
}

"October. The tenth month of a gregorian calendar system."
shared object october extends Month(gregorian.october) {
    shared actual shared actual String string = "october";
    shared actual Month predecessor { return september; }  
    shared actual Month successor { return november; }
}

"November. The eleventh month of a gregorian calendar system."
shared object november extends Month(gregorian.november) {
    shared actual shared actual String string = "november";
    shared actual Month predecessor { return october; }  
    shared actual Month successor { return december; }
}

"December. The twelveth (last) month of a gregorian calendar system."
shared object december extends Month(gregorian.december) {
    shared actual shared actual String string = "december";
    shared actual Month predecessor { return november; }  
    shared actual Month successor { return january; }
}
