doc "A mutable Linked List"
by "Stéphane Épardaud"
shared interface MutableList<Element> satisfies List<Element> {

    doc "Sets an item at the given index. List is expanded if index > size"
    shared formal void set(Integer index, Element val);
    
    doc "Adds an item at the end of this list"
    shared formal void add(Element val);

    doc "Adds the items at the end of this list"
    shared formal void addAll({Element*} values);

    doc "Inserts an item at specified index, list is expanded if index > size"    
    shared formal void insert(Integer index, Element val);

    doc "Removes the item at the specified index"
    shared formal void remove(Integer index);

    doc "Removes all occurences of the given element"
    shared formal void removeElement(Element val);

    doc "Remove every item"
    shared formal void clear();
}