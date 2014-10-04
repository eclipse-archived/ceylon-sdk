"""This module enables updates to multiple databases within 
   a single transaction. It is integrated with 
   [[module ceylon.dbc]] but you do need to create and pass
   an XA capable datasource to [[ceylon.dbc::Sql]].
   
   First, obtain a reference to the 
   [[transaction manager|TransactionManager]] by importing 
   its [[singleton instance|transactionManager]]:
   
       import ceylon.transaction.tm {
           tm=transactionManager
       }
   
   Then [[start|TransactionManager.start]] it:

       tm.start();
   
   The `TransactionManager` needs to know about every JDBC
   [[datasource|javax.sql::DataSource]] so that it can 
   intercept calls and automatically enlist the datasource 
   as an XA resource in the current transaction. Therefore, 
   the datasource must be XA-capable.
   
   Specifically, the `TransactionManager` needs to know the 
   details of:
   
    - the module that provides the database driver, and 
    - the connection details for the datasource.
   
   This information can be provided in a java properties 
   file or programatically:
   
   - The location of a the properties file is set via a 
     process property named `dbc.properties`. The format 
     follows [[http://java.sun.com/dtd/properties.dtd]] and 
     an example is provided with the tests for this module.
   - Alternatively, the information may be provided by first
     calling [[ceylon.transaction.datasource::registerDriver]]
     and then one of [[ceylon.transaction.datasource::registerDataSourceUrl]]
     or [[ceylon.transaction.datasource::registerDataSourceName]].
     
   For example, to register an h2 datasource programmatically:
     
           registerDriver {
               driver = "org.h2.Driver"; 
               moduleAndVersion = ["org.h2", "1.3.168"];
               className = "org.h2.jdbcx.JdbcDataSource"
           };
           registerDataSourceUrl {
               "h2"; 
               driver = "org.h2.Driver"; 
               url = "jdbc:h2:tmp/ceylondb"; 
               userAndPassword = ["sa", "sa"]
           };
     
   Where `registerDriver()` accepts:
   
   - the class name of the JDBC driver, 
   - the name and version of the module that provides the 
     driver, and 
   - the java class name of the XA datasource.
   
   Note that the JDBC driver `.jar` must be available to 
   Ceylon as a module in either a Ceylon module repository
   or a Maven repository.
   
   Finally, `registerDataSourceUrl()` or 
   `registerDataSourceName()` specify details of how to 
   connect to the database.
   
   Note that not all database drivers correctly support XA 
   (particularly in the area of recovering from failures), 
   so `ceylon.transaction` only explicitly supports the 
   subset of possible products that are known to behave 
   correctly with respect to recovery:
   
        org.postgresql.Driver
        oracle.jdbc.driver.OracleDriver
        com.microsoft.sqlserver.jdbc.SQLServerDriver
        com.mysql.jdbc.Driver
        com.ibm.db2.jcc.DB2Driver
        com.sybase.jdbc3.jdbc.SybDriver
   
   If you try to register any other driver then a warning 
   will be printed to the console. You may still use the 
   resource in an XA transaction but recovery may not work 
   in which case you will need to manually resolve any in 
   doubt transaction involving that datasource.

   The registration process makes the resource available as 
   a datasource via JNDI:
   
       assert (is DataSource ds1 = InitialContext().lookup("h2"));
       assert (is DataSource ds2 = InitialContext().lookup("pgsql"));
   
   (Note that you must obtain the datasource via this lookup 
   mechanism. You may not instantiate it directly.)
   
   Now you may use the XA datasource just like any other 
   datasource:
   
       Sql sql1 = Sql(ds1);
       Sql sql2 = Sql(ds2);
   
   But to make updates to both within a single transaction 
   you must demarcate the transaction boundaries, usually
   using [[TransactionManager.transaction]]:
   
       tm.transaction {
           function do() {
               sql1.insert("insert ... ");
               sql2.insert("insert ... ");
               //This will cause a commit - return false or throw to cause rollback
               return true;
           }
       };
   
   You also have the option of manually controlling the 
   transaction boundary:

       assert (exists tx = tm.beginTransaction());
       sql1.insert("insert ... ");
       sql2.insert("insert ... ");
       tx.commit();

   Of equal importance as the transaction manager is the 
   recovery manager for managing transactions that have 
   prepared but some part of the system has failed before 
   all resources could be committed.
   
   In order to correctly recover such transactions, a 
   non-volatile log is created on the local file system 
   after the prepare phase which is later deleted after a s
   uccessful commit or after a successful recovery attempt.
   The location of this store defaults to a directory called
   `tmp` in the directory from where the ceylon application 
   was started. The default can be changed by setting a 
   process property called:

       com.arjuna.ats.arjuna.common.ObjectStoreEnvironmentBean.objectStoreDir

   By default, when you start the transaction manager a 
   recovery manager is not automatically started. The reason 
   for this is that there can only be a single recovery 
   service for all processes that share the same transaction
   logs. You _may_ run an in-process recovery service, 
   though this is not recommended, by passing a flag to 
   [[TransactionManager.start]]. But it's much better to run 
   the recovery service in its own 
   [[dedicated process|ceylon.transaction.recovery::run]],
   either interactively, or in the background.

   This recovery process also needs to know which datasources 
   any in doubt transaction was using prior to a failure so 
   you need to pass the location of a properties file which 
   defines the datasources via a process property called 
   `dbc.properties`."""
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
