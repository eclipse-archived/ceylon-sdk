"This module provides `ceylon.math.whole`&mdash;an arbitrary-precision integer
 numeric type.

 The type [[Whole|ceylon.whole::Whole]] is a first-class numeric type and
 support all the usual mathematical operations:

     Whole i = wholeNumber(12P);
     Whole j = wholeNumber(3);
     Whole n = i**j + j;
     print(n); //prints 1728000000000000000000000000000000000003"
by("Tom Bentley", "John Vasileff")
module ceylon.whole "1.2.1" {
    native("jvm") import java.base "7";
    native("jvm") import ceylon.interop.java "1.2.1";
}
