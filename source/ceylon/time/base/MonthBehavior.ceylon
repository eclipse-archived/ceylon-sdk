"Common behavior for month types."
shared interface MonthBehavior<Element>
       given Element satisfies ReadableMonth {

    "Returns a copy of this instance with the specified month of year."
    shared formal Element withMonth(Month month);

    "Returns a copy of this instance with the specified number of months added."
    shared formal Element plusMonths(Integer months);

    "Returns a copy of this instance with the specified number of months subtracted."
    shared formal Element minusMonths(Integer months);

}