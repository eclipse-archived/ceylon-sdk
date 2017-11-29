/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Decimal floating point arithmetic. The focus of this package 
 is the [[Decimal]] type which performs computations using 
 decimal floating point arithmetic. An of `Decimal` may be 
 obtained by calling [[decimalNumber]] or [[parseDecimal]].
 
 A [[Rounding]] is used to specify how results of calculations 
 should be rounded, and an instance may be obtained by 
 calling [[round]]. The [[implicitRounding]] function may
 be used to associate a [[Rounding]] with a computation, 
 performing the whole computation with an implicit rounding
 strategy."
shared package ceylon.math.decimal;
