import ceylon.time { Duration, Period }

"An interface to represent a Range between two Date/DateTime/Time"
shared interface Range<Element, in Self, StepBy> satisfies Iterable<Element, Null>
                                given Element satisfies Comparable<Element> & Ordinal<Element>
                                given Self satisfies Range<Element,Self, StepBy> {

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

    "Returns the Duration between _from_ and _to_ fields.

     Example: 
     
     Given: today().to(tomorrow).duration then duration is 86400000 milliseconds
     
     Given: tomorrow().to(today).duration then duration is -86400000 milliseconds"
    shared formal Duration duration;

    "Returns the Period between _from_ and _to_ fields.

     Example: 
     
     Given: today().to(tomorrow).duration then duration is 1 day
     
     Given: tomorrow().to(today).duration then duration is -1 day"
    shared formal Period period;
    
    shared formal Range<Element, Self, StepBy>|Empty overlap( Self other );
    
    shared formal Range<Element, Self, StepBy>|Empty gap( Self other );

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
        if ( is Range<Element, Self, StepBy> other ) {
            return from == other.from && to == other.to;
        }
        return false;
    }

    "Define how this Range will get next or previous element while iterating."
    shared formal Range<Element, Self, StepBy> stepBy( StepBy step );

}