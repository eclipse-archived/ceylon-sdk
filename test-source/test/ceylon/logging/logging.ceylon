import ceylon.logging { Logger, Writer, ListWriter, levelTrace, levelInfo, levelWarn, Configuration, levelDebug, LoggerConfiguration }
import ceylon.collection { LinkedList }
import ceylon.test { assertTrue, assertFalse }
import ceylon.net.http.server { Server, createServer, StatusListener, Status, started }

void testSmoke() {
    //TODO -Djava.util.logging.manager=org.jboss.logmanager.LogManager
    
    LinkedList<String> logList = LinkedList<String>();
    Writer writer = ListWriter(logList);
    
    Configuration logConfig = Configuration {
        defaultWriter = writer; 
        rootLevel = levelInfo;
        loggers = {
            LoggerConfiguration("ceylon.smoke.foo", levelTrace, writer),
            LoggerConfiguration("ceylon.smoke", levelInfo, writer),
            LoggerConfiguration("ceylon.smoke.bar", levelWarn, writer)
        };
    };
    
    Logger smokeLogger => logConfig.logger("ceylon.smoke");
    smokeLogger.info("Info message from ceylon.smoke.");
    smokeLogger.debug("Debug message from ceylon.smoke.");
    
    print(logList);
    
    assertContains("Info message from ceylon.smoke.", logList);
    assertNotContains("Debug message from ceylon.smoke.", logList);
}

void testJavaLoggerConfig() {
    LinkedList<String> logList = LinkedList<String>();
    Writer writer = ListWriter(logList);
    
    Configuration logConfig = Configuration {
        defaultWriter = writer; 
        rootLevel = levelInfo;
        loggers = {
            LoggerConfiguration("org.xnio.nio", levelDebug, writer, true)
        };
    };

    Server server = createServer {};
    
    object serverListerner satisfies StatusListener {
        shared actual void onStatusChange(Status status) {
            if (status.equals(started)) {
                server.stop();
                print(logList);

                //assertContains("Info message from ceylon.smoke.", logList);
                //assertNotContains("Debug message from ceylon.smoke.", logList);
            }
        }
    }
    server.addListener(serverListerner);
    server.startInBackground();
    
    

//import org.jboss.logging { Logger {logger = getLogger}}
//import org.jboss.logmanager { LogManager = Logger {manager = getLogger}, Level { trace = TRACE, debug = DEBUG }}
//import org.jboss.logmanager.handlers { ConsoleHandler }

//    LogManager logManager = manager("org.xnio.nio");
//    print(logManager.level);
//
//    logManager.setLevelName("DEBUG");
//    logManager.level = debug;
//    
//    ConsoleHandler ch = ConsoleHandler();
//    ch.formatter = SimpleFormatter();
//    
//    logManager.addHandler(ch);
//    
//    print(logManager.level);
//    
//    LogManager utManager = manager("io.undertow");
//    utManager.setLevelName("DEBUG");
//    utManager.level = debug;
//    utManager.addHandler(ch);
//    
//    print(logManager.level);
//    
//
//    Logger log = logger("org.xnio.nio");
//    log.debug("Debug mesage");
//    log.info("Info mesage");

}


//TODO make generic and move to test module
void assertContains(String element, Collection<String> collection ) {
    assertTrue(collection.contains(element));
}

void assertNotContains(String element, Collection<String> collection ) {
    assertFalse(collection.contains(element));
}