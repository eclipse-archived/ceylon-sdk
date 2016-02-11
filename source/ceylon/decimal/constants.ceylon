import java.lang {
    JInteger=Integer {
        maxInt=MAX_VALUE,
        minInt=MIN_VALUE
    }
}
import java.math {
    BigDecimal
}

"A `Decimal` instance representing zero."
shared Decimal zero = DecimalImpl(BigDecimal.\iZERO);

"A `Decimal` instance representing one."
shared Decimal one = DecimalImpl(BigDecimal.\iONE);

"A `Decimal` instance representing ten."
shared Decimal ten = DecimalImpl(BigDecimal.\iTEN);

Decimal intMax = decimalNumber(maxInt);
Decimal intMin = decimalNumber(minInt);
