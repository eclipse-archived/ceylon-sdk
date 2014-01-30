"""This module enables updates to multiple databases within a single transaction. It is integrated
   with ceylon.dbc but you do need to create and pass an XA capable datasource to ceylon.dbc

   Initially get a reference to the transaction manager:

       import ceylon.transaction.tm { TM, getTM }

       TM tm = getTM();

   The TM needs to know about any DataSources you intend to use so perform a one time only JNDI registration:

       tm.getJndiServer().registerDSUrl(
           "h2", "org.h2.Driver", "jdbc:h2:~/ceylondb", "sa", "sa");
       tm.getJndiServer().registerDSName(
           "pgsql", "org.postgresql.Driver", "ceylondb", "localhost", 5432, "sa", "sa");

   [You can also define datasources in a properties file called dbc.properties that is located either on the
   class path or in any of the directories set in the JDK system properties: user.dir, user.home or java.home.
   The format follows [[http://java.sun.com/dtd/properties.dtd]] and an example is provided in the
   sdk test sources directory].

   To perform transactional updates you need an XA aware datasource. The previous registration
   process makes them available via JNDI:

       Object? ds1 = tm.getJndiServer().lookup("h2");
       Object? ds2 = tm.getJndiServer().lookup("pgsql");

       // and ensure that the looked up datasources are valid
       assert (is DataSource ds1);
       assert (is DataSource ds2);

   Now you may use the datasource just like any other datasource:

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

    """
by("Mike Musgrove")
license("Apache Software License 2.0")
module ceylon.transaction "1.0.0" {
    shared import javax.transaction.api "1.2";

    // ceylon.transaction dependencies
    import org.jboss.logging "3.1.3.GA";
    import org.jboss.jnpserver "5.0.3.GA";

    // transaction manager dependencies
    import org.jboss.narayana.jta "5.0.0.CR3-SNAPSHOT";

    import java.base "7";
    import javax.naming "7";

    import org.jboss.modules "1.1.3.GA";

    // ceylon.dbc dependencies
    import ceylon.collection "1.0.0";
    shared import ceylon.dbc "1.0.1";
}
