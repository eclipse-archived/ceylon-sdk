import ceylon.time { Date }

"Common behaviors for _Date_ types."
shared abstract class AbstractDate( dayOfEra )
       satisfies Date {

    "Every [[Date]] implementation should indicate it´s own _day of era_ based in it´s own chronology."
    shared actual Integer dayOfEra;

    //TODO: How to deal with two dates of different chronology, maybe compare should use _Rata Die_?
    "Dates from same chronology can be compared if they have same _day of era_."
    shared actual Comparison compare(Date other) {
        return dayOfEra <=> other.dayOfEra;
    }

    //TODO: How to deal with two dates of different chronology, maybe compare should use _Rata Die_?
    "Dates from same chronology can be considered equal if they have same _day of era_."
    shared actual Boolean equals( Object other ) {
        if (is AbstractDate other) {
            return dayOfEra.equals(other.dayOfEra);
        }
        return false;
    }

    //TODO: When we have another chronology this should be revisited.
    "This implementation respect the constraint that if `x==y` then `x.hash==y.hash`."
    shared actual Integer hash {
        value prime = 31;
        value result = 7;
        return prime * result + dayOfEra.hash;
    }

}
