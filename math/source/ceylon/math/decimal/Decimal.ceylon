import ceylon.math.whole{Whole}
import java.lang{NumberFormatException}
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

doc "A decimal floating point number. This class provides support for fixed 
     and arbitrary precision numbers."
shared interface Decimal
        of DecimalImpl
        //extends Object()
        satisfies //Castable<Decimal> &
                  Numeric<Decimal> {
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
    
    // operators with context
    shared formal Decimal dividedWithRounding(Decimal other, Rounding rounding);
    shared formal Decimal timesWithRounding(Decimal other, Rounding rounding);
    shared formal Decimal plusWithRounding(Decimal other, Rounding rounding);
    shared formal Decimal minusWithRounding(Decimal other, Rounding rounding);
    shared formal Decimal powerWithRounding(Integer other, Rounding rounding);
    
    //shared formal Whole dividedToWholeWithRounding(Decimal other, Rounding context);
    shared formal Decimal remainderWithRounding(Decimal other, Rounding rounding);
    
    doc "The precision of this decimal."
    shared formal Integer precision;
    doc "The scale of this decimal."
    shared formal Integer scale;
    doc "This value rounded according to the given context."
    shared formal Decimal round(Rounding rounding);
}

MathContext mc(Integer precision, Mode mode) {
    JRoundingMode jmode;
    switch(mode) 
    case (floor) {jmode = jFloor;}
    case (ceiling) {jmode = jCeiling;}
    case (up) {jmode = jUp;}
    case (down) {jmode = jDown;}
    case (halfUp) {jmode = jHalfUp;}
    case (halfDown) {jmode = jHalfDown;}
    case (halfEven) {jmode = jHalfEven;}
    case (unnecessary) {jmode = jUnnecessary;}
    
    return MathContext(precision, jmode);
}

class DecimalImpl(BigDecimal num)
        extends Object()
        satisfies //Castable<Decimal> &
                  Decimal {

    shared actual BigDecimal implementation = num;
	
    // operators with context
    shared actual Decimal dividedWithRounding(Decimal other, Rounding rounding) { throw; }
    shared actual Decimal timesWithRounding(Decimal other, Rounding rounding) { throw; }
    shared actual Decimal plusWithRounding(Decimal other, Rounding rounding) { throw; }
    shared actual Decimal minusWithRounding(Decimal other, Rounding rounding) { throw; }
    shared actual Decimal powerWithRounding(Integer other, Rounding rounding) { throw; }
    
    //shared Whole dividedToWholeWithRounding(Decimal other, Rounding context) { throw; }
    shared actual Decimal remainderWithRounding(Decimal other, Rounding rounding) { throw; }
	
    doc "The precision of this decimal."
    shared actual Integer precision {
        return this.implementation.precision(); 
    }
    doc "The scale of this decimal."
	shared actual Integer scale {
		return this.implementation.scale(); 
	}
	doc "This value rounded according to the given context."
	shared actual Decimal round(Rounding rounding) {
        return DecimalImpl(this.implementation.round(mc(rounding.precision, rounding.mode)));    
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
		    return DecimalImpl(this.implementation.divide(other.implementation));
	    }
	    throw;
	}
    shared actual Boolean equals(Object that) {
		if (is DecimalImpl that) {
		    return this.implementation === that.implementation || this.implementation.compareTo(that.implementation) == 0;
	    }
	    return false;
	}
	shared actual Boolean strictlyEquals(Decimal that) {
		if (is DecimalImpl that) {
		      return this.implementation === that.implementation || this.implementation.equals(that.implementation);
		}
		throw;
    }
	shared actual Float float {
		return implementation.doubleValue();
	}
	shared actual Integer hash {
		return implementation.hash;
	}
	shared actual Integer integer {
		return implementation.longValue();
	}
	shared actual Decimal magnitude {
		return DecimalImpl(this.implementation.round(MathContext(this.implementation.scale(), jDown)));
	}
	shared actual Decimal minus(Decimal other) {
        if (is DecimalImpl other) {
            return DecimalImpl(this.implementation.subtract(other.implementation));
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
            return DecimalImpl(this.implementation.add(other.implementation));
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
        if (is DecimalImpl other) {
            // TODO What if converting other to an int looses information?
            Integer pow = other.implementation.longValue();
            return DecimalImpl(this.implementation.pow(pow));
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
            return DecimalImpl(this.implementation.multiply(other.implementation));
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
        if (exists rounding) {
            Object? bi = number.implementation;
            if (is BigInteger bi) {
                val = BigDecimal(bi).plus(mc(rounding.precision, rounding.mode));
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
        if (exists rounding) {
            val = BigDecimal(number, mc(rounding.precision, rounding.mode));
        } else {
            val = BigDecimal(number);
        }    
    }
    case(is Float) {
        if (exists rounding) {
            val = BigDecimal(number, mc(rounding.precision, rounding.mode));
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