import ceylon.test { suite }
"Run the module `test.ceylon.logging`."
void run() {
    suite("ceylon.log",
        "Logging smoke" -> testSmoke,
        "Java logger config" -> testJavaLoggerConfig
    );
}