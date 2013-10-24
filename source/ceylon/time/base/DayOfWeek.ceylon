"A day of week, such as 'tuesday'."
shared abstract class DayOfWeek(integer)
       of monday | tuesday | wednesday | thursday | friday | saturday | sunday
       satisfies Ordinal<DayOfWeek> & Comparable<DayOfWeek> {

    "Numeric value of the DayOfWeek."
    shared Integer integer;

    "Returns a day of week that comes specified number of days after this DayOfWeek."
    shared DayOfWeek plusDays(Integer number){
        value wd = (integer + number) % 7;
        assert (exists dow = weekdays[wd]);
        return dow;
    }

    "Returns a day of week that comes number of days before this DayOfWeek."
    shared DayOfWeek minusDays(Integer number) => plusDays(-number);

    "Compare days of week."
    shared actual Comparison compare(DayOfWeek other) => this.integer <=> other.integer;

}

"List of all available weekdays."
shared DayOfWeek[] weekdays = [ sunday, monday, tuesday, wednesday, thursday, friday, saturday ];

"Returns [[DayOfWeek]] from the input."
shared DayOfWeek dayOfWeek(Integer|DayOfWeek dayOfWeek){
    switch(dayOfWeek)
    case (is DayOfWeek) { return dayOfWeek; }
    case (is Integer) {
        assert (0 <= dayOfWeek && dayOfWeek < 7);
        assert (exists DayOfWeek dow = weekdays[dayOfWeek]);
        return dow;
    }
}

"Parses a string into a DayOfWeek.

 Expected inputs and outputs are:
 * \"sunday\"    results in [[sunday]]
 * \"monday\"    results in [[monday]]
 * \"tuesday\"   results in [[tuesday]]
 * \"wednesday\" results in [[wednesday]]
 * \"thursday\"  results in [[thursday]]
 * \"friday\"    results in [[friday]]
 * \"saturday\"  results in [[saturday]]"
shared DayOfWeek? parseDayOfWeek(String dayOfWeek){
    value wd = dayOfWeek.lowercased;
    for (dow in weekdays) {
        if (dow.string.lowercased == wd) {
            return dow;
        }
    }

    return null;
}

"_Sunday_ is the day of the week that follows Saturday and preceeds Monday."
shared object sunday extends DayOfWeek(0) {
    shared actual String string = "sunday";
    shared actual DayOfWeek predecessor => saturday;
    shared actual DayOfWeek successor => monday;
}

"_Monday_ is the day of the week that follows Sunday and preceeds Tuesday."
shared object monday extends DayOfWeek(1) {
    shared actual String string = "monday";
    shared actual DayOfWeek predecessor => sunday;
    shared actual DayOfWeek successor => tuesday;
}

"_Tuesday_ is the day of the week that follows Monday and preceeds Wednesday."
shared object tuesday extends DayOfWeek(2) {
    shared actual String string = "tuesday";
    shared actual DayOfWeek predecessor => monday;
    shared actual DayOfWeek successor => wednesday;
}

"_Wednesday_ is the day of the week that follows Tuesday and preceeds Thursday."
shared object wednesday extends DayOfWeek(3) {
    shared actual String string = "wednesday";
    shared actual DayOfWeek predecessor => tuesday;
    shared actual DayOfWeek successor => thursday;
}

"_Thursday_ is the day of the week that follows Wednesday and preceeds Friday."
shared object thursday extends DayOfWeek(4) {
    shared actual String string = "thursday";
    shared actual DayOfWeek predecessor => wednesday;
    shared actual DayOfWeek successor => friday;
}

"_Friday_ is the day of the week that follows Thursday and preceeds Saturday."
shared object friday extends DayOfWeek(5) {
    shared actual String string = "friday";
    shared actual DayOfWeek predecessor => thursday;
    shared actual DayOfWeek successor => saturday;
}

"_Saturday_ is the day of the week that follows Friday and preceeds Sunday."
shared object saturday extends DayOfWeek(6) {
    shared actual String string = "saturday";
    shared actual DayOfWeek predecessor => friday;
    shared actual DayOfWeek successor => sunday;
}
