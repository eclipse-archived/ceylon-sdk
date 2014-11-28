import ceylon.test {
  test
}
import ceylon.promise {
  Deferred,
  Context
}


shared class ContextTest() extends AsyncTestBase() {
  
  variable Integer serial = 0;

  class CustomContext() satisfies Context {
    shared Integer id = serial++;    
    shared actual void run(void task()) {
      task();
    }
    shared actual Context childContext() => CustomContext();
  }
  
  shared test void testChildContext() {
    value p1 = Deferred<String>(CustomContext()).promise;
    value p2 = p1.compose((String s) => s);
    value p3 = p1.compose((String s) => s);    
    assert(is CustomContext c1 = p1.context);
    assert(is CustomContext c2 = p2.context);
    assert(is CustomContext c3 = p3.context);
    assertEquals(0, c1.id);
    assertEquals(1, c2.id);
    assertEquals(2, c3.id);
    testComplete();
  }

  shared test void testUseCustomContextOnDeferred() {
    variable Integer count = 0;
    object myContext satisfies Context {
      shared actual void run(void task()) {
        assertEquals(count++, 0);
        task();
        assertEquals(count++, 2);
        testComplete();
      }
      shared actual Context childContext() => this;
    }
    value deferred = Deferred<String>(myContext);
    deferred.promise.onComplete {
      void onFulfilled(String s) {
        assertEquals(count++, 1);
        assertEquals(s, "hello");
      }
    };
    deferred.resolve("hello");
  }
  
  shared test void testCustomContextPropagation() {
    variable Boolean onContext = false;
    object myContext satisfies Context {
      shared actual void run(void task()) {
        onContext = true;
        task();
        onContext = false;
      }
      shared actual Context childContext() => this;
    }
    value deferred = Deferred<String>(myContext);
    value promise = deferred.promise.compose {
      String onFulfilled(String s) {
        assertEquals(onContext, true);
        assertEquals(s, "hello");
        return "bye";
      }
    };
    promise.onComplete {
      void onFulfilled(String s) {
        assertEquals(onContext, true);
        assertEquals(s, "bye");
        testComplete();
      }
    };
    deferred.resolve("hello");
  }
}