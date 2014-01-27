import ceylon.collection {
    HashMap, MutableList, MutableMap, ArrayList
}
import ceylon.language.meta.declaration {
    Module,
    Package
}

shared abstract class Priority(shared actual String string, Integer integer)
        of fatal|error|warn|info|debug|fine 
        satisfies Comparable<Priority> {
    shared actual Comparison compare(Priority other) 
            => integer<=>other.integer;
}
shared object fatal extends Priority("FATAL",100) {}
shared object error extends Priority("ERROR",90) {}
shared object warn extends Priority("WARN",80) {}
shared object info extends Priority("INFO",70) {}
shared object debug extends Priority("DEBUG",60) {}
shared object fine extends Priority("FINE",50) {}

shared abstract class Root() of root {}
shared object root extends Root() {}

shared alias Category => Module|Package|Root;

shared interface Logger {
    shared formal Category category;
    shared formal variable Priority priority;
    
    String render(String|String() message) {
        switch (message)
        case (is String) { return message; }
        case (is String()) { return message(); }
    }
    
    shared void log(Priority priority, String|String() message) {
        if (this.priority<=priority) {
            for (write in logWriters) {
                write(priority, category,render(message));
            }
        }
        
    }
    
    shared void fatal(String|String() message) 
            => log(package.fatal, message);
    shared void error(String|String() message) 
            => log(package.error, message);
    shared void warn(String|String() message) 
            => log(package.warn, message);
    shared void info(String|String() message) 
            => log(package.info, message);
    shared void debug(String|String() message)
            => log(package.debug, message);
    shared void fine(String|String() message)
            => log(package.fine, message);
}

shared object rootLogger satisfies Logger {
    category => root;
    shared actual variable Priority priority = package.warn;
}

MutableMap<Category,Logger> loggers = HashMap<Category,Logger>();

shared Logger logger(Category category) {
    if (exists logger = loggers[category]) {
        return logger;
    }
    else {
        value cat = category;
        object logger satisfies Logger {
            category => cat;
            variable Priority? currentPriority = null;
            shared actual Priority priority {
                return currentPriority else rootLogger.priority;
            }
            assign priority {
                currentPriority = priority;
            }
        }
        loggers.put(cat, logger);
        return logger;
    }
}

shared alias LogWriter => Anything(Priority,Category,String);

MutableList<LogWriter> logWriters = ArrayList<LogWriter>();

shared void addLogWriter(LogWriter logWriter) {
    logWriters.add(logWriter);
}