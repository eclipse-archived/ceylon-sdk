import ceylon.promise { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

class Thrower<E, T>(T fail()) given T satisfies Throwable {
    shared LinkedList<T> thrown = LinkedList<T>();
    shared String m(E e) {
        T t = fail();
        thrown.add(t);
        throw t;
    }
}

shared test void testAllRespectiveFulfilledCallbacksMustExecuteInTheOrderOfTheirOriginatingCallsToThen() {
    value calls = LinkedList<Integer>();
    value d = Deferred<String>();	
    Promise<String> promise = d.promise;
    promise.compose((String s) => calls.add(1));
    promise.compose((String s) => calls.add(2));
    d.fulfill("");
    
    assertEquals { expected = LinkedList {1,2}; actual = calls; };
}

shared test void testAllRespectiveRejectedCallbacksMustExecuteInTheOrderOfTheirOriginatingCallsToThen() {
    value calls = LinkedList<Integer>();
    value d = Deferred<String>();	
    Promise<String> promise = d.promise;
    promise.compose((String s) => print(s),(Throwable e) => calls.add(1));
    promise.compose((String s) => print(s),(Throwable e) => calls.add(2));
    d.reject(Exception());
    
    assertEquals { expected = LinkedList {1,2}; actual = calls; };
}

shared test void testReturnedPromiseMustBeRejectWithSameReasonWhenOnFulfilledThrowsAnException() {
    value doneThrower = Thrower<Integer, Exception>(() => Exception());
    LinkedList<String> done = LinkedList<String>();
    value failedThrower = Thrower<Throwable, Exception>(() => Exception());
    LinkedList<Throwable> failed = LinkedList<Throwable>();
    Deferred<Integer> deferred = Deferred<Integer>();
    Promise<Integer> promise = deferred.promise;
    promise.compose(doneThrower.m, failedThrower.m).compose(done.add, failed.add);
    deferred.fulfill(3);
    
    assertEquals { expected = LinkedList {}; actual = done; };
    assertEquals { expected = failed; actual = doneThrower.thrown; };
    assertEquals { expected = LinkedList {}; actual = failedThrower.thrown; };
}

shared test void testReturnedPromiseMustBeRejectedWithSameReasonWhenOnRejectedThrowsAnException() {
	testReturnedPromiseMustBeRejectedWithSameReasonWhenOnRejectedThrowsAThrowable(() => Exception());
}

shared test void testReturnedPromiseMustBeRejectedWithSameReasonWhenOnRejectedThrowsAnError() {
	testReturnedPromiseMustBeRejectedWithSameReasonWhenOnRejectedThrowsAThrowable(() => AssertionError(""));
}

void testReturnedPromiseMustBeRejectedWithSameReasonWhenOnRejectedThrowsAThrowable<T>(T fail()) given T satisfies Throwable {
	value doneThrower = Thrower<Integer, T>(fail);
	value failedThrower = Thrower<Throwable, T>(fail);
	LinkedList<String> done = LinkedList<String>();
	LinkedList<Throwable> failed = LinkedList<Throwable>();
	Deferred<Integer> deferred = Deferred<Integer>();
	Promise<Integer> promise = deferred.promise;
	promise.compose(doneThrower.m, failedThrower.m).compose(done.add, failed.add);
	deferred.reject(Exception());
	
	assertEquals { expected = LinkedList {}; actual = done; };
	assertEquals { expected = LinkedList {}; actual = doneThrower.thrown; };
	assertEquals { expected = failed; actual = failedThrower.thrown; };
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
    LinkedList<Throwable> a = LinkedList<Throwable>();
    Deferred<String> d = Deferred<String>();
    Promise<String> promise = d.promise;
    promise.compose((String s) => s).compose((String s) => print(s),a.add);
    Exception e = Exception();
    d.reject(e);

    assertEquals { expected = LinkedList {e}; actual = a; };
}
