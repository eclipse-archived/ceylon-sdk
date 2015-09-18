import ceylon.promise { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

shared class ConjunctionTest() extends AsyncTestBase() {
  
  shared test void testResolveConjonction() {
    value d1 = Deferred<String>();
    value d2 = Deferred<Integer>();
    value d3 = Deferred<Boolean>();
    value and = d1.promise.and(d2.promise).and(d3.promise);
    variable Integer count = 0;
    void onFulfilled(Boolean b, Integer i, String s) {
      assertEquals(count++, 0);
      assertEquals(b, true);
      assertEquals(i, 3);
      assertEquals("foo", s);
      testComplete();
    }
    and.map(onFulfilled, fail);
    d2.fulfill(3);
    assertEquals(count, 0);
    d2.promise.completed {
      void onFulfilled(Integer i) {
        d3.fulfill(true);
        assertEquals(count, 0);
        d3.promise.completed {
          void onFulfilled(Boolean b) {
            d1.fulfill("foo");
            assertEquals(count, 0);
          }
        };
      }
    };
  }
  
  class RejectConjonctionTest() {
    shared Deferred<String> d1 = Deferred<String>();
    shared Deferred<Integer> d2 = Deferred<Integer>();
    shared Deferred<Boolean> d3 = Deferred<Boolean>();
    value and = d1.promise.and(d2.promise).and(d3.promise);
    void onFulfilled(Boolean b, Integer i, String s) {
      fail("Was not expecting onFulfilled");
    }
    shared Exception reason = Exception();
    shared variable Integer count = 0;
    void onRejected(Throwable t) {
      assertEquals(count++, 0);
      assertEquals(t, reason);
      testComplete();
    }
    and.map(onFulfilled, onRejected);
  }
  
  shared test void testRejectConjonction1() {
    value test = RejectConjonctionTest();
    test.d1.reject(test.reason);
    assertEquals(test.count, 0);
  }
  
  shared test void testRejectConjonction2() {
    value test = RejectConjonctionTest();
    test.d2.reject(test.reason);
    assertEquals(test.count, 0);
  }

  shared test void testRejectConjonction3() {
    value test = RejectConjonctionTest();
    test.d3.reject(test.reason);
    assertEquals(test.count, 0);
  }

  shared test void testNestedConjonctions() {
    value d1 = Deferred<String>();
    value d2 = Deferred<Integer>();
    value d3 = Deferred<Boolean>();
    value d4 = Deferred<Float>();
    Promise<String> p1 = d1.promise;
    Promise<Integer> p2 = d2.promise;
    Promise<Boolean> p3 = d3.promise;
    Promise<Float> p4 = d4.promise;
    value s1 = p1.and(p2);
    value s2 = p3.and(p4);
    value s3 = s1.and(s2.promise);
    variable Integer count = 0;
    s3.completed {
      void onFulfilled([Float, Boolean] a1, Integer a2, String a3) {
        assertEquals(count++, 0);
        assertEquals(a1, [0.4, false]);
        assertEquals(a2, 4);
        assertEquals(a3, "a");
        testComplete();
      }
    };
    d1.promise.completed {
      void onFulfilled(String s) {
        d2.fulfill(4);
        assertEquals(count, 0);
      }
    };
    d2.promise.completed {
      void onFulfilled(Integer i) {
        d3.fulfill(false);
        assertEquals(count, 0);
      }
    };
    d3.promise.completed {
      void onFulfilled(Boolean b) {
        d4.fulfill(0.4);
        assertEquals(count, 0);
      }
    };
    d1.fulfill("a");
    assertEquals(count, 0);
  }
}
