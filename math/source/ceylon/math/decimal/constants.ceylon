import java.math{
    BigDecimal {
        bdone=\iONE, bdzero=\iZERO, bdten=\iTEN
    }
}

doc "A Decimal instance representing zero."
shared Decimal zero = DecimalImpl(bdzero);

doc "A Decimal instance representing one."
shared Decimal one = DecimalImpl(bdone);

doc "A Decimal instance representing ten."
shared Decimal ten = DecimalImpl(bdten);