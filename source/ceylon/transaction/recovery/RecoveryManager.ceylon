import ceylon.file {
    File,
    parsePath
}
import ceylon.transaction {
    transactionManager
}
import ceylon.transaction.datasource {
    registerDataSources
}

import java.lang {
    System {
        setProperty,
        getProperty
    }
}

"Manages the lifecycle of a recovery service."
class RecoveryManager() {

    shared void start(String? dataSourceConfigPropertyFile) {
        String userDir = getProperty("user.dir", "") + "/tmp";
        setProperty("com.arjuna.ats.arjuna.objectstore.objectStoreDir", userDir);
        setProperty("com.arjuna.ats.arjuna.common.ObjectStoreEnvironmentBean.objectStoreDir", userDir);
        
        transactionManager.start(true);
        bindDSProperties(dataSourceConfigPropertyFile);
    }

    shared void scan() {
        transactionManager.recoveryScan();
    }

    shared void parseCommandInput() {
        process.write("> ");
        while (exists line = process.readLine()) {
            if (line == "quit") {
                transactionManager.stop();
                break;
            } else if (line == "scan") {
                print("scanning");
                scan();
                print("finished scan");
            //} else if (line.contains("dbc.properties=")) {
                //String? propFile = line.split((Character c) => c == '=').rest.first;
                //bindDSProperties(propFile);
            } else {
                print("Valid command options are:");
                print("\tquit - shutdown the recovery manager and exit");
                print("\tscan - perform a synchronous recovery scan (ie find and recover pending transaction branches)");
                //print("\tdbc.properties=<datasource properties file location>");
            }

            process.write("> ");
        }
    }

    void bindDSProperties(String? dataSourceConfigPropertyFile) {
        if (exists dataSourceConfigPropertyFile) {
            value propFile = dataSourceConfigPropertyFile.trimmed;
            value path = parsePath(propFile);
            if (is File f = path.resource) {
                print("configuring datasources via properties file ``propFile``");
                registerDataSources(propFile);
            } else {
                print("warning: no datasources configured - property file ``propFile`` does not exist");
            }
         } else {
             print("warning: no datasources configured - missing property file");
         }
    }
}