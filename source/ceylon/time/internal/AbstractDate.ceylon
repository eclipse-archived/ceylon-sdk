import ceylon.time { Date }

"Common behaviors for _Date_ types."
shared abstract class AbstractDate( dayOfEra ) extends Object()
       satisfies Date {

    "Every [[Date]] implementation should indicate it´s own _day of era_ based in it´s own chronology."
    shared actual Integer dayOfEra;

    "Dates from same chronology can be compared if they have same _day of era_."
    shared actual Comparison compare(Date other) {
        return dayOfEra <=> other.dayOfEra;
    }

}
