import ceylon.threadpool {
    submit,
    jobMap
}
import ceylon.threadpool.util {
    AcquireTimeoutException
}
import ceylon.language.meta {
    type
}
import ceylon.test {
    test,
    assertEquals,
    assertThatException
}

import java.lang {
    Thread
}

class ArbitraryException() extends Exception() {}

shared class SubmitTests() {
    test
    shared void resultNoException() {
        value expected = 123;
        assertEquals(submit(() => expected).result(), expected);
    }
    
    test
    shared void resultWithException() {
        value future = submit(() { throw ArbitraryException(); });
        assertThatException(future.result).hasType(`ArbitraryException`);
    }
    
    test
    shared void resultNull() {
        assertEquals(submit(() => null).result(), null);
    }
    
    test
    shared void resultTimeout() {
        value future = submit(() => Thread.sleep(10));
        assertThatException(() => future.result(1)).hasType(`AcquireTimeoutException`);
    }
    
    test
    shared void exceptionNoException() {
        assertEquals {
            submit(() => 123).exception();
            null;
        };
    }
    
    test
    shared void exceptionWithException() {
        value future = submit(() { throw ArbitraryException(); });
        assertEquals(type(future.exception()), `ArbitraryException`);
    }
    
    test
    shared void exceptionTimeout() {
        value future = submit(() => Thread.sleep(10));
        assertThatException(() => future.exception(1)).hasType(`AcquireTimeoutException`);
    }
}

shared class MapTests() {
    test
    shared void noException() {
        assertEquals {
            jobMap({ () => 123, () => null }).sequence();
            [123, null];
        };
    }
    
    test
    shared void withException() {
        value iter = jobMap({ () => 123, () { throw ArbitraryException(); } });
        assertEquals(iter.first, 123);
        assertThatException(() => iter.last).hasType(`ArbitraryException`);
    }
    
    test
    shared void timeout() {
        value iter = jobMap({ () => 123, () { Thread.sleep(10); } }, 1);
        assertEquals(iter.first, 123);
        assertThatException(() => iter.last).hasType(`AcquireTimeoutException`);
    }
}
