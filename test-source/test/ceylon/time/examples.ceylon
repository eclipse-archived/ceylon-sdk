import ceylon.time { now, date, Date, Period, today, Time, dateTime, DateTime, DateRange, TimeRange, time }
import ceylon.time.base { february, december, saturday, sunday, november }

void dateRangeSamples() {
    Boolean weekday( Date day ) {
        return day.dayOfWeek != saturday && day.dayOfWeek != sunday;
    }

    value christmas = date(today().year, december, 25);
    DateRange christmasRange = DateRange(today(), christmas);
    print("More ``christmasRange.size`` day(s) until christmas");
    print("More ``christmasRange.filter(weekday).size`` weekday(s) until christmas");

    value vacationDays = 20;
	value startVacation = date(2013, november, 1);

    print("But ill be on vacation from ``startVacation`` to ``startVacation.plusDays(vacationDays)`` ");

    value realWeekdays = christmasRange.filter(weekday).size 
           - startVacation.rangeTo(startVacation.plusDays(vacationDays)).filter(weekday).size;
	print("Then its just only ``realWeekdays`` weekday(s) until christmas");
}

void timeRangeSamples() {
    class DaySchedule() {
        variable [TimeRange*] schedules = [];

       // shared [TimeRange*]|Empty availables() {
       //    variable [TimeRange*]|Empty result = [];
       //    if( schedules.size == 1 ) {
       //        assert( exists unique = schedules[0]);
       //        result = [ time(0,0).to(unique.from), unique, unique.to(time(24,0)) ];
       //    }
       //    for( i in 1..schedules.size -1 ) {
       //        value a = schedules[0];
       //    }
       //    return result;
       //}

        shared Boolean isFree( Time begin, Time end = begin.plusMinutes(30) ) {
            variable Boolean free = true;
            value newSchedule = begin.rangeTo(end);
            for( current in schedules ) {
                if( newSchedule.overlap(current) != empty ) {
                    free = false;
                    break;
                }
            }
            return free;
        }

        shared void add( Time begin, Time end = begin.plusMinutes(30) ) {
            this.schedules = [begin.rangeTo(end), *schedules];
            this.schedules = schedules.sort((TimeRange x, TimeRange y) => x.from <=> y.from);
        }

        shared actual String string {
            value builder = StringBuilder();
            for( current in schedules ) {
                builder.append("Reserved from ``current.from`` until ``current.to``\n");
            }
            return builder.string;
        }
    }

    value schedule = DaySchedule();
    schedule.add(time(9,0));

    print( "Can i add to 9:20 ? [``schedule.isFree(time(9,20))``] ");

    schedule.add(time(13,0), time(15,0));

    schedule.add(time(10,0), time(11,0));

    print( schedule );
}

"An example program using ceylon.time"
shared void example(){
    Date thisDay = today();
    print("today is ``thisDay.dayOfWeek``");
    assert(today() == now().date());
    
    Time time = now().time();
    print("Current time is ``time``");
    print("In five minutes it will be ``time.plusMinutes(5)``");

    DateTime eventStart = dateTime(2013, february, 13, 12, 30);
    Period length = Period { hours = 1; minutes = 30; };
    print("Lunch interview on ``eventStart`` to ``eventStart.plus(length).time``");
}