import ceylon.language.meta {
    modules
}
import ceylon.test {
    createTestRunner,
    TestSource,
    TestListener
}
import com.redhat.ceylon.test {
    TestEventPublisher,
    TapLoggingListener,
    TestLoggingListener
}
import ceylon.collection {
    ArrayList
}

shared void run() {
    value moduleNameAndVersions = ArrayList<[String, String]>();
    value testSources = ArrayList<TestSource>();
    value testListeners = ArrayList<TestListener>();
    variable String prev = "";
    variable Integer port = -1;
    variable Boolean tap = false;
    variable Boolean report = false;
    variable String? colorReset = null;
    variable String? colorGreen = null;
    variable String? colorRed = null;
    
    
    
    for (String arg in process.arguments) {
        if (prev == "--module") {
            assert (exists i = arg.firstInclusion("/"));
            String moduleName = arg[0 .. i - 1];
            String moduleVersion = arg[i + 1 ...];
            
            moduleNameAndVersions.add([moduleName, moduleVersion]);
        }
        if (prev == "--test") {
            testSources.add(arg);
        }
        if (arg == "--tap") {
            tap = true;
        }
        if (arg == "--report") {
            report = true;
        }
        if (arg.startsWith("--port")) {
            assert (exists p = parseInteger(arg[7...]));
            port = p;
        }
        if (prev == "--com.redhat.ceylon.common.tool.terminal.color.reset") {
            colorReset = arg;
        }
        if (prev == "--com.redhat.ceylon.common.tool.terminal.color.green") {
            colorGreen = arg;
        }
        if (prev == "--com.redhat.ceylon.common.tool.terminal.color.red") {
            colorRed = arg;
        }
        
        prev = arg;
    }
    
    if (port != -1) {
        dynamic {
            dynamic net = require("net");
            dynamic socket = net.connect(port);
            socket.setNoDelay(true);
            
            void publishEvent(String json) {
                dynamic {
                    socket.write(json);
                    socket.write("\{END OF TRANSMISSION}");
                }
            }
            
            testListeners.add(TestEventPublisher(publishEvent));
        }
    } else if (tap) {
        testListeners.add(TapLoggingListener());
    } else {
        testListeners.add(TestLoggingListener(colorReset, colorGreen, colorRed));
    }
    
    if (report) {
        testListeners.add(HtmlReportGenerator());
    }
    
    // initialize tested modules
    for (value moduleNameAndVersion in moduleNameAndVersions.sequence()) {
        assert (exists m = modules.find(moduleNameAndVersion[0], moduleNameAndVersion[1]));
    }
    
    if (testSources.empty) {
        for (value moduleNameAndVersion in moduleNameAndVersions.sequence()) {
            assert (exists m = modules.find(moduleNameAndVersion[0], moduleNameAndVersion[1]));
            testSources.add(m);
        }
    }
    
    value result = createTestRunner(testSources.sequence(), testListeners.sequence()).run();
    
    if (port == -1) {
        process.exit(result.isSuccess then 0 else 100);
    }
}