/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Performs an arbitrary calculation with the given rounding used 
 implicitly when arithmetic operators are applied to `Decimal` 
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