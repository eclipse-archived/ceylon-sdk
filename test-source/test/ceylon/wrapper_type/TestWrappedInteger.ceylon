import ceylon.test {
    test,
    assertEquals,
    assertNotEquals
}
import ceylon.wrapper_type {
    WrappedInteger
}

test
void testTypedInteger() {
    class MyInteger(Integer baseValue) extends WrappedInteger(baseValue) {}
    class MyInteger2(Integer baseValue) extends WrappedInteger(baseValue) {}

    value myInteger59First = MyInteger(59);
    value myInteger59Second = MyInteger(59);
    value myInteger62 = MyInteger(62);

    assertEquals(myInteger59First.baseValue, 59);
    assertEquals(myInteger59First.name, "MyInteger");
    assertEquals(myInteger59First, myInteger59Second);
    assertNotEquals(myInteger59First, myInteger62);

    value myInteger2 = MyInteger2(59);

    assertNotEquals(myInteger59First, myInteger2);
}