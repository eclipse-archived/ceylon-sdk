import java.lang{NumberFormatException}
import java.math{
    BigDecimal {
        bdone=\iONE, bdzero=\iZERO, bdten=\iTEN
    }
}

doc "A decimal floating point number. This class provides support for fixed 
     and arbitrary precision numbers."
shared class Decimal(BigDecimal|Integer|Float num, Rounding? rounding = null)
        extends Object()
        satisfies //Castable<Decimal> &
                  Numeric<Decimal> {

    BigDecimal val;
    switch(num)
    case(is BigDecimal) {
        if (exists rounding) {
            val = num.plus(rounding.jContext);
        } else {
            val = num;
        }
    }
    case(is Integer) {
        if (exists rounding) {
            val = BigDecimal(num, rounding.jContext);
        } else {
            val = BigDecimal(num);
        }    
    }
    case(is Float) {
        if (exists rounding) {
            val = BigDecimal(num, rounding.jContext);
        } else {
            val = BigDecimal(num);
    }
    }
	
    // operators with context
    shared Decimal dividedWithRounding(Decimal other, Rounding context) { throw; }
    shared Decimal timesWithRounding(Decimal other, Rounding context) { throw; }
    shared Decimal plusWithRounding(Decimal other, Rounding context) { throw; }
    shared Decimal minusWithRounding(Decimal other, Rounding context) { throw; }
    shared Decimal powerWithRounding(Integer other, Rounding context) { throw; }
    
    //shared Whole dividedToWholeWithRounding(Decimal other, Rounding context) { throw; }
    shared Decimal remainderWithRounding(Decimal other, Rounding context) { throw; }
	
    doc "The precision of this decimal."
    shared Integer precision {
        return this.val.precision(); 
    }
    doc "The scale of this decimal."
	shared Integer scale {
		return this.val.scale(); 
	}
	doc "This value rounded according to the given context."
	shared Decimal round(Rounding context) {
		return Decimal(this.val.round(context.jContext));
	}	
	shared actual Comparison compare(Decimal other) {
		Integer cmp = this.val.compareTo(other.val);
		if (cmp < 0) {
			return smaller;
		} else if (cmp > 0) {
		    return larger;
	    }
	    return equal;
	}
	shared actual Decimal divided(Decimal other) {
		return Decimal(this.val.divide(other.val));
	}
    doc "Determine whether two instances have equal value. 
         `equals()` considers 1 and 1.0 to 
         be the same, `strictlyEquals()` considers them to be the different."
	see(strictlyEquals)
	shared actual Boolean equals(Object that) {
		if (is Decimal that) {
		    return this.val === that.val || this.val.compareTo(that.val) == 0;
	    }
	    return false;
	}
	doc "Determine whether two instances have equal value **and scale**. 
	     `strictlyEquals()` considers 1 and 1.0 to 
	     be different, `equals()` considers them to be the same."
	see(equals)
	shared Boolean strictlyEquals(Decimal that) {
		return this.val === that.val || this.val.equals(that.val);
    }
	shared actual Float float {
		return val.doubleValue();
	}
	shared actual Integer hash {
		return val.hash;
	}
	shared actual Integer integer {
		return val.longValue();
	}
	shared actual Decimal magnitude {
		return Decimal(this.val.round(Rounding(this.val.scale(), down).jContext));
	}
	shared actual Decimal minus(Decimal other) {
		return Decimal(this.val.subtract(other.val));
	}
    shared actual Decimal fractionalPart {
        return this.minus(this.magnitude);
    }
	shared actual Boolean negative {
		return val.signum() < 0;
	}
	shared actual Decimal negativeValue {
		return Decimal(this.val.negate());
	}
	shared actual Decimal plus(Decimal other) {
		return Decimal(this.val.add(other.val));
	}
	shared actual Boolean positive {
		return val.signum() > 0;
	}
	shared actual Decimal positiveValue {
		return this;
	}
	shared actual Decimal power(Decimal other) {
		// TODO What if converting other to an int looses information?
		Integer pow = other.val.longValue();
		return Decimal(this.val.pow(pow));
	}
	shared actual Integer sign {
		return this.val.signum();
	}
	shared actual String string {
		return this.val.string;
	}
	shared actual Decimal times(Decimal other) {
		return Decimal(this.val.multiply(other.val));
	}
	shared actual Decimal wholePart {
		return Decimal(BigDecimal(this.val.toBigInteger()));
	}
    /*shared actual Decimal castTo<Decimal>() {
        // TODO What do I do here return this;
        throw;
    }*/
}

doc "A Decimal instance representing zero."
shared Decimal zero = Decimal(bdzero);

doc "A Decimal instance representing one."
shared Decimal one = Decimal(bdone);

doc "A Decimal instance representing ten."
shared Decimal ten = Decimal(bdten);

doc "The Decimal repesented by the given string, or null if the given string
     does not represent a Decimal."
shared Decimal? parseDecimal(String str) {
    BigDecimal bd;
    try {
        bd = BigDecimal(str);
    } catch (NumberFormatException e) {
        return null;
    }
    return Decimal(bd);
}