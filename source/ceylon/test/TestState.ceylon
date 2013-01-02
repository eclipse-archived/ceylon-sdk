shared abstract class TestState()
        of undefined | running | success | failure | error {}

shared object undefined extends TestState() {}

shared object running extends TestState() {}

shared object success extends TestState() {}

shared object failure extends TestState() {}

shared object error extends TestState() {}