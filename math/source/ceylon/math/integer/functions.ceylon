doc "The greatest common divisor of the given arguments."
throws(Exception, "Either argument is zero")
shared Integer gcd(Integer a, Integer b) {
    variable Integer x := a;
    variable Integer y := b;
    while ( x != 0) {
        Integer t = x;
        x := y % x;
        y := t;
    }
    return y;
}

doc "The lowest common multiple of the given arguments."
throws(Exception, "Both arguments are zero")
throws(Exception, "The result is too large to fit in an Integer")
shared Integer lcm(Integer a, Integer b) {
    // TODO What about overflow of a*b (even if the result would be representable as an integer)
    return (a*b) / gcd(a, b);
}

doc "Calculate the logarithm (base 2) of the argument, rounded down.
     This is effectively the number of digits in the number."
throws(Exception, "Argument is less than 1")
shared Integer log2(Integer num) {
    // http://stackoverflow.com/questions/3305059/how-do-you-calculate-log-base-2-in-java-for-integers
    /*variable Integer bits := num;
    variable Integer log := 0;
    if( ( bits & 0xffff0000 ) != 0 ) { bits >>>= 16; log := 16; }
    if( bits >= 256 ) { bits >>>= 8; log += 8; }
    if( bits >= 16  ) { bits >>>= 4; log += 4; }
    if( bits >= 4   ) { bits >>>= 2; log += 2; }
    return log + ( bits >>> 1 );*/
    throw;
}