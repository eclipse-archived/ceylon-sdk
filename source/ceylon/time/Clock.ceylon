
doc "A clock providing access to the current instant, date and time using a time-zone.
     
     Instances of this class are used to find the current instant, which can be
     interpreted using the stored time-zone to find the current date and time.
     As such, a clock can be used instead of {@link System#currentTimeMillis()}
     and {@link TimeZone#getDefault()}.
      
     The primary purpose of this abstraction is to allow alternate clocks to be
     plugged in as and when required. Applications use an object to obtain the
     current time rather than a static method. This can simplify testing.
     
     Applications should <i>avoid</i> using the static methods on this class.
     Instead, they should pass a {@code Clock} into any method that requires it.
     A dependency injection framework is one way to achieve this:
     
         public class MyBean {
           private Clock clock;  // dependency inject
           ...
           public void process(LocalDate eventDate) {
             if (eventDate.isBefore(LocalDate.now(clock)) {
               ...
             }
           }
         }
      
     This approach allows an alternate clock, such as {@link #fixed} to be used during testing.
      
     The {@code system} factory method provides clocks based on the best available system clock,
     such as {@code System.currentTimeMillis}."
shared interface Clock {

    //TODO: shared formal TimeZone zone
    //TODO: shared formal Clock withZone(TimeZone zone);

    doc "Gets the current millisecond instant of the clock."
    shared formal Integer millis();

    doc "Gets the current instant of the clock."
    shared formal Instant instant();

}

doc "Gets a clock that obtains the current instant using the best available system clock."
shared object systemTime satisfies Clock {
    
    doc "Return number of milliseconds from system time"
    shared actual Integer millis() {
        return process.milliseconds;
    }

    doc "Return current instant from system time"
    shared actual Instant instant() {
        return Instant( millis() );
    }
}


doc "Gets a clock that always returns the same instant in the UTC time-zone."
shared Clock fixedTime(Instant|Integer instant) {
    switch(instant)
    case (is Instant){
        return FixedInstant(instant);
    }
    case (is Integer){
        return FixedMilliseconds(instant);
    }
}

doc "Implementation of a clock that always returns the same instant.
     This is typically used for testing."
class FixedInstant(Instant fixedInstant) satisfies Clock {
    
    doc "Returns milliseconds from the fixed instant"
    shared actual Integer millis() {
        return fixedInstant.millis;
    }

    doc "Returns the fixed instant"
    shared actual Instant instant() {
        return fixedInstant;
    }
}

doc "Implementation of a clock that always returns the same instant.
     This is typically used for testing."
class FixedMilliseconds(Integer fixedMilliseconds) satisfies Clock {
    
    doc "Returns the fixed milliseconds"
    shared actual Integer millis() {
        return fixedMilliseconds;
    }

    doc "Returns the instant from the fixed milliseconds"
    shared actual Instant instant() {
        return Instant(fixedMilliseconds);
    }
}
