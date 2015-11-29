"The result state of test execution."
shared abstract class TestState(shared actual String string)
        of success|failure|error|ignored|aborted {}

"A test state is _success_, if it complete normally (that is, does not throw an exception)."
shared object success extends TestState("success") {}

"A test state is _failure_, if it propagates an [[AssertionError]]."
shared object failure extends TestState("failure") {}

"A test state is _error_, if it propagates any exception which is not an [[AssertionError]]."
shared object error extends TestState("error") {}

"A test state is _ignored_, if it is marked with [[ignore]] annotation."
shared object ignored extends TestState("ignored") {}

"A test state is _aborted_, if its assumption is not met, see e.g. [[assumeTrue]] and it propagates an [[ceylon.test.core::TestAbortedException]]."
shared object aborted extends TestState("aborted") {}
