import ceylon.collection {
    HashMap,
    CLinkedList=LinkedList,
    CArrayList=ArrayList,
    MutableList
}
import ceylon.interop.java {
    ...
}
import ceylon.test {
    assertFalse,
    assertEquals,
    test,
    assertTrue,
    assertNull,
    assertNotNull
}

import java.lang {
    System {
        getSystemProperty=getProperty
    },
    JString=String,
    JThread=Thread
}
import java.util {
    ArrayList,
    HashSet,
    LinkedHashSet,
    TreeSet,
    LinkedList,
    Date,
    JavaHashMap=HashMap
}

suppressWarnings("deprecation")
test void stringTests() {
    value val = javaString(getSystemProperty("user.home"));
    assertFalse(val.empty);
}

test void collectionTests() {
    value lst = ArrayList<Integer>(JavaCollection([ 1, 2, 3 ]));
    
    value iter = CeylonIterator(lst.iterator());
    variable value val = 1;
    while (!is Finished i=iter.next()) {
        assertEquals(val++, i);
    }
    
    val = 1;
    for (Integer i in CeylonIterable(lst)) {
        assertEquals(val++, i);
    }
    
    assertEquals(CeylonList(lst)[0], 1);
    assertEquals(CeylonList(lst).getFromFirst(0), 1);

    assertEquals(CeylonList(lst)[2], 3);
    assertEquals(CeylonList(lst).getFromFirst(2), 3);

    assertNull(CeylonList(lst)[-1]);
    assertNull(CeylonList(lst).getFromFirst(-1));

    assertNull(CeylonList(lst)[3]);
    assertNull(CeylonList(lst).getFromFirst(3));
    
    assertEquals(JavaIterable([]).string, "[]");
    assertEquals(JavaIterable([1]).string, "[1]");
}

test void javaListIteratorPerformance() {
    value ll = CLinkedList { *(0:100k) };
    value javaList = JavaList(ll);
    value it = javaList.iterator();
    
    value start = system.nanoseconds;
    variable value i = 0;
    while (it.hasNext()) {
        i += it.next();
    }
    
    assertEquals(i, 4999950000);
    assertTrue(system.nanoseconds - start < 1G,
        "list iteration took more than one second; \
         non-optimized iterator?");
}

test void javaListIterator() {
    value ll = CArrayList { 0, 1, 2 };
    print ((ll of Anything) is MutableList<Integer>);
    value javaList = JavaList(ll);
    value it = javaList.iterator();
    
    variable value sum = 0;
    while (it.hasNext()) {
        assert (exists x = it.next());
        if (x == 1) {
            it.remove();
        }
        sum += x;
    }
    assertEquals(sum, 3, "sum of elements");
    assertEquals(ll.size, 2, "size after removal");
}

test void bug264() {
    HashSet<Date>().addAll(JavaCollection<Date>([]));
    LinkedHashSet<Date>().addAll(JavaCollection<Date>([]));
    TreeSet<Date>().addAll(JavaCollection<Date>([]));
    ArrayList<Date>().addAll(JavaCollection<Date>([]));
    LinkedList<Date>().addAll(JavaCollection<Date>([]));
}

suppressWarnings("deprecation")
test void classTests() {
    Integer x = 5;
    value klass1 = javaClassFromInstance(x);
    assertEquals("class ceylon.language.Integer", klass1.string);
    
    value klass2 = javaClass<String>();
    assertEquals("class ceylon.language.String", klass2.string);
    
    value klass3 = javaClassFromDeclaration(`class Integer`);
    assertEquals("class ceylon.language.Integer", klass3.string);

    value klass4 = javaClassFromDeclaration(`interface Numeric`);
    assertEquals("interface ceylon.language.Numeric", klass4.string);

    assertEquals("class java.lang.Object", javaClass<Object>().string);
    assertEquals("class java.lang.Object", javaClassFromDeclaration(`class Object`).string);
    assertEquals("class java.lang.Object", javaClassFromModel(`Object`).string);

    assertEquals("class java.lang.Throwable", javaClass<Throwable>().string);
    assertEquals("class java.lang.Throwable", javaClassFromDeclaration(`class Throwable`).string);
    assertEquals("class java.lang.Throwable", javaClassFromModel(`Throwable`).string);

    assertEquals("class java.lang.Exception", javaClass<Exception>().string);
    assertEquals("class java.lang.Exception", javaClassFromDeclaration(`class Exception`).string);
    assertEquals("class java.lang.Exception", javaClassFromModel(`Exception`).string);
    // this one is fine since the instance type actually exists
    assertEquals("class ceylon.language.Exception", javaClassFromInstance(Exception()).string);

    assertEquals("interface java.lang.annotation.Annotation", javaClass<Annotation>().string);
    assertEquals("interface java.lang.annotation.Annotation", javaClassFromDeclaration(`interface Annotation`).string);
    assertEquals("interface java.lang.annotation.Annotation", javaClassFromModel(`Annotation`).string);
}

