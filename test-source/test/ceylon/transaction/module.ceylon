module test.ceylon.transaction "1.0.0" {
    import ceylon.test "1.0.0";

    shared import javax.transaction.api "1.2";

    // ceylon.transaction dependencies
    import org.jboss.logging "3.1.3.GA";
    shared import org.jboss.jnpserver "5.0.3.GA";

    // transaction manager dependencies
    import org.jboss.narayana.jta "5.0.0.CR3-SNAPSHOT";

    import java.base "7";
    //import javax.naming "7";

    // ceylon.dbc dependencies
    import ceylon.collection "1.0.0";
    import ceylon.dbc "1.0.1";

    // use vendor specific datasources
    import org.h2 "1.3.168";
    // import org.jumpmind.symmetric.jdbc.postgresql "9.2-1002-jdbc4";
}
