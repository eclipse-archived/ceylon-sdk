"""This module enables updates to multiple databases within 
   a single transaction. It is integrated with 
   [[module ceylon.dbc]].

   First, obtain a reference to the
   [[transaction manager|TransactionManager]] by importing 
   its [[singleton instance|transactionManager]]:
   
       import ceylon.transaction.tm {
           tm=transactionManager
       }
   
   Then [[start|TransactionManager.start]] it:

       tm.start();
   
   The `TransactionManager` needs to know about every JDBC
   [[datasource|javax.sql::XADataSource]] so that it can
   intercept calls and automatically enlist the datasource 
   as an XA resource in the current transaction. Therefore, 
   the datasource must be XA-capable. If you use the method
   [[ceylon.dbc::newConnectionFromXADataSource]] to obtain 
   XA connections then the TransactionManager will 
   automatically ensure that work done on the returned 
   connection is transactional.

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


   After obtaining an XA connection you may use it just like 
   any other datasource connection:
   
       Sql sql1 = Sql(conn1);
       Sql sql2 = Sql(conn2);
   
   But to make updates to both within a single transaction 
   you must demarcate the transaction boundaries, usually
   using [[TransactionManager.transaction]]:
   
       tm.transaction {
           function do() {
               sql1.insert("insert ... ");
               sql2.insert("insert ... ");
               // returning true will cause a commit
               // returning false or throwing an exception will
               // result in the transaction rolling back
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
   after the prepare phase which is later deleted when the
   transaction finishes (either after a successful commit
   or after a successful recovery attempt). The location of 
   this store defaults to the directory from where the 
   Ceylon application was started. The default can be 
   changed by setting a process property called:

       com.arjuna.ats.arjuna.common.ObjectStoreEnvironmentBean.objectStoreDir

   By default when you start the transaction manager a
   recovery manager is not automatically started. The reason 
   for this is that there can only be a single recovery 
   service for all processes that share the same transaction
   logs. You _may_ run an in-process recovery service, 
   though this is not recommended, by passing a flag to 
   [[TransactionManager.start]]. But it's much better to run 
   the recovery service in its own
   [[dedicated process|TransactionRecoveryManager.start]].

   This recovery process needs to know which datasources
   any in doubt transactions were using prior to a failure 
   so you will need to explicitly register them:

       import ceylon.transaction {transactionRecoveryManager}

       transactionRecoveryManager.start()

       XADataSource xaDataSource = ... // such as org.h2.jdbcx.JdbcDataSource()

       transactionRecoveryManager.registerXAResourceRecoveryDataSource(xaDataSource)

   """
suppressWarnings("doclink")
by ("Mike Musgrove", "Stéphane Épardaud", "Gavin King")
license ("Apache Software License 2.0")
native("jvm")
module ceylon.transaction maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    shared import org.jboss.narayana.jta "5.2.7.Final-1";
    shared import java.jdbc "7";
    shared import javax.transaction "7";
    import javax.naming "7";
    import java.base "7";
}
