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

    "The result of `(this**exponent) mod modulus`."
    throws(`class Exception`, "If passed a negative modulus")
    shared formal Whole modPower(Whole exponent, 
                                 Whole modulus);

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

    shared formal Boolean get(Integer index);

    shared formal [Whole, Whole] quotientAndRemainder(Whole other);

    shared formal Whole leftLogicalShift(Integer shift);

    shared formal Whole rightArithmeticShift(Integer shift);

    "Determine if this number is even.

     A number `i` is even if there exists an integer `k` 
     such that:

         i == 2*k

     Thus, `i` is even if and only if `i%2 == 0`."
    shared formal Boolean even;

    shared formal Whole modInverse(Whole modulus);

    shared formal Whole mod(Whole modulus);

}
