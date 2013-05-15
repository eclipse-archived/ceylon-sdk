import ceylon.interop.java { ... }
import java.lang { System { getSystemProperty=getProperty } }
import java.util { ArrayList }

shared void run() {
    value val = javaString(getSystemProperty("user.home"));
    print(val);
    
    value lst = ArrayList<Integer>(JavaCollection({ 1, 2, 3 }));

    value iter = CeylonIterator(lst.iterator());
    while (!is Finished i=iter.next()) {
        print(i);
    }

    for (Integer i in CeylonIterable(lst)) {
        print(i);
    }

    value klass1 = javaClassFromInstance(iter);
    print(klass1);

    value klass2 = javaClass<String>();
    print(klass2);
}
