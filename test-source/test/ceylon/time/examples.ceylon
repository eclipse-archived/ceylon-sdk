import ceylon.time { now, date, Date, Period, today, Time, dateTime, DateTime, DateRange, TimeRange, time }
import ceylon.time.base { february, december, saturday, sunday, november, minutes }
import ceylon.collection { StringBuilder }

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

        shared [TimeRange*]|Empty availables() {
           variable [TimeRange*]|Empty result = [];
           if( schedules.size == 1 ) {
               assert( exists unique = schedules[0]);
               result = [ time(0,0).rangeTo(unique.from), unique.to.rangeTo(time(23, 59, 59)) ];
           } else {
               result = [for( i in 0..schedules.size ) if( exists start = schedules[i], exists end = schedules[i+1]) start.to.rangeTo(end.from) ]; 

               assert(exists first = schedules.first);
               assert(exists last =  schedules.last);
               result = [ time(0,0).rangeTo(first.from), last.to.rangeTo(time(23,59,59)), *result ];
           }
           result = result.sort((TimeRange x, TimeRange y) => x.from <=> y.from);
           return result;
       }

        shared Boolean isAvailable( Time begin, Time end = begin.plusMinutes(30) ) {
            variable Boolean free = true;
            value newSchedule = begin.rangeTo(end).stepBy(minutes);
            for( current in schedules ) {
                if( newSchedule.overlap(current) != empty ) {
                    free = false;
                    break;
                }
            }
            return free;
        }

        shared void add( Time begin, Time end = begin.plusMinutes(30) ) {
            this.schedules = [begin.rangeTo(end).stepBy(minutes), *schedules];
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
    print("Adding 9:00 using default of 30 minutes");
    schedule.add(time(9,0));
    
    print( "Check if is 9:20 available ? The answer is ``schedule.isAvailable(time(9,20)) then "yes" else "no"`` ");

    print("Adding 13:00 until 15:00");
    schedule.add(time(13,0), time(15,0));

    print("Adding 10:00 until 11:00");
    schedule.add(time(10,0), time(11,0));

    print("\n############### Final Result ###############\n");
    print( schedule );
    for( range in schedule.availables()) {
        print("Available from: ``range.from`` until ``range.to`` ");
    }
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