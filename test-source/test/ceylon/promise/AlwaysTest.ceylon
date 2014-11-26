import ceylon.promise { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

shared class AlwaysTest() extends AsyncTestBase() {
  
  shared test void testResolveWithArg() {
    Deferred<String> d = Deferred<String>();
    variable Integer count = 0;
    void done(String|Throwable result) {
      assertEquals(count++, 0);
      assertEquals(result, "abc");
      testComplete();
    }
    d.promise.always(done);
    d.fulfill("abc");
    assertEquals(count, 0);
  }
  
  shared test void testRejectWithArg() {
    Deferred<String> d = Deferred<String>();
    Exception reason = Exception();
    variable Integer count = 0;
    void done(String|Throwable result) {
      assertEquals(count++, 0);
      assertEquals(result, reason);
      testComplete();
    }
    d.promise.always(done);
    d.reject(reason);
    assertEquals(count, 0);
  }
}
