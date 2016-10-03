"Common behavior for date types."
shared interface DateBehavior<Element> of Element
       satisfies ReadableDate 
       given Element satisfies ReadableDate {

    "Returns a copy of this period with the specified year."
    shared formal Element withYear(Integer year);

    "Returns a copy of this period with the specified month of year."
    shared formal Element withMonth(Month month);

    "Returns a copy of this period with the specified day of month."
    shared formal Element withDay(Integer dayOfMonth);
    
    "Returns a copy of this period with the specified week of year."
    shared formal Element withWeekOfYear(Integer weekNumber);

    "Returns a copy of this period with the specified day of week."
    shared formal Element withDayOfWeek(DayOfWeek dayOfWeek);
    
    "Returns a copy of this period with the specified day of year."
    shared formal Element withDayOfYear(Integer dayOfYear);
    
    "Returns a copy of this period with the specified number of years added."
    shared formal Element plusYears(Integer years);

    "Returns a copy of this period with the specified number of months added."
    shared formal Element plusMonths(Integer months);

    "Returns a copy of this period with the specified number of weeks added."
    shared formal Element plusWeeks(Integer weeks);

    "Returns a copy of this period with the specified number of days added."
    shared formal Element plusDays(Integer days);

    "Returns a copy of this period with the specified number of years subtracted."
    shared formal Element minusYears(Integer years);

    "Returns a copy of this period with the specified number of months subtracted."
    shared formal Element minusMonths(Integer months);

    "Returns a copy of this period with the specified number of weeks subtracted."
    shared formal Element minusWeeks(Integer weeks);

    "Returns a copy of this period with the specified number of days subtracted."
    shared formal Element minusDays(Integer days);

}
