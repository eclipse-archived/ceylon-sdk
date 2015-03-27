import ceylon.language.meta.declaration {
    Module,
    Package
}

"A topic to which a log message relates."
see (`function logger`, `value Logger.category`)
shared alias Category => Module|Package;

"An object that sends log messages relating to a particular
 [[topic|category]]. A `Logger` instance for a [[Category]] 
 may be obtained by invoking [[logger]].
 
     Logger log = logger(`module org.hibernate`);
 
 Each `Logger` has a [[priority]]. Log messages with a 
 priority lower than the current priority of the `Logger` 
 will not be sent.
 
     log.priority = warn;
     log.info(\"hello\"); //not sent
     log.error(\"sos\"); //sent"
see (`function logger`)
shared interface Logger {
    
    "A log message, which may be a string or an unevaluated 
     string, represented by the function type `String()`."
    shared alias Message => String|String();
    
    "The [[topic|Category]] to which log messages sent by 
     this `Logger` relate."
    shared formal Category category;
    
    "The current priority of this `Logger`. If not 
     explicitly set, the [[default|defaultPriority]] 
     priority is used."
    see (`value defaultPriority`, `function enabled`)
    shared formal variable Priority priority;
    
    "Evaluate the given message, producing a [[String]]."
    shared String render(Message message) {
        switch (message)
        case (is String) { return message; }
        case (is String()) { return message(); }
    }
    
    "Determines if log messages with the given priority will
     be sent by this `Logger`. That is, if the given 
     priority is at least as high as this `Logger`s
     [[current priority|Logger.priority]]."
    shared Boolean enabled(Priority priority) 
            => this.priority<=priority;
    
    "Send a log [[message]] with the given [[priority]].
     Optionally, a [[throwable]] may be given."
    shared formal void log(Priority priority, 
                    Message message, 
                    Throwable? throwable=null);
    
    "Send a [[ceylon.logging::fatal]] log message."
    shared void fatal(Message message,
                    Throwable? throwable=null) 
            => log(package.fatal, message, throwable);
    
    "Send an [[ceylon.logging::error]] log message."
    shared void error(Message message,
                    Throwable? throwable=null) 
            => log(package.error, message, throwable);
    
    "Send a [[ceylon.logging::warn]] log message."
    shared void warn(Message message,
                    Throwable? throwable=null) 
            => log(package.warn, message, throwable);
    
    "Send an [[ceylon.logging::info]] log message."
    shared void info(Message message,
                    Throwable? throwable=null) 
            => log(package.info, message, throwable);
    
    "Send a [[ceylon.logging::debug]] log message."
    shared void debug(Message message,
                    Throwable? throwable=null)
            => log(package.debug, message, throwable);
    
    "Send a [[ceylon.logging::trace]] log message."
    shared void trace(Message message,
                    Throwable? throwable=null)
            => log(package.trace, message, throwable);
    
}

"Function to obtain a canonical [[Logger]] for the given 
 [[Category]]. For each [[Category]], there is at most one 
 instance of `Logger`.

 This function delegates to [[loggerFactory]]."
shared Logger logger(Category category)
    =>  loggerFactory.logger(category);
