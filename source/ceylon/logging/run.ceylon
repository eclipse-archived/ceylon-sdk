"Run the module `ceylon.logging`."
shared void run() {
    addLogWriter((Priority p, Category c, String m) => print(p.string + " " + m));
    logger(`package ceylon.logging`).error("Something bad happened!");
}