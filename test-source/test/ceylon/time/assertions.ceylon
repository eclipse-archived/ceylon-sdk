shared Boolean same(Anything expected, Anything actual) {
    if (is Identifiable expected, is Identifiable actual) {
        return expected == actual;
    }
    return false;
}
