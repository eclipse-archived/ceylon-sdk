"Produces a [[Map]] mapping elements to frequencies, where 
 each entry maps a distinct member of the given iterable
 [[elements]] to the number of times it occurs among the 
 given `elements`."
shared Map<Element,Integer> frequencies<Element>
        ({Element*} elements)
        given Element satisfies Object {
    /*
     We've no idea how long the iterable is, nor how 
     selective the grouping function is, so it's really 
     hard to accurately estimate the size of the HashMap.
    */
    value map = HashMap<Element,Counter>();
    for (element in elements) {
        if (exists counter = map[element]) {
            counter.count++;
        }
        else {
            map.put(element, Counter(1));
        }
    }
    return map.mapItems((e, c) => c.count);
}

class Counter(count) {
    shared variable Integer count;
}
