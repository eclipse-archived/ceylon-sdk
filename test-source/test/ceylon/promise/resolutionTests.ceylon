import ceylon.promise { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

class Test() {
    shared LinkedList<Integer> d1Values = LinkedList<Integer>();
    shared LinkedList<Throwable> d1Reasons = LinkedList<Throwable>();
    shared LinkedList<String> d2Values = LinkedList<String>();
    shared LinkedList<Throwable> d2Reasons = LinkedList<Throwable>();
    shared Deferred<Integer> d1 = Deferred<Integer>();
    shared Deferred<String> d2 = Deferred<String>();
    
    shared void check({Integer*} expectedD1Values, {Exception*} expectedD1Reasons, {String*} expectedD2Values, {Exception*} expectedD2Reasons) {
        assertEquals { expected = LinkedList(expectedD1Values); actual = d1Values; };
        assertEquals { expected = LinkedList(expectedD1Reasons); actual = d1Reasons; };
        assertEquals { expected = LinkedList(expectedD2Values); actual = d2Values; };
        assertEquals { expected = LinkedList(expectedD2Reasons); actual = d2Reasons; };
    }
}

test void testOnFulfilledAdoptPromiseThatResolves() {
    Test test = Test();
    Promise<String> f(Integer val) {
        test.d1Values.add(val);
        return test.d2.promise;
    }
    Promise<String> g(Throwable reason) {
        test.d1Reasons.add(reason);
        return test.d2.promise;
    }
    Promise<Integer> promise = test.d1.promise;
    promise.handle(f, g).compose(test.d2Values.add, test.d2Reasons.add);
    test.check({},{},{},{});
    test.d1.fulfill(3);
    test.check({3},{},{},{});
    test.d2.fulfill("foo");
    test.check({3},{},{"foo"},{});
}

test void testOnFulfilledAdoptPromiseThatRejects() {
    Test test = Test();
    Promise<String> f(Integer val) {
        test.d1Values.add(val);
        return test.d2.promise;
    }
    Promise<String> g(Throwable reason) {
        test.d1Reasons.add(reason);
        return test.d2.promise;
    }
    Promise<Integer> promise = test.d1.promise;
    promise.handle(f, g).compose(test.d2Values.add, test.d2Reasons.add);
    test.check({},{},{},{});
    test.d1.fulfill(3);
    test.check({3},{},{},{});
    Exception e = Exception();
    test.d2.reject(e);
    test.check({3},{},{},{e});
}

test void testOnRejectedAdoptPromiseThatResolves() {
    Test test = Test();
    Promise<String> f(Integer val) {
        test.d1Values.add(val);
        return test.d2.promise;
    }
    Promise<String> g(Throwable reason) {
        test.d1Reasons.add(reason);
        return test.d2.promise;
    }
    Promise<Integer> promise = test.d1.promise;
    promise.handle(f, g).compose(test.d2Values.add, test.d2Reasons.add);
    test.check({},{},{},{});
    Exception e = Exception();
    test.d1.reject(e);
    test.check({},{e},{},{});
    test.d2.fulfill("foo");
    test.check({},{e},{"foo"},{});
}

test void testOnRejectedAdoptPromiseThatRejects() {
    Test test = Test();
    Promise<String> f(Integer val) {
        test.d1Values.add(val);
        return test.d2.promise;
    }
    Promise<String> g(Throwable reason) {
        test.d1Reasons.add(reason);
        return test.d2.promise;
    }
    Promise<Integer> promise = test.d1.promise;
    promise.handle(f, g).compose(test.d2Values.add, test.d2Reasons.add);
    test.check({},{},{},{});
    Exception e1 = Exception();
    test.d1.reject(e1);
    test.check({},{e1},{},{});
    Exception e2 = Exception();
    test.d2.reject(e2);
    test.check({},{e1},{},{e2});
}
