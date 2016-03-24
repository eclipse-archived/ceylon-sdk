import ceylon.collection {
    MutableList
}

import java.util {
    JList=List,
    ArrayList,
    Collections {
        singleton
    }
}

"A Ceylon [[MutableList]] that wraps a [[java.util::List]]."
shared class CeylonMutableList<Element>(JList<Element> list)
        extends CeylonList<Element>(list)
        satisfies MutableList<Element> 
        given Element satisfies Object {

    add(Element element) => list.add(element);
    
    set(Integer index, Element element) 
            => list.set(index, element);
    
    insert(Integer index, Element element) 
            => list.add(index, element);
    
    shared actual Integer remove(Element element) {
        value size = list.size();
        list.removeAll(singleton(element));
        return size-list.size();
    }
    
    delete(Integer index) => list.remove(index);
    
    clear() => list.clear();
    
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
    
    shared actual Element? findAndRemoveFirst(
        Boolean selecting(Element element)) {
        for (i in 0:size) {
            if (selecting(list.get(i))) {
                return list.remove(i);
            }
        }
        return null;
    }
    
    shared actual Element? findAndRemoveLast(
        Boolean selecting(Element element)) {
        for (i in (0:size).reversed) {
            if (selecting(list.get(i))) {
                return list.remove(i);
            }
        }
        return null;
    }
    
    shared actual Integer removeWhere(
        Boolean selecting(Element element)) {
        variable Integer count = 0;
        for (i in 0:size) {
            if (selecting(list.get(i))) {
                list.remove(i);
                count++;
            }
        }
        return count;
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
    
    shared actual Integer replace(Element element, 
        Element replacement) {
        variable value count = 0;
        for (i in 0:size) {
            if (list.get(i)==element) {
                list.set(i,replacement);
                count++;
            }
        }
        return count;
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
    
    shared actual Element? findAndReplaceFirst(
        Boolean selecting(Element element), 
        Element replacement) {
        for (i in 0:size) {
            value element = list.get(i);
            if (selecting(element)) {
                list.set(i,replacement);
                return element;
            }
        }
        return null;
    }
    
    shared actual Element? findAndReplaceLast(
        Boolean selecting(Element element), 
        Element replacement) {
        for (i in (0:size).reversed) {
            value element = list.get(i);
            if (selecting(element)) {
                list.set(i,replacement);
                return element;
            }
        }
        return null;
    }
    
    shared actual Integer replaceWhere(
        Boolean selecting(Element element), 
        Element replacement) {
        variable value count = 0;
        for (i in 0:size) {
            if (selecting(list.get(i))) {
                list.set(i,replacement);
                count++;
            }
        }
        return count;
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
    
    clone() => CeylonMutableList(ArrayList(list));

}