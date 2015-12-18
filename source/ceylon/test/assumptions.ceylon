import ceylon.test.engine {
    TestAbortedException
}


"Abort test execution if the assumption _condition_ is false.
 
 Example:
 
     test
     shared void shouldUseDatabase() {
         assumeTrue(isDatabaseAvailable);
         ...
     }
 
"
throws (`class TestAbortedException`, "When _condition_ is false.")
shared void assumeTrue(
    "The condition to be checked."
    Boolean condition,
    "The message describing the assumption."
    String? message = null) {
    if (!condition) {
        throw TestAbortedException(message else "assumption failed: expected true");
    }
}


"Abort test execution if the assumption _condition_ is true.
 
 Example:
 
     test
     shared void shouldUseNetwork() {
         assumeFalse(isDisconnected);
         ...
     }
 
"
throws (`class TestAbortedException`, "When _condition_ is true.")
shared void assumeFalse(
    "The condition to be checked."
    Boolean condition,
    "The message describing the assumption."
    String? message = null) {
    if (condition) {
        throw TestAbortedException(message else "assumption failed: expected false");
    }
}