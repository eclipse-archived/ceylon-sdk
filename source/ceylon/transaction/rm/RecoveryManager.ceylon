import ceylon.transaction.tm {
    TM, getTM, TransactionServiceFactory, DSHelper { bindDataSources }
}
import java.lang {
    System { setProperty, getProperty }
}
import ceylon.file {
    File, Path, parsePath
}

shared interface RecoveryManager {
    shared formal void start(String? dataSourceConfigPropertyFile = null);
    shared formal void scan();
    shared formal void parseCommandInput();
}

shared class RecoveryManagerImpl() satisfies RecoveryManager {
    TM tm = getTM();
	TransactionServiceFactory transactionServiceFactory = TransactionServiceFactory();

    void init() {
        String userDir = getProperty("user.dir", "") + "/tmp";
        setProperty("com.arjuna.ats.arjuna.objectstore.objectStoreDir", userDir);
        setProperty("com.arjuna.ats.arjuna.common.ObjectStoreEnvironmentBean.objectStoreDir", userDir);

        tm.start(true);
    }

    shared actual void start(String? dataSourceConfigPropertyFile) {
	    init();
        bindDSProperties(dataSourceConfigPropertyFile);
//    tm.getJndiServer().registerDriverSpec("org.h2.Driver", "org.h2", "1.3.168", "org.h2.jdbcx.JdbcDataSource");
//    tm.getJndiServer().registerDSUrl("h2", "org.h2.Driver", "jdbc:h2:ceylondb", "sa", "sa");

//tm.getJndiServer().registerDriverSpec("org.postgresql.Driver", "org.jumpmind.symmetric.jdbc.postgresql",
//     "9.2-1002-jdbc4", "org.postgresql.xa.PGXADataSource");
//tm.getJndiServer().registerDSName(
//     "postgresql", "org.postgresql.Driver", "ceylondb", "localhost", 5432, "sa", "sa");
    }

    shared actual void scan() {
        transactionServiceFactory.recoveryScan();
    }

    shared actual void parseCommandInput() {
	    process.write("> ");
        while (exists line = process.readLine()) {
            if (line == "quit") {
                tm.stop();
                break;
            } else if (line == "scan") {
                print("scanning");
                scan();
                print("finished scan");
            } else if (line.contains("dbc.properties=")) {
                //value val = line.split((Character c) => c == '=').rest;
                String? propFile = line.split((Character c) => c == '=').rest.first;
                bindDSProperties(propFile);
            } else {
                print("Valid command options are:");
                print("\tquit - shutdown the recovery manager and exit");
                print("\tscan - perform a synchronous recovery scan (ie find and recover pending transaction branches)");
                print("\tdbc.properties=<datasource properties file location>");
            }

	        process.write("> ");
        }
    }

    void bindDSProperties(String? dataSourceConfigPropertyFile) {
        if (exists dataSourceConfigPropertyFile) {
            String propFile = dataSourceConfigPropertyFile.trimmed;

            Path path = parsePath(propFile);

            if (is File f = path.resource) {
                print("configuring datasources via properties file ``propFile``");
                bindDataSources(propFile);
            } else {
                print("warning: no datasources configured - property file ``propFile`` does not exist");
            }
         } else {
             print("warning: no datasources configured - missing property file");
         }
    }
}

"Command line run method of the module.
 ceylon run --rep=modules --run=ceylon.transaction.rm.run
 --define=dbc.properties=<datasource config file> --define=interactive=true
 ceylon.transaction"
by("Mike Musgrove")
shared void run() {
    for (arg in process.arguments) {
        if (arg.contains == "help" || arg.contains == "?") {
            print("Start a transaction recovery manager.");
            print("For interactive mode run with --define=interactive=true");
            print("For recovery to operate correctly you must define which datasources are needed");
            print("by either putting a file called dbc.properties on the class path or by defining an");
            print("alternative file location using --define=dbc.properties=<file name>");
            print("The format for defining datasources is java properties file format");

            return;
        }
    }

    RecoveryManagerImpl rm = RecoveryManagerImpl();
    String? dataSourceConfigPropertyFile = process.propertyValue("dbc.properties");
    String? interactive = process.propertyValue("interactive");

    rm.start(dataSourceConfigPropertyFile);
    print("Recovery Manager running ...");

    if (exists interactive) {
        rm.parseCommandInput();
    } else {
        print("daemon mode");
    }
}

