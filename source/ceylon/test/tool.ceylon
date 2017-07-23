import ceylon.test.engine.internal {
    Runner
}


"Run function used by `ceylon test` and `ceylon test-js` tools, 
 it is not supposed to be call directly from code."
shared void runTestTool() => Runner().run();
