native("jvm")
module test.ceylon.transaction "1.2.3" {
    import ceylon.test "1.2.3";
    // NB need to use shared import to manually enlist resources
    shared import ceylon.transaction "1.2.3";

    import java.base "7";
    import javax.naming "7";

    // ceylon.dbc dependencies
    import ceylon.collection "1.2.3";
    import ceylon.dbc "1.2.3";

    // use vendor specific datasources
    import org.h2 "1.3.168";
}
