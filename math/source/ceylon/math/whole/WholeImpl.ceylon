import java.math { BigInteger { jzero=ZERO, jone=ONE } }

class WholeImpl(BigInteger num)
        satisfies Whole { //& Castable<Whole|Decimal>

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

    shared actual WholeImpl positiveValue {
        return this;
    }

    shared actual WholeImpl negativeValue {
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
        }
        return false;
    }

    shared actual Comparison compare(Whole other) {
        if (is WholeImpl other) {
            Integer cmp = implementation
                    .compareTo(other.implementation);
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
            return WholeImpl(implementation
                    .add(other.implementation));
        }
        throw;
    }

    shared actual WholeImpl minus(Whole other) {
        if (is WholeImpl other) {
            return WholeImpl(implementation
                    .subtract(other.implementation));
        }
        throw;
    }

    shared actual WholeImpl times(Whole other) {
        if (is WholeImpl other) {
            return WholeImpl(implementation
                    .multiply(other.implementation));
        }
        throw;
    }

    shared actual WholeImpl divided(Whole other) {
        if (is WholeImpl other) {
            return WholeImpl(implementation
                    .divide(other.implementation));
        }
        throw;
    }

    shared actual WholeImpl remainder(Whole other) {
        if (is WholeImpl other) {
            return WholeImpl(implementation
                    .remainder(other.implementation));
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
                throw Exception("Unsupported power " this 
                        "**" other "");
            } else if (other == 0) {
                return oneImpl;
            } else if (other > maxIntImpl) {
                throw Exception("Unsupported power " this 
                        "**" other "");
            }
            return WholeImpl(implementation
                    .pow(other.implementation.intValue()));
        }
        throw;
    }

    shared actual Whole powerRemainder(Whole exponent, 
                                       Whole modulus) {
        if (is WholeImpl exponent) {
            if (is WholeImpl modulus) {
                return WholeImpl(implementation
                        .modPow(exponent.implementation, 
                                modulus.implementation));
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