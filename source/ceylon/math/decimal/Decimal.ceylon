/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.math.whole {
    Whole
}

shared class DividedWithRemainder(divided, remainder) {
    shared Decimal divided;
    shared Decimal remainder;
    shared [Decimal,Decimal] pair => [divided,remainder];
}

"A decimal floating point number. This class provides support 
 for fixed and arbitrary precision numbers. Values are immutable 
 and represented as `unscaled * 10^(-scale)`. Methods without 
 an explicit [[Rounding]] parameter use [[unlimitedPrecision]] 
 (unless documented otherwise) except for `plus()`, `minus()`, 
 `times()`, `divided()` and `power()` whose implicit rounding 
 is subject to the rounding specified in [[implicitlyRounded]]."
see(`function implicitlyRounded`)
see(`class Rounding`)
see(`value unlimitedPrecision`)
shared interface Decimal
        of DecimalImpl
        satisfies Number<Decimal> & 
                  Exponentiable<Decimal,Integer> {

    "The platform-specific implementation object, if any. This 
     is provided for interoperation with the runtime platform."
    shared formal Object? implementation;

    "Determine whether two instances have equal value.`equals()` 
     considers `1` and `1.0` to be the same, `strictlyEquals()` 
     considers them to be different."
    see(`function strictlyEquals`)
    shared formal actual Boolean equals(Object that);

    "Determine whether two instances have equal value _and 
     scale_. `strictlyEquals()` considers `1` and `1.0` to
     be different, `equals()` considers them to be the same."
    see(`function equals`)
    shared formal Boolean strictlyEquals(Decimal that);

    "The hash value of this `Decimal`. Due to the definition 
     of `equals()` trailing zeros do not contribute to the 
     hash calculation so `1` and `1.0` have the same `hash."
    shared formal actual Integer hash;

    "The quotient obtained by dividing this `Decimal` by the 
     given `Decimal`. Unless invoked within `implicitlyRounded()`
     the preferred scale of the result is the difference between 
     this `Decimal`'s scale and the given `Decimal`'s scale; it 
     may be larger if necessary; an exception is thrown if the 
     result would have a nonterminating decimal representation."
    see(`function dividedRounded`)
    see(`function dividedTruncated`)
    see(`function implicitlyRounded`)
    shared formal actual Decimal divided(Decimal other);

    "The quotient obtained by dividing this `Decimal` by the given 
     `Decimal` with the given rounding."
    see(`function divided`)
    see(`function dividedTruncated`)
    shared formal Decimal dividedRounded(Decimal other, 
                                         Rounding? rounding = null);

    "The product of this `Decimal` and the given `Decimal`. Unless 
     invoked within `implicitlyRounded()` the scale of the result 
     is the sum of the scales of the operands."
    see(`function timesRounded`)
    see(`function implicitlyRounded`)
    shared formal actual Decimal times(Decimal other);

    "The product of this `Decimal` and the given `Decimal` with 
     the given rounding."
    see(`function times`)
    shared formal Decimal timesRounded(Decimal other, 
                                       Rounding? rounding = null);

    "The sum of this `Decimal` and the given `Decimal`. Unless 
     invoked within `implicitlyRounded()` the scale of the result 
     is the greater of the scales of the operands."
    see(`function plusRounded`)
    see(`function implicitlyRounded`)
    shared formal actual Decimal plus(Decimal other);

    "The sum of this `Decimal` and the given `Decimal` with the 
     given rounding."
    see(`function plus`)
    shared formal Decimal plusRounded(Decimal other, 
                                      Rounding? rounding = null);

    "The difference between this `Decimal` and the given `Decimal`.
     Unless invoked within `implicitlyRounded()` the scale of the 
     result is the greater of the scales of the operands."
    see(`function minusRounded`)
    see(`function implicitlyRounded`)
    shared formal actual Decimal minus(Decimal other);

    "The difference between this `Decimal` and the given `Decimal` 
     with the given rounding."
    see(`function minus`)
    shared formal Decimal minusRounded(Decimal other, 
                                       Rounding? rounding = null);

    "The result of raising this number to the given power. 
     Unless invoked within 
     `implicitlyRounded()` the result is computed to unlimited 
     precision and negative powers are not supported."
    see(`function powerRounded`)
    throws(`class Exception`, "The exponent has a non-zero fractional part")
    throws(`class Exception`, "The exponent is too large or too small")
    throws(`class Exception`, "The exponent was negative when attempting to 
                               compute a result to unlimited precision")
    shared formal actual Decimal power(Integer other);

    "The result of raising this number to the given power with 
     the given rounding. Fractional powers are not supported."
    see(`function power`)
    shared formal Decimal powerRounded(Integer other, 
                                       Rounding? rounding = null);

    "The integer part of the quotient obtained by dividing this 
     `Decimal` by the given `Decimal` and truncating the result. 
     The scale of the result is the difference of the scales of 
     the operands."
    throws(`class Exception`, "The integer part of the quotient requires 
                               more than the given precision.")
    throws(`class Exception`, "The given divisor is zero")
    see(`function dividedTruncated`)
    see(`function divided`)
    shared formal Decimal dividedTruncated(Decimal other, 
                                           Rounding? rounding = null);

    "The Decimal remainder after the division of this `Decimal` 
     by the given `Decimal`, that is:
     
         `this - this.dividedTruncated(other, rounding) * other
     
      This is not equivalent to the `%` operator (`Decimal` does 
      not satisfy `Integral`), and the result may be negative."
    throws(`class Exception`, "The integer part of the quotient requires more 
                               than the given precision.")
    throws(`class Exception`, "The given divisor is zero")
    shared formal Decimal remainderRounded(Decimal other, 
                                           Rounding? rounding = null);

    "A pair containing the same results as calling 
     `dividedTruncated()` and `remainderRounded()` with the given 
     arguments, except the division is only performed once."
    throws(`class Exception`, "The given divisor is zero")
    see(`function dividedTruncated`, `function remainderRounded`)
    shared formal DividedWithRemainder dividedAndRemainder(Decimal other, 
                                                           Rounding? rounding = null);
    
    "The precision of this decimal. This is the number of digits 
     in the unscaled value."
    see(`value scale`)
    shared formal Integer precision;

    "The scale of this decimal. This is the number of digits to 
     the right of the decimal point (for a positive scale) or 
     the power of ten by which the unscaled value is multiplied 
     (for a negative scale)."
    see(`value unscaled`)
    see(`value precision`)
    shared formal Integer scale;
    
    "The unscaled value of this `Decimal`."
    see(`value scale`)
    shared formal Whole unscaled;

    "This value rounded according to the given context."
    shared formal Decimal round(Rounding rounding);

    "The number, represented as a `Whole`, after truncation of 
     any fractional part."
    see(`interface Whole`)
    see(`value integer`)
    shared formal Whole whole;
    
    "The number, represented as an [[Integer]]. If the number is too 
     big to fit in an Integer then an Integer corresponding to the
     lower order bits is returned."
    shared formal Integer integer;
    
    "The number, represented as a [[Float]]. If the magnitude of this number 
     is too large the result will be `infinity` or `-infinity`. If the result
     is finite, precision may still be lost."
    shared formal Float float;

}

