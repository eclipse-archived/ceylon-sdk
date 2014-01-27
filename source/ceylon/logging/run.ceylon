Logger myLogger = logger(`package ceylon.logging`);

shared void run() {
    addLogWriter(void (Priority p, Category c, String m, Exception? e) {
        print("[``system.milliseconds``] ``p.string`` ``m``");
        if (exists e) {
            e.printStackTrace();
        }
    });
    myLogger.error("Something bad happened!");
    myLogger.trace("Almost done");
    myLogger.info("Terminating!");
}