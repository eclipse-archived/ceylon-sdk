"Decimal floating point arithmetic. The focus of this module 
 is the [[Decimal]] type which performs computations using 
 decimal floating point arithmetic. An of `Decimal` may be 
 obtained by calling [[decimalNumber]] or [[parseDecimal]].
 
 A [[Rounding]] is used to specify how results of calculations 
 should be rounded, and an instance may be obtained by 
 calling [[round]]. The [[implicitRounding]] function may
 be used to associate a [[Rounding]] with a computation, 
 performing the whole computation with an implicit rounding
 strategy."
native("jvm")
module ceylon.decimal maven:"org.ceylon-lang" "1.3.2" {
    shared import ceylon.whole "1.3.2";
    import java.base "7";
}
