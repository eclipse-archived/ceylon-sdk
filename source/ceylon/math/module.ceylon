import java.lang.annotation {
    inherited
}
"This module provides four APIs:
 
 - `ceylon.math.decimal`&mdash;an arbitrary-precision decimal
   numeric type,
 - `ceylon.math.whole`&mdash;an arbitrary-precision integer
   numeric type,
 - `ceylon.math.float`&mdash;various common mathematical 
   functions for floating-point numbers, and
 - `ceylon.math.integer`&mdash;various common functions for
   integers.
 
 The types [[Whole|ceylon.math.whole::Whole]] and 
 [[Decimal|ceylon.math.decimal::Decimal]] are first-class 
 numeric types and support all the usual mathematical 
 operations:
 
     Whole i = wholeNumber(12P);
     Whole j = wholeNumber(3);
     Whole n = i**j + j;
     print(n); //prints 1728000000000000000000000000000000000003
 
 Operations on `Decimal`s can result in a non-terminating 
 decimal representation. In such cases, it is necessary to 
 perform the operations with _rounding_. The function
 `implicitlyRounded()` performs a computation with rounding.
 
     Decimal x = decimalNumber(66.0G);
     Decimal y = decimalNumber(100.0T);
     Decimal z = decimalNumber(66.0f);
     Decimal d = implicitlyRounded(() => (x+z)/y/x, round(40, halfUp));
     print(d); //prints 1.000000000000000000000001E-14
 
 Here, the expression `(x+z)/y/x`, which has no terminating 
 decimal representation, is evaluated with the intermediate 
 result of each constituent operation rounded down to 40
 decimal digits."
by("Tom Bentley")
module ceylon.math "1.1.1" {
    import java.base "7";
    import ceylon.interop.java "1.1.1";
}
