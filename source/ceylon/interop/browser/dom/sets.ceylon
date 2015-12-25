shared dynamic DOMTokenList {
    shared formal Integer length;
    shared formal String? item(Integer index);
    shared formal Boolean contains(String token);
    // TODO should be String*
    shared formal void add(String tokens);
    // TODO should be String*
    shared formal void remove(String tokens);
    shared formal Boolean toggle(String token, Boolean force);

    // TODO stringifier;
    // TODO iterable<DOMString>;
}