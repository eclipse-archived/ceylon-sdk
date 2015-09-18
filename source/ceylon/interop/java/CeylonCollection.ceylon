import java.util {
    JCollection=Collection,
    ArrayList
}

"A Ceylon [[Collection]] that wraps a [[java.util::Collection]]."
shared
class CeylonCollection<out Element>
        (JCollection<out Element> collection)
        satisfies Collection<Element> {

    shared actual default
    Integer size
        =>  collection.size();

    shared actual default
    Boolean contains(Object element)
        =>  collection.contains(element);

    shared actual default
    Collection<Element> clone()
        =>  CeylonCollection(ArrayList(collection));

    shared actual default
    Iterator<Element> iterator()
        =>  CeylonIterator(collection.iterator());

}
