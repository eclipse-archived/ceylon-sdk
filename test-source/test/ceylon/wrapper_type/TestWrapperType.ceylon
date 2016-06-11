import ceylon.test {
    test,
    assertEquals,
    assertNotEquals
}
import ceylon.wrapper_type {
    WrapperType
}

shared class Gorfle(String name) {}

shared abstract class WrappedGorfle(Gorfle baseValue)
        extends WrapperType<Gorfle>(baseValue) {}

test
void testTypedClass() {
    class MyGorfle1(Gorfle baseValue) extends WrappedGorfle(baseValue) {}
    class MyGorfle2(Gorfle baseValue) extends WrappedGorfle(baseValue) {}

    value gorfle = Gorfle("myGorfle");
    value myGorfle1 = MyGorfle1(gorfle);
    value myGorfle2 = MyGorfle2(gorfle);

    assertEquals(myGorfle1.baseValue, gorfle);
    assertEquals(myGorfle1.name, "MyGorfle1");
    assertEquals(myGorfle1.baseValue, myGorfle2.baseValue);
    assertNotEquals(myGorfle1, myGorfle2);
}