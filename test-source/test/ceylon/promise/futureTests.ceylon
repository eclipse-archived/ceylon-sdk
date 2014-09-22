import ceylon.promise { ... }
import ceylon.test { ... }
import java.lang { Thread { sleep, currentThread } }

test void testPromisePeekValue() {
    Deferred<String> d = Deferred<String>();
    Promise<String> p = d.promise;
    value f = p.future;
    assertNull(f.peek());
    d.fulfill("abc");
    assertEquals("abc", f.peek());	
}

test void testPromisePeekReason() {
    Deferred<String> d = Deferred<String>();
    Promise<String> p = d.promise;
    value f = p.future;
    assertNull(f.peek());
    Exception r = Exception();
    d.reject(r);
    assertEquals(r, f.peek());	
}

test void testPromiseGetValue() {
    Deferred<String> d = Deferred<String>();
    Promise<String> p = d.promise;
    value f = p.future;
    d.fulfill("abc");
    assertEquals("abc", f.get());	
}

test void testPromiseGetReason() {
    Deferred<String> d = Deferred<String>();
    Promise<String> p = d.promise;
    value f = p.future;
    Exception r = Exception();
    d.reject(r);
    assertEquals(r, f.get());	
}

test void testPromiseTimeOut() {
    Deferred<String> d = Deferred<String>();
    Promise<String> p = d.promise;
    value f = p.future;
    try {
        f.get(20);
        fail("Was expecting an exception");
    } catch (Exception e) {
        // Ok
    }
}

test void testPromiseInterrupted() {
    Deferred<String> d = Deferred<String>();
    Promise<String> p = d.promise;
    value f = p.future;
    Thread current = currentThread();
    object t extends Thread() {
        shared actual void run() {
            // Sleep 500ms should be more than enough for making the test pass
            sleep(500);
            current.interrupt();
        }
    }
    t.start();
    try {
        f.get();
        fail("Was expecting an interrupt");
    } catch (Exception e) {
        // Ok
    }
}

test void testThenable() {
    Deferred<String> d = Deferred<String>();
    Completable<[String]> t = d.promise;
    Promise<[String]> p = t.promise;
    value f = p.future;
    d.fulfill("abc");
    assertEquals(["abc"], f.get());	
}

