import ceylon.logging {
    logger,
    Logger,
    addLogWriter,
    Priority,
    Category,
    fatal,
    error,
    warn,
    info,
    debug,
    trace
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
Level jdkLevel(Priority priority) {
    switch (priority)
    case (fatal) { return Level.\iSEVERE; }
    case (error) { return Level.\iSEVERE; }
    case (warn) { return Level.\iWARNING; }
    case (info) { return Level.\iINFO; }
    case (debug) { return Level.\iFINE; }
    case (trace) { return Level.\iFINER; }
}

test void run() {
    //jdkLogger.level=jdkLevel(info);
    //jdkLogger.info("hello world");
    variable value count = 0;
    addLogWriter {
        void log(Priority p, Category c, String m, Exception? e) {
            value print = p<=info then process.writeLine else process.writeError;
            print("[``system.milliseconds``] ``p.string`` ``m``");
            if (exists e) {
                e.printStackTrace();
            }
        }
    };
    addLogWriter (void (Priority p, Category c, String m, Exception? e) 
                => count++);
    addLogWriter(void (Priority p, Category c, String m, Exception? e) 
                => jdkLogger.log(jdkLevel(p), m));
    myLogger.error("Something bad happened!");
    myLogger.trace("Almost done");
    myLogger.info("Terminating!");
    assert (count==2);
}