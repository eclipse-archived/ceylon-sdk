import ceylon.collection { LinkedList, MutableList }

doc "Represents an HTTP Header"
by "Stéphane Épardaud"
shared class Header(name, String... initialValues){
    
    doc "Header name"
    shared String name;
    
    doc "Header value"
    shared MutableList<String> values = LinkedList<String>();
    
    for(val in initialValues){
        values.add(val);
    }
}