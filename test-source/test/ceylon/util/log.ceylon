import ceylon.util.logging { logInstance, levelTrace, LogSupport, logManager, ListWriter, levelDebug }
import ceylon.collection { LinkedList, MutableList }
import ceylon.test { assertTrue, assertFalse }

void testLog() {
    value list = LinkedList<String>(); 

    logManager.logWriter = ListWriter(list);
    
    LoggingTest().test(list);
    SupportedLoggingTest().test(list);
    
    print(list);
}

class LoggingTest() {

    shared void test(MutableList<String> list) {
    
    
        value log1 = logInstance("log1");
        log1.info("info 1");
        log1.error("error 1");
        log1.debug("debug 1");

        value log3 = logInstance("log3");
        log3.logLevel = levelTrace;
        log3.info("info 3");
        log3.error("error 3");
        log3.debug("debug 3");
        
        value log31 = logInstance("log3");
        log31.info("info 31");
        log31.error("error 31");
        log31.debug("debug 31");

        value log5 = logInstance("log5");
        log5.info("info 5");
        log5.error("error 5");
        log5.debug("debug 5");

        //default level is info
        assertTrue(logContains("info 1", list));
        assertTrue(logContains("error 1", list));
        assertFalse(logContains("debug 1", list));
        
        //check level config
        assertTrue(logContains("info 3", list));
        assertTrue(logContains("error 3", list));
        assertTrue(logContains("debug 3", list));
        
        //check if we get the same instance with the same name
        assertTrue(logContains("info 31", list));
        assertTrue(logContains("error 31", list));
        assertTrue(logContains("debug 31", list));
        
        //check if new istance still uses defaults
        assertTrue(logContains("info 5", list));
        assertTrue(logContains("error 5", list));
        assertFalse(logContains("debug 5", list));
    }
    
    
}

class SupportedLoggingTest() satisfies LogSupport {
    shared void test(MutableList<String> list) {
        log.logLevel = levelDebug;
        log.info("supported info");
        log.error("supported error");
        log.debug("supported debug");
        log.trace("supported trace");
        
        //check for class name
        assertTrue(logContains(className(this), list));
        
        assertTrue(logContains("supported info", list));
        assertTrue(logContains("supported error", list));
        assertTrue(logContains("supported debug", list));
        assertFalse(logContains("supported trace", list));
        
    }
}


Boolean logContains(String message, List<String> messagesList) {
    for (String msg in messagesList) {
        if (msg.contains(message)) {
            return true;
        }
    }
    return false;
}
