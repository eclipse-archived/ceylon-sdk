import ceylon.language { Integer }
import ceylon.time { Date, DateTime, Time }
import ceylon.time.base { DayOfWeek, weekdayOf=dayOfWeek, monthOf, Month, days, january, sunday, ReadableDatePeriod }
import ceylon.time.chronology { impl=gregorian }
import ceylon.time.math { adjustedMod }


"Default implementation of a gregorian calendar"
shared class GregorianDate( Integer dayOfEra ) 
      extends AbstractDate( dayOfEra ) {

    "Returns year of this gregorian date."
    shared actual Integer year => impl.yearFrom( dayOfEra );

    "Returns month of this gregorian date"
    shared actual Month month => monthOf(impl.monthFrom( dayOfEra ));

    "Returns _day of month_ value of this gregorian date"
    shared actual Integer day => impl.dayFrom( dayOfEra );

    "Returns `true`, if this is a leap year according to gregorian calendar leap year rules."
    shared actual Boolean leapYear => impl.leapYear( year );

    "Returns _day of year_ value of this gregorian date."
    shared actual Integer dayOfYear => month.fisrtDayOfYear( leapYear ) + day - 1;

    "Returns gregorian date immediately preceeding this date."
    shared actual GregorianDate predecessor => minusDays( 1 );

    "Returns gregorian date immediately succeeding this date."
    shared actual GregorianDate successor => plusDays( 1 );

    "Returns current day of the week."
    shared actual DayOfWeek dayOfWeek => weekdayOf(impl.dayOfWeekFrom( dayOfEra ));

    "Adds number of days to this date and returns the resulting date."
    shared actual GregorianDate plusDays(Integer days) {
        if ( days == 0 ) {
            return this;
        }
        return GregorianDate( dayOfEra + days );
    }

    "Subtracts number of days from this date and returns the resulting date."
    shared actual GregorianDate minusDays(Integer days) => plusDays(-days);

    "Adds number of weeks to this date and returns the resulting date."
    shared actual GregorianDate plusWeeks(Integer weeks) => plusDays( weeks * days.perWeek );

    "Subtracts number of weeks from this date and returns the resulting date."
    shared actual GregorianDate minusWeeks(Integer weeks) => plusWeeks( -weeks );

    "Adds number of months to this date and returns the resulting date.
     
     **Note:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2013, 1, 31).plusMonths(1)` will return
     `2013-02-28`, since _February 2013_ has only 28 days.
     "
    shared actual GregorianDate plusMonths(Integer months) {
        if ( months == 0 ) {
            return this;
        }

        value o = month.add(months);
        value newYear = year + o.years;

        impl.checkDate([newYear, o.month.integer, day]);
        return GregorianDate( impl.fixedFrom([newYear, o.month.integer, day]) );
    }

    "Subtracts number of months from this date and returns the resulting date.
     
     **Note:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2013, 3, 30).minusMonths(1)` will return
     `2013-02-28`, since _February 2013_ has only 28 days.
     "
    shared actual GregorianDate minusMonths(Integer months) => plusMonths(-months);

    "Adds number of years to this date returning the resulting gregorian date.
     
     **Note:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2012, 2, 29).plusYears(1)` will return
     `2013-02-28`, since _February 2013_ has only 28 days.
     "
    shared actual GregorianDate plusYears(Integer years) {
        if ( years == 0 ) {
            return this;
        }

        return withYear( year + years );
    }

    "Subtracts number of years from this date returning the resulting the new gregorian date.
     
     **Note:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2012, 2, 29).minusYears(1)` will return
     `2011-02-28`, since _February 2011_ has only 28 days.
     "
    shared actual GregorianDate minusYears(Integer years) => plusYears(-years);

    "Returns new date with the _day of month_ vaue set to the specified value.
     
     Resulting date will have to be valid Gregorian date.
     "
    shared actual GregorianDate withDay(Integer day) {
        if ( day == this.day ) {
            return this;
        }
        impl.checkDate([year,month.integer,day]);
        return GregorianDate( dayOfEra - this.day + day);
    }

    "Returns new date with the month set to the specified value.
     
     Resulting date will have to be valid Gregorian date.
     "
    shared actual GregorianDate withMonth(Month month) {
        Month newMonth = monthOf(month);
        if ( newMonth == this.month ) {
            return this;
        }

        impl.checkDate([year,newMonth.integer,day]);
        return GregorianDate( impl.fixedFrom([year, newMonth.integer, day]) );
    }

    "Returns new date with the specified year value.
     
     Resulting date will have to be valid Gregorian date.
     "
    shared actual GregorianDate withYear(Integer year) {
        if ( year == this.year ) {
            return this;
        }

        impl.checkDate([year,month.integer,day]);
        return GregorianDate( impl.fixedFrom([year, month.integer, day]) );
    }

    "Adds specified date period to this date and returns the new date."
    shared actual GregorianDate plus( ReadableDatePeriod amount ) {
        return plusYears( amount.years )
              .plusMonths( amount.months )
              .plusDays( amount.days );
    }

    "Subtracts specified date period from this date and returns the new date."
    shared actual GregorianDate minus( ReadableDatePeriod amount ) {
        return minusYears( amount.years )
              .minusMonths( amount.months )
              .minusDays( amount.days );
    }

    "Returns week of year according to ISO 8601 week number calculation rules."
    shared actual Integer weekOfYear {
        value weekFromYearBefore = 0;
        value possibleNextYearWeek = 53;

        //TODO: Simplify this method (and move it to gregorian chronology?)
        function normalizeFirstWeek( Integer weekNumber ) {
            variable value result = weekNumber;
            value jan1 = withDay(1).withMonth(january);
            value jan1WeekDay = jan1.dayOfWeek == sunday then 7 else jan1.dayOfWeek.integer; 
            if ( ( dayOfYear <= ( 8 - jan1WeekDay ) ) && jan1WeekDay > 4 ) {
                if ( jan1WeekDay == 5 || (jan1WeekDay == 6 && minusYears(1).leapYear)) {
                    result = 53;
                } else {
                    result = 52;
                }
            }
            return result;
        }

        function normalizeLastWeek( Integer weekNumber ) {
            variable value result = weekNumber;
            value weekDay = adjustedMod(dayOfWeek.integer, 7); 
            value totalDaysInYear = leapYear then 366 else 365;
            if (( totalDaysInYear - dayOfYear) < (4 - weekDay) ) {
                result = 1;
            }
            return result;
        }

        value dayOfWeekNumber = adjustedMod(dayOfWeek.integer, 7);
        variable value weekNumber = ( dayOfYear - dayOfWeekNumber + 10 ) / 7;

        if ( weekNumber == weekFromYearBefore ) {
            weekNumber = normalizeFirstWeek( weekNumber );
        }
        else if ( weekNumber == possibleNextYearWeek ) {
            weekNumber = normalizeLastWeek( weekNumber );
        }

        return weekNumber;
    }

    "Returns new [[DateTime]] value."
    shared actual DateTime at(Time time) {
        return GregorianDateTime(this, time);
    }

    "Returns ISO 8601 formatted String representation of this date."
    shared actual String string {
        return "``year``-``leftPad(month.integer)``-``leftPad(day)``";	
    }
}

"Returns a gregorian calendar date according to the specified year, month and date values"
shared Date gregorianDate(year, month, day){
        "Year number of the date"
        Integer year;
        
        "Month of the year"
        Integer|Month month; 
        
        "Day of month"
        Integer day;
 
    impl.checkDate([year, monthOf(month).integer, day]);       
    return GregorianDate( impl.fixedFrom([year, monthOf(month).integer, day]) );
}