"A day of week, such as 'tuesday'."
shared abstract class DayOfWeek(integer)
       of monday | tuesday | wednesday | thursday | friday | saturday | sunday
       satisfies Ordinal<DayOfWeek> & Comparable<DayOfWeek> {

    "Numeric value of the DayOfWeek"
    shared Integer integer;

    "Returns a day of week that comes specified number of days after this DayOfWeek"
    shared DayOfWeek plusDays(Integer number){
        value wd = (integer + number) % 7;
        assert (exists dow = weekdays[wd]);
        return dow;
    }

    "Returns a day of week that comes number of days before this DayOfWeek"
    shared DayOfWeek minusDays(Integer number){
        return plusDays(-number);
    }

    "Compare days of week"
    shared actual Comparison compare(DayOfWeek other) {
        return this.integer <=> other.integer;
    }

}

"List of all available weekdays"
shared DayOfWeek[] weekdays = [ sunday, monday, tuesday, wednesday, thursday, friday, saturday ];

"Returns [[DayOfWeek]] from the input"
shared DayOfWeek dayOfWeek(Integer|DayOfWeek dayOfWeek){
    switch(dayOfWeek)
    case (is DayOfWeek) { return dayOfWeek; }
    case (is Integer) {
        assert (0 <= dayOfWeek && dayOfWeek < 7);
        assert (exists DayOfWeek dow = weekdays[dayOfWeek]);
        return dow;
    }
}

"An exception that is thrown when parsing a DayOfWeek fails"
shared class WeekdayParseError(String message)
       extends Exception(message) {}

"Parses a string into a DayOfWeek"
shared DayOfWeek parseWeekday(String dayOfWeek){
    value wd = dayOfWeek.lowercased;
    for (dow in weekdays) {
        if (dow.string.lowercased == wd) {
            return dow;
        }
    }

    throw WeekdayParseError("Unrecognized DayOfWeek: ``dayOfWeek`` ." );
}

"_Sunday_ is the day of the week that follows Saturday and preceeds Monday."
shared object sunday extends DayOfWeek(0) {
    shared actual String string = "sunday";
    shared actual DayOfWeek predecessor { return  saturday; }
    shared actual DayOfWeek successor { return monday; }
}

"_Monday_ is the day of the week that follows Sunday and preceeds Tuesday."
shared object monday extends DayOfWeek(1) {
    shared actual String string = "monday";
    shared actual DayOfWeek predecessor { return sunday; }
    shared actual DayOfWeek successor { return tuesday; }
}

"_Tuesday_ is the day of the week that follows Monday and preceeds Wednesday."
shared object tuesday extends DayOfWeek(2) {
    shared actual String string = "tuesday";
    shared actual DayOfWeek predecessor { return monday; }
    shared actual DayOfWeek successor { return wednesday; }
}

"_Wednesday_ is the day of the week that follows Tuesday and preceeds Thursday."
shared object wednesday extends DayOfWeek(3) {
    shared actual String string = "wednesday";
    shared actual DayOfWeek predecessor { return tuesday; }
    shared actual DayOfWeek successor { return thursday; }
}

"_Thursday_ is the day of the week that follows Wednesday and preceeds Friday."
shared object thursday extends DayOfWeek(4) {
    shared actual String string = "thursday";
    shared actual DayOfWeek predecessor { return wednesday; }
    shared actual DayOfWeek successor { return friday; }
}

"_Friday_ is the day of the week that follows Thursday and preceeds Saturday."
shared object friday extends DayOfWeek(5) {
    shared actual String string = "friday";
    shared actual DayOfWeek predecessor { return thursday; }
    shared actual DayOfWeek successor { return saturday; }
}

"_Saturday_ is the day of the week that follows Friday and preceeds Sunday."
shared object saturday extends DayOfWeek(6) {
    shared actual String string = "saturday";
    shared actual DayOfWeek predecessor { return friday; }
    shared actual DayOfWeek successor { return sunday; }
}
