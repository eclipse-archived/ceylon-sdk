import ceylon.promise { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

test void testResolveWithArg() {
    Deferred<String> d = Deferred<String>();
    LinkedList<String|Throwable> done = LinkedList<String|Throwable>();
    d.promise.always(done.add);
    d.fulfill("abc");
    assertEquals(LinkedList {"abc"}, done);
}

test void testRejectWithArg() {
    Deferred<String> d = Deferred<String>();
    LinkedList<String|Throwable> done = LinkedList<String|Throwable>();
    d.promise.always(done.add);
    Exception e = Exception();
    d.reject(e);
    assertEquals(LinkedList {e}, done);
}

test void testResolveWithEmptyArg() {
    Deferred<String> d = Deferred<String>();
    LinkedList<String|Throwable> done = LinkedList<String|Throwable>();
    d.promise.always((String|Throwable a) => done.add("done"));
    d.fulfill("abc");
    assertEquals(LinkedList {"done"}, done);
}

test void testRejectWithEmptyArg() {
    Deferred<String> d = Deferred<String>();
    LinkedList<String|Exception> done = LinkedList<String|Exception>();
    d.promise.always((String|Throwable a) => done.add("done"));
    d.reject(Exception());
    assertEquals(LinkedList {"done"}, done);
}
