"A clock providing access to the current instant, date and time using a time-zone.
 
 Instances of this class are used to find the current instant, which can be
 interpreted using the stored time-zone to find the current date and time.
 As such, a clock can be used instead of `process.milliseconds`.
 
 The primary purpose of this abstraction is to allow alternate clocks to be
 plugged in as and when required. Applications use an object to obtain the
 current time rather than a static method. This can simplify testing.
 
 Applications should _avoid_ using the top level objects directly.
 Instead, they should pass a [[Clock]] into any method that requires it.
 A dependency injection framework is one way to achieve this.
 
 This approach allows an alternate clock, such as [[fixedTime]] to be used during testing.
 
 The [[systemTime]] top level factory method offers clocks based on the best available 
 system clock, such as `process.milliseconds`."
shared interface Clock {

    "Gets the current millisecond instant of the clock."
    shared formal Integer milliseconds();

    "Gets the current instant of the clock."
    shared formal Instant instant();

}

"Gets a clock that obtains the current instant using the best available system clock."
shared object systemTime satisfies Clock {

    "Return number of milliseconds from system time"
    shared actual Integer milliseconds() => process.milliseconds;

    "Return current instant from system time"
    shared actual Instant instant() => Instant( milliseconds() );

}


"Gets a clock that always returns the same instant in the UTC time-zone."
shared Clock fixedTime(Instant|Integer instant) {
    switch(instant)
    case (is Instant){
        return FixedInstant(instant);
    }
    case (is Integer){
        return FixedMilliseconds(instant);
    }
}

"Implementation of a clock that always returns the same instant.
 This is typically used for testing."
class FixedInstant(Instant fixedInstant) satisfies Clock {

    "Returns milliseconds from the fixed instant"
<<<<<<< Upstream, based on ceylon/master
    shared actual Integer milliseconds() => fixedInstant.millisecondsOfEpoch;
=======
    shared actual Integer milliseconds() => fixedInstant.millisecondsOfEra;
>>>>>>> 026d7bd initial beginnings of TimeZone implementation

    "Returns the fixed instant"
    shared actual Instant instant() => fixedInstant;

}

"Implementation of a clock that always returns the same instant.
 This is typically used for testing."
class FixedMilliseconds(Integer fixedMilliseconds) satisfies Clock {

    "Returns the fixed milliseconds"
    shared actual Integer milliseconds() => fixedMilliseconds;

    "Returns the instant from the fixed milliseconds"
    shared actual Instant instant() => Instant(fixedMilliseconds);

}

"Returns an implementation of a clock that always returns a 
 constant offset from the value of the provided clock."
shared Clock offsetTime(Clock baseClock, Integer offset) 
       => OffsetClock(baseClock, offset);

"An implementation of a [[Clock]] that returns tilem with a constant 
 offset from the provided clock."
class OffsetClock(Clock baseClock, Integer offset) satisfies Clock {
    shared actual Instant instant() => Instant( milliseconds() );
    shared actual Integer milliseconds() => baseClock.milliseconds() + offset;
<<<<<<< Upstream, based on ceylon/master
}
=======
}
>>>>>>> 026d7bd initial beginnings of TimeZone implementation
