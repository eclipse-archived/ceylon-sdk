import ceylon.promise { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

String toString(Integer i) => i.string;

shared test void testFulfilledFulfillmentHandlerReturnsValue() {
    LinkedList<String> done = LinkedList<String>();
    ThrowableCollector failed = ThrowableCollector();
    Deferred<Integer> deferred = Deferred<Integer>();
    Promise<Integer> promise = deferred.promise;
    promise.compose(toString).compose(done.add, failed.add);
    deferred.fulfill(3);

    assertEquals { expected = LinkedList {"3"}; actual = done; };
    assertEquals { expected = LinkedList {}; actual = failed.collected; };
}

shared test void testRejectedRejectionHandlerReturnsAValue() {
    LinkedList<String> done = LinkedList<String>();
    ThrowableCollector failed = ThrowableCollector();
    Deferred<Integer> deferred = Deferred<Integer>();
    Promise<Integer> promise = deferred.promise;
    promise.compose(toString, (Throwable e) => "3").compose(done.add, failed.add);
    deferred.reject(Exception());

    assertEquals { expected = LinkedList {"3"}; actual = done; };
    assertEquals { expected = LinkedList {}; actual = failed.collected; };
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
