shared Boolean same(Object? expected, Object? actual) {
    if (is Identifiable expected, is Identifiable actual) {
        return expected == actual;
    }
    return false;
}
