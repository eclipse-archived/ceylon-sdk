"Shuffle the given elements. This operation modifies the `Array`."
shared void randomizeInPlace<Element>(
        Array<Element> elements, Random random = LCGRandom()) {
    // Fisher-Yates Shuffle
    value size = elements.size;
    for (i in 0:size - 1) {
        value j = random.nextInteger(size - i) + i;
        assert(exists oldi = elements.getFromFirst(i));
        assert(exists oldj = elements.getFromFirst(j));
        elements.set(i, oldj);
        elements.set(j, oldi);
    }
}
