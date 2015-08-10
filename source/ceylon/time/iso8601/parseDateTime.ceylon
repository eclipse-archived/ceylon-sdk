import ceylon.time {
    DateTime,
    dateTime,
    Date,
    Time
}

"""
   `<date>T<time>`
   """
shared DateTime? parseDateTime(String input) {
    if (exists t = input.firstOccurrence('T')) {
        if (exists date = parseDate(input[0..t-1]),
            exists timeComponents = parseTimeComponents(input[t+1...])) {
            
            if (exists time = convertToTime(timeComponents)) {
                if (timeComponents[0] == 24) {
                    return createDateTime(date.successor, time);
                }
                else {
                    return createDateTime(date, time);
                }
            }
        }
    }
    
    return null;
}

DateTime createDateTime(Date date, Time time) => dateTime { 
    year = date.year; 
    month = date.month; 
    day = date.day; 
    hours = time.hours; 
    minutes = time.minutes; 
    seconds = time.seconds; 
    milliseconds = time.milliseconds; 
};
