/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"An arbitrary precision integer."
shared interface Whole 
        of WholeImpl
        satisfies Integral<Whole> &
                  Exponentiable<Whole, Whole> {

    "The platform-specific implementation object, if any. 
     This is provided for interoperation with the runtime 
     platform."
    see(`function fromImplementation`)
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
    throws(`class Exception`, "If passed a negative or large 
                               positive exponent")
    shared formal actual Whole power(Whole exponent);

    deprecated("Renamed to [[moduloPower]].")
    see(`function moduloPower`)
    throws(`class Exception`, "If passed a negative modulus")
    shared Whole powerRemainder(Whole exponent, 
                                Whole modulus)
        => moduloPower(exponent, modulus);

    "The result of `(this^exponent) mod modulus`."
    throws(`class Exception`, "If passed a negative modulus")
    shared formal Whole moduloPower(Whole exponent, 
                                 Whole modulus);

    //"The result of `this mod modulus`. This method differs from
    // [[remainder]] in that the returned value will always be positive."
    //shared formal Whole modulo(Whole modulus);

    "Returns a pair containing the same results as calling
     `divided()` and `remainder()` with the given
     argument, except the division is only performed once."
    shared formal [Whole, Whole] quotientAndRemainder(Whole other);

    "The number, represented as an [[Integer]]. If the number is too 
     big to fit in an Integer then an Integer corresponding to the
     lower order bits is returned."
    shared formal Integer integer;
    
    "The number, represented as a [[Float]]. If the magnitude of this number 
     is too large the result will be `infinity` or `-infinity`. If the result
     is finite, precision may still be lost."
    shared formal Float float;
    
    "The distance between this whole and the other whole"
    throws(`class OverflowException`, 
        "The numbers differ by an amount larger than can be represented as an `Integer`")
    shared actual formal Integer offset(Whole other);
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
