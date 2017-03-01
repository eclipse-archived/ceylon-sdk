
"This module allows you to read and write to streams, such 
 as files, sockets and pipes.
 
 See the `ceylon.io` package for usage examples."
by("Stéphane Épardaud")
license("Apache Software License")
native("jvm")
module ceylon.io maven:"org.ceylon-lang" "**NEW_VERSION**-SNAPSHOT" {
    shared import ceylon.buffer "**NEW_VERSION**-SNAPSHOT";
    shared import ceylon.file "**NEW_VERSION**-SNAPSHOT";
    import ceylon.collection "**NEW_VERSION**-SNAPSHOT";
    import java.base "7";
    import java.tls "7";
    import ceylon.interop.java "**NEW_VERSION**-SNAPSHOT";
}
