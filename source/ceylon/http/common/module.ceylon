"""This module defines APIs common to HTTP clients and servers.
"""

by("Stéphane Épardaud", "Matej Lazar")
license("Apache Software License")
native("jvm")
module ceylon.http.common maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    shared import ceylon.collection "1.3.4-SNAPSHOT";
    shared import ceylon.io "1.3.4-SNAPSHOT";
}
