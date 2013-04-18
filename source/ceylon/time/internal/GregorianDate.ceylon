import ceylon.time { Date, DateTime, Time, Period }
import ceylon.time.base { DayOfWeek, weekdayOf=dayOfWeek, monthOf, Month, days, january, sunday, ReadableDatePeriod, february, months}
import ceylon.time.chronology { impl=gregorian }
import ceylon.time.internal.math { adjustedMod }


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
    shared actual Date predecessor => minusDays( 1 );

    "Returns gregorian date immediately succeeding this date."
    shared actual Date successor => plusDays( 1 );

    "Returns current day of the week."
    shared actual DayOfWeek dayOfWeek => weekdayOf(impl.dayOfWeekFrom( dayOfEra ));

    "Adds number of days to this date and returns the resulting date."
    shared actual Date plusDays(Integer days) {
        if ( days == 0 ) {
            return this;
        }
        return GregorianDate( dayOfEra + days );
    }

    "Subtracts number of days from this date and returns the resulting date."
    shared actual Date minusDays(Integer days) => plusDays(-days);

    "Adds number of weeks to this date and returns the resulting date."
    shared actual Date plusWeeks(Integer weeks) => plusDays( weeks * days.perWeek );

    "Subtracts number of weeks from this date and returns the resulting date."
    shared actual Date minusWeeks(Integer weeks) => plusWeeks( -weeks );

    "Adds number of months to this date and returns the resulting date.
     
     **Note:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2013, 1, 31).plusMonths(1)` will return
     `2013-02-28`, since _February 2013_ has only 28 days.
     "
    shared actual Date plusMonths(Integer months) {
        if ( months == 0 ) {
            return this;
        }

        value o = month.add(months);
        value newYear = year + o.years;

        value monthDay = monthOf(o.month.integer).numberOfDays(impl.leapYear(newYear));
        return GregorianDate( impl.fixedFrom([newYear, o.month.integer, min([monthDay, day])]) );
    }

    "Subtracts number of months from this date and returns the resulting date.
     
     **Note:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2013, 3, 30).minusMonths(1)` will return
     `2013-02-28`, since _February 2013_ has only 28 days.
     "
    shared actual Date minusMonths(Integer months) => plusMonths(-months);

    "Adds number of years to this date returning the resulting gregorian date.
     
     **Note:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2012, 2, 29).plusYears(1)` will return
     `2013-02-28`, since _February 2013_ has only 28 days.
     "
    shared actual Date plusYears(Integer years) {
        if ( years == 0 ) {
            return this;
        }
        value newDay = day == 29 && month == february then 28 else day;
        return GregorianDate(impl.fixedFrom([year + years, month.integer, newDay] ));
    }

    "Subtracts number of years from this date returning the resulting the new gregorian date.
     
     **Note:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2012, 2, 29).minusYears(1)` will return
     `2011-02-28`, since _February 2011_ has only 28 days.
     "
    shared actual Date minusYears(Integer years) => plusYears(-years);

    "Returns new date with the _day of month_ vaue set to the specified value.
     
     Resulting date will have to be valid Gregorian date.
     "
    shared actual Date withDay(Integer day) {
        if ( day == this.day ) {
            return this;
        }
        impl.checkDate([year,month.integer,day]);
        return GregorianDate( dayOfEra - this.day + day);
    }

    "Returns new date with the month set to the specified value.
     
     Resulting date will have to be valid Gregorian date.
     "
    shared actual Date withMonth(Month month) {
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
    shared actual Date withYear(Integer year) {
        if ( year == this.year ) {
            return this;
        }

        impl.checkDate([year,month.integer,day]);
        return GregorianDate( impl.fixedFrom([year, month.integer, day]) );
    }

    "Adds specified date period to this date and returns the new date."
    shared actual Date plus( ReadableDatePeriod amount ) {
        return addPeriod {
                months = amount.years * months.perYear + amount.months;
                days = amount.days; 
        };
    }

    "Subtracts specified date period from this date and returns the new date."
    shared actual Date minus( ReadableDatePeriod amount ) {
        return addPeriod {
                months = amount.years.negativeValue * months.perYear + amount.months.negativeValue;
                days = amount.days.negativeValue; 
        };
    }

    "This method add the specified fields doing first the subtraction and last the additions.
     The mix between positive and negative fields does not guarantee any expected behavior"
    Date addPeriod( Integer months, Integer days ) {
        variable Date _this = this;
        //do all subtractions first
        if ( days < 0 ) {
            _this = _this.minusDays(days.negativeValue);
        } 
        if ( months < 0 ) {
            _this = _this.minusMonths(months.negativeValue);
        }
        
        //now we should do all additions
        if ( months > 0 ) {
            _this = _this.plusMonths(months);
        }
        if ( days > 0 ) {
            _this = _this.plusDays(days);
        } 
        
        return _this;
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

    "Returns the period between this and the given date.
     If this date is before the given date then return negative period"
    shared actual Period periodFrom(Date start) {
        value from = this < start then this else start;
        value to = this < start then start else this;

        variable value nextDate = from.plusYears(1);
        variable value yy = 0;
        while ( nextDate <= to ) {
            nextDate = nextDate.plusYears(1);
            yy+=1;
        }

        variable value mm = 0;
        nextDate = from.plusYears(yy).plusMonths(mm+1);
        while ( nextDate <= to ) {
            mm+=1;
            nextDate = from.plusYears(yy).plusMonths(mm+1);
        }

        nextDate = from.plusYears(yy).plusMonths(mm).plusDays(1);
        variable value dd = 0;
        while ( nextDate <= to ) {
            nextDate = nextDate.plusDays(1);
            dd+=1;
        }

        Boolean positive = start < this; 
        return Period {
            years = positive then yy else -yy;
            months = positive then mm else -mm;
            days = positive then dd else -dd;
        }; 
    }

    "Returns the period between this and the given date.
     If this date is after the given date then return negative period"
    shared actual Period periodTo(Date end) => end.periodFrom(this); 
}

"Returns a gregorian calendar date according to the specified year, month and date values"
shared Date gregorianDate(year, month, day) {
        "Year number of the date"
        Integer year;

        "Month of the year"
        Integer|Month month; 

        "Day of month"
        Integer day;

    impl.checkDate([year, monthOf(month).integer, day]);
    return GregorianDate( impl.fixedFrom([year, monthOf(month).integer, day]) );
}
