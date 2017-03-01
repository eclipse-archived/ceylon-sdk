"""This module defines APIs common to HTTP clients and servers.
"""

by("Stéphane Épardaud", "Matej Lazar")
license("Apache Software License")
native("jvm")
module ceylon.http.common maven:"org.ceylon-lang" "**NEW_VERSION**-SNAPSHOT" {
    shared import ceylon.collection "**NEW_VERSION**-SNAPSHOT";
    shared import ceylon.io "**NEW_VERSION**-SNAPSHOT";
}
