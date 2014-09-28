"""This module enables updates to multiple databases within a single transaction. It is integrated
   with ceylon.dbc but you do need to create and pass an XA capable datasource to ceylon.dbc
   
   Initially get a reference to the transaction manager by importing:
   
       import ceylon.transaction.tm {
           tm=transactionManager
       }
   
   and call the transaction manager `start()` method:

       tm.start();
   
   The TM needs to know about any DataSources you intend to use so that it can intercept calls and
   automatically enlist the datasource into the current transaction. These datasources must be XA
   aware. Specifically, the TM needs to know the details of the module that provides the driver and
   connection details for the datasource. Such information can be provided in a java properties file
   or programatically:
   
   - The configuration approach is to define the datasources via a properties file whose
     location is set via a process property called `dbc.properties`. The format follows
     [[http://java.sun.com/dtd/properties.dtd]] and an example is provided in the Ceylon 
     examples directory.
   
   - The programatic approach is via calls on the JNDI server to specify details of the
     module that contains the JDBC driver for the datasource together with details of how to 
     connect to the datasource. An example is provided in the ceylon-sdk test sources directory.
     For example, to register an h2 datasource:
     
           jndiServer.registerDriverSpec("org.h2.Driver", "org.h2", "1.3.168", "org.h2.jdbcx.JdbcDataSource");
           jndiServer.registerDSUrl("h2", "org.h2.Driver", "jdbc:h2:tmp/ceylondb", "sa", "sa");
     
     `registerDriverSpec()` takes the java class name of the JDBC driver, the module name and version 
     of the module that provides the class and the java class name of the XA datasource. `registerDSUrl()` 
     (or `registerDSName()`) provide details of how to connect to the datasource.
   
   Note that not all db products correctly support XA (particularly in the area of recovering from
   failures) so ceylon.transaction only explicitly supports a subset of possible products that are known to 
   perform correctly with respect to recovery:

        org.postgresql.Driver
        oracle.jdbc.driver.OracleDriver
        com.microsoft.sqlserver.jdbc.SQLServerDriver
        com.mysql.jdbc.Driver
        com.ibm.db2.jcc.DB2Driver
        com.sybase.jdbc3.jdbc.SybDriver

   If you try to register any other type then a warning will be printed to the console. You may
   still use the resource in an XA transaction but recovery may not work in which case you will
   need to manually resolve any in doubt transaction involving that datasource.

   The registration process makes the resource available as a datasource via JNDI:
   
       assert (is DataSource ds1 = jndiServer.lookup("h2"));
       assert (is DataSource ds2 = jndiServer.lookup("pgsql"));
   
   Note that you must obtain the datasource via this lookup mechanism and not instantiate them 
   directly. Now you may use the XA datasource just like any other datasource:

       Sql sql1 = Sql(ds1);
       Sql sql2 = Sql(ds2);

   But to make updates to both within a single transaction you must demarcate the transaction 
   boundaries:

       tm.transaction {
           Boolean do() {
               sql1.insert("insert ... ");
               sql2.insert("insert ... ");
               //This will cause a commit - return false or throw to cause rollback
               return true;
           }
       };

   You also have the option of manually controlling the transaction boundary:

       assert (exists tx = tm.beginTransaction());
       sql1.insert("insert ... ");
       sql2.insert("insert ... ");
       tx.commit();

   Of equal importance as the transaction manager is the recovery manager for managing transactions
   that have prepared but some part of the system failed before all resources could be committed.
   In order to correctly recover such transactions a non volatile log is created on the local
   file system after the prepare phase which is later deleted after a successful commit or after a
   successful recovery attempt. The location of this store defaults to a directory called
   tmp in the directory from where the ceylon application was started. The default can be changed
   by setting a process property called:

       com.arjuna.ats.arjuna.common.ObjectStoreEnvironmentBean.objectStoreDir

   by default when you start the transaction manager a recovery manager is not automatically started.
   The reason for this is that there can only be a single recovery manager for all ceylon processes.
   You may run one in process with your application but this is not recommended - instead use the standalone
   recovery manager [[ceylon.transaction.rm::RecoveryManager]] which can run interactively or as a
   background process.

   This recovery process also needs to know which datasources any in doubt transaction was using prior
   to a failure so you need to pass the location of a properties file which defines the datasources
   via a process property called dbc.properties (an example is provided in the sdk test sources directory).
   There is also an example that demonstrates recovery in the examples directory.

   To run interactively set a process property called interactive. For example, type

       ceylon run --run=ceylon.transaction.rm.run --define=interactive= --define=dbc.properties=<path>/dbc.properties ceylon.transaction

   Omit "--define=interactive=" to run recovery in daemon mode. Interactive mode is for situations where
   you want trigger an immediate scan of the recovery logs.

    """
by("Mike Musgrove", "Stéphane Épardaud")
license("Apache Software License 2.0")
module ceylon.transaction "1.1.0" {
    // transaction manager dependencies
    shared import org.jboss.narayana.jta "5.0.0.Final";

    shared import java.base "7";
    shared import java.logging "7";
    shared import javax.naming "7";
    shared import java.jdbc "7";

    //import org.jboss.modules "1.1.3.GA"; // this one fails
    import org.jboss.modules "1.3.3.Final";
    import ceylon.runtime "1.1.0";

    // ceylon.dbc dependencies
    shared import ceylon.dbc "1.1.0";
    shared import ceylon.interop.java "1.1.0";

    import ceylon.file "1.1.0";
}
