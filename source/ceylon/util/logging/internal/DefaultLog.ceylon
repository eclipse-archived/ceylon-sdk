import ceylon.util.logging { Log, Level, LogWriter, logManager }
import ceylon.util.logging.internal { DefaultLogManager }

by "Matej Lazar"
shared class DefaultLog(String name, LogWriter writer) satisfies Log {

    shared variable Level? logLevel = null;

    shared actual void log(Level level, String message) {
        if (level.getLevel() >= getLogLevel().getLevel()) {
            //LogWriter writer = logManager.getLogWriter();
            writer.write("``level.string.uppercased`` ``process.milliseconds`` ``name``: ``message``");
        }
    }
    
    shared actual Level getLogLevel() {
        if (exists l = logLevel) {
            return l;
        } else {
            if (is DefaultLogManager l = logManager) {
                value parent = l.getParent(this);
                return parent.getLogLevel();
            } else {
                throw Exception("Default log should use DefaultLogManager.");
            }
        }
    }
    
    shared actual void setLogLevel(Level level) {
        logLevel = level;
    }
}

