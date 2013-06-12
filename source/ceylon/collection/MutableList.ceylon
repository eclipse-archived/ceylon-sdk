"A mutable Linked List"
by("Stéphane Épardaud")
shared interface MutableList<Element> satisfies List<Element> {

    "Sets an item at the given index. List is expanded if index > size"
    shared formal void set(Integer index, Element val);
    
    "Adds an item at the end of this list"
    shared formal void add(Element val);

    "Adds the items at the end of this list"
    shared formal void addAll({Element*} values);

    "Inserts an item at specified index, list is expanded if index > size"    
    shared formal void insert(Integer index, Element val);

    "Removes the item at the specified index"
    shared formal void remove(Integer index);

    "Removes all occurences of the given element"
    shared formal void removeElement(Element val);

    "Remove every item"
    shared formal void clear();
}