"This module provides an arbitrary-precision integer numeric type.

 The type [[Whole|ceylon.whole::Whole]] is a first-class numeric type and
 support all the usual mathematical operations:

     Whole i = wholeNumber(12P);
     Whole j = wholeNumber(3);
     Whole n = i**j + j;
     print(n); //prints 1728000000000000000000000000000000000003"
by("Tom Bentley", "John Vasileff")
module ceylon.whole maven:"org.ceylon-lang" "1.3.3-SNAPSHOT" {
    native("jvm") import java.base "7";
    native("jvm") import ceylon.interop.java "1.3.3-SNAPSHOT";
}
