import ceylon.language.meta.declaration {
    FunctionOrValueDeclaration
}
import ceylon.test {
    test,
    parameters,
    ignore
}
import ceylon.test.core {
    ArgumentsProvider,
    ArgumentsProviderContext
}
import ceylon.collection {
    ArrayList
}

shared {String*} paramSourceEmpty() => {};

shared {String*} paramSourceStrings() => { "a", "b", "c" };

shared {Integer*} paramSourceIntegers() => { 1, 2 };

shared {Boolean*} paramSourceBooleans() => { true, false };

shared {Float*} paramSourceFloats() => { 0.999, 0.888, 0.777 };

shared {[Integer, Float]*} paramSourceTuple = { [1, 0.9], [2, 0.8], [3, 0.7] };

shared void paramSourceVoid() {}

shared {String*} paramSourceParameterizedDefaulted(String s = "abc") => {s};

shared ArrayList<Anything> paramCollector = ArrayList<Anything>();

test
parameters (`function paramSourceStrings`)
shared void parameterized1(String s) {
    paramCollector.add(s);
}

test
shared void parameterized2(parameters (`function paramSourceStrings`) String s) {
    paramCollector.add(s);
}

test
shared void parameterized3(
    parameters (`function paramSourceStrings`) String s,
    parameters (`function paramSourceIntegers`) Integer i) {
    paramCollector.add([s, i]);
}

test
shared void parameterized4(
    parameters (`function paramSourceStrings`) String s,
    parameters (`function paramSourceIntegers`) Integer i,
    parameters (`function paramSourceBooleans`) Boolean b) {
    paramCollector.add([s, i, b]);
}

test
shared void parameterized5(
    parameters (`function paramSourceStrings`) String s,
    parameters (`function paramSourceIntegers`) Integer i,
    parameters (`function paramSourceBooleans`) Boolean b,
    parameters (`function paramSourceFloats`) Float f) {
    paramCollector.add([s, i, b, f]);
}

test
parameters (`value paramSourceTuple`)
shared void parameterized6(Integer i, Float f) {
    paramCollector.add([i, f]);
}

test
shared void parameterizedWithParameterizedDefaultedSource(parameters (`function paramSourceParameterizedDefaulted`) String s) {
    paramCollector.add(s);
}

test
ignore
shared void parameterizedIgnored(parameters (`function paramSourceStrings`) String s) {
}

test
shared void parameterizedButNoArgumentProvider(String s) {}

test
shared void parameterizedButSeveralArgumentProviders1(parameters (`function paramSourceStrings`) customArgumentProvider String s) {}

test
parameters (`function paramSourceStrings`) customArgumentProvider
shared void parameterizedButSeveralArgumentProviders2(String s) {}

test
parameters (`function paramSourceVoid`)
shared void parameterizedButSourceVoid1(String s) {}

test
shared void parameterizedButSourceVoid2(parameters (`function paramSourceVoid`) String s) {}

test
parameters (`function paramSourceEmpty`)
shared void parameterizedButSourceEmpty1(String s) {}

test
parameters (`function paramSourceEmpty`)
shared void parameterizedButSourceEmpty2(parameters (`function paramSourceEmpty`) String s) {}

shared variable Anything customArgumentProviderValue = null;

shared annotation CustomArgumentProviderAnnotation customArgumentProvider() => CustomArgumentProviderAnnotation();

shared final annotation class CustomArgumentProviderAnnotation()
        satisfies OptionalAnnotation<CustomArgumentProviderAnnotation,FunctionOrValueDeclaration> & ArgumentsProvider {
    
    shared actual Anything values(ArgumentsProviderContext context) {
        if( is Exception e = customArgumentProviderValue ) {
            throw e;
        }
        return customArgumentProviderValue;
    }
    
}

test
shared void parameterizedCustomArgumentProvider(customArgumentProvider Object o) {
    paramCollector.add(o);
}
