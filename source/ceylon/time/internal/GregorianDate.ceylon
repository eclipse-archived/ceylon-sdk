/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time { Date, DateTime, Time, Period, DateRange }
import ceylon.time.base { DayOfWeek, weekdayOf=dayOfWeek, monthOf, Month, days, january, ReadableDatePeriod, months, monday, weekdays }
import ceylon.time.chronology { impl=gregorian }

"Default implementation of a gregorian calendar"
shared serializable class GregorianDate( dayOfEra ) extends Object() satisfies Date {
	
	"Every [[Date]] implementation should indicate it´s own _day of era_ based in it´s own chronology."
	shared actual Integer dayOfEra;

    "Returns year of this gregorian date."
    shared actual Integer year => impl.yearFrom( dayOfEra );

    "Returns month of this gregorian date."
    shared actual Month month => monthOf(impl.monthFrom( dayOfEra ));

    "Returns _day of month_ value of this gregorian date."
    shared actual Integer day => impl.dayFrom( dayOfEra );

    "Returns `true`, if this is a leap year according to gregorian calendar leap year rules."
    shared actual Boolean leapYear => impl.leapYear( year );

    "Returns _day of year_ value of this gregorian date."
    shared actual Integer dayOfYear => month.firstDayOfYear( leapYear ) + day - 1;

    "Returns gregorian date immediately preceding this date.\n
     For successor its used the lowest unit of date, this way we can benefit
     from maximum precision. In this case the successor is the current value minus 1 day."
    shared actual Date predecessor => minusDays( 1 );

    "Returns gregorian date immediately succeeding this date.\n
     For successor its used the lowest unit of date, this way we can benefit
     from maximum precision. In this case the successor is the current value plus 1 day."
    shared actual Date successor => plusDays( 1 );

    "Returns current day of the week."
    shared actual DayOfWeek dayOfWeek => weekdayOf(impl.dayOfWeekFrom( dayOfEra ));

    "Adds number of days to this date and returns the resulting [[Date]]."
    shared actual Date plusDays(Integer days) {
        if ( days == 0 ) {
            return this;
        }
        return GregorianDate( dayOfEra + days );
    }

    "Subtracts number of days from this date and returns the resulting [[Date]]."
    shared actual Date minusDays(Integer days) => plusDays(-days);

    "Adds number of weeks to this date and returns the resulting [[Date]]."
    shared actual Date plusWeeks(Integer weeks) => plusDays( weeks * days.perWeek );

    "Subtracts number of weeks from this date and returns the resulting [[Date]]."
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

        value monthDay = o.month.numberOfDays(impl.leapYear(newYear));
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
        
        value newYear = year + years;
        value monthDay = month.numberOfDays(impl.leapYear(newYear));
        
        return GregorianDate(impl.fixedFrom([newYear, month.integer, min{ day, monthDay }] ));
    }

    "Subtracts number of years from this date returning the resulting the new gregorian date.
     
     **Note:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2012, 2, 29).minusYears(1)` will return
     `2011-02-28`, since _February 2011_ has only 28 days.
     "
    shared actual Date minusYears(Integer years) => plusYears(-years);

    "Returns new date with the _day of month_ value set to the specified value.

     **Note:** It should result in a valid gregorian date.
     "
    shared actual Date withDay(Integer day) {
        if ( day == this.day ) {
            return this;
        }
        impl.checkDate([year,month.integer,day]);
        return GregorianDate( dayOfEra - this.day + day);
    }

    "Returns new date with the month set to the specified value.
     
     **Note:** It should result in a valid gregorian date.
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
     
     **Note:** It should result in a valid gregorian date.
     "
    shared actual Date withYear(Integer year) {
        if ( year == this.year ) {
            return this;
        }

        impl.checkDate([year,month.integer,day]);
        return GregorianDate( impl.fixedFrom([year, month.integer, day]) );
    }

    "Returns new date with the specified weekOfYear value.
     
     **Note:** It should result in a valid gregorian date.
     "
    shared actual Date withWeekOfYear(Integer weekOfYear) {
        value thisWeekOfYear = this.weekOfYear;
        if (weekOfYear == thisWeekOfYear) {
            return this;
        }
        
        assert(0 <= weekOfYear <= 53);
        return plusWeeks(weekOfYear - thisWeekOfYear);
    }
    
    shared actual Date withDayOfWeek(DayOfWeek dayOfWeek) {
        if (dayOfWeek == this.dayOfWeek) {
            return this;
        }
        
        return plusDays(dayOfWeek.integer - this.dayOfWeek.integer);
    }
    
    shared actual Date withDayOfYear(Integer dayOfYear) {
        if (dayOfYear == this.dayOfYear) {
            return this;
        }
        
        value lastDayOfYear = leapYear then days.perLeapYear else days.perYear;
        assert(1 <= dayOfYear <= lastDayOfYear);
        
        return plusDays(dayOfYear - this.dayOfYear);
    }
    
    "Adds specified date period to this date and returns the new [[Date]]."
    shared actual Date plus( ReadableDatePeriod amount ) {
        return addPeriod {
                months = amount.years * months.perYear + amount.months;
                days = amount.days; 
        };
    }

    "Subtracts specified date period from this date and returns the new [[Date]]."
    shared actual Date minus( ReadableDatePeriod amount ) {
        return addPeriod {
                months = -amount.years * months.perYear + -amount.months;
                days = -amount.days; 
        };
    }

    "This method add the specified fields doing first the subtraction and last the additions.

     The mix between positive and negative fields does not guarantee any expected behavior."
    Date addPeriod( Integer months, Integer days ) {
        variable Date _this = this;
        //do all subtractions first
        if ( days < 0 ) {
            _this = _this.minusDays(-days);
        } 
        if ( months < 0 ) {
            _this = _this.minusMonths(-months);
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

    "Returns week of year according to ISO-8601 week number calculation rules."
    shared actual Integer weekOfYear {
        function normalizeFirstWeek(Integer yearNumber) {
            value jan1 = withDay(1).withMonth(january).withYear(yearNumber);
            value jan1WeekDayMinusMonday = jan1.dayOfWeek.integer - monday.integer;
            
            return jan1.minusDays(jan1WeekDayMinusMonday)
                       .plusDays(if (jan1WeekDayMinusMonday >= 4) then weekdays.size else 0);
        }
        
        function normalizeLastWeek(Integer yearNumber)
                => normalizeFirstWeek(yearNumber + 1).minusDays(1);
        
        value startFirstWeekOfYear = normalizeFirstWeek( year );
        
        variable value weekNumber = 1;
        if (this < startFirstWeekOfYear) {
            value startFirstWeekOfPriorYear = normalizeFirstWeek(year - 1);
            value daysSinceStartFirstWeekOfPriorYear = this.offset(startFirstWeekOfPriorYear) + 1;
            
            weekNumber = (daysSinceStartFirstWeekOfPriorYear / weekdays.size)
                       + (daysSinceStartFirstWeekOfPriorYear % weekdays.size > 0 then 1 else 0);
        }
        else {
            value endLastWeekOfYear = normalizeLastWeek(year);
            if (this <= endLastWeekOfYear) {
                value daysSinceStartFirstWeekOfYear = this.offset( startFirstWeekOfYear ) + 1;
                weekNumber = (daysSinceStartFirstWeekOfYear / weekdays.size)
                           + (daysSinceStartFirstWeekOfYear % weekdays.size > 0 then 1 else 0);
            }
        }
        
        return weekNumber;
    }

    "Returns new [[DateTime]] value."
    shared actual DateTime at(Time time) => GregorianDateTime(this, time);

    "Returns ISO-8601 formatted String representation of this date.\n
     Reference: https://en.wikipedia.org/wiki/ISO_8601#Dates"
    shared actual String string 
            => "``year.string.padLeading(4, '0')``-``month.integer.string.padLeading(2, '0')``-``day.string.padLeading(2, '0')``";

    "Returns the period between this and the given date.

     If this date is before the given date then return negative period."
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
    
    "Dates from same chronology can be compared if they have same _day of era_."
    shared actual Comparison compare(Date other) {
        return dayOfEra <=> other.dayOfEra;
    }

    "Returns the period between this and the given date.

     If this date is after the given date then return negative period."
    shared actual Period periodTo(Date end) => end.periodFrom(this);

    "Returns the [[DateRange]] between this and given Date."
    shared actual DateRange rangeTo( Date other ) => DateRange(this, other);

    shared actual Date neighbour(Integer offset) => plusDays(offset);

    shared actual Integer offset(Date other) => dayOfEra - other.dayOfEra;
    
     
}

"Returns a gregorian calendar date according to the specified year, month and date values."
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
