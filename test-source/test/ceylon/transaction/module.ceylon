native("jvm")
module test.ceylon.transaction "**NEW_VERSION**-SNAPSHOT" {
    import ceylon.test "**NEW_VERSION**-SNAPSHOT";
    // NB need to use shared import to manually enlist resources
    shared import ceylon.transaction "**NEW_VERSION**-SNAPSHOT";

    import java.base "7";
    import javax.naming "7";

    // ceylon.dbc dependencies
    import ceylon.collection "**NEW_VERSION**-SNAPSHOT";
    import ceylon.dbc "**NEW_VERSION**-SNAPSHOT";

    // use vendor specific datasources
    import org.h2 "1.3.168";
}
