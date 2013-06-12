import java.lang { NumberFormatException }
import java.math { BigInteger { fromLong=valueOf } }

"An arbitrary precision integer."
shared interface Whole of WholeImpl
        //extends IdentifiableObject()
        satisfies //Castable<Whole|Decimal> &
                  Integral<Whole> & Scalar<Whole> &
                  Exponentiable<Whole, Whole> {

    "The platform-specific implementation object, if any. 
     This is provided for interoperation with the runtime 
     platform."
    see(fromImplementation)
    shared formal Object? implementation;
    
    "The result of raising this number to the given power.
     
     Special cases:
     
     * Returns one if `this` is one (or all powers)
     * Returns one if `this` is minus one and the power 
       is even
     * Returns minus one if `this` is minus one and the 
       power is odd
     * Returns one if the power is zero.
     * Otherwise negative powers result in an `Exception` 
       being thrown
     "
    throws(Exception, "If passed a negative or large positive 
                       exponent")
    shared formal actual Whole power(Whole exponent);

    "The result of `(this**exponent) % modulus`."
    throws(Exception, "If passed a negative modulus")
    shared formal Whole powerRemainder(Whole exponent, 
                                       Whole modulus);
}

"The `Whole` repesented by the given string, or `null` 
 if the given string does not represent a `Whole`."
shared Whole? parseWhole(String num) {
    BigInteger bi;
    try {
        //TODO: Use something more like the Ceylon literal 
        //      format
        bi = BigInteger(num);
    } catch (NumberFormatException e) {
        return null;
    }
    return WholeImpl(bi);
}

"The `number.integer` converted to a `Whole`."
shared Whole wholeNumber(Number number) {
    Integer int = number.integer;
    if (int == 0) {
        return zeroImpl;
    } else if (int == 1) {
        return oneImpl;
    } else {
        return WholeImpl(fromLong(int));
    }
}

"Converts a platform-specific implementation object to a 
 `Whole` instance. This is provided for interoperation 
 with the runtime platform."
//see(Whole.implementation)
shared Whole fromImplementation(Object implementation) {
    if(is BigInteger implementation) {
        return WholeImpl(implementation);
    }
    throw;
}

/*
"The greatest common divisor of the arguments."
shared Whole gcd(Whole a, Whole b) {
    // TODO return Whole(a.val.gcd(b.val));
    throw;
}

"The least common multiple of the arguments."
shared Whole lcm(Whole a, Whole b) {
    return (a*b) / gcd(a, b);
}

"The factorial of the argument."
shared Whole factorial(Whole a) {
    if (a <= Whole(0)) {
        throw;
    }
    variable Whole b = a;
    variable Whole result = a;
    while (b >= Whole(2)) {
        b = b.predecessor;
        result *= b;
    }
    return result;
}
*/