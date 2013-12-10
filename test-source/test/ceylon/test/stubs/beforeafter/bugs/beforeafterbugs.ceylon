import ceylon.test {
    ...
}

shared class BugBeforeNonVoid() {
    beforeTest shared Boolean before() { return true; }
    test shared void f() {}
}

shared class BugBeforeWithParameters() {
    beforeTest shared void before(String s) {}
    test shared void f() {}
}

shared class BugBeforeWithTypeParameters() {
    beforeTest shared void before<T>() { assert(0 is T); }
    test shared void f() {}
}

shared class BugAfterNonVoid() {
    afterTest shared Boolean after() { return true; }
    test shared void f() {}
}

shared class BugAfterWithParameters() {
    afterTest shared void after(String s) {}
    test shared void f() {}
}

shared class BugAfterWithTypeParameters() {
    afterTest shared void after<T>() { assert(0 is T); }
    test shared void f() {}
}