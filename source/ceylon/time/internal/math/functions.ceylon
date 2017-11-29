/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Returns the largest integer less than or equal to _x_."
shared Integer floor( Float x ) {
    if (x.fractionalPart != 0.0 && x.negative){
        return x.integer - 1;
    }
    value i = x.integer;
    return i;
}

"Returns floored division of the two integers."
shared Integer floorDiv(Integer x, Integer y)
    => floor(x.float / y.float);

"Returns nearest integer to x"
shared Integer round( Float f ) => floor( f + 0.5);

"Returns the floor remainder (modulus) of the two integers.
 
     value moduli = [for (x in 4..-4) mod(x, 4)] 
     assert( moduli == [0, 3, 2, 1, 0, 3, 2, 1, 0] );
 "
shared Integer floorMod(Integer x, Integer y) {
    Float fx = x.float;
    Float fy = y.float;
    return (fx - fy * floor(fx / fy)).integer;
}

"Returns an _adjusted remainder_ of the two integers.
 
    value moduli = [for (x in 4..-4) amod(x, 4)];
    assert( moduli == [4, 3, 2, 1, 4, 3, 2, 1, 4] );
 "
shared Integer adjustedMod(Integer x, Integer y){
    value amod = floorMod(x, y);
    if (amod == 0) {
        return y;
    }
    return amod;
}
