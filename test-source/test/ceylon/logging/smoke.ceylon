import ceylon.logging { Logger, Writer, ListWriter, levelTrace, levelInfo, levelWarn, Configuration, levelDebug }
import ceylon.collection { LinkedList }
import ceylon.test { assertEquals, assertTrue, assertFalse }
void testSmoke() {
    //TODO -Djava.util.logging.manager=org.jboss.logmanager.LogManager
    
    LinkedList<String> logList = LinkedList<String>();
    Writer writer = ListWriter(logList);
    
    Configuration logConfig = Configuration {
        defaultWriter = writer; 
        rootLevel = levelInfo;
        loggerConfigs = {
            ["ceylon.smoke.foo", levelTrace, writer],
            ["ceylon.smoke", levelInfo, writer],
            ["ceylon.smoke.bar", levelWarn, writer]
        };
    };

    Logger smokeLogger => logConfig.logger("ceylon.smoke");
    smokeLogger.info("Info message from ceylon.smoke.");
    smokeLogger.debug("Debug message from ceylon.smoke.");
    
    print(logList);
    
    assertContains("Info message from ceylon.smoke.", logList);
    assertNotContains("Debug message from ceylon.smoke.", logList);
}

//TODO make generic and move to test module
void assertContains(String element, Collection<String> collection ) {
    assertTrue(collection.contains(element));
}

void assertNotContains(String element, Collection<String> collection ) {
    assertFalse(collection.contains(element));
}