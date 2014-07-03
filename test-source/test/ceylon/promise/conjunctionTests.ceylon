import ceylon.promise { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

test void testResolveConjonction() {
    value d1 = Deferred<String>();
    value d2 = Deferred<Integer>();
    value d3 = Deferred<Boolean>();
    value a = LinkedList<[Boolean, Integer, String]>();
    value b = LinkedList<Throwable>();
    
    value and = d1.promise.and<Integer>(d2.promise).and<Boolean>(d3.promise);
    and.compose((Boolean b, Integer i, String s) => a.add([b,i,s]), b.add);
    assertEquals { expected = LinkedList {}; actual = a; };
    assertEquals { expected = LinkedList {}; actual = b; };
    
    d2.fulfill(3);
    assertEquals { expected = LinkedList {}; actual = a; };
    assertEquals { expected = LinkedList {}; actual = b; };
    
    d3.fulfill(true);
    assertEquals { expected = LinkedList {}; actual = a; };
    assertEquals { expected = LinkedList {}; actual = b; };
    
    d1.fulfill("foo");
    assertEquals { expected = LinkedList {[true, 3, "foo"]}; actual = a; };
    assertEquals { expected = LinkedList {}; actual = b; };
}

test void testRejectConjonction() {
    
    class Test() {
        
        shared Deferred<String> d1 = Deferred<String>();
        shared Deferred<Integer> d2 = Deferred<Integer>();
        shared Deferred<Boolean> d3 = Deferred<Boolean>();
        shared LinkedList<[Boolean, Integer, String]> a = LinkedList<[Boolean, Integer, String]>();
        shared LinkedList<Throwable> b = LinkedList<Throwable>();
        
        value and = d1.promise.and<Integer>(d2.promise).and<Boolean>(d3.promise);
        and.compose((Boolean b, Integer i, String s) => a.add([b, i, s]), b.add);
    }

    value e = Exception();
    
    value t1 = Test();  
    assertEquals { expected = LinkedList {}; actual = t1.a; };
    assertEquals { expected = LinkedList {}; actual = t1.b; };
    t1.d1.reject(e);
    assertEquals { expected = LinkedList {}; actual = t1.a; };
    assertEquals { expected = LinkedList {e}; actual = t1.b; };
    
    value t2 = Test();  
    assertEquals { expected = LinkedList {}; actual = t2.a; };
    assertEquals { expected = LinkedList {}; actual = t2.b; };
    t2.d2.reject(e);
    assertEquals { expected = LinkedList {}; actual = t2.a; };
    assertEquals { expected = LinkedList {e}; actual = t2.b; };
    
    value t3 = Test();  
    assertEquals { expected = LinkedList {}; actual = t3.a; };
    assertEquals { expected = LinkedList {}; actual = t3.b; };
    t3.d3.reject(e);
    assertEquals { expected = LinkedList {}; actual = t3.a; };
    assertEquals { expected = LinkedList {e}; actual = t3.b; };
}

test void testNestedConjonctions() {

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

    value results = LinkedList<[[Float, Boolean], Integer, String]>();
    void h([Float, Boolean] a1, Integer a2, String a3) {
        results.add([a1, a2, a3]);
    }
    s3.compose(h);

    //
    d1.fulfill("a");
    assertEquals(LinkedList {}, results);

    //
    d2.fulfill(4);
    assertEquals(LinkedList {}, results);

    //
    d3.fulfill(false);
    assertEquals(LinkedList {}, results);

    //
    d4.fulfill(0.4);
    assertEquals(LinkedList {[[0.4, false], 4, "a"]}, results);

}
