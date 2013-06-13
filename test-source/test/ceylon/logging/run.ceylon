import ceylon.test { suite }
import java.lang { System { sysProperty = setProperty }}
"Run the module `test.ceylon.logging`."
void run() {
    suite("ceylon.log",
        "Logging smoke" -> testSmoke,
        "Java logger config" -> testJavaLoggerConfig
    );
}