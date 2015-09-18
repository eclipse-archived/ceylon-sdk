
"Enumerates the fields of a formatted [[ceylon.time::Date]]."
shared class DateField {
    
    shared new day {}
    shared new month {}
    shared new year {}
    
    "A field ordering for formatted [[ceylon.time::Date]]s."
    shared alias Order => DateField[3];
    
}

"The day/month/year [[date field ordering|DateField.Order]]."
shared DateField.Order dayMonthYear 
        = [DateField.day, DateField.month, DateField.year];

"The year/month/day [[date field ordering|DateField.Order]]."
shared DateField.Order yearMonthDay 
        = [DateField.year, DateField.month, DateField.day];

"The month/day/year [[date field ordering|DateField.Order]]."
shared DateField.Order monthDayYear 
        = [DateField.month, DateField.day, DateField.year];
