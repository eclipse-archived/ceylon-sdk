import ceylon.test {
    assumeTrue,
    assumeFalse,
    assertThatException,
    test
}

import ceylon.test.engine {
    TestAbortedException
}

test
shared void testAssumeTrue() {
    assumeTrue(true);
    assumeTrue(true, "");
    
    assertThatException(()=>assumeTrue(false)).
            hasType(`TestAbortedException`).
            hasMessage("assumption failed: expected true");
    
    assertThatException(()=>assumeTrue(false, "woops!")).
            hasType(`TestAbortedException`).
            hasMessage("woops!");
}

test
shared void testAssumeFalse() {
    assumeFalse(false);
    assumeFalse(false, "");
    
    assertThatException(()=>assumeFalse(true)).
            hasType(`TestAbortedException`).
            hasMessage("assumption failed: expected false");
    
    assertThatException(()=>assumeFalse(true, "woops!")).
            hasType(`TestAbortedException`).
            hasMessage("woops!");
}