suppressWarnings("deprecation")
test void ceylonStringMap() {
    value jsMap = HashMap { javaString("one") -> 1, javaString("two") -> 2 };
    value csMap = CeylonStringMap(jsMap);

    assertEquals(csMap.get("one"), 1);
    assertEquals(csMap.get("two"), 2);
    assertTrue(csMap.defines("one"));
    assertFalse(csMap.defines(javaString("one")));
    assertFalse(csMap.defines("ONE"));
    assertTrue(csMap.keys.contains("two"));
    assertEquals(csMap.keys.size, 2);
    assertEquals(CeylonStringMap(emptyMap).size, 0);
}

test void ceylonMutableMap() {
    value javaMap = JavaHashMap<String, Integer>();
    value ceylonMap = CeylonMutableMap(javaMap);

    assertEquals(1, ceylonMap["x"] = 1);
    assertEquals(1, ceylonMap.put("x", 2));
    assertEquals(2, ceylonMap.put("x", 3));
}

suppressWarnings("deprecation")
test void ceylonStringMutableMap() {
    value jsMap = HashMap { javaString("one") -> 1 };
    value csMap = CeylonStringMutableMap(jsMap);
    csMap.put("two", 2);

    assertEquals(jsMap.get(javaString("two")), 2);

    assertEquals(csMap.get("one"), 1);
    assertEquals(csMap.get("two"), 2);
    assertTrue(csMap.defines("one"));
    assertFalse(csMap.defines(javaString("one")));
    assertFalse(csMap.defines("ONE"));
    assertTrue(csMap.keys.contains("two"));
    assertEquals(csMap.keys.size, 2);
    assertEquals(CeylonStringMutableMap(
        HashMap<JString, Object>()).size, 0);

    csMap.remove("two");
    assertNull(jsMap.get(javaString("two")));
}

suppressWarnings("deprecation")
test void bug342() {
    class OuterClass() {
        shared class InnerClass() {
            shared class InnerInnerClass() {}
        }
    }
    object outerObject {}
    class FunctionClass() {}
    object functionObject {}

    assertNotNull(javaClass<OuterClass>());
    assertNotNull(javaClass<OuterClass.InnerClass>());
    assertNotNull(javaClass<OuterClass.InnerClass.InnerInnerClass>());
    assertNotNull(javaClass<FunctionClass>());
    assertNotNull(javaClass<\IouterObject>());
    assertNotNull(javaClass<\IfunctionObject>());
}

test void ceylonRunnableThread() {
    variable Integer i = 0;
    value t1 = JThread(JavaRunnable(() => i++));
    t1.start();
    t1.join();
    assertEquals { expected = 1; actual = i; };
    value t2 = JavaThread(() => i++);
    t2.start();
    t2.join();
    assertEquals { expected = 2; actual = i; };
}

test void mutableListRemoveWhere() {
    value javaList = ArrayList<Integer>(JavaCollection(1..10));
    value ceylonList = CeylonMutableList(javaList);

    assertEquals(ceylonList.removeWhere(Integer.even), 5);
    assertEquals(ceylonList, [1, 3, 5, 7, 9]);

    assertEquals(ceylonList.removeWhere((i) => false), 0);
    assertEquals(ceylonList, [1, 3, 5, 7, 9]);

    javaList.clear();
    assertEquals(ceylonList.removeWhere((i) => true), 0);
}

test void mutableListRemoveFirst() {
    value javaList = ArrayList<Integer>(JavaCollection(1..10));
    value ceylonList = CeylonMutableList(javaList);

    assertEquals(ceylonList.findAndRemoveFirst(Integer.even), 2);
    assertEquals(ceylonList, [1, *(3..10)]);

    assertEquals(ceylonList.findAndRemoveFirst((i) => false), null);
    assertEquals(ceylonList, [1, *(3..10)]);

    javaList.clear();
    assertEquals(ceylonList.findAndRemoveFirst((i) => true), null);
}

test void mutableListRemoveLast() {
    value javaList = ArrayList<Integer>(JavaCollection(1..5));
    value ceylonList = CeylonMutableList(javaList);

    assertEquals(ceylonList.findAndRemoveLast(Integer.even), 4);
    assertEquals(ceylonList, [1, 2, 3, 5]);

    assertEquals(ceylonList.findAndRemoveLast((i) => false), null);
    assertEquals(ceylonList, [1, 2, 3, 5]);

    javaList.clear();
    assertEquals(ceylonList.findAndRemoveLast((i) => true), null);
}

test void mutableListPrune() {
    value javaList = ArrayList<String>();
    javaList.add("A");
    javaList.add(null);
    javaList.add("B");
    javaList.add(null);
    value list = CeylonMutableList(javaList);
    assertEquals(list.prune(), 2, "prune count 1");
    assertEquals(list.prune(), 0, "prune count 2");
    assertEquals(list, ["A", "B"]);
}