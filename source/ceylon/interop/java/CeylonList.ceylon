import ceylon.collection {
    MutableList
}
import ceylon.interop.java {
    CeylonIterator
}

import java.util {
    JList=List,
    ArrayList,
    Collections {
        singleton
    }
}

"A Ceylon [[List]] that wraps a [[java.util::List]]."
shared class CeylonList<Element>(JList<Element> list) 
        satisfies MutableList<Element> 
        given Element satisfies Object {
    
    getFromFirst(Integer index) => list.get(index);
    
    size => list.size();
    
    shared actual Integer? lastIndex {
        value size = this.size;
        return size>0 then size-1;
    }
    
    iterator() => CeylonIterator(list.iterator());
    
    add(Element element) => list.add(element);
    
    set(Integer index, Element element) 
            => list.set(index, element);
    
    insert(Integer index, Element element) 
            => list.add(index, element);
    
    remove(Element element) 
            => list.remove(singleton(element));
    
    delete(Integer index) => list.remove(index);
    
    clear() => list.clear();
    
    shared actual void addAll({Element*} elements) {
        for (e in elements) {
            list.add(e);
        }
    }
    
    shared actual Boolean removeFirst(Element element) 
            => list.remove(element);
    
    shared actual Boolean removeLast(Element element) {
        for (i in (0:size).reversed) {
            if (list.get(i)==element) {
                list.remove(i);
                return true;
            }
        }
        return false;
    }
    
    shared actual void removeAll({Element*} elements) {
        for (e in elements) {
            remove(e);
        }
    }
    
    shared actual void deleteMeasure(Integer from, Integer length) {
        value iterator = list.iterator();
        variable value i = 0;
        value measure = from:length;
        while (iterator.hasNext()) {
            iterator.next();
            if (i in measure) {
                iterator.remove();
            }
            i++;
        }
    }
    
    shared actual void deleteSpan(Integer from, Integer to) {
        value iterator = list.iterator();
        variable value i = 0;
        value span = from..to;
        while (iterator.hasNext()) {
            iterator.next();
            if (i in span) {
                iterator.remove();
            }
            i++;
        }
    }
    
    shared actual void prune() {
        value iterator = list.iterator();
        while (iterator.hasNext()) {
            if (!iterator.next() exists) {
                iterator.remove();
            }
        }
    }
    
    shared actual void replace(Element element, 
        Element replacement) {
        for (i in 0:size) {
            if (list.get(i)==element) {
                list.set(i,replacement);
            }
        }
    }
    
    shared actual void infill(Element replacement) {
        for (i in 0:size) {
            if (!list.get(i) exists) {
                list.set(i,replacement);
            }
        }
    }
    
    shared actual Boolean replaceFirst(Element element, 
        Element replacement) {
        for (i in 0:size) {
            if (list.get(i)==element) {
                list.set(i,replacement);
                return true;
            }
        }
        return false;
    }
    
    shared actual Boolean replaceLast(Element element, 
        Element replacement) {
        for (i in (0:size).reversed) {
            if (list.get(i)==element) {
                list.set(i,replacement);
                return true;
            }
        }
        return false;
    }
    
    shared actual void truncate(Integer size) {
        value iterator = list.iterator();
        variable value i = 0;
        while (iterator.hasNext()) {
            iterator.next();
            if (i>=size) {
                iterator.remove();
            }
            i++;
        }
    }
    
    clone() => CeylonList(ArrayList(list));
    
    equals(Object that) 
            => (super of List<Element>).equals(that);
    
    hash => (super of List<Element>).hash;
    
}