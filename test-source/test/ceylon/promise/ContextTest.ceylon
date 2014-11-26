import ceylon.test {
  test
}
import ceylon.promise {
  Deferred,
  Context
}


shared class ContextTest() extends AsyncTestBase() {
  
  shared test void testUseCustomContextOnDeferred() {
    variable Integer count = 0;
    object myContext satisfies Context {
      shared actual void run(void task()) {
        assertEquals(count++, 0);
        task();
        assertEquals(count++, 2);
        testComplete();
      }
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