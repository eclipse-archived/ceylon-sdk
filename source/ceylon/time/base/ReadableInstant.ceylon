import ceylon.time { Instant }


"An abstraction for data that can represent an instant of time."
see (`Instant`)
shared interface ReadableInstant {

    "Internal value of an instant as a number of milliseconds 
     since beginning of an _era_ (january 1st 1970 UTC)"
    shared formal Integer millisecondsOfEpoch;

}
