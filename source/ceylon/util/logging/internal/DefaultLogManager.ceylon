import ceylon.collection { MutableMap, HashMap }
import ceylon.util.logging { Log, levelInfo, LogWriter, LogManager, ConsoleWriter }

by "Matej Lazar"
shared class DefaultLogManager() satisfies LogManager {
    
    shared actual variable LogWriter logWriter = ConsoleWriter();
    
    Log rootLogger = DefaultLog("", logWriter);
    rootLogger.logLevel = levelInfo;
    
    MutableMap<String, Log> loggers = HashMap<String, Log>();
    
    shared actual Log loggerInstance(String name) {
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
    
}
