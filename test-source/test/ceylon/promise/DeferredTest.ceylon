import ceylon.promise { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

shared class DeferredTest() extends AsyncTestBase() {
  
  void performFulfill(<String|Exception>* actions) {
    variable Integer count = 0;
    void onFulfilled(String s) {
      assertEquals(count++, 0);
      assertEquals(s, "value");
      testComplete();
    }
    Deferred<String> deferred = Deferred<String>();
    Promise<String> promise = deferred.promise;
    promise.map(onFulfilled, fail);
    for (action in actions) {
      switch (action)
      case (is String) {
        deferred.fulfill(action);
      }
      case (is Exception) {
        deferred.reject(action);
      }
    }
    assertEquals(count, 0);
  }

  shared test void testResolve1() {
    performFulfill("value");
  }
  
  shared test void testResolve2() {
    performFulfill("value", "done");
  }
  
  shared test void testResolve3() {
    performFulfill("value", Exception());
  }

  void performReject(Throwable reason, <String|Exception>* actions) {
    variable Integer count = 0;
    void onRejected(Throwable t) {
      assertEquals(count++, 0);
      assertEquals(t, reason);
      testComplete();
    }
    Deferred<String> deferred = Deferred<String>();
    Promise<String> promise = deferred.promise;
    promise.map((String s) => fail("Was not expecting a fulfill"), onRejected);
    for (action in actions) {
      switch (action)
      case (is String) {
        deferred.fulfill(action);
      }
      case (is Exception) {
        deferred.reject(action);
      }
    }
    assertEquals(0, count);
  }

  shared test void testReject1() {
    Exception reason = Exception();
    performReject(reason, reason);
  }

  shared test void testReject2() {
    Exception reason = Exception();
    performReject(reason, reason, "done");
  }

  shared test void testReject3() {
    Exception reason = Exception();
    performReject(reason, reason, Exception());
  }

  shared test void testThenAfterResolve() {
    variable Integer count = 0;
    void onFulfilled(String s) {
      assertEquals(count++, 0);
      assertEquals("value", s);
      testComplete();
    }
    value deferred = Deferred<String>();
    deferred.fulfill("value");
    Promise<String> promise = deferred.promise;
    promise.map(onFulfilled, fail);
    assertEquals(count, 0);
  }

  shared test void testThenAfterReject() {
    Exception reason = Exception();
    variable Integer count = 0;
    void onRejected(Throwable t) {
      assertEquals(count++, 0);
      assertEquals(reason, t);
      testComplete();
    }    
    value deferred = Deferred<String>();
    deferred.reject(reason);
    Promise<String> promise = deferred.promise;
    promise.map((String s) => fail("Was not expecting a fulfill"), onRejected);
    assertEquals(count, 0);
  }
}
