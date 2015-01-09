"An arbitrary precision integer."
by("John Vasileff")
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
    throws(`class Exception`, "If passed a negative exponent")
    throws(`class OverflowException`, "If passed an exponent > runtime.maxIntegerValue")
    shared formal actual Whole power(Whole exponent);

    deprecated("Renamed to [[modPower]].")
    see(`function modPower`)
    throws(`class Exception`, "If passed a negative modulus")
    shared Whole powerRemainder(Whole exponent, Whole modulus)
        => modPower(exponent, modulus);

    "The result of `(this**exponent) mod modulus`."
    throws(`class Exception`, "If passed a negative modulus")
    shared formal Whole modPower(Whole exponent,
                                 Whole modulus);

    "The number, as an [[Integer]] composed of the
     [[runtime.integerAddressableSize]] number of least significant
     bits of the two's complement representation of this Whole.

     The sign of the returned [[Integer]] may be different from
     the sign of the Whole."
    shared formal Integer integer;

    "The number, represented as a [[Float]], if such a
     representation is possible."
    throws (`class OverflowException`,
        "if the number cannot be represented as a `Float`
         without loss of precision")
    shared formal Float float;

    "The distance between this whole and the other whole"
    throws(`class OverflowException`,
        "The numbers differ by an amount larger than can be represented as an `Integer`")
    shared actual formal Integer offset(Whole other);

    "Retrieves a given bit from the two's complement representation
     of this Whole if `index <= 0`, otherwise returns false."
    shared formal Boolean get(Integer index);

    "Returns an instance with the given bit set to the given
     value if `index >= 0`, otherwise returns a value
     with the same bits as this value."
    shared formal Whole set(Integer index, Boolean bit = true);

    "Returns an instance with the given bit flipped to its
     opposite value if `index >= 0`, otherwise
     returns a value with the same bits as this value."
    shared formal Whole flip(Integer index);

    "Returns a pair containing the same results as calling
     `divided()` and `remainder()` with the given
     argument, except the division is only performed once."
    shared formal [Whole, Whole] quotientAndRemainder(Whole other);

    "Shift the sequence of bits to the left, by the
     given [[number of places|shift]], filling the least
     significant bits with zeroes."
    shared formal Whole leftLogicalShift(Integer shift);

    "Shift the sequence of bits to the right, by the
     given [[number of places|shift]], preserving the values
     of the most significant bits.

     If the sequence of bits represents a signed value,
     the sign is preserved."
    shared formal Whole rightArithmeticShift(Integer shift);

    "Performs a logical AND operation. The result will be negative
     if and only if both this and the other `Whole` is negative."
    shared formal Whole and(Whole other);

    "Performs a logical OR operation. The result will be negative
     if and only if either this or the other `Whole` is negative."
    shared formal Whole or(Whole other);

    "Performs a logical XOR operation. The result will be negative
     if and only if exactly one of this and the other `Whole` is negative."
    shared formal Whole xor(Whole other);

    "Determine if this number is even.

     A number `i` is even if there exists an integer `k`
     such that:

         i == 2*k

     Thus, `i` is even if and only if `i%2 == 0`."
    shared formal Boolean even;

    "The result of (this<sup>-1</sup> mod m)"
    shared formal Whole modInverse(Whole modulus);

    "The result of `this mod modulus`, differing from [[remainder]] in that
     the returned value will always be positive."
    shared formal Whole mod(Whole modulus);

    "The binary complement of this sequence of bits. The returned value
     will have the opposite sign of the orignal value."
    shared formal Whole not;

}
