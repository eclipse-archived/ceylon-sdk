module test.ceylon.transaction "1.0.0" {
    import ceylon.test "1.1.0";

    // transaction manager dependencies
    import org.jboss.narayana.jta "5.0.0.Final";

    import java.base "7";
    //import javax.naming "7";

    // ceylon.dbc dependencies
    import ceylon.collection "1.1.0";
    import ceylon.dbc "1.1.1";

    // use vendor specific datasources
    import org.h2 "1.3.168";
    // import org.jumpmind.symmetric.jdbc.postgresql "9.2-1002-jdbc4";
}
