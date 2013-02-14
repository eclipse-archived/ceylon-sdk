import ceylon.util.logging { logManager }

doc "Interface to log messages."
by "Matej Lazar"
shared interface Log {
    
    shared void fatal(String message) {
        log(levelFatal, message);
    }
    
    shared void error(String message) {
        log(levelError, message);
    }
    
    shared void warn(String message) {
        log(levelWarn, message);
    }
    
    shared void info(String message) {
        log(levelInfo, message);
    }
    
    shared void debug(String message) {
        log(levelDebug, message);
    }
    
    shared void trace(String message) {
        log(levelTrace, message);
    }
    
    shared formal void log(Level level, String message);
    
    shared formal variable Level? logLevel;

}

doc "Get log instance."
shared Log logInstance(String name) => logManager.loggerInstance(name); 

shared abstract class Level(Integer level) of levelFatal | levelError | levelWarn | levelInfo | levelDebug | levelTrace {
    shared Integer getLevel() {
        return level;
    }
}

shared object levelFatal extends Level(600) {
    shared actual String string = "fatal"; 
}

shared object levelError extends Level(500) {
    shared actual String string = "error";
}
shared object levelWarn extends Level(400) {
    shared actual String string = "warn "; 
}

shared object levelInfo extends Level(300) {
    shared actual String string = "info "; 
}

shared object levelDebug extends Level(200) {
    shared actual String string = "debug"; 
}

shared object levelTrace extends Level(100) {
    shared actual String string = "trace"; 
}
