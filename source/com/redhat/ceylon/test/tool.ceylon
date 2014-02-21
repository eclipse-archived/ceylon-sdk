import ceylon.language.meta {
    modules
}
import ceylon.test {
    createTestRunner,
    TestSource,
    SimpleLoggingListener,
    TestListener,
    TestRunResult
}
import com.redhat.ceylon.test.eclipse {
    TestEventPublisher,
    Util {
        createSocket,
        createObjectOutputStream,
        setColor
    }
}
import java.io {
    ObjectOutputStream,
    IOException
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
    },
    ModuleIdentifier {
        createModuleIdentifier=create
    },
    ModuleClassLoader
}

shared void run() {
    Runner().run();
}

class Runner() {

    value moduleNameAndVersions = SequenceBuilder<[String, String]>();
    value testSources = SequenceBuilder<TestSource>();
    variable Integer port = -1;
    variable Socket? socket = null;
    variable ObjectOutputStream? oos = null;

    shared void run() {
        try {
            init();
            loadModules();
            connect();
            
            if( testSources.empty ) {
                for(value moduleNameAndVersion in moduleNameAndVersions.sequence) {
                    assert(exists m = modules.find(moduleNameAndVersion[0], moduleNameAndVersion[1]));
                    testSources.append(m);
                }
            }

            TestListener[] testListeners;
            if( exists o = oos ) {
                testListeners = [TestEventPublisher(o)];
            }
            else {
                object loggingListener extends SimpleLoggingListener() {

                    value colorCodeRed = 1;
                    value colorCodeGreen = 2;
                    value colorCodeWhite = 7;

                    shared actual void writeBannerSuccess(TestRunResult result) {
                        setColor(colorCodeGreen);
                        try {
                            super.writeBannerSuccess(result);
                        }
                        finally {
                            setColor(colorCodeWhite);
                        }
                    }

                    shared actual void writeBannerFailed(TestRunResult result) {
                        setColor(colorCodeRed);
                        try {
                            super.writeBannerFailed(result);
                        }
                        finally {
                            setColor(colorCodeWhite);
                        }
                    }

                }
                testListeners = [loggingListener];
            }

            createTestRunner(testSources.sequence, testListeners).run();
        }
        finally {
            disconnect();
        }
    }

    void init() {
        variable String prev = "";

        for(String arg in process.arguments) {
            if( prev == "--module" ) {
                assert(exists i = arg.firstInclusion("/"));
                String moduleName = arg[0..i-1];
                String moduleVersion = arg[i+1...];
                
                moduleNameAndVersions.append([moduleName, moduleVersion]);
            }
            if( prev == "--test" ) {
                testSources.append(arg);
            }
            if( arg.startsWith("--port") ) {
                assert(exists p = parseInteger(arg[7...]));
                port = p;
            }
            prev = arg;
        }
    }

    void loadModules() {
        for(value moduleNameAndVersion in moduleNameAndVersions.sequence) {
            loadModule(moduleNameAndVersion[0], moduleNameAndVersion[1]);
        }
    }

    void loadModule(String modName, String modVersion) {
        ModuleIdentifier modIdentifier = createModuleIdentifier(modName, modVersion);
        Module mod = ceylonModuleLoader.loadModule(modIdentifier);
        ModuleClassLoader modClassLoader = mod.classLoader;
        modClassLoader.loadClass(modName+".module_");
    }

    void connect() {
        if( port != -1 ) {
            variable Exception? lastException = null;
            for (value i in 0..10) {
                try {
                    socket = createSocket(null, port);
                    oos = createObjectOutputStream(socket);
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
            if( oos exists ) {
                oos?.close();
                oos = null;
            }
        } catch (IOException e) {
            // noop
        }

        try {
            if( socket exists ) {
                socket?.close();
                socket = null;
            }
        } catch (IOException e) {
            // noop
        }
    }

}