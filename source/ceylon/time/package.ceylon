doc """"Main package for the Ceylon's Date and Time library.
        
        Like in [JodaTime] and [JSR-310], there is a _machine timeline_ and a _human timeline_.
        
        [JodaTime]: http://joda-time.sourceforge.net
        [JSR-310]: http://sourceforge.net/apps/mediawiki/threeten/index.php?title=ThreeTen
        
        ## Machine timeline
        
        Machine timeline is represented by an [[Instant]] that is basically just an object 
        wrapper around an [[Integer]] representing _[Unix time]_ value. A value of an Instant 
        uniquely identifies a particular instant of time without needing to take into account
        timezone information and contain no ambiguities associated with [DST] changeover times.
        
        [Unix time]: http://en.wikipedia.org/wiki/Unix_time
        [DST]: http://en.wikipedia.org/wiki/Daylight_saving_time
        
        ## Human timeline
        
        Human timeline is based mostly on Gregorian and ISO 8601 calendar systems and consists of 
        the following principal data types:
        
        * [[Date]] -- A date value without time component
        * [[Time]] -- A time of day vallue without date component.
        * [[DateTime]] -- A particular time of a particular date.
        * [[ZoneDateTime]] -- A particular moment of time identified by date, time of day and 
          a time zone.
       
       **Note:** At the moment, timezone support and awareness is missing from the library, so
       all of the time and date types and conversions behave as though staying in UTC-0.
        """
by ("Diego Coronel", "Roland Tepp")
shared package ceylon.time;