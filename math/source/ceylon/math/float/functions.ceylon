import java.lang{ Math {jsin=sin, jcos=cos, jtan=tan,
    jasin=asin, jacos=acos, jatan=atan, 
    jatan2=atan2, jhypot=hypot, 
    jexp=exp, jlog=log, jlog10=log10,
    jsqrt=sqrt, jcbrt=cbrt,
    jrandom=random, 
    jfloor=floor, jceiling=ceil, 
    jround=round, jrint=rint}}

doc "*e* raised to the power of the argument."
shared Float exp(Float num) {
    return jexp(num);
}

doc "The natural logarithm (base *e*) of the argument."
see(log10)
shared Float log(Float num) {
    return jlog(num);
}

doc "The base 10 logarithm of the argument."
see(log)
shared Float log10(Float num) {
    return jlog10(num);
}

doc "The given angle (in radians) converted to degrees."
see(toRadians)
shared Float toDegrees(Float num) {
    return num/pi*180;
}

doc "The given angle (in degrees) converted to radians."
see(toDegrees)
shared Float toRadians(Float num) {
    return num/180*pi;
}

doc "The sine of the given angle specified in radians."
shared Float sin(Float num) {
    return jsin(num);
}

doc "The cosine of the given angle specified in radians."
shared Float cos(Float num) {
    return jcos(num);
}

doc "The tangent of the given angle specified in radians."
shared Float tan(Float num) {
    return jtan(num);
}

doc "The arc sine of the given number."
shared Float asin(Float num) {
    return jasin(num);
}

doc "The arc cosine of the given number."
shared Float acos(Float num) {
    return jacos(num);
}

doc "The arc tangent of the given number."
shared Float atan(Float num) {
    return jatan(num);
}

doc "The angle from converting rectangular coordinates `x` and `y` to polar 
     coordinates."
shared Float atan2(Float y, Float x) {
    return jatan2(y, x);
}

doc "Returns the length of the hypotenuse of a right angle triangle with other 
     sides having lengths `x` and `y`. This method may be more accurate than 
     computing `sqrt(x**2 + x**2)` directly."
shared Float hypot(Float x, Float y) {
    return jhypot(x, y);
}

doc "The positive square root of the given number. This method may be faster 
     and/or more accurate than computing `num.power(0.5)` directly."
shared Float sqrt(Float num) {
    return jsqrt(num);
}

doc "The cube root of the given number. This method may be faster and/or 
     more accurate than `num.power(1.0/3.0)`."
shared Float cbrt(Float num) {
    return jcbrt(num);
}

doc "A number greater and or equal to positive zero and less than 
     1.0, chosen pseudorandomly and (approximately) uniformly distributed."
shared Float random() {
    return jrandom();
}

doc "The largest value that is less than or equal to the argument and 
     equal to an integer."
see(ceiling)
see(halfEven)
shared Float floor(Float num) {
    return jfloor(num);
}

doc "The smallest value that is greater than or equal to the argument and 
     equal to an integer."
see(floor)
see(halfEven)
shared Float ceiling(Float num) {
    return jceiling(num);
}

doc "The closest value to the argument that is equal to a mathematical integer,
     with even values preferred in the event of a tie (half even rounding)."
see(floor)
see(ceiling)
shared Float halfEven(Float num) {
    return jrint(num);
}

doc "The closest value to the argument that is equal to a mathematical integer, 
     with ties rounding up (half up rounding)."
shared Float halfUp(Float num) {
    return jround(num).float;
}

doc "The closest value to the argument that is equal to a mathematical integer, 
     with ties rounding up (half up rounding)."
shared Float halfDown(Float num) {
    return ceiling(num-0.5);
}