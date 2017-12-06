/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.math {
    BigInteger {
        jzero=ZERO,
        jone=ONE
    }
}

final class WholeImpl(BigInteger num)
        satisfies Whole {

    shared actual BigInteger implementation = num;

    shared actual String string {
        return implementation.string;
    }

    shared actual WholeImpl successor {
        return WholeImpl(implementation.add(jone));
    }

    shared actual WholeImpl predecessor {
        return WholeImpl(implementation.subtract(jone));
    }

    shared actual WholeImpl negated {
        return WholeImpl(implementation.negate());
    }

    shared actual Boolean positive {
        return implementation.signum() > 0;
    }

    shared actual Boolean negative {
        return implementation.signum() < 0;
    }

    shared actual Boolean zero {
        return implementation === jzero || 
                implementation.equals(jzero);
    }

    shared actual Boolean unit {
        return implementation === jone || 
                implementation.equals(jone);
    }

    shared actual Float float {
        return implementation.doubleValue();
    }

    shared actual Integer integer {
        return implementation.longValue();
    }

    shared actual WholeImpl magnitude {
        if (implementation.signum() < 0) {
            return WholeImpl(implementation.negate());
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
        return implementation.signum();
    }

    shared actual Integer hash {
        return implementation.hash;
    }

    shared actual Boolean equals(Object other) {
        if (is WholeImpl other) {
            return implementation.equals(other.implementation);
        } else {
            return false;
        }
    }

    shared actual Comparison compare(Whole other) {
        assert (is WholeImpl other);
        Integer cmp = implementation
                .compareTo(other.implementation)
                .sign;
        switch (cmp)
        case (1) {
            return larger;
        } case (-1) {
            return smaller;
        } else {
            return equal;
        }
    }

    shared actual WholeImpl plus(Whole other) {
        assert (is WholeImpl other);
        return WholeImpl(implementation
                .add(other.implementation));
    }

    shared actual WholeImpl minus(Whole other) {
        assert (is WholeImpl other);
        return WholeImpl(implementation
                .subtract(other.implementation));
    }

    shared actual WholeImpl times(Whole other) {
        assert (is WholeImpl other);
        return WholeImpl(implementation
                .multiply(other.implementation));
    }

    shared actual WholeImpl divided(Whole other) {
        assert (is WholeImpl other);
        return WholeImpl(implementation
                .divide(other.implementation));
    }

    shared actual WholeImpl remainder(Whole other) {
        assert (is WholeImpl other);
        return WholeImpl(implementation
                .remainder(other.implementation));
    }

    shared actual [WholeImpl, WholeImpl]
            quotientAndRemainder(Whole other) {
        assert (is WholeImpl other);
        value result = implementation
                .divideAndRemainder(other.implementation);
        return [WholeImpl(result.get(0)),
                WholeImpl(result.get(1))];
    }

    shared actual WholeImpl modulo(Whole other) {
        assert (is WholeImpl other);
        return WholeImpl(implementation
                .mod(other.implementation));
    }

    shared actual Whole power(Whole other) {
        assert (is WholeImpl other);
        if (this == -oneImpl) {
            if (other % two == zeroImpl) {
                return oneImpl;
            } else {
                return -oneImpl;
            }
        } else if (this == oneImpl) {
            return oneImpl;
        }
        if (other.zero) {
            return oneImpl;
        }
        "exponent must be non-negative"
        assert (!other.negative);
        "exponent too large"
        assert (other <= intMax);
        return WholeImpl(implementation
                .pow(other.implementation.intValue()));
    }

    shared actual Whole moduloPower(Whole exponent,
                                 Whole modulus) {
        assert (is WholeImpl exponent, is WholeImpl modulus);
        return WholeImpl(implementation
                .modPow(exponent.implementation, 
                        modulus.implementation));
    }
    
    shared actual Whole plusInteger(Integer integer) {
        return WholeImpl(implementation.add(BigInteger.valueOf(integer)));
    }
    
    shared actual Whole timesInteger(Integer integer) {
        return WholeImpl(implementation.multiply(BigInteger.valueOf(integer)));
    }
    
    shared actual Whole powerOfInteger(Integer integer) {
        "exponent must be non-negative"
        assert (integer>=0);
        return WholeImpl(implementation.pow(integer));
    }
    
    shared actual Whole neighbour(Integer offset) {
        return plusInteger(offset);
    }
    
    shared actual Integer offset(Whole other) {
        Whole diff = this.minus(other);
        if (longMin <= diff <= longMax) {
            return diff.integer;
        }
        throw OverflowException();
    }
    
}
