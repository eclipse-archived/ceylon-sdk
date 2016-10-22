import ceylon.transaction.internal {
    RecoveryHelper
}
import com.arjuna.ats.arjuna.common {
    recoveryPropertyManager {
        recoveryEnvironmentBean
    }
}
import com.arjuna.ats.arjuna.recovery {
    RecoveryModule,
    RecoveryManager
}
import com.arjuna.ats.internal.arjuna.recovery {
    AtomicActionRecoveryModule
}
import com.arjuna.ats.internal.jta.recovery.arjunacore {
    XARecoveryModule
}

import java.lang {
    Runtime,
    Thread,
    System {
        setProperty,getProperty
    }
}
import java.util {
    Arrays
}

import javax.sql {
    XADataSource
}

"Manages the lifecycle of a recovery service."
class ConcreteRecoveryManager() 
        satisfies TransactionRecoveryManager {
    
    variable RecoveryManager? rm = null;
    variable XARecoveryModule? xARecoveryModule = null;
    variable Boolean recoveryManagerInitialized = false;
    
    shared actual void start(String? objectStoreDir) {
        
        if (exists objectStoreDir) {
            // set the location of the action and communications stores
            setProperty("com.arjuna.ats.arjuna.common.ObjectStoreEnvironmentBean.objectStoreDir", objectStoreDir);
            setProperty("com.arjuna.ats.arjuna.objectstore.objectStoreDir", objectStoreDir);

            print("Will recover transaction logs located under " + objectStoreDir);
        }
        else if (exists dir = getProperty("com.arjuna.ats.arjuna.common.ObjectStoreEnvironmentBean.objectStoreDir", ".")) {
            print("Will recover transaction logs located under " + dir);
        }
        else {
            print("No transaction logs");
        }

        if (!rm exists) {
            xARecoveryModule = XARecoveryModule();
            recoveryEnvironmentBean.recoveryModules
                    = Arrays.asList<RecoveryModule>
                        (AtomicActionRecoveryModule(), 
                            xARecoveryModule);
            value realRM = RecoveryManager.manager();
            realRM.initialize();
            rm = realRM;
            recoveryManagerInitialized = true;
        }
        
        Runtime.runtime.addShutdownHook(
            object extends Thread() {
                run() => outer.stop();
            });
    }

    "Stop the transaction service. If an in-process recovery
     manager is running, then it to will be stopped."
    shared actual void stop() {
        if (recoveryManagerInitialized) {
            rm?.terminate();
            rm = null;
            recoveryManagerInitialized = false;
        }
    }

    shared actual void registerXAResourceRecoveryDataSource(XADataSource dataSource) {
        RecoveryHelper rh = RecoveryHelper(dataSource);
        assert (xARecoveryModule exists);
        xARecoveryModule?.addXAResourceRecoveryHelper(rh);
    }

    shared actual void recoveryScan() => rm?.scan();

    shared void parseCommandInput() {
        process.write("> ");
        while (exists line = process.readLine()) {
            if (line=="quit") {
                rm?.terminate();
                break;
            }
            else if (line=="scan") {
                print("scanning");
                recoveryScan();
                print("finished scan");
            }
            else {
                print("Valid command options are:");
                print("\tquit - shutdown the recovery manager and exit");
                print("\tscan - perform a synchronous recovery scan (ie find and recover pending transaction branches)");
                //print("\tdbc.properties=<datasource properties file location>");
            }
            process.write("> ");
        }
    }

    shared actual [String*] supportedDrivers() 
            => ["org.postgresql.Driver",
                "oracle.jdbc.driver.OracleDriver",
                "com.microsoft.sqlserver.jdbc.SQLServerDriver",
                "com.mysql.jdbc.Driver",
                "com.ibm.db2.jcc.DB2Driver",
                "com.sybase.jdbc3.jdbc.SybDriver"];
}

TransactionRecoveryManager concreteRecoveryManager
        = ConcreteRecoveryManager();
