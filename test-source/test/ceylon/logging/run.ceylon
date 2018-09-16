import ceylon.logging {
    logger,
    Logger,
    addLogWriter,
    Priority { ... },
    Category
}
import ceylon.test {
    test
}

import java.util.logging {
    JLogger=Logger {
        getLogger
    },
    Level
}

Logger myLogger = logger(`package ceylon.logging`);

JLogger jdkLogger = getLogger(`package ceylon.logging`.qualifiedName);
Level jdkLevel(Priority priority) 
        => switch (priority)
        case (fatal|error) Level.severe
        case (warn) Level.warning
        case (info) Level.info
        case (debug) Level.fine
        case (trace) Level.finer;

test void run() {
    //jdkLogger.level=jdkLevel(info);
    //jdkLogger.info("hello world");
    variable value count = 0;
    addLogWriter {
        void log(Priority p, Category c, String m, Throwable? t) {
            value print = p<=info then process.writeLine else process.writeError;
            print("[``system.milliseconds``] ``p.string`` ``m``");
            if (exists t) {
                t.printStackTrace();
            }
        }
    };
    addLogWriter (void (Priority p, Category c, String m, Throwable? t)
                => count++);
    addLogWriter(void (Priority p, Category c, String m, Throwable? t)
                => jdkLogger.log(jdkLevel(p), m));
    myLogger.error("Something bad happened!");
    myLogger.trace("Almost done");
    myLogger.info("Terminating!");
    assert (count==2);
}