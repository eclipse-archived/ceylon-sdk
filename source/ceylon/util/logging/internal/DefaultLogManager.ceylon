import ceylon.collection { MutableMap, HashMap }
import ceylon.util.logging { Log, levelInfo, LogWriter, LogManager, ConsoleWriter }

by "Matej Lazar"
shared class DefaultLogManager() satisfies LogManager {
    
    variable LogWriter logWriter = ConsoleWriter(); 
    
    Log rootLogger = DefaultLog("", logWriter);
    rootLogger.setLogLevel(levelInfo);
    
    MutableMap<String, Log> loggers = HashMap<String, Log>();
    
    shared actual Log getLogger(String name) {
        if ( exists logger = loggers.get(name)) {
            return logger;
        } else {
            value logger = DefaultLog(name, logWriter);
             //TODO implement tree
            loggers.put(name, logger);
            return logger;
        }
    }
    
    shared Log getParent(Log log) { 
        //TODO implement tree
        return rootLogger;
    }
    
    shared LogWriter getLogWriter() {
        return logWriter;
    }

    shared actual void setLogWriter(LogWriter writer) {
        logWriter = writer;
    }
}
