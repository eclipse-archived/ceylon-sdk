import ceylon.language { Integer }
import ceylon.time { Date }

shared abstract class AbstractDate( dayOfEra )
       satisfies Date {

    shared actual Integer dayOfEra;

    shared actual Comparison compare(Date other) {
        return dayOfEra <=> other.dayOfEra;
    }

    shared actual Boolean equals( Object other ) {
        if (is AbstractDate other) {
            return dayOfEra.equals(other.dayOfEra);
        }
        return false;
    }

}