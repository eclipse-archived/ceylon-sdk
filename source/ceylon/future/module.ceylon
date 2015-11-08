"Thread concurrency extensions for `ceylon.promise`"
by ("Alex Szczuczko")
license ("Apache Software License")
native ("jvm") module ceylon.future "1.2.1" {
    import java.base "7";
    shared import ceylon.promise "1.2.1";
}
