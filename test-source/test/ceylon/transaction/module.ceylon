module test.ceylon.transaction "1.1.2" {
    import ceylon.test "1.1.1";
    // NB need to use shared import to manually enlist resources
    shared import ceylon.transaction "1.1.2";

    import java.base "7";
    import javax.naming "7";

    // ceylon.dbc dependencies
    import ceylon.collection "1.1.1";
    import ceylon.dbc "1.1.2";

    // use vendor specific datasources
    import org.h2 "1.3.168";
}
