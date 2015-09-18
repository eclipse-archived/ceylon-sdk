import ceylon.promise { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

shared class PromiseTest() extends AsyncTestBase() {
  
  shared test void testFulfilledFulfillmentHandlerReturnsValue() {
    variable Integer count = 0;
    void done(String s) {
      assertEquals(count++, 0);
      assertEquals("3", s);
      testComplete();
    }
    Deferred<Integer> deferred = Deferred<Integer>();
    Promise<Integer> promise = deferred.promise;
    promise.map(Integer.string).map(done, fail);
    deferred.fulfill(3);
    assertEquals(count, 0);
  }
  
  shared test void testRejectedRejectionHandlerReturnsAValue() {
    variable Integer count = 0;
    void done(String s) {
      assertEquals(count++, 0);
      assertEquals("3", s);
      testComplete();
    }
    Deferred<Integer> deferred = Deferred<Integer>();
    Promise<Integer> promise = deferred.promise;
    promise.map(Integer.string, (Throwable e) => "3").map(done, fail);
    deferred.reject(Exception());
    assertEquals(count, 0);
  }
  
  /*
   void testFulfillementState() {
   Deferred<Integer> deferred = Deferred<Integer>();
   assertEquals { expected = pending; actual = deferred.status; };
   deferred.resolve(3);
   assertEquals { expected = fulfilled; actual = deferred.status; };
   }
   
   void testRejectedState() {
   Deferred<Integer> deferred = Deferred<Integer>();
   Exception e = Exception();
   assertEquals { expected = pending; actual = deferred.status; };
   deferred.reject(e);
   assertEquals { expected = rejected; actual = deferred.status; };
   }
   */
  
}
