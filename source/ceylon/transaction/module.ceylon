"""This module enables updates to multiple databases within a single transaction. It is integrated
   with ceylon.dbc but you do need to create and pass an XA capable datasource to ceylon.dbc

   Initially get a reference to the transaction manager:

       import ceylon.transaction.tm { TM, getTM }

       TM tm = getTM();

   and call the transaction manager start method:

       tm.start();

   The TM needs to know about any DataSources you intend to use so perform a one time only JNDI registration:

       tm.getJndiServer().registerDSUrl(
           "h2", "org.h2.Driver", "jdbc:h2:~/ceylondb", "sa", "sa");
       tm.getJndiServer().registerDSName(
           "pgsql", "org.postgresql.Driver", "ceylondb", "localhost", 5432, "sa", "sa");

   [You can also define datasources in a properties file called dbc.properties by setting a process property
   called dbc.properties whose value is the property file name.
   The format follows [[http://java.sun.com/dtd/properties.dtd]] and an example is provided in the
   sdk test sources directory].

   To perform transactional updates you need an XA aware datasource. Not all db products correctly support
   XA (particularly in the area of recovering from failures) so ceylon.transaction only supports a subset of
   possible products:

        org.postgresql.Driver
        oracle.jdbc.driver.OracleDriver
        com.microsoft.sqlserver.jdbc.SQLServerDriver
        com.mysql.jdbc.Driver
        com.ibm.db2.jcc.DB2Driver
        com.sybase.jdbc3.jdbc.SybDriver

   If you try to register any other type then a warning will be printed to the console. You may
   still use the resource in an XA transaction but recovery will probable not work and you will
   need to manually resolve in doubt transactions.

   The XA datasource registration process makes the resource available via JNDI:

       Object? ds1 = tm.getJndiServer().lookup("h2");
       Object? ds2 = tm.getJndiServer().lookup("pgsql");

       // Your code should ensure that the looked up datasources are valid
       assert (is DataSource ds1);
       assert (is DataSource ds2);

   Now you may use the XA datasource just like any other datasource:

   Sql sql1 = Sql(ds1);
   Sql sql2 = Sql(ds2);

   But to make updates to both within a single transaction you must demarcate the transaction boundaries:

       tm.transaction {
           Boolean do() {
               sql1.insert("insert ... ");
               sql2.insert("insert ... ");
               //This will cause a commit - return false or throw to cause rollback
               return true;
           }
       };

   You also have the option of manually controlling the transaction:

       UserTransaction? transaction = tm.beginTransaction();
       assert (is UserTransaction transaction);
       sql1.insert("insert ... ");
       sql2.insert("insert ... ");
       transaction.commit();

   Apart from the transaction manager there is also a recovery manager for managing transactions
   that have prepared but some part of the system failed before all resources could be committed.
   In order to correctly recovery such transactions a non volatile log is created on the local
   file system after the prepare phase which is deleted after a successful commit or after a
   successful recovery attempt. The location of this store is defaults to a directly called
   tmp in the directory from where the ceylon application was started. The default can be changed
   by setting a process property called:

   com.arjuna.ats.arjuna.common.ObjectStoreEnvironmentBean.objectStoreDir

   By default when you start the transaction manager no recovery takes place.
   There must only be a single recovery manager for all ceylon processes. You may run one in process
   with your application but this is not recommended - instead use the standalone recovery manager:
   [[transaction.rm.RecoveryManager]]

   To run recovery manager in interactive mode set a process property called interactive. The recovery
   process also needs to know which datasource in doubt transaction were using so you must pass 
   the location of a  properties file containing the datasource configuration in a process property
   called dbc.properties (an example is provided in the sdk test sources directory). So, to start
   the manager running in interactive mode type

   ceylon run --run=ceylon.transaction.rm.run --define=interactive= --define=dbc.properties=<path>/dbc.properties ceylon.transaction

   Omit --define=interactive= to run recovery in daemon mode. Interactive mode if you want trigger an immediate
   scan of the recovery logs.

    """
by("Mike Musgrove")
license("Apache Software License 2.0")
module ceylon.transaction "1.1.0" {
    // transaction manager dependencies
    shared import org.jboss.narayana.jta "5.0.0.Final";

    shared import java.base "7";
    import java.logging "7";
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
