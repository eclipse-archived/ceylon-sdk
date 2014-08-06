import ceylon.interop.java {
    ...
}
import ceylon.test {
    assertFalse,
    assertEquals,
    test
}

import java.lang {
    System {
        getSystemProperty=getProperty
    }
}
import java.util { ArrayList, HashSet, LinkedHashSet, TreeSet, LinkedList, Date, UUID{randomUUID} }

test void stringTests() {
    value val = javaString(getSystemProperty("user.home"));
    assertFalse(val.empty);
}

test void collectionTests() {
	value uuidArray = 
			createJavaObjectArray({randomUUID(),randomUUID()});

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
}

test void bug264() {
    HashSet<Date>().addAll(JavaCollection<Date>([]));
    LinkedHashSet<Date>().addAll(JavaCollection<Date>([]));
    TreeSet<Date>().addAll(JavaCollection<Date>([]));
    ArrayList<Date>().addAll(JavaCollection<Date>([]));
    LinkedList<Date>().addAll(JavaCollection<Date>([]));
}

test void classTests() {
    Integer x = 5;
    value klass1 = javaClassFromInstance(x);
    assertEquals("class ceylon.language.Integer", klass1.string);
    
    value klass2 = javaClass<String>();
    assertEquals("class ceylon.language.String", klass2.string);
}
