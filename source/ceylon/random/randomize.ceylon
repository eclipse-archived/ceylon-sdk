"Shuffle the given elements, returning a new `List`."
shared List<Elements> randomize<Elements>
        ({Elements*} elements, Random random = LCGRandom()) {
    value result = Array(elements);
    randomizeInPlace<Elements>(result, random);
    return result;
}
