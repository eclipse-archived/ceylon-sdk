import ceylon.time { Duration }

"An abstraction of data representing a specific duration of time.
 
 A duration is a fixed delta of time between two instants 
 measured in number of milliseconds."
//TODO see (Duration)
by ("Diego Coronel", "Roland Tepp")
shared interface ReadableDuration {

    "Number of milliseconds."
    shared formal Integer milliseconds;

}