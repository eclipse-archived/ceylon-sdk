import ceylon.math.whole{Whole, wrapBigInteger=fromImplementation}
import java.lang{NumberFormatException, ThreadLocal}
import java.math{
    BigDecimal {
        bdone=\iONE, bdzero=\iZERO, bdten=\iTEN
    },
    BigInteger,
    MathContext,
    JRoundingMode=RoundingMode{
        jDown=\iDOWN,
        jUp=\iUP,
        jFloor=\iFLOOR,
        jCeiling=\iCEILING,
        jHalfDown=\iHALF_DOWN,
        jHalfUp=\iHALF_UP,
        jHalfEven=\iHALF_EVEN,
        jUnnecessary=\iUNNECESSARY
    }
}

ThreadLocal<Rounding?> defaultRounding = ThreadLocal<Rounding?>();

doc "Performs an arbitrary calcuation with the given rounding used implicity
     when arithmetic operators are applied to `Decimal` operands.

     During a call to this method the `Decimal` operators
     `+`, `-`, `*`, `/` and `**`
     (or equivalently, the `Decimal` methods
     `plus()`, `minus()`, `times()`, `divided()` and `power()`)
     will implicitly use the given rounding.
     The behaviour of all other `Decimal` methods are unchanged 
     during a call to this function.
     
     The implicit rounding will only take affect on the current thread.
     The `calculate()` function may itself call `implicitlyRounded()`
     to apply a different implicit rounding for a subcalculation."
see(implicitRounding)
shared Decimal implicitlyRounded(Decimal calculate(), Rounding rounding) {
    Rounding? prev = defaultRounding.get();
    try {
        defaultRounding.set(rounding);
        return calculate();
    } finally {
        defaultRounding.set(prev);
    }
}

doc "The rounding currently being used implicitly by 
     the `Decimal` operators
     `+`, `-`, `*`, `/` and `**`
     (or equivalently, the `Decimal` methods
     `plus()`, `minus()`, `times()`, `divided()` and `power()`).
"
see(implicitlyRounded)
shared Rounding? implicitRounding {
    return defaultRounding.get();
}

doc "A decimal floating point number. This class provides support for fixed
     and arbitrary precision numbers. Values are immuatable and 
     represented as `unscaled * 10**(-scale)`. Methods without an explicit 
     `Rounding` parameter use `unlimitedPrecision` (unless documented 
     otherwise) except for `plus()`, `minus()`, `times()`, `divided()` 
     and `power()` whose implicit rounding is subject to the rules of 
     `implicitlyRounded()`."
