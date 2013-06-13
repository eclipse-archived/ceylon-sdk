import ceylon.logging { Logger, levelTrace, levelInfo, levelWarn, Configuration, LoggerConfiguration }
import ceylon.collection { LinkedList, MutableList }
import ceylon.test { assertTrue, assertFalse, AssertException }
import ceylon.net.http.server { Server, createServer, StatusListener, Status, started, stopped }
import ceylon.logging.writer { Writer, ListWriter }

void testSmoke() {
    //java system prop must be set: -Djava.util.logging.manager=org.jboss.logmanager.LogManager
    
    MutableList<String> list = LinkedList<String>();
    Writer writer = ListWriter(list);
    
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
    
    print(list);
    
    assertContains("Info message from ceylon.smoke.", list);
    assertNotContains("Debug message from ceylon.smoke.", list);
}

void testJavaLoggerConfig() {
    MutableList<String> list = LinkedList<String>();
    Writer writer = ListWriter(list);
    //Writer writer = ConsoleWriter();
    
    Configuration logConfig = Configuration {
        defaultWriter = writer; 
        rootLevel = levelInfo;
        loggers = {
            LoggerConfiguration("org.xnio.nio", levelInfo, writer, true)
        };
    };

    Server server = createServer {};
    
    object serverListerner satisfies StatusListener {
        shared actual void onStatusChange(Status status) {
            if (status.equals(started)) {
                server.stop();
            } else if (status.equals(stopped)) {
                print(list.string);
                assertListElementMatches("XNIO NIO Implementation Version", list);
                assertListElementNotMatches("Started channel thread", list);
            }
        }
    }
    server.addListener(serverListerner);
    server.start();

}


//TODO make generic and move to test module
void assertContains(String element, Collection<String> collection ) {
    assertTrue(collection.contains(element));
}

void assertNotContains(String element, Collection<String> collection ) {
    assertFalse(collection.contains(element));
}

void assertListElementMatches(String element, Collection<String> collection, String message = "") {
    for (c in collection) {
        if (c.contains(element)) {
            return;
        }
    }
    throw AssertException("assertion failed: `` message ``");
}

void assertListElementNotMatches(String element, Collection<String> collection, String message = "") {
    variable Boolean contains = false;
    for (c in collection) {
        if (c.contains(element)) {
            contains = true;
        }
    }
    if (contains) {
        throw AssertException("assertion failed: `` message ``");
    }
}

