import ceylon.collection { LinkedList, MutableList }

by "Stéphane Épardaud"
doc "Represents an HTTP Header"
shared class Header(name, String... initialValues){
    
    doc "Header name"
    shared String name;
    
    doc "Header value"
    shared MutableList<String> values = LinkedList<String>();
    
    for(val in initialValues){
        values.add(val);
    }
}