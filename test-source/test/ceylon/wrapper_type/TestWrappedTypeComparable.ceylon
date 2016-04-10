import ceylon.test {
    test,
    assertEquals,
    assertNotEquals
}
import ceylon.wrapper_type {
    WrappedTypedComparable
}

shared class Gorkle(String name) satisfies Comparable<Gorkle> {
    shared actual Comparison compare(Gorkle other) => name.compare(other.name);
}

shared abstract class TypedGorkle(Gorkle baseValue)
        extends WrappedTypedComparable<Gorkle>(baseValue) {}

test
void testTypedClassComprable() {
    class MyGorkle1(Gorkle baseValue) extends TypedGorkle(baseValue) {}
    class MyGorkle2(Gorkle baseValue) extends TypedGorkle(baseValue) {}

    value gorkle = Gorkle("myGorkle");
    value myGorkle1 = MyGorkle1(gorkle);
    value myGorkle2 = MyGorkle2(gorkle);

    assertEquals(myGorkle1.baseValue, gorkle);
    assertEquals(myGorkle1.name, "MyGorkle1");
    assertEquals(myGorkle1.baseValue, myGorkle2.baseValue);
    assertNotEquals(myGorkle1, myGorkle2);
    assertEquals(myGorkle1.compare(myGorkle1), equal);
    //myGorkle1.compare(myGorkle2)); Compile error
}