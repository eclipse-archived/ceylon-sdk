"Common behavior for year types."
shared interface YearBehavior<Element>
       given Element satisfies ReadableYear {

    "Returns a copy of this instance with the specified year."
    shared formal Element withYear(Integer year);

    "Returns a copy of this instance with the specified number of years added."
    shared formal Element plusYears(Integer years);

    "Returns a copy of this instance with the specified number of years subtracted."
    shared formal Element minusYears(Integer years);

}