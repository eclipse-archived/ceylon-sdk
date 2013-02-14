import ceylon.util.logging { Log, Level, LogWriter, logManager }
import ceylon.util.logging.internal { DefaultLogManager }

by "Matej Lazar"
shared class DefaultLog(String name, LogWriter writer) satisfies Log {

    shared actual variable Level? logLevel = null;

    shared actual void log(Level level, String message) {
        if (level.getLevel() >= resolvedLogLevel().getLevel()) {
            //LogWriter writer = logManager.getLogWriter();
            writer.write("``level.string.uppercased`` ``process.milliseconds`` ``name``: ``message``");
        }
    }
    
    shared Level resolvedLogLevel() {
        if (exists l = logLevel) {
            return l;
        } else {
            if (is DefaultLogManager l = logManager) {
                value parent = l.getParent(this);
                if (is DefaultLog p = parent) {
                    return p.resolvedLogLevel();
                } else {
                    throw Exception("Parent should be instance of the same class (DefaultLog).");
                }
            } else {
                throw Exception("Default log should use DefaultLogManager.");
            }
        }
    }

    
}

