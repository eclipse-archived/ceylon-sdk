import ceylon.collection { MutableMap, HashMap }
import ceylon.logging.internal { DefaultLogger }

doc "Configure logger."
by "Matej Lazar"
//TODO inject writter
shared class Configuration(
        Writer defaultWriter, 
        Level rootLevel,
        {[String,Level,Writer]+} loggerConfigs) {

    Logger rootLogger = createLogger("_ROOT_", rootLevel, defaultWriter);

    MutableMap<String, Logger> indexedLoggers = HashMap<String, Logger>();
    for (loggerConfig in loggerConfigs) {
        //TODO make writter optional, add default here ?
        
        value name = loggerConfig[0];
        value level = loggerConfig[1];
        value writer = loggerConfig[2];
        indexedLoggers.put(name, createLogger(name, level, writer));
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

Logger createLogger(String name, Level level, Writer writer) => DefaultLogger(name, level, writer);

