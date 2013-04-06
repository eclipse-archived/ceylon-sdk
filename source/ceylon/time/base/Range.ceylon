import ceylon.time { Duration, Period }

"An interface to represent a Range between two Date/DateTime/Time"
shared interface Range<Element, in Self> satisfies Category & Iterable<Element, Null>
                                given Element satisfies Comparable<Element> & Ordinal<Element>
                                given Self satisfies Range<Element,Self> {

    "The first Element returned by the iterator, if any.
     This should always produce the same value as
     `iterable.iterator().head`.
     It also represents the _caller_ that created the Range:
     
     Example: today().to(tomorrow) -> in this case today() is the caller/creator of the range"
    shared formal Element from;

    "The limit of the Range where. 

     Example:

     Given: today().to(tomorrow) then tomorrow is the _to_ element
     
     Given: tomorrow.to(today()) then today() is the _to_ element"
    shared formal Element to;

    "Customized way to iterate over each element, it does not interfer in _from_
     and _to_ fields, but it does not guarantee that _to_ will be included in iterator"
    shared formal UnitOfDate|UnitOfTime step;

    "Returns the Duration between _from_ and _to_ fields in ascending order.
     This means that its never going to produces a negative duration.

     Example: 
     
     Given: today().to(tomorrow).duration then duration is 86400000 milliseconds
     
     Given: tomorrow().to(today).duration then duration is 86400000 milliseconds"
    shared formal Duration duration;

    "Returns the Period between _from_ and _to_ fields in ascending order.
     This means that its never going to produces a negative duration.

     Example: 
     
     Given: today().to(tomorrow).duration then duration is 1 day
     
     Given: tomorrow().to(today).duration then duration is 1 day"
    shared formal Period period;
    
    "Returns a new range based on overlap with given parameter. \n
     Overlaps are considered inclusives on both _from_ and _to_ fields and 
     will always return the new Range with _from_ and _to_ ordered ascending.

     Examples:
     
     Scenario: Two ranges that overlaps 

     Given:\n
     DateRange januaryRange = date(2013, january, 1).to(date(2013, january, 31));\n
     DateRnage januaryFirstHalf = date(2013, january, 1).to(date(2013, january, 15));\n
     DateRanged overlapedRange = januaryRange.overlap(januaryFirstHalf);

     Then: \n
     overlapedRange will have _from_: date(2013, january, 1) and _to_: date(2013, january, 15)

     Scenario: Two inverted ranges that overlaps 

     Given:\n
     DateRange januaryRange = date(2013, january, 31).to(date(2013, january, 1));\n
     DateRnage januaryFirstHalf = date(2013, january, 15).to(date(2013, january, 1));\n
     DateRanged overlapedRange = januaryRange.overlap(januaryFirstHalf);

     Then: \n
     overlapedRange will have _from_: date(2013, january, 1) and _to_: date(2013, january, 15)

     Scenario: Two ranges that dont overlaps 

     Given:\n
     DateRange januaryRange = date(2013, january, 31).to(date(2013, january, 1));\n
     DateRnage februaryRange = date(2013, february, 1).to(date(2013, february, 28));\n
     DateRanged overlapedRange = januaryRange.overlap(februaryRange);

     Then: \n
     overlapedRange will be Null"
    shared formal Range<Element, Self>? overlap( Self other );
    
    "Returns a new range based on gap with given parameter. \n
     Gaps are considered exclusives on both _from_ and _to_ fields and 
     will always return the new Range with _from_ and _to_ ordered ascending.

     Examples:
     
     Scenario: Two ranges that dont overlaps 

     Given:\n
     DateRange januaryRange = date(2013, january, 1).to(date(2013, january, 31));\n
     DateRnage marchRange = date(2013, march, 1).to(date(2013, march, 31));\n
     DateRanged gapRange = januaryRange.overlap(marchRange);

     Then: \n
     gapRange will have _from_: date(2013, february, 1) and _to_: date(2013, february, 28)

     Scenario: Two inverted ranges that dont overlaps 

     Given:\n
     DateRange januaryRange = date(2013, january, 1).to(date(2013, january, 31));\n
     DateRnage marchRange = date(2013, march, 31).to(date(2013, march, 1));\n
     DateRanged gapRange = januaryRange.overlap(marchRange);

     Then: \n
     gapRange will have _from_: date(2013, february, 1) and _to_: date(2013, february, 28)

     Scenario: Two ranges that overlaps 

     Given:\n
     DateRange januaryRange = date(2013, january, 1).to(date(2013, january, 31));\n
     DateRnage januaryFirstHalf = date(2013, january, 1).to(date(2013, january, 15));\n
     DateRanged gapRange = januaryRange.overlap(januaryFirstHalf);

     Then: \n
     gapRange will be Null"
    shared formal Range<Element, Self>? gap( Self other );

    //TODO: How to link it with Container::contains doc?
    shared actual Boolean contains(Object element) {
        if ( is Element element ) {
            return from <= to
                   then from <= element <= to
                   else to <= element <= from;
        }
        return false;
    }

    "Returns true if both: this and other are same type and have equal fields _from_ and _to_"
    shared default actual Boolean equals( Object other ) {
        if ( is Range<Element, Self> other ) {
            return from == other.from && to == other.to;
        }
        return false;
    }
}