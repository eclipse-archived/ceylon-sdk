import ceylon.test { beforeTest, afterTest, assertEquals_=assertEquals, assertTrue_=assertTrue, assertFalse_=assertFalse }
import ceylon.promise { Context, defineGlobalContext }
import ceylon.collection { LinkedList }

"""A base class for running asynchronous tests managing an event loop"""
shared class AsyncTestBase() {
  
  variable Boolean completed = false;
  variable Throwable? failed = null;
  
  object eventLoop satisfies Context {
    shared LinkedList<Anything()> queuedEvents = LinkedList<Anything()>();
    shared actual void run(void event()) {
      queuedEvents.add(event);
    }
  }
  
  shared void runOnContext(Anything() run) {
    assertFalse(completed);
    eventLoop.queuedEvents.add(run);
  }
  
  shared void testComplete() {
    if (!completed) {
      completed = true;
    } else {
      fail("Already completed");
    }
  }

  shared void assertEquals(Anything actual, Anything expected, String? message = null) {
    try {
      assertEquals_(actual, expected, message);
    } catch(Throwable failure) {
      failed = failure;
      throw failure;
    }
  }
  
  shared void assertTrue(Boolean condition, String? message = null) {
    try {
      assertTrue_(condition, message);
    } catch(Throwable failure) {
      failed = failure;
      throw failure;
    }
  }
  
  shared void assertFalse(Boolean condition, String? message = null) {
    try {
      assertFalse_(condition, message);
    } catch(Throwable failure) {
      failed = failure;
      throw failure;
    }
  }

  shared Throwable fail(String|Throwable cause) {
    if (is Throwable cause) {
      failed = cause;
      return cause;
    } else {
      value ex = Exception(cause);
      failed = ex;
      return ex;
    }
  }

  shared beforeTest void before() {
    completed = false;
    failed = null;
    eventLoop.queuedEvents.clear();
    defineGlobalContext(eventLoop);
  }
  
  shared afterTest void after() {
    while (!completed) {
      if (exists failure = failed) {
        throw failure;
      } else {
        if (exists event = eventLoop.queuedEvents.delete(0)) {
          event();
        } else {
          throw Exception("Test not completed");
        }
      }
    }
    if (exists event = eventLoop.queuedEvents.first) {
      throw Exception("Was expecting an empty queue: ``eventLoop.queuedEvents``");
    }
  }
}