import ceylon.test { ... }
import ceylon.time { ... }

import ceylon.time.parse { ... }

shared class ISO8601ParserTest() {
    /*
     * Date and time values are ordered from the largest to smallest unit of time: 
     * year, month (or week), day, hour, minute, second, and fraction of second. 
     * 
     * The lexicographical order of the representation thus corresponds to chronological order, 
     * except for date representations involving negative years. This allows dates to be naturally 
     * sorted by, for example, file systems.
     */
    
    shared test void it_parses_ISO8601_formatted_string() 
                => assertEquals(date(2014, 12, 29), iso8601.parseDate("20141229"));

    shared test void it_parses_ISO8601_formatted_string_with_dashes() 
                => assertEquals(date(2014, 12, 29), iso8601.parseDate("2014-12-29"));

}
/*
 * Each date and time value has a fixed number of digits that must be padded with leading zeros.
 */

/*
 * Representations can be done in one of two formats – a basic format with a minimal number of 
 * separators or an extended format with separators added to enhance human readability.[5] 
 * The standard notes that "The basic format should be avoided in plain text."[6] The separator 
 * used between date values (year, month, week, and day) is the hyphen, while the colon is used 
 * as the separator between time values (hours, minutes, and seconds). For example, the 6th day 
 * of the 1st month of the year 2009 may be written as "2009-01-06" in the extended format or 
 * simply as "20090106" in the basic format without ambiguity.
 *
 * [5]: ISO, FAQ: Numeric representation of Dates and Time
 * [6]: ISO 8601:2004 section 2.3.3 basic format
 */

/*
 * For reduced precision,[7] any number of values may be dropped from any of the date and time 
 * representations, but in the order from the least to the most significant. For example, "2004-05" 
 * is a valid ISO 8601 date, which indicates May (the fifth month) 2004. This format will never 
 * represent the 5th day of an unspecified month in 2004, nor will it represent a time-span extending 
 * from 2004 into 2005.
 *
 * [7]: ISO 8601 uses the word accuracy, not precision, in the relevant section, e.g: 2.3.7 representation with reduced accuracy.
 */

/*
 * If necessary for a particular application, the standard supports the addition of a decimal 
 * fraction to the smallest time value in the representation.
 */
shared ignore test void failThis() => fail("nothing to test");