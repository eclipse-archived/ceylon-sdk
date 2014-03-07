import ceylon.language.meta {
    modules
}
import ceylon.test {
    createTestRunner,
    TestSource,
    SimpleLoggingListener
}

shared void run() {
    value moduleNameAndVersions = SequenceBuilder<[String, String]>();
    value testSources = SequenceBuilder<TestSource>();
    variable String prev = "";
    
    for(String arg in process.arguments) {
        if( prev == "__module" ) {
            assert(exists i = arg.firstInclusion("/"));
            String moduleName = arg[0..i-1];
            String moduleVersion = arg[i+1...];
            
            moduleNameAndVersions.append([moduleName, moduleVersion]);
        }
        if( prev == "__test" ) {
            testSources.append(arg);
        }
        prev = arg;
    }
    
    if( testSources.empty ) {
        for(value moduleNameAndVersion in moduleNameAndVersions.sequence) {
            assert(exists m = modules.find(moduleNameAndVersion[0], moduleNameAndVersion[1]));
            testSources.append(m);
        }
    }
    
    createTestRunner(testSources.sequence, [SimpleLoggingListener()]).run();
}