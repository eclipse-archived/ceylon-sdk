"Start a transaction recovery service. 
 
 Since there must be at most one recovery service per set of 
 transaction logs, the recovery service should run in a 
 separate process whenever multiple processes share the logs.
 
 From the command line, start the recovery service using:
 
 ~~~bash
 ceylon run --run=ceylon.transaction.recovery.run ceylon.transaction
 ~~~
 
 Additional options:
 
 - `--rep=<modules>` &mdash; specify module repositories
 - `--define=dbc.properties=<file>` &mdash; specify database 
   configuration file
 - `--define=interactive=true` &mdash; run in interactive
   mode
 
 For recovery to operate correctly you must specify the
 datasources either by putting a Java properties file named 
 `dbc.properties` on the class path or by defining an 
 alternative file location using `--define=dbc.properties`."
by("Mike Musgrove")
shared void run() {
    for (arg in process.arguments) {
        if (arg.contains == "help" || arg.contains == "?") {
            print("Start a transaction recovery service.");
            print("For interactive mode specify --define=interactive=true");
            print("For recovery to operate correctly you must specify the datasources");
            print("either by putting a Java properties file named dbc.properties on ");
            print("the class path or by defining an alternative file location using");
            print("--define=dbc.properties=<file>");
            print("The format for defining datasources is java properties file format");
            return;
        }
    }

    RecoveryManager rm = RecoveryManager();
    String? dataSourceConfigPropertyFile = process.propertyValue("dbc.properties");
    String? interactive = process.propertyValue("interactive");

    rm.start(dataSourceConfigPropertyFile);

    if (exists interactive) {
        print("Recovery service running...");
        rm.parseCommandInput();
    } else {
        print("Recovery service running in daemon mode.");
    }
}

