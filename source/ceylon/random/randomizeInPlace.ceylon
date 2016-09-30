"Shuffle the given elements. This operation modifies the `Array`."
shared void randomizeInPlace<Element>(
        Array<Element> elements, Random random = DefaultRandom()) {
    // Fisher-Yates Shuffle
    value size = elements.size;
    for (i in 0:size - 1) {
        value j = random.nextInteger(size - i) + i;
        assert (exists oldi = elements[i]);
        assert (exists oldj = elements[j]);
        elements[i] = oldj;
        elements[j] = oldi;
    }
}
