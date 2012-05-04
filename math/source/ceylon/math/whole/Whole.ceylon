import java.lang{
    JInt=Integer {maxInt=\iMAX_VALUE},
    NumberFormatException}
import java.math{
    BigInteger{
        fromLong=valueOf,
        jzero=\iZERO,
        jone=\iONE},
    BigDecimal
}
import ceylon.math.decimal{Decimal}

doc "An arbitrary precision integer."
shared interface Whole of WholeImpl
        //extends IdentifiableObject()
        satisfies //Castable<Whole|Decimal> &
                  Integral<Whole> & Scalar<Whole> &
                  Exponentiable<Whole, Whole> {

    doc "The platform specific implementation object, if any.
         This is provided for the purposes of interoperation with the
         runtime platform."
    see(fromImplementation)
    shared formal Object? implementation;

    doc "The result of raising this number to the given
         power.

         Special cases:

         * Returns one if `this` is one (or all powers)
         * Returns one if `this` is minus one and the power is even
         * Returns minus one if `this` is minus one and the power is odd
         * Returns one if the power is zero.
         * Otherwise negative powers result in an `Exception` being thrown
    "
    throws(Exception, "If passed a negative or large positive exponent")
    shared formal actual Whole power(Whole exponent);

    doc "The result of `(this**exponent) % modulus`."
    throws(Exception, "If passed a negative modulus")
    shared formal Whole powerRemainder(Whole exponent, Whole modulus);
}

class WholeImpl(BigInteger num)
        extends IdentifiableObject()
        satisfies //Castable<Whole|Decimal> &
                  Whole {

    shared actual BigInteger implementation = num;

    shared actual String string {
        return implementation.string;
    }

    shared actual WholeImpl successor {
        return WholeImpl(this.implementation.add(jone));
    }

    shared actual WholeImpl predecessor {
        return WholeImpl(this.implementation.subtract(jone));
    }

    shared actual WholeImpl positiveValue {
        return this;
    }

    shared actual WholeImpl negativeValue {
        return WholeImpl(this.implementation.negate());
    }

    shared actual Boolean positive {
        return this.implementation.signum() > 0;
    }

    shared actual Boolean negative {
        return this.implementation.signum() < 0;
    }

    shared actual Boolean zero {
        return implementation === jzero || implementation.equals(jzero);
    }

    shared actual Boolean unit {
        return implementation === jone || implementation.equals(jone);
    }

    shared actual Float float {
        return this.implementation.doubleValue();
    }

    shared actual Integer integer {
        return this.implementation.longValue();
    }

    shared actual WholeImpl magnitude {
        if (this.implementation.signum() < 0) {
            return WholeImpl(this.implementation.negate());
        } else {
            return this;
        }
    }

    shared actual WholeImpl wholePart {
        return this;
    }

    shared actual Whole fractionalPart {
        return zeroImpl;
    }

    shared actual Integer sign {
        return this.implementation.signum();
    }

    shared actual Integer hash {
        return this.implementation.hash;
    }

    shared actual Boolean equals(Object other) {
        if (is WholeImpl other) {
            return this.implementation.equals(other.implementation);
        }
        return false;
    }

    shared actual Comparison compare(Whole other) {
        if (is WholeImpl other) {
            Integer cmp = this.implementation.compareTo(other.implementation);
            if (cmp > 0) {
                return larger;
            } else if (cmp < 0) {
                return smaller;
            } else {
                return equal;
            }
        }
        throw;
    }

    shared actual WholeImpl plus(Whole other) {
        if (is WholeImpl other) {
            return WholeImpl(this.implementation.add(other.implementation));
        }
        throw;
    }

    shared actual WholeImpl minus(Whole other) {
        if (is WholeImpl other) {
            return WholeImpl(this.implementation.subtract(other.implementation));
        }
        throw;
    }

    shared actual WholeImpl times(Whole other) {
        if (is WholeImpl other) {
            return WholeImpl(this.implementation.multiply(other.implementation));
        }
        throw;
    }

    shared actual WholeImpl divided(Whole other) {
        if (is WholeImpl other) {
            return WholeImpl(this.implementation.divide(other.implementation));
        }
        throw;
    }

    shared actual WholeImpl remainder(Whole other) {
        if (is WholeImpl other) {
            return WholeImpl(this.implementation.remainder(other.implementation));
        }
        throw;
    }

    shared actual Whole power(Whole other) {
        if (is WholeImpl other) {
            if (this == -oneImpl) {
                if (other % twoImpl == zeroImpl) {
                    return oneImpl;
                } else {
                    return -oneImpl;
                }
            } else if (this == oneImpl) {
                return oneImpl;
            }
            if (other < zeroImpl) {
                throw Exception("Unsupported power " this "**" other "");
            } else if (other == 0) {
                return oneImpl;
            } else if (other > maxIntImpl) {
                throw Exception("Unsupported power " this "**" other "");
            }
            return WholeImpl(this.implementation.pow(other.implementation.intValue()));
        }
        throw;
    }

    shared actual Whole powerRemainder(Whole exponent, Whole modulus) {
        if (is WholeImpl exponent) {
            if (is WholeImpl modulus) {
                return WholeImpl(this.implementation.modPow(exponent.implementation, modulus.implementation));
            }
        }
        throw;
    }
    /*shared actual CastValue castTo<CastValue>() {
        // TODO what do I do here?
        return bottom;
        //return this;
        //return Decimal(BigDecimal(this.val));
    }*/

}

doc "The Whole repesented by the given string, or null if the given string
     does not represent a Whole."
shared Whole? parseWhole(String num) {
    BigInteger bi;
    try {
        // TODO Use something more like the Ceylon literal format
        bi = BigInteger(num);
    } catch (NumberFormatException e) {
        return null;
    }
    return WholeImpl(bi);
}

doc "The `number.integer` converted to a Whole."
shared Whole toWhole(Number number) {
    Integer int = number.integer;
    if (int == 0) {
        return zeroImpl;
    } else if (int == 1) {
        return oneImpl;
    } else {
        return WholeImpl(fromLong(int));
    }
}

doc "Converts a platform specific implementation object to a `Whole` instance.
     This is provided for the purposes of interoperation with the
     runtime platform."
//see(Whole.implementation)
shared Whole fromImplementation(Object implementation) {
    if(is BigInteger implementation) {
        return WholeImpl(implementation);
    }
    throw;
}

/*
doc "The greatest common divisor of the arguments."
shared Whole gcd(Whole a, Whole b) {
    // TODO return Whole(a.val.gcd(b.val));
    throw;
}

doc "The least common multiple of the arguments."
shared Whole lcm(Whole a, Whole b) {
    return (a*b) / gcd(a, b);
}

doc "The factorial of the argument."
shared Whole factorial(Whole a) {
    if (a <= Whole(0)) {
        throw;
    }
    variable Whole b := a;
    variable Whole result := a;
    while (b >= Whole(2)) {
        b := b.predecessor;
        result *= b;
    }
    return result;
}
*/