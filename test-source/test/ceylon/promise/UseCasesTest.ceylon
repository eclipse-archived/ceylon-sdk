import ceylon.promise {
  Deferred,
  Promise
}
import ceylon.test {
  test
}
shared class UseCasesTest() extends AsyncTestBase() {
  
  // Disabled until we cane make onFulfilled optional again
  /*
   void testNoFulfilledWithCasting() {
    Deferred<String> d = Deferred<String>();
    LinkedList<String> collected = LinkedList<String>();
    void foo(String s) {
      collected.add(s);
    }
    d.promise.then_<String>().then_(foo);
    d.resolve("foo");
    assertEquals { expected = {"foo"}; actual = collected; };
   }
   
   void testNoFulfilledWithNoCasting() {
    Deferred<String> d = Deferred<String>();
    LinkedList<Exception> collected = LinkedList<Exception>();
    void foo(Exception e) {
      collected.add(e);
    }
    d.promise.then_<Boolean>().then_{onRejected = foo;};
    d.resolve("foo");
    assertEquals { expected = 1; actual = collected.size; };
   }
   */
  
  shared test void testReject() {
    Deferred<Integer> deferred = Deferred<Integer>();
    Exception reason = Exception();
    variable Integer count = 0;
    void onRejected(Throwable t) {
      assertEquals(count++, 0);
      assertEquals(t, reason);
      testComplete();
    }
    Promise<Integer> promise = deferred.promise;
    promise.compose((Integer i) => fail("Was not expecting onFulfilled"), onRejected);
    deferred.reject(reason);
    assertEquals(count, 0);
  }
  
  shared test void testFail() {
    Deferred<Integer> deferred = Deferred<Integer>();
    Exception reason = Exception();
    variable Integer count = 0;
    void onRejected(Throwable t) {
      assertEquals(count++, 0);
      assertEquals(t, reason);
      testComplete();
    }
    Promise<Integer> promise = deferred.promise;
    promise.compose((Integer i) { throw reason; }, fail).compose((Anything i) => fail("Was not expecting onFufilled"), onRejected);
    deferred.fulfill(3);
    assertEquals(count, 0);
  }
  
  shared test void testCatchException() => testCatchReason(Exception());
  
  shared test void testCatchAssertionError() => testCatchReason(AssertionError("whatever"));

  void testCatchReason(Throwable reason) {
    variable Integer count = 0;
    Deferred<Integer> deferred = Deferred<Integer>();
    Integer bar(Throwable e) {
      assertEquals(count++, 0);
      assertEquals(reason, e);
      return 4;
    }
    void onFulfilled(Integer i) {
      assertEquals(count++, 1);
      assertEquals(i, 4);
      testComplete();
    }
    Promise<Integer> promise = deferred.promise;
    promise.compose((Integer i) { throw reason; }).compose(identity, bar).compose(onFulfilled);
    deferred.fulfill(3);
    assertEquals(count, 0);
  }
  
  shared test void testResolveWithPromise() {
    variable Integer count = 0;    
    Deferred<Integer> di = Deferred<Integer>();
    Promise<Integer> promise = di.promise;
    Promise<String> p = promise.compose {
      String onFulfilled(Integer integer) {
        assertEquals(count++, 0);
        assertEquals(integer, 4);
        return integer.string;
      }
    };
    Deferred<String> d = Deferred<String>();
    d.promise.compose {
      void onFulfilled(String s) {
        assertEquals(count++, 1);
        assertEquals(s, "4");
        testComplete();
      }
    };
    d.fulfill(p);
    assertEquals(count, 0);
    runOnContext {
      void run() {
        assertEquals(count, 0);
        di.fulfill(4);
        assertEquals(count, 0);
      }
    };
  }
  
  shared test void testComposeWithPromise() {
    Deferred<Integer> deferred = Deferred<Integer>();
    Deferred<String> resolving = Deferred<String>();
    variable Integer count = 0;
    deferred.promise.flatMap {
      Promise<String> onFulfilled(Integer i) {
        assertEquals(count++, 0);
        assertEquals(i, 4);
        return resolving.promise;
      }
    }.onComplete {
      void onFulfilled(String s) {
        assertEquals(count++, 1);
        assertEquals(s, "foo");
        testComplete();
      }
    };
    deferred.fulfill(4);
    assertEquals(count, 0);
    runOnContext {
      void run() {
        assertEquals(count, 1);
        resolving.fulfill("foo");
        assertEquals(count, 1);
      }
    };
  }
}