import java.lang{NumberFormatException}
import java.math{
    BigInteger{
        fromLong=valueOf, 
        bizero=\iZERO, 
        bione=\iONE},
    BigDecimal
}
import ceylon.math.decimal{Decimal}

doc "An arbitrary precision integer"
shared class Whole(Integer|BigInteger num)
        extends IdentifiableObject()
        satisfies //Castable<Whole|Decimal> &
                  Integral<Whole> {
    BigInteger val;
    switch(num)
    case(is Integer) {
        val = fromLong(num);
    }
    case(is BigInteger) {
	    val = num;
    }
    
    shared actual String string {
        return val.string;
    }
         
    shared actual Whole successor {
        return Whole(this.val.add(bione));
    }
    
    shared actual Whole predecessor {
        return Whole(this.val.subtract(bione));
    }
    
    shared actual Whole positiveValue {
        return this;
    }
    
    shared actual Whole negativeValue {
        throw;
    }
    
    shared actual Boolean positive {
        return this.val.signum() > 0;
    }
    
    shared actual Boolean negative {
        return this.val.signum() < 0;
    }
    
    shared actual Boolean zero {
        return val === bizero || val.equals(bizero);
    }
    
    shared actual Boolean unit {
        return val === bione || val.equals(bione);
    }
    
    shared actual Float float {
        return this.val.doubleValue();
    }
    
    shared actual Integer integer {
        return this.val.longValue();
    }
    
    shared actual Whole magnitude { 
        if (this.val.signum() < 0) {
            return Whole(this.val.negate());
        } else {
            return this;
        }
    }
    
    shared actual Whole wholePart { 
        return this;
    }
    
    shared actual Whole fractionalPart { 
        return Whole(bizero); // TODO Preallocate zero
    }
    
    shared actual Integer sign { 
        return this.val.signum();
    }
    
    shared actual Integer hash {
        return this.val.hash;
    }
    
    shared actual Boolean equals(Object other) {
        if (is Whole other) {
            return this.val.equals(other.val);
        }
        return false;
    }
    
    shared actual Comparison compare(Whole other) { 
        Integer cmp = this.val.compareTo(other.val);
        if (cmp > 0) {
            return larger;
        } else if (cmp < 0) {
            return smaller;
        } else {
            return equal;
        }
    }
    
    shared actual Whole plus(Whole other) {
        return Whole(this.val.add(other.val));
    }
    
    shared actual Whole minus(Whole other) {
        return Whole(this.val.subtract(other.val));
    }
    
    shared actual Whole times(Whole other) {
        return Whole(this.val.multiply(other.val));
    }
    
    shared actual Whole divided(Whole other) {
        return Whole(this.val.divide(other.val));
    }
    
    shared actual Whole remainder(Whole other) {
        return Whole(this.val.remainder(other.val));
    }
    
    shared actual Whole power(Whole other) {
        if (other.sign == -1) {
    		throw;
    	}
    	// TODO Worry about other > Integer.MAX_VALUE
        return Whole(this.val.pow(other.val.intValue()));
    }
    /*shared actual CastValue castTo<CastValue>() {
        // TODO what do I do here?
        return bottom;
        //return this;
        //return Decimal(BigDecimal(this.val));
    }*/
    
}

doc "A Whole instance representing zero."
shared Whole zero = Whole(bizero);

doc "A Whole instance representing one."
shared Whole one = Whole(bione);

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
    return Whole(bi);
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