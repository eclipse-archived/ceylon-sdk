native("jvm")
module test.ceylon.transaction "1.3.4-SNAPSHOT" {
    import ceylon.test "1.3.4-SNAPSHOT";
    // NB need to use shared import to manually enlist resources
    shared import ceylon.transaction "1.3.4-SNAPSHOT";

    import java.base "7";
    import javax.naming "7";

    // ceylon.dbc dependencies
    import ceylon.collection "1.3.4-SNAPSHOT";
    import ceylon.dbc "1.3.4-SNAPSHOT";

    // use vendor specific datasources
    import org.h2 "1.3.168";
}
