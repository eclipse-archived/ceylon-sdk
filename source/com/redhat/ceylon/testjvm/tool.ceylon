import ceylon.collection {
    ArrayList
}
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
import java.io {
    IOException,
    PrintWriter
}
import java.lang {
    Thread,
    InterruptedException
}
import java.net {
    Socket
}
import org.jboss.modules {
    Module {
        ceylonModuleLoader=callerModuleLoader
    }
}
import ceylon.modules.jboss.runtime { CeylonModuleLoader }

shared void run() {
    Runner().run();
}

class Runner() {
    
    value moduleNameAndVersions = ArrayList<[String, String]>();
    value testSources = ArrayList<TestSource>();
    value testListeners = ArrayList<TestListener>();
    variable Integer port = -1;
    variable Socket? socket = null;
    variable PrintWriter? writer = null;
    variable Boolean tap = false;
    variable Boolean report = false;
    
    shared void run() {
        try {
            init();
            loadModules();
            connect();
            
            if (testSources.empty) {
                for (value moduleNameAndVersion in moduleNameAndVersions) {
                    assert (exists m = modules.find(moduleNameAndVersion[0], moduleNameAndVersion[1]));
                    testSources.add(m);
                }
            }
            
            if (exists w = writer) {
                void publishEvent(String json) {
                    w.write(json);
                    w.write('\{END OF TRANSMISSION}'.integer);
                    w.flush();
                }
                testListeners.add(TestEventPublisher(publishEvent));
            } else if (tap) {
                testListeners.add(TapLoggingListener());
            } else {
                testListeners.add(TestLoggingListener {
                    colorWhite = process.propertyValue("com.redhat.ceylon.common.tool.terminal.color.white");
                    colorGreen = process.propertyValue("com.redhat.ceylon.common.tool.terminal.color.green");
                    colorRed = process.propertyValue("com.redhat.ceylon.common.tool.terminal.color.red");
                });
            }
            
            if (report) {
                testListeners.add(HtmlReportGenerator());
            }
            
            createTestRunner(testSources.sequence(), testListeners.sequence()).run();
        }
        finally {
            disconnect();
        }
    }
    
    void init() {
        variable String prev = "";
        
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
            if (arg.startsWith("--port")) {
                assert (exists p = parseInteger(arg[7...]));
                port = p;
            }
            if (arg == "--tap") {
                tap = true;
            }
            if (arg == "--report") {
                report = true;
            }
            prev = arg;
        }
    }
    
    void loadModules() {
        for (value moduleNameAndVersion in moduleNameAndVersions.sequence()) {
            loadModule(moduleNameAndVersion[0], moduleNameAndVersion[1]);
        }
    }
    
    void loadModule(String modName, String modVersion) {
        assert(is CeylonModuleLoader loader = ceylonModuleLoader);
        loader.loadModuleSynchronous(modName, modVersion);
    }
    
    void connect() {
        if (port != -1) {
            variable Exception? lastException = null;
            for (value i in 0..10) {
                try {
                    String? host = null;
                    socket = Socket(host, port);
                    writer = PrintWriter(socket?.outputStream);
                    return;
                } catch (IOException e) {
                    lastException = e;
                }
                try {
                    Thread.sleep(2000);
                } catch (InterruptedException e) {
                    // noop
                }
            }
            throw Exception("failed connect to port ``port``", lastException);
        }
    }
    
    void disconnect() {
        try {
            if (writer exists) {
                writer?.close();
                writer = null;
            }
        } catch (IOException e) {
            // noop
        }
        
        try {
            if (socket exists) {
                socket?.close();
                socket = null;
            }
        } catch (IOException e) {
            // noop
        }
    }
}
