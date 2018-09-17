/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
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
 
     Logger log = logger(`module org.hibernate`);
 
 Each `Logger` has a [[priority]]. Log messages with a 
 priority lower than the current priority of the `Logger` 
 will not be sent.
 
     log.priority = warn;
     log.info(\"hello\"); //not sent
     log.error(\"sos\"); //sent"
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
        case (String) { return message; }
        case (String()) { return message(); }
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
            => log(Priority.fatal, message, throwable);
    
    "Send an [[ceylon.logging::error]] log message."
    shared void error(Message message,
                    Throwable? throwable=null) 
            => log(Priority.error, message, throwable);
    
    "Send a [[ceylon.logging::warn]] log message."
    shared void warn(Message message,
                    Throwable? throwable=null) 
            => log(Priority.warn, message, throwable);
    
    "Send an [[ceylon.logging::info]] log message."
    shared void info(Message message,
                    Throwable? throwable=null) 
            => log(Priority.info, message, throwable);
    
    "Send a [[ceylon.logging::debug]] log message."
    shared void debug(Message message,
                    Throwable? throwable=null)
            => log(Priority.debug, message, throwable);
    
    "Send a [[ceylon.logging::trace]] log message."
    shared void trace(Message message,
                    Throwable? throwable=null)
            => log(Priority.trace, message, throwable);
    
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
        loggers[category.name] = logger;
        return logger;
    }
};

MutableMap<String,Logger> loggers = HashMap<String,Logger>();

class LoggerImpl(shared actual Category category) 
        satisfies Logger {
    variable Priority? explicitPriority = null;
    
    shared actual Priority priority 
            => explicitPriority else defaultPriority;
    assign priority 
            => explicitPriority = priority;
    
    shared actual void log(Priority priority, 
            Message message, 
            Throwable? throwable) {
        if (enabled(priority)) {
            for (writeLog in logWriters) {
                writeLog(priority, category, 
                        render(message), 
                        throwable);
            }
        } 
    }
}
