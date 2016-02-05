import ceylon.whole {
    Whole
}

import java.math {
    BigDecimal
}

"The given [[number]] converted to a [[Decimal]]."
// TODO: Document peculiarities of passing a Float or switch
//       to using valueOf(double)
shared Decimal decimalNumber(Whole|Integer|Float number,
                             Rounding? rounding = null) {
    BigDecimal val;
    switch(number)
    case(is Whole) {
        if (is RoundingImpl rounding) {
            value bi = toBigInteger(number);
            val = BigDecimal(bi).plus(rounding.implementation);
        } else {
            value bi = toBigInteger(number);
            val = BigDecimal(bi);
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
