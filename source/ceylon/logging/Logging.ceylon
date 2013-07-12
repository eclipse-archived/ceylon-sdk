import ceylon.collection { MutableMap, HashMap }
import ceylon.logging.internal { DefaultLogger, JavaLogger }
import ceylon.logging.writer { Writer, ConsoleWriter }

"Configure logger."
by ("Matej Lazar")
String rootLoggerName = "_ROOT_";
MutableMap<String, Logger> indexedLoggers = HashMap<String, Logger>(
    //TODO configure java root logger
    {rootLoggerName -> DefaultLogger(rootLoggerName, levelInfo, ConsoleWriter())}
);

shared class Configuration (
        Writer defaultWriter, 
        Level rootLevel,
        {LoggerConfiguration*} loggers = empty) {

    indexedLoggers.clear();
    indexedLoggers.put(rootLoggerName, DefaultLogger(rootLoggerName, rootLevel, defaultWriter));

    for (logger in loggers) {
        //TODO make writter optional, add default here ?
        indexedLoggers.put(logger.name, createLogger(logger));
    }
}

shared class LoggerConfiguration (
    shared String name,
    shared Level level,
    shared Writer writer,
    shared Boolean delagateToJavaModule = false) {}

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
    if (exists rootLogger = indexedLoggers.get(rootLoggerName)) {
        return rootLogger;
    } else {
        throw Exception("Something went wrong, root logger shoud be defined.");
    }
}

Logger createLogger(LoggerConfiguration config) {
    if (config.delagateToJavaModule) {
        return JavaLogger(config.name, config.level, config.writer);
    } else {
        return DefaultLogger(config.name, config.level, config.writer);
    }
}
