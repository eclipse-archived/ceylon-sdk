"A [[Set]] that maintains its entries in sorted order."
by ("Gavin King")
shared interface SortedSet<Element>
        satisfies Set<Element> 
                  & Ranged<Element,SortedSet<Element>>
        given Element satisfies Object {
    
    "The elements larger than the given [[value|element]],
     sorted in ascending order."
    shared formal {Element*} higherElements(Element element);
    
    "The elements smaller than the given [[value|element]],
     sorted _in descending order_."
    shared formal {Element*} lowerElements(Element element);
    
}

