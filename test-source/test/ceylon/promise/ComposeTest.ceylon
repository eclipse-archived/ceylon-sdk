import ceylon.promise { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

shared class ComposeTest() extends AsyncTestBase() {
  
  shared test void testAllRespectiveFulfilledCallbacksMustExecuteInTheOrderOfTheirOriginatingCallsToThen() {
    variable Integer status = 0;
    void onFulfilled1(String s) {
      assertEquals(status, 0);
      status = 1;
      assertEquals(s, "val");
    }
    void onFulfilled2(String s) {
      assertEquals(status, 1);
      status = 2;
      assertEquals(s, "val");
      testComplete();
    }
    value d = Deferred<String>();	
    Promise<String> promise = d.promise;
    promise.compose(onFulfilled1);
    promise.compose(onFulfilled2);
    d.fulfill("val");
    assertEquals(status, 0);
  }
  
  shared test void testAllRespectiveRejectedCallbacksMustExecuteInTheOrderOfTheirOriginatingCallsToThen() {
    Exception reason = Exception();
    variable Integer status = 0;
    void onRejected1(Throwable t) {
      assertEquals(status, 0);
      status = 1;
      assertEquals(t, reason);
    }
    void onRejected2(Throwable t) {
      assertEquals(status, 1);
      status = 2;
      assertEquals(t, reason);
      testComplete();
    }
    value d = Deferred<String>();	
    Promise<String> promise = d.promise;
    promise.compose(fail, onRejected1);
    promise.compose(fail, onRejected2);
    d.reject(reason);
    assertEquals(status, 0);
  }
  
  shared test void testReturnedPromiseMustBeRejectWithSameReasonWhenOnFulfilledThrowsAnException() {
    Exception failure = Exception();
    variable Integer count = 0;
    void onFulfilled(Integer i) {
      assertEquals(count++, 0);
      assertEquals(i, 3);
      throw failure;
    }
    Deferred<Integer> deferred = Deferred<Integer>();
    Promise<Integer> promise = deferred.promise;
    void onRejected(Throwable t) {
      assertEquals(count++, 1);
      assertEquals(failure, t);
      testComplete();
    }
    promise.compose(onFulfilled, fail).compose((Anything s) => fail("Was not expecting a call to onFulfilled"), onRejected);
    deferred.fulfill(3);
    assertEquals(count, 0);
  }
  
  shared test void testReturnedPromiseMustBeRejectedWithSameReasonWhenOnRejectedThrowsAnException() {
    testReturnedPromiseMustBeRejectedWithSameReasonWhenOnRejectedThrowsAThrowable(() => Exception());
  }
  
  shared test void testReturnedPromiseMustBeRejectedWithSameReasonWhenOnRejectedThrowsAnError() {
    testReturnedPromiseMustBeRejectedWithSameReasonWhenOnRejectedThrowsAThrowable(() => AssertionError(""));
  }
  
  void testReturnedPromiseMustBeRejectedWithSameReasonWhenOnRejectedThrowsAThrowable<T>(T createFailure()) given T satisfies Throwable {
    Exception reason = Exception();
    variable Integer count = 0;
    void onFulfilled(Throwable t) {
      assertEquals(count++, 0);
      assertEquals(t, reason);
      throw createFailure();
    }
    Deferred<Integer> deferred = Deferred<Integer>();
    Promise<Integer> promise = deferred.promise;
    void onRejected(Throwable t) {
      assertEquals(count++, 1);
      testComplete();
    }
    promise.compose((Integer i) => fail("Was not expecting onFulfilled"), onFulfilled).compose((Anything a) => fail("Was not expecting onFulfilled"), onRejected);
    deferred.reject(reason);
    assertEquals(count, 0);
  }
  
  // Disabled until we cane make onFulfilled optional again
  /*
   void testReturnedPromiseMustBeFulfilledWithSameValueWhenOnFulfilledIsNotAFunction() {
   LinkedList<String> a = LinkedList<String>();
   Deferred<String> d = Deferred<String>();
   d.promise.then_<String>().then_(a.add);
   d.resolve("a");
   assertEquals { expected = {"a"}; actual = a; };
   }
   */
  
  shared test void testReturnedPromiseMustBeRejectedWithSameValueWhenOnRejectedIsNotAFunction() {
    Exception reason = Exception();
    variable Integer count = 0;
    void onRejected(Throwable t) {
      assertEquals(count++, 0);
      assertEquals(t, reason);
      testComplete();
    }
    Deferred<String> d = Deferred<String>();
    Promise<String> promise = d.promise;
    promise.compose((String s) => s).compose((String s) => fail("Was not expecting this"), onRejected);
    d.reject(reason);
    assertEquals(count, 0);
  }
}
