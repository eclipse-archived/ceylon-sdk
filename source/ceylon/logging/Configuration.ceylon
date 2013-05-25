import ceylon.collection { MutableMap, HashMap }
import ceylon.logging.internal { DefaultLogger, JavaLogger }

doc "Configure logger."
by "Matej Lazar"
//TODO inject writter
shared class Configuration (
        Writer defaultWriter, 
        Level rootLevel,
        {LoggerConfiguration+} loggers) {
    //TODO configure java root logger
    Logger rootLogger = createDefaultLogger("_ROOT_", rootLevel, defaultWriter);

    MutableMap<String, Logger> indexedLoggers = HashMap<String, Logger>();
    for (logger in loggers) {
        //TODO make writter optional, add default here ?
        indexedLoggers.put(logger.name, createLogger(logger));
    }
    
    shared Logger logger(String name) {
        Logger? loggger = indexedLoggers.get(name);
        if (exists l = loggger) {
            return l;
        } else {
            return parent(name);
        }
    }

    Logger parent(String childName) {
        //TODO dot parent search
        return rootLogger;
    }
}

shared class LoggerConfiguration (
    shared String name,
    shared Level level,
    shared Writer writer,
    shared Boolean javaLib = false) {}



Logger createLogger(LoggerConfiguration config) {
    if (config.javaLib) {
        return createJavaLogger(config.name, config.level, config.writer);
    } else {
        return createDefaultLogger(config.name, config.level, config.writer);
    }
}
Logger createDefaultLogger(String name, Level level, Writer writer) => DefaultLogger(name, level, writer);
Logger createJavaLogger(String name, Level level, Writer writer) => JavaLogger(name, level, writer);

