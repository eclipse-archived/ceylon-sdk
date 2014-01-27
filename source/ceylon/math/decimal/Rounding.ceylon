"A strategy for rounding the result of an operation
 on two `Decimal`s."
shared abstract class Mode() 
        of floor | ceiling | 
           halfUp | halfDown | halfEven | 
           down | up | unnecessary {}

"Round towards negative infinity."
shared object floor extends Mode() {}

"Round towards positive infinity."
shared object ceiling extends Mode() {}

"Round towards the nearest neighbour, or round up if 
 there are two nearest neighbours."
shared object halfUp extends Mode() {}

"Round towards the nearest neighbour, or round down if 
 there are two nearest neighbours."
shared object halfDown extends Mode() {}

"Round towards the nearest neighbour, or round towards 
 the even neighbour if there are two nearest neighbours."
shared object halfEven extends Mode() {}

"Round towards zero."
shared object down extends Mode() {}

"Round away from zero."
shared object up extends Mode() {}

"Asserts that rounding will not be required causing an 
 exception to be thrown if it is."
shared object unnecessary extends Mode() {}

"The rounding currently being used implicitly by the `Decimal` 
 operators `+`, `-`, `*`, `/` and `^` (or equivalently, the 
 methods `plus()`, `minus()`, `times()`, `divided()`, and 
 `power()`)."
see(`function implicitlyRounded`)
shared Rounding? implicitRounding => defaultRounding.get();

"Holds precision and rounding information for use in 
 decimal arithmetic. A precision of `0` means unlimited 
 precision."
throws(`class AssertionException`, 
        "if the given [[precision]] is negative.")
see(`interface Decimal`)
see(`function round`)
see(`value unlimitedPrecision`)
shared abstract class Rounding(precision, mode) 
        of RoundingImpl {
    "Precision cannot be negative"
    assert (precision >= 0);
    
    "The precision to apply when rounding."
    shared Integer precision;
    
    "The kind of rounding to apply."
    shared Mode mode;
    
    shared actual String string {
        if (precision == 0) {
            return "unlimited";
        }
        return "`` precision `` `` mode ``";
    }
    
    shared formal Object? implementation;
}

"Creates a rounding with the given precision and mode."
shared Rounding round(Integer precision, Mode mode) {
    return RoundingImpl(precision, mode);
}

"Unlimited precision."
shared Rounding unlimitedPrecision = RoundingImpl(0, halfUp);

