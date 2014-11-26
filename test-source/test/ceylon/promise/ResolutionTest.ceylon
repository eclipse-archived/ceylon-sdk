import ceylon.promise { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

shared class ResolutionTest() extends AsyncTestBase() {
  
  Promise<Result> flatMapFail<Result, Value>(Value v) {
    throw fail("Was not expecting to be called");
  }

  shared test void testOnFulfilledAdoptPromiseThatResolves() {
    variable Integer count = 0;
    value deferred = Deferred<Integer>();
    Promise<String> f(Integer val) {
      assertEquals(count++, 0);
      assertEquals(val, 3);
      value adopted = Deferred<String>();
      adopted.fulfill("foo");
      return adopted.promise;
    }
    void g(String s) {
      assertEquals(count++, 1);
      assertEquals(s, "foo");
      testComplete();
    }
    Promise<Integer> promise = deferred.promise;
    promise.flatMap(f, flatMapFail).compose(g, fail);
    deferred.fulfill(3);
    assertEquals(count, 0);
  }
  
  shared test void testOnFulfilledAdoptPromiseThatRejects() {
    value reason = Exception();
    variable Integer count = 0;
    value deferred = Deferred<Integer>();
    Promise<String> f(Integer val) {
      assertEquals(count++, 0);
      assertEquals(val, 3);
      value adopted = Deferred<String>();
      adopted.reject(reason);
      return adopted.promise;
    }
    void g(Throwable s) {
      assertEquals(count++, 1);
      assertEquals(s, reason);
      testComplete();
    }
    Promise<Integer> promise = deferred.promise;
    promise.flatMap(f, flatMapFail).compose((String s) => fail("Was not expecting onFulfilled"), g);
    deferred.fulfill(3);
    assertEquals(count, 0);
  }
  
  shared test void testOnRejectedAdoptPromiseThatResolves() {
    value reason = Exception();
    variable Integer count = 0;
    value deferred = Deferred<Integer>();
    Promise<String> f(Throwable val) {
      assertEquals(count++, 0);
      assertEquals(val, reason);
      value adopted = Deferred<String>();
      adopted.fulfill("foo");
      return adopted.promise;
    }
    void g(String s) {
      assertEquals(count++, 1);
      assertEquals(s, "foo");
      testComplete();
    }
    Promise<Integer> promise = deferred.promise;
    promise.flatMap<String>(flatMapFail, f).compose(g, fail);
    deferred.reject(reason);
    assertEquals(count, 0);
  }
  
  shared test void testOnRejectedAdoptPromiseThatRejects() {
    value reason1 = Exception();
    value reason2 = Exception();
    variable Integer count = 0;
    value deferred = Deferred<Integer>();
    Promise<String> f(Throwable val) {
      assertEquals(count++, 0);
      assertEquals(val, reason1);
      value adopted = Deferred<String>();
      adopted.reject(reason2);
      return adopted.promise;
    }
    void g(Throwable t) {
      assertEquals(count++, 1);
      assertEquals(t, reason2);
      testComplete();
    }
    Promise<Integer> promise = deferred.promise;
    promise.flatMap<String>(flatMapFail, f).compose((String s) => fail("Was not expecting onFulfilled"), g);
    deferred.reject(reason1);
    assertEquals(count, 0);
  }
  
  shared test void testFulfillAnythingWithNull() {
    Deferred<Anything> deferred = Deferred<Anything>();
    deferred.fulfill(null);
    testComplete();
  }
}
