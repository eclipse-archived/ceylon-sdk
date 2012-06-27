doc "A mutable Linked List"
by "Stéphane Épardaud"
shared interface MutableList<T> satisfies List<T> {

    doc "Sets an item at the given index. List is expanded if index > size"
    shared formal void setItem(Integer index, T val);
    
    doc "Adds an item at the end of this list"
    shared formal void add(T val);

    doc "Adds the items at the end of this list"
    shared formal void addAll(T... values);

    doc "Inserts an item at specified index, list is expanded if index > size"    
    shared formal void insert(Integer index, T val);

    doc "Removes the item at the specified index"
    shared formal void remove(Integer index);

    doc "Remove every item"
    shared formal void clear();
}