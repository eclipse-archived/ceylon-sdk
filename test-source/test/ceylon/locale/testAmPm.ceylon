import ceylon.locale {
    locale
}
import ceylon.test {
    assertEquals,
    assumeTrue,
    parameters,
    test
}
import ceylon.time {
    time
}

{[Integer, String]*} testAmPmParameters = {
    [0, "12:30 AM"],
    [1, "1:30 AM"],
    [2, "2:30 AM"],
    [3, "3:30 AM"],
    [4, "4:30 AM"],
    [5, "5:30 AM"],
    [6, "6:30 AM"],
    [7, "7:30 AM"],
    [8, "8:30 AM"],
    [9, "9:30 AM"],
    [10, "10:30 AM"],
    [11, "11:30 AM"],
    [12, "12:30 PM"],
    [13, "1:30 PM"],
    [14, "2:30 PM"],
    [15, "3:30 PM"],
    [16, "4:30 PM"],
    [17, "5:30 PM"],
    [18, "6:30 PM"],
    [19, "7:30 PM"],
    [20, "8:30 PM"],
    [21, "9:30 PM"],
    [22, "10:30 PM"],
    [23, "11:30 PM"]
};

test
parameters(`value testAmPmParameters`)
shared void testAmPm(Integer hour, String expected) {
    value localeTag = "en-US";
    value enUsLocale = locale(localeTag);
    
    assumeTrue(enUsLocale exists, "Locale not found: ``localeTag``");
    
    assert (exists enUsLocale);
    
    value format = enUsLocale.formats.shortFormatTime;
    
    assertEquals(format(time(hour, 30, 0)), expected);
}
