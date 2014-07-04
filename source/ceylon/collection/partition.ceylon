"Groups the given [[elements]] into two sequences, the first 
 containing elements selected by the given [[predicate 
 function|selecting]], and the second containing elements 
 rejected by the given predicate function."
shared [Element[],Element[]] partition<Element>
        ({Element*} elements, selecting) {
    
    "A predicate function that determines if a specified 
     element should be selected or rejected. Returns `true`
     to indicate that the element is selected, or `false`
     to indicate that the element is rejected."
    Boolean selecting(Element element);
    
    value selected = ArrayList<Element>();
    value rejected = ArrayList<Element>();
    for (element in elements) {
        if (selecting(element)) {
            selected.add(element);
        }
        else {
            rejected.add(element);
        }
    }
    return [selected.sequence(), rejected.sequence()];
}

"Groups the given [[elements]] into consecutive subsequences of 
 the original such that each subsequence (except possibly the 
 last one) is of the given [[length|len]]."
shared {{Element*}*} chunk<Element>
        ({Element*} elements, Integer len) {
    {Element*} initialSegment = elements.taking(len);
    {Element*} finalSegment = elements.skipping(len);
    if (finalSegment.empty) {
        return {initialSegment};
    } else {
        return {initialSegment, *chunk<Element>(finalSegment, len)};
    }
}