see(implicitlyRounded)
see(Rounding)
see(unlimitedPrecision)
shared interface Decimal
        of DecimalImpl
        satisfies //Castable<Decimal> &
                  Scalar<Decimal> & Exponentiable<Decimal,Decimal> {

    doc "The platform specific implementation object, if any.
         This is provided for the purposes of interoperation with the
         runtime platform."
    shared formal Object? implementation;

    doc "Determine whether two instances have equal value.
         `equals()` considers 1 and 1.0 to
         be the same, `strictlyEquals()` considers them to be the different."
    see(strictlyEquals)
    shared formal actual Boolean equals(Object that);

    doc "Determine whether two instances have equal value **and scale**.
         `strictlyEquals()` considers 1 and 1.0 to
         be different, `equals()` considers them to be the same."
    see(equals)
    shared formal Boolean strictlyEquals(Decimal that);

    doc "The hash value of this `Decimal`. Due to the definition of `equals()`
         trailing zeros do not contribute to the hash calculation so 1 and 1.0
         have the same hash."
    shared formal actual Integer hash;

    doc "The quotient obtained by dividing this Decimal by
         the given Decimal. Unless invoked within `implicitlyRounded()`
         the preferred scale of the result is the difference between this
         Decimal's scale and the given Decimal's scale; it may be larger
         if necessary; an exception is thrown if the result would have
         a nonterminating decimal representation."
    see(dividedRounded)
    see(dividedTruncated)
    see(implicitlyRounded)
    shared formal actual Decimal divided(Decimal other);

    doc "The quotient obtained by dividing this `Decimal` by
         the given `Decimal` with the given
         rounding."
    see(divided)
    see(dividedTruncated)
    shared formal Decimal dividedRounded(Decimal other, Rounding? rounding = null);

    doc "The product of this `Decimal` and the given `Decimal`.
         Unless invoked within `implicitlyRounded()` the scale of the result is
         the sum of the scale of the operands."
    see(timesRounded)
    see(implicitlyRounded)
    shared formal actual Decimal times(Decimal other);

    doc "The product of this `Decimal` and the given `Decimal` with the given
         rounding."
    see(times)
    shared formal Decimal timesRounded(Decimal other, Rounding? rounding = null);

    doc "The sum of this `Decimal` and the given `Decimal`.
         Unless invoked within `implicitlyRounded()` the scale of the result is
         the maximum of the scale of the operands."
    see(plusRounded)
    see(implicitlyRounded)
    shared formal actual Decimal plus(Decimal other);

    doc "The sum of this `Decimal` and the given `Decimal` with the given
         rounding."
    see(plus)
    shared formal Decimal plusRounded(Decimal other, Rounding? rounding = null);

    doc "The difference of this `Decimal` and the given `Decimal`.
         Unless invoked within `implicitlyRounded()` the scale of the result is
         the maximum of the scale of the operands."
    see(minusRounded)
    see(implicitlyRounded)
    shared formal actual Decimal minus(Decimal other);

    doc "The difference of this `Decimal` and the given `Decimal` with the given
         rounding."
    see(minus)
    shared formal Decimal minusRounded(Decimal other, Rounding? rounding = null);

    doc "The result of raising this number to the given
         power. Fractional powers are not supported.
         Unless invoked within `implicitlyRounded()` the
         result is computed to unlimited precision and negative powers are
         not supported."
    see(powerRounded)
    throws(Exception, "The exponent has a non-zero fractional part")
    throws(Exception, "The exponent is too large or too small")
    throws(Exception, "The exponent was negative when attempting to compute
                       a result to unlimited precision")
    shared formal actual Decimal power(Decimal other);

    doc "The result of raising this number to the given
         power with the given rounding. Fractional powers are not supported."
    see(power)
    shared formal Decimal powerRounded(Integer other, Rounding? rounding = null);

    doc "The integer part of the quotient obtained by dividing this `Decimal` by
         the given `Decimal` and truncating the result. The scale of the result is
         the difference of the scales of the operands."
    throws(Exception, "The integer part of the quotient requires more than the given precision.")
    throws(Exception, "The given divisor is zero")
    see(dividedTruncated)
    see(divided)
    shared formal Decimal dividedTruncated(Decimal other, Rounding? rounding = null);

    doc "The Decimal remainder after the division of this `Decimal` by the 
    given `Decimal`, 
    `this - (this.dividedTruncated(other, rounding) * other)`.
    This is not equivalent to the `%` operator 
    (`Decimal` does not satisfy `Integral`), and the result may be negative."
    throws(Exception, "The integer part of the quotient requires more than the given precision.")
    throws(Exception, "The given divisor is zero")
    shared formal Decimal remainderRounded(Decimal other, Rounding? rounding = null);

    doc "A two-element sequence containing the same results as 
         calling `dividedTruncated()` and `remainderRounded()` with the given 
         arguments, except the division is only performed once."
    throws(Exception, "The given divisor is zero")
    shared formal Decimal[] dividedAndRemainder(Decimal other, Rounding? rounding = null);
    
    doc "The precision of this decimal. This is the number of digits in the unscaled value."
    see(scale)
    shared formal Integer precision;

    doc "The scale of this decimal. This is the number of digits to the right the 
    decimal point (for a positive scale) or the power of ten by which the 
    unscaled value is multiplied (for a negative scale)."
    see(unscaled)
    see(precision)
    shared formal Integer scale;
    
    doc "The unscaled value of this `Decimal`."
    see(scale)
    shared formal Whole unscaled;

    doc "This value rounded according to the given context."
    shared formal Decimal round(Rounding rounding);

    doc "The number, represented as an `Whole`, after
         truncation of any fractional part."
    see(Whole)
    see(integer)
    shared formal Whole whole;

}

class DecimalImpl(BigDecimal num)
        extends Object()
        satisfies //Castable<Decimal> &
                  Decimal {

    shared actual BigDecimal implementation = num;

    shared actual Decimal dividedTruncated(Decimal other, Rounding? rounding) {
        if (is DecimalImpl other) {
            if (is RoundingImpl rounding) {
                return DecimalImpl(this.implementation.divideToIntegralValue(
                    other.implementation, rounding.implementation));
            } else if (!exists rounding) {
                return DecimalImpl(this.implementation.divideToIntegralValue(
                    other.implementation));
            }
        }
        throw;
    }
    
    shared actual Decimal remainderRounded(Decimal other, Rounding? rounding) {
        if (is DecimalImpl other) {
            if (is RoundingImpl rounding) {
                return DecimalImpl(this.implementation.remainder(
                    other.implementation, rounding.implementation));
            } else if (!exists rounding) {
                return DecimalImpl(this.implementation.remainder(
                    other.implementation));
            }
        }
        throw;
    }

    shared actual Decimal[] dividedAndRemainder(Decimal other, Rounding? rounding) {
        if (is DecimalImpl other) {
            Array<BigDecimal> array;
            if (is RoundingImpl rounding) {
                array = this.implementation.divideAndRemainder(
                    other.implementation, rounding.implementation);
            } else if (!exists rounding) {
                array = this.implementation.divideAndRemainder(
                    other.implementation);
            } else {
                throw;
            }
            return {DecimalImpl(array[0] ? bdzero), DecimalImpl(array[1] ? bdzero)};
        }
        throw;
    }

    doc "The precision of this decimal."
    shared actual Integer precision {
        return this.implementation.precision();
    }
    doc "The scale of this decimal."
    shared actual Integer scale {
        return this.implementation.scale();
    }
    doc "The unscaled value."
    shared actual Whole unscaled {
        return wrapBigInteger(this.implementation.unscaledValue());
    }
    doc "This value rounded according to the given context."
    shared actual Decimal round(Rounding rounding) {
        if (is RoundingImpl rounding) {
            return DecimalImpl(this.implementation.round(rounding.implementation));
        }
        throw;
    }
    shared actual Comparison compare(Decimal other) {
        if (is DecimalImpl other) {
            Integer cmp = this.implementation.compareTo(other.implementation);
            if (cmp < 0) {
                return smaller;
            } else if (cmp > 0) {
                return larger;
            }
            return equal;
        }
        throw;
    }
    shared actual Decimal divided(Decimal other) {
        if (is DecimalImpl other) {
            Rounding? rounding = defaultRounding.get();
            if (exists rounding) {
                return dividedRounded(other, rounding);
            }
            return DecimalImpl(this.implementation.divide(other.implementation));
        }
        throw;
    }
    shared actual Decimal dividedRounded(Decimal other, Rounding? rounding) {
         if (is DecimalImpl other) {
            if (is RoundingImpl rounding) {
                return DecimalImpl(this.implementation.divide(
                    other.implementation, rounding.implementation));
            } else if (!exists rounding) {
                return DecimalImpl(this.implementation.divide(
                    other.implementation));
            }
        }
        throw;
    }
    shared actual Boolean equals(Object that) {
        if (is DecimalImpl that) {
            return this.implementation === that.implementation
                || this.implementation.compareTo(that.implementation) == 0;
        }
        return false;
    }
    shared actual Boolean strictlyEquals(Decimal that) {
        if (is DecimalImpl that) {
              return this.implementation === that.implementation
                  || this.implementation.equals(that.implementation);
        }
        throw;
    }
    shared actual Float float {
        return implementation.doubleValue();
    }
    shared actual Integer hash {
        return implementation.stripTrailingZeros().hash;
    }
    shared actual Integer integer {
        return implementation.longValue();
    }
    shared actual Whole whole {
        return wrapBigInteger(implementation.toBigInteger());
    }
    shared actual Decimal magnitude {
        return DecimalImpl(this.implementation.round(
            MathContext(this.implementation.scale(), jDown)));
    }
    shared actual Decimal minus(Decimal other) {
        if (is DecimalImpl other) {
            Rounding? rounding = defaultRounding.get();
            if (exists rounding) {
                return minusRounded(other, rounding);
            }
            return DecimalImpl(this.implementation.subtract(other.implementation));
        }
        throw;
    }
    shared actual Decimal minusRounded(Decimal other, Rounding? rounding) {
         if (is DecimalImpl other) {
             if (is RoundingImpl rounding) {
                 return DecimalImpl(this.implementation.subtract(
                     other.implementation, rounding.implementation));
             } else if (!exists rounding) {
                 return DecimalImpl(this.implementation.subtract(
                     other.implementation));
             }
        }
        throw;
    }
    shared actual Decimal fractionalPart {
        return this.minus(this.magnitude);
    }
    shared actual Boolean negative {
        return implementation.signum() < 0;
    }
    shared actual Decimal negativeValue {
        return DecimalImpl(this.implementation.negate());
    }
    shared actual Decimal plus(Decimal other) {
        if (is DecimalImpl other) {
            Rounding? rounding = defaultRounding.get();
            if (exists rounding) {
                return plusRounded(other, rounding);
            }
            return DecimalImpl(this.implementation.add(other.implementation));
        }
        throw;
    }
    shared actual Decimal plusRounded(Decimal other, Rounding? rounding) {
        if (is DecimalImpl other) {
            if (is RoundingImpl rounding) {
                return DecimalImpl(this.implementation.add(
                    other.implementation, rounding.implementation));
            } else if (!exists rounding) {
                return DecimalImpl(this.implementation.add(
                    other.implementation));
            }
        }
        throw;
    }
    shared actual Boolean positive {
        return implementation.signum() > 0;
    }
    shared actual Decimal positiveValue {
        return this;
    }
    shared actual Decimal power(Decimal other) {
        if (other.fractionalPart != zero) {
            throw Exception("Fractional powers are not supported");
        } else if (other > intMax || other < intMin) {
            throw Exception("Exponent too large");
        }
        if (is DecimalImpl other) {
            Integer pow = other.implementation.longValue();
            Rounding? rounding = defaultRounding.get();
            if (exists rounding) {
                return powerRounded(pow, rounding);
            }
            if (other.sign < 0) {
                throw Exception("Negative powers are not supported with unlimited precision");
            }
            // TODO Special cases
            return DecimalImpl(this.implementation.pow(pow));
        }
        throw;
    }
    shared actual Decimal powerRounded(Integer other, Rounding? rounding) {
        if (is RoundingImpl rounding) {
            return DecimalImpl(this.implementation.pow(other, rounding.implementation));
        } else if (!exists rounding) {
            return DecimalImpl(this.implementation.pow(other));
        }
        throw;
    }
    shared actual Integer sign {
        return this.implementation.signum();
    }
    shared actual String string {
        return this.implementation.string;
    }
    shared actual Decimal times(Decimal other) {
        if (is DecimalImpl other) {
            Rounding? rounding = defaultRounding.get();
            if (exists rounding) {
                return timesRounded(other, rounding);
            }
            return DecimalImpl(this.implementation.multiply(other.implementation));
        }
        throw;
    }
    shared actual Decimal timesRounded(Decimal other, Rounding? rounding) {
        if (is DecimalImpl other) {
            if (is RoundingImpl rounding) {
                return DecimalImpl(this.implementation.multiply(
                    other.implementation, rounding.implementation));
            } else if (!exists rounding) {
                return DecimalImpl(this.implementation.multiply(
                    other.implementation));
            }
        }
        throw;
    }
    shared actual Decimal wholePart {
        return DecimalImpl(BigDecimal(this.implementation.toBigInteger()));
    }
    /*shared actual Decimal castTo<Decimal>() {
        // TODO What do I do here return this;
        throw;
    }*/
}


doc "The number `number` converted to a Decimal"
// TODO Document peculiarities of passing a Float or switch to using valueOf(double)
shared Decimal toDecimal(Whole|Integer|Float number, Rounding? rounding = null) {
    BigDecimal val;
    switch(number)
    case(is Whole) {
        if (is RoundingImpl rounding) {
            Object? bi = number.implementation;
            if (is BigInteger bi) {
                val = BigDecimal(bi).plus(rounding.implementation);
            } else {
                throw;
            }
        } else {
            Object? bi = number.implementation;
            if (is BigInteger bi) {
                val = BigDecimal(bi);
            } else {
                throw;
            }
        }
    }
    case(is Integer) {
        if (is RoundingImpl rounding) {
            val = BigDecimal(number, rounding.implementation);
        } else {
            val = BigDecimal(number);
        }
    }
    case(is Float) {
        if (is RoundingImpl rounding) {
            val = BigDecimal(number, rounding.implementation);
        } else {
            val = BigDecimal(number);
        }
    }
    return DecimalImpl(val);
}

doc "The Decimal repesented by the given string, or null if the given string
     does not represent a Decimal."
shared Decimal? parseDecimal(String str) {
    BigDecimal bd;
    try {
        bd = BigDecimal(str);
    } catch (NumberFormatException e) {
        return null;
    }
    return DecimalImpl(bd);
}