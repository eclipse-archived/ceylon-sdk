import ceylon.test { ... }
import ceylon.collection { ... }
import ceylon.promise { ... }

class ThrowableCollector() {
    shared LinkedList<Throwable> collected = LinkedList<Throwable>();
    shared Throwable add(Throwable e) {
        collected.add(e);
        return e;
    }
}

void run() {
	value testRunner = createTestRunner([`module test.ceylon.promise`]);	
	value result = testRunner.run();
	print(result);
    useCases();
}

void useCases() {

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

    void testReject() {
        LinkedList<Integer> done = LinkedList<Integer>();
        Deferred<Integer> d = Deferred<Integer>();
        variable Throwable? found = null;
        Throwable e(Throwable r) {
            found = r;
            return r;
        }
        Promise<Integer> promise = d.promise;
        promise.compose(done.add, e);
        Exception ee = Exception();
        d.reject(ee);
        assertEquals { expected = ee; actual = found; };
        assertEquals { expected = LinkedList {}; actual = done; };
    }
    
    void testFail() {
        LinkedList<Integer> done = LinkedList<Integer>();
        variable Throwable? found = null;
        Throwable cc(Throwable r) {
            found = r;
            return r;
        }
        
        Deferred<Integer> d = Deferred<Integer>();
        Exception e = Exception();
        Integer foo(Integer i) {
            throw e;
        }
        Promise<Integer> promise = d.promise;
        promise.compose(foo).compose(done.add, cc);
        d.fulfill(3);
        
        assertEquals { expected = e; actual = found; };
        assertEquals { expected = LinkedList {}; actual = done; };
    }
    
    void testCatchReason<T>(T fail()) given T satisfies Throwable {
        LinkedList<Integer> collected = LinkedList<Integer>();
        LinkedList<Throwable> exc = LinkedList<Throwable>();
        Deferred<Integer> deferred = Deferred<Integer>();
        T e = fail();
        Integer foo(Integer i) {
            throw e;
        }
        Integer bar(Throwable e) {
            exc.add(e);
            return 4;
        }
        Promise<Integer> promise = deferred.promise;
        promise.compose(foo).compose((Integer i) => i, bar).compose(collected.add);
        deferred.fulfill(3);
        assertEquals { expected = LinkedList {4}; actual = collected; };
        assertEquals { expected = LinkedList {e}; actual = exc; };
    }
    
    void testResolveWithPromise() {
        variable Integer? i = null;
        Deferred<Integer> di = Deferred<Integer>();
        String f(Integer integer) {
            i = integer;
            return integer.string;
        }
        Promise<Integer> promise = di.promise;
        Promise<String> p = promise.compose(f);
        variable String? s = null;
        Deferred<String> d = Deferred<String>();
        Promise<String> promise2 = d.promise;
        promise2.compose((String string) => s = string);
        assertEquals { expected = null; actual = i; };
        assertEquals { expected = null; actual = s; };
        d.fulfill(p);
        assertEquals { expected = null; actual = i; };
        assertEquals { expected = null; actual = s; };
        di.fulfill(4);
        assertEquals { expected = 4; actual = i; };
        assertEquals { expected = "4"; actual = s; };
    }
    
    void testComposeWithPromise() {
        Deferred<Integer> d = Deferred<Integer>();
        Deferred<String> mine = Deferred<String>();
        variable Integer? a = null;
        Promise<String> f(Integer i) {
            a = i;
            return mine.promise;
        }
        Promise<Integer> promise = d.promise;
        Promise<String> p = promise.compose<String>(f);
        variable String? result = null;
        void g(String s) {
            result = s;
        }
        p.compose(g);
        assertEquals { expected = null; actual = a; };
        assertEquals { expected = null; actual = result; };
        d.fulfill(4);
        assertEquals { expected = 4; actual = a; };
        assertEquals { expected = null; actual = result; };
        mine.fulfill("foo");
        assertEquals { expected = 4; actual = a; };
        assertEquals { expected = "foo"; actual = result; };
    }

    //testNoFulfilledWithCasting();
    //testNoFulfilledWithNoCasting();
    testReject();
    testFail();
    testCatchReason(() => Exception());
    testCatchReason(() => AssertionError(""));
    testResolveWithPromise();
    testComposeWithPromise();
}

