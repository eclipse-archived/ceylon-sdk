import ceylon.collection {
    HashMap,
    MutableMap
}
import ceylon.language.meta.declaration {
    Module,
    Package
}

"A topic to which a log message relates."
see (`value logger`, `value Logger.category`)
shared alias Category => Module|Package;

"An object that sends log messages relating to a particular
 [[topic|category]]. A `Logger` instance for a [[Category]] 
 may be obtained by invoking [[logger]].
 
     Logger logger = logger(`module org.hibernate`);
 
 Each `Logger` has a [[priority]]. Log messages with a 
 priority lower than the current priority of the `Logger` 
 will not be sent.
 
     logger.priority = warn;
     logger.info(\"hello\"); //not sent
     logger.error(\"sos\"); //sent"
see (`value logger`)
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
     Optionally, an [[exception]] may be given."
    shared formal void log(Priority priority, 
                    Message message, 
                    Exception? exception=null);
    
    "Send a [[ceylon.logging::fatal]] log message."
    shared void fatal(Message message,
                    Exception? exception=null) 
            => log(package.fatal, message, exception);
    
    "Send an [[ceylon.logging::error]] log message."
    shared void error(Message message,
                    Exception? exception=null) 
            => log(package.error, message, exception);
    
    "Send a [[ceylon.logging::warn]] log message."
    shared void warn(Message message,
                    Exception? exception=null) 
            => log(package.warn, message, exception);
    
    "Send an [[ceylon.logging::info]] log message."
    shared void info(Message message,
                    Exception? exception=null) 
            => log(package.info, message, exception);
    
    "Send a [[ceylon.logging::debug]] log message."
    shared void debug(Message message,
                    Exception? exception=null)
            => log(package.debug, message, exception);
    
    "Send a [[ceylon.logging::trace]] log message."
    shared void trace(Message message,
                    Exception? exception=null)
            => log(package.trace, message, exception);
    
}

"Function to obtain a canonical [[Logger]] for the given 
 [[Category]]. For each [[Category]], there is at most one 
 instance of `Logger`.
 
 Assigning a new function of type `Logger(Category)` to
 `logger` allows the program to specify a custom strategy 
 for `Logger` instantiation."
shared variable Logger(Category) logger 
        = (Category category) {
    if (exists logger = loggers[category.name]) {
        return logger;
    }
    else {
        value logger = LoggerImpl(category); 
        loggers.put(category.name, logger);
        return logger;
    }
};

MutableMap<String,Logger> loggers = HashMap<String,Logger>();

class LoggerImpl(shared actual Category category) 
        satisfies Logger {
    variable Priority? explicitPriority = null;
    shared actual Priority priority {
        return explicitPriority else defaultPriority;
    }
    assign priority {
        explicitPriority = priority;
    }
    shared actual void log(Priority priority, 
            Message message, 
            Exception? exception) {
        if (enabled(priority)) {
            for (writeLog in logWriters) {
                writeLog(priority, category, 
                        render(message), 
                        exception);
            }
        } 
    }
}
