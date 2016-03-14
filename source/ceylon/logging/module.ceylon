"""Defines a platform-neutral API for writing log messages.
   This module does not actually define any infrastructure
   for log message output, so the program must register a
   [[LogWriter]] function at startup by calling 
   [[addLogWriter]], passing a log writer function.
   
       addLogWriter(writeSimpleLog);
   
   [[writeSimpleLog]] is a trivial log writer function that
   logs information to standard out and warnings and errors 
   to standard error. Your program will almost certainly 
   need to define its own log writer function that appends
   to a file, or whatever. 
   
   _By default, no log writer function is registered, and so
   nothing is logged._
   
   Log messages are written to a [[Logger]]. A canonical 
   `Logger` instance for a package or module may be obtained 
   by calling [[logger]].
   
       Logger log = logger(`module hello`);
   
   The methods [[Logger.fatal]], [[Logger.error]], 
   [[Logger.warn]], [[Logger.info]], [[Logger.debug]], and 
   [[Logger.trace]] write log messages with various
   [[priorities|Priority]].
   
       log.debug("trying to do something");
       try {
           doSomething();
       }
       catch (e) {
           log.error("something bad happened", e);
       }
   
   For log messages with interpolated expressions, these
   methods accept an anonymous function.
     
       log.debug(()=>"trying to do ``something``");
       try {
           do(something);
       }
       catch (e) {
           log.error(()=>"badness happened doing ``something``", e);
       }
    
   By default, only log messages with priority at least 
   [[info]] are sent to the `LogWriter` functions. To change
   the minimum priority, assign to [[defaultPriority]].
   
       defaultPriority = debug;
   
   Alternatively, we can assign an explicit priority to a
   specific `Logger` by assigning to [[Logger.priority]].
   
       logger(`module hello`).priority = debug;
   
   It's easy to customize the output by writing your own
   [[log writer function|LogWriter]]. For example, we can
   use `ceylon.time` and `ceylon.locale` to obtain a nicely
   formatter time and date:
   
       import ceylon.logging { ... }
       import ceylon.time { now }
       import ceylon.locale { systemLocale }
       
       ...
       
       addLogWriter {
           void log(Priority p, Category c, String m, Throwable? t) {
               value print 
                       = p <= info 
                       then process.write
                       else process.writeError;
               value instant = now();
               value formats = systemLocale.formats;
               value date = 
                       formats.shortFormatDate(instant.date());
               value time = 
                       formats.mediumFormatTime(instant.time());
               print("[``date`` at ``time``] ``p.string``: ``m``");
               print(operatingSystem.newline);
               if (exists t) {
                   printStackTrace(t, print);
               }
           }
       };
   
   Or, to log to a file, using `ceylon.file`:
   
       import ceylon.logging { ... }
       import ceylon.file { ... }

       File file;
       switch (resource = parsePath("log.txt").resource)
       case (is ExistingResource) {
           assert (is File resource);
           file = resource;
       }
       case (is Nil) {
           file = resource.createFile();
       }
       
       addLogWriter {
           void log(Priority p, Category c, String m, Throwable? t) {
               try (appender = file.Appender()) {
                   appender.writeLine("[``system.milliseconds``] ``p.string``: ``m``");
                   if (exists t) {
                       printStackTrace(t, appender.write);
                   }
               }
           }
       };
   
   For integration with other logging libraries, it is
   possible to completely replace the [[logger]] function
   with a custom function for producing `Logger`s.
   
       logger = (Category category)
           => JDKLoggerImpl(JDKLogger.getLogger(category.qualifiedName));"""
module ceylon.logging "1.2.3" {
    import ceylon.collection "1.2.3";
}
