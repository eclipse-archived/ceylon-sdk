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
    variable String prev = "";
    variable TestListener listener;
    variable Integer port = -1;
    variable Boolean tap = false;
    variable String? colorWhite = null;
    variable String? colorGreen = null;
    variable String? colorRed = null;
    
    for (String arg in process.arguments) {
        if (prev == "__module") {
            assert (exists i = arg.firstInclusion("/"));
            String moduleName = arg[0 .. i - 1];
            String moduleVersion = arg[i + 1 ...];
            
            moduleNameAndVersions.add([moduleName, moduleVersion]);
        }
        if (prev == "__test") {
            testSources.add(arg);
        }
        if (arg == "__tap") {
            tap = true;
        }
        if (arg.startsWith("--port")) {
            assert (exists p = parseInteger(arg[7...]));
            port = p;
        }
        if (prev == "__com.redhat.ceylon.common.tool.terminal.color.white") {
            colorWhite = arg;
        }
        if (prev == "__com.redhat.ceylon.common.tool.terminal.color.green") {
            colorGreen = arg;
        }
        if (prev == "__com.redhat.ceylon.common.tool.terminal.color.red") {
            colorRed = arg;
        }
        
        prev = arg;
    }
    
    if (port != -1) {
        dynamic {
            dynamic net = require("net");
            dynamic socket = net.connect(port);
            
            void publishEvent(String json) {
                dynamic {
                    socket.write(json);
                    socket.write("\{END OF TRANSMISSION}");
                }
            }
            
            listener = TestEventPublisher(publishEvent);
        }
    } else if (tap) {
        listener = TapLoggingListener();
    } else {
        listener = TestLoggingListener(colorWhite, colorGreen, colorRed);
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
    
    createTestRunner(testSources.sequence(), [listener]).run();
}
