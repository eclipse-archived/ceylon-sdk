/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""Defines a platform-neutral API for writing log messages.
   
   _Important! By default, no log writer function is registered,
   and so nothing is logged. Read on to learn how to properly
   configure logging for your application_

   ## Adding logging to your module
   
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
   
   ## Configuring logging for your application
   
   If your module is going to be part of a larger application
   then the above is the only thing you need to know to add
   logging. But given the fact that this logging module does
   _not_ actually define any infrastructure for log message
   output, your application must at some point during startup
   register a [[LogWriter]] function by calling [[addLogWriter]]
   and passing it a log writer function. For example:
   
       addLogWriter(writeSimpleLog);
   
   [[writeSimpleLog]] is a trivial log writer function that
   logs information to standard out and warnings and errors 
   to standard error. Your program will almost certainly 
   need to define its own log writer function that appends
   to a file, or whatever. 
   
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
                       = p <= Priority.info 
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
       case (ExistingResource) {
           assert (is File resource);
           file = resource;
       }
       case (Nil) {
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
label("Ceylon Logging API")
module ceylon.logging maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    import ceylon.collection "1.3.4-SNAPSHOT";
}
