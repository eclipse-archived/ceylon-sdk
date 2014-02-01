"""Defines a platform-neutral API for writing log messages.
   This module does not actually define any infrastructure
   for log message output, so the program must register a
   [[LogWriter]] function at startup by calling 
   [[addLogWriter]].
   
       addLogWriter {
           void log(Priority p, Category c, String m, Exception? e) {
               value print = p<=info 
                       then process.writeLine 
                       else process.writeError;
               print("[``system.milliseconds``] ``p.string`` ``m``");
               if (exists e) {
                   printStackTrace(e, print);
               }
           }
       };
   
   Log messages are written to a [[Logger]]. A canonical 
   `Logger` instance for a package or module may be obtained 
   by calling [[logger]].
   
       Logger logger = logger(`module hello`);
   
   The methods [[Logger.fatal]], [[Logger.error]], 
   [[Logger.warn]], [[Logger.info]], [[Logger.debug]], and 
   [[Logger.trace]] write log messages with various
   [[priorities|Priority]].
   
       logger.debug("trying to do something");
       try {
           doSomething();
       }
       catch (e) {
           logger.error("something bad happened", e);
       }
   
   For log messages with interpolated expressions, these
   methods accept an anonymous function.
     
       logger.debug(()=>"trying to do ``something``");
       try {
           do(something);
       }
       catch (e) {
           logger.error(()=>"badness happened doing ``something``", e);
       }
    
   By default, only log messages with priority at least 
   [[info]] are sent to the `LogWriter` functions. To change
   the minimum priority, assign to [[defaultPriority]].
   
       defaultPriority = debug;
   
   Alternatively, we can assign an explicit priority to a
   specific `Logger` by assigning to [[Logger.priority]].
   
       logger(`module hello`).priority = debug;
   
   For integration with other logging libraries, it is
   possible to completely replace the [[logger]] function
   with a custom function for producing `Logger`s.
   
       logger = (Category category)
           => JDKLoggerImpl(JDKLogger.getLogger(category.qualifiedName));"""
module ceylon.logging "1.0.0" {
    import ceylon.collection "1.0.0";
}
