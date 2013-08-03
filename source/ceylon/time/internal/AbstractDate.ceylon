import ceylon.time { Date }

"Common behaviors for _Date_ types."
shared abstract class AbstractDate( dayOfEra )
       satisfies Date {

    "Every [[Date]] implementation should indicate it own _day of ere_ based in it´s own chronology."
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

}
