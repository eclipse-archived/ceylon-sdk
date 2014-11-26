"A day of week, such as 'tuesday'."
shared abstract class DayOfWeek(integer)
       of monday | tuesday | wednesday | thursday | friday | saturday | sunday
       satisfies Ordinal<DayOfWeek> & Comparable<DayOfWeek> & Enumerable<DayOfWeek> {

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
    
    "Iteration of the _day of week_ is always a modular way, 
     ie [[saturday]] iteration for [[sunday]] 
     will **not** occur in reverse order. It does follow the rules:
     
     \n_From sunday to saturday_
     * sunday.offset(sunday)    == 0
     * sunday.offset(monday)    == 1
     * sunday.offset(tuesday)   == 2
     * sunday.offset(wednesday) == 3
     * sunday.offset(thursday)  == 4
     * sunday.offset(friday)    == 5
     * sunday.offset(saturday)  == 6
     \n_From saturday to sunday_
     * saturday.offset(sunday)    == 6
     * saturday.offset(monday)    == 5
     * saturday.offset(tuesday)   == 4
     * saturday.offset(wednesday) == 3
     * saturday.offset(thursday)  == 2
     * saturday.offset(friday)    == 1
     * saturday.offset(saturday)  == 0
     "
    shared actual default Integer offset(DayOfWeek other) {
        return this >= other
            then integer - other.integer
            else other.integer - integer;
    }
    
    "It does follow the rules:
       
     \tvalue i = 1;
     \tassertEquals(sunday.neighbour(0), sunday);
     \tassertEquals(sunday.neighbour(i+1), sunday.neighbour(i).successor);
     \tassertEquals(sunday.neighbour(i-1), sunday.neighbour(i).predecessor);
     
     "
    shared actual DayOfWeek neighbour(Integer offset) {
        return plusDays(offset);
    }

}

"List of all available weekdays."
shared DayOfWeek[] weekdays = [ sunday, monday, tuesday, wednesday, thursday, friday, saturday ];

"Returns [[DayOfWeek]] from the input."
shared DayOfWeek dayOfWeek(Integer|DayOfWeek dayOfWeek){
    switch(dayOfWeek)
    case (is DayOfWeek) { return dayOfWeek; }
    case (is Integer) {
        assert (0 <= dayOfWeek < 7);
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

"_Sunday_ is the day of the week that follows Saturday and precedes Monday."
shared object sunday extends DayOfWeek(0) {
    shared actual String string = "sunday";
    shared actual DayOfWeek predecessor => saturday;
    shared actual DayOfWeek successor => monday;
}

"_Monday_ is the day of the week that follows Sunday and precedes Tuesday."
shared object monday extends DayOfWeek(1) {
    shared actual String string = "monday";
    shared actual DayOfWeek predecessor => sunday;
    shared actual DayOfWeek successor => tuesday;
}

"_Tuesday_ is the day of the week that follows Monday and precedes Wednesday."
shared object tuesday extends DayOfWeek(2) {
    shared actual String string = "tuesday";
    shared actual DayOfWeek predecessor => monday;
    shared actual DayOfWeek successor => wednesday;
}

"_Wednesday_ is the day of the week that follows Tuesday and precedes Thursday."
shared object wednesday extends DayOfWeek(3) {
    shared actual String string = "wednesday";
    shared actual DayOfWeek predecessor => tuesday;
    shared actual DayOfWeek successor => thursday;
}

"_Thursday_ is the day of the week that follows Wednesday and precedes Friday."
shared object thursday extends DayOfWeek(4) {
    shared actual String string = "thursday";
    shared actual DayOfWeek predecessor => wednesday;
    shared actual DayOfWeek successor => friday;
}

"_Friday_ is the day of the week that follows Thursday and precedes Saturday."
shared object friday extends DayOfWeek(5) {
    shared actual String string = "friday";
    shared actual DayOfWeek predecessor => thursday;
    shared actual DayOfWeek successor => saturday;
}

"_Saturday_ is the day of the week that follows Friday and precedes Sunday."
shared object saturday extends DayOfWeek(6) {
    shared actual String string = "saturday";
    shared actual DayOfWeek predecessor => friday;
    shared actual DayOfWeek successor => sunday;
}
