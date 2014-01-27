"Performs an arbitrary calcuation with the given rounding used 
 implicity when arithmetic operators are applied to `Decimal` 
 operands.
 
 During a call to this method the `Decimal` operators
 `+`, `-`, `*`, `/` and `^` (or equivalently, the methods 
 `plus()`, `minus()`, `times()`, `divided()`, and `power()`)
 will implicitly use the given rounding. The behaviour of all 
 other `Decimal` methods are unchanged during a call to this 
 function.
 
 The implicit rounding will only take effect on the current 
 thread. The `calculate()` function may itself call 
 `implicitlyRounded()` to apply a different implicit rounding 
 for a sub-calculation."
see(`value implicitRounding`)
shared Decimal implicitlyRounded(Decimal calculate(), Rounding rounding) {
    Rounding? prev = defaultRounding.get();
    try {
        defaultRounding.set(rounding);
        return calculate();
    } finally {
        defaultRounding.set(prev);
    }
}