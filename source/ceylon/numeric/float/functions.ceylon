/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.lang {
    JVMMath=Math
}

"\{#0001D452} raised to the power of the argument.

 * `exp(-infinity)` is `+0`,
 * `exp(+infinity)` is `+infinity`,
 * `exp(undefined)` is `undefined`.
 "
see (`function expm1`)
shared native
Float exp(Float num);

shared native("jvm")
Float exp(Float num)
    =>  JVMMath.exp(num);

shared native("js")
Float exp(Float num) {
    dynamic {
        return Math.exp(num);
    }
}

"A more accurate computation of `exp(x)-1.0` for `x` near
 zero."
native shared Float expm1(Float num);

native("jvm") shared Float expm1(Float num)
    =>  JVMMath.expm1(num);

native("js") shared Float expm1(Float num)
    =>  exp(num) - 1.0;

"The natural logarithm (base \{#0001D452}) of the
 argument.

 * `log(x)` for any x < 0 is `undefined`,
 * `log(+0)` and `log(-0)` is `-infinity`,
 * `log(+infinity)` is `+infinity`,
 * `log(undefined)` is `undefined`.
 "
see(`function log10`, `function log1p`)
shared native
Float log(Float num);

shared native("jvm")
Float log(Float num)
    =>  JVMMath.log(num);

shared native("js")
Float log(Float num) {
    dynamic {
        return Math.log(num);
    }
}

"A more accurate computation of `log(1.0+x)` for `x` near
 zero."
native shared
Float log1p(Float num);

native("jvm") shared
Float log1p(Float num)
    =>  JVMMath.log1p(num);

native("js") shared
Float log1p(Float num)
    =>  log(num + 1.0);

"The base 10 logarithm of the argument.

 * `log10(x)` for any x < 0 is `undefined`,
 * `log10(-0)` and `log10(+0)` is `-infinity`,
 * `log10(+infinity)` is `+infinity`,
 * `log10(undefined)` is `undefined`.
 "
see(`function log`)
shared native
Float log10(Float num);

shared native("jvm")
Float log10(Float num)
    =>  JVMMath.log10(num);

shared native("js")
Float log10(Float num) {
    dynamic {
        Float n = Math.log(num);
        Float d = Math.\iLN10;
        return n / d;
    }
}

"The given angle (in radians) converted to degrees."
shared see(`function toRadians`)
Float toDegrees(Float num)
    =>  num/pi*180;

"The given angle (in degrees) converted to radians."
shared see(`function toDegrees`)
Float toRadians(Float num)
    => num/180*pi;

"The sine of the given angle specified in radians.

 * `sin(-0)` is `-0`,
 * `sin(+0)` is `+0`,
 * `sin(-infinity)` is `undefined`,
 * `sin(+infinity)` is `undefined`,
 * `sin(undefined)` is `undefined`.
 "
shared native
Float sin(Float num);

shared native("jvm")
Float sin(Float num)
    =>  JVMMath.sin(num);

shared native("js")
Float sin(Float num) {
    if (num == 0.0 && num.strictlyNegative) {
        return -0.0;
    }
    dynamic {
        return \iMath.sin(num);
    }
}

"The cosine of the given angle specified in radians.

 * `cos(-infinity)` is `undefined`,
 * `cos(+infinity)` is `undefined`,
 * `cos(undefined)` is `undefined`.
 "
shared native
Float cos(Float num);

shared native("jvm")
Float cos(Float num)
    =>  JVMMath.cos(num);

shared native("js")
Float cos(Float num) {
    dynamic {
        return Math.cos(num);
    }
}

"The tangent of the given angle specified in radians.

 * `tan(-infinity)` is `undefined`,
 * `tan(-0)` is `-0`,
 * `tan(+0)` is `+0`,
 * `tan(+infinity)` is `undefined`,
 * `tan(undefined)` is `undefined`.
 "
shared native
Float tan(Float num);

shared native("jvm")
Float tan(Float num)
    =>  JVMMath.tan(num);

shared native("js")
Float tan(Float num) {
    if (num == 0.0 && num.strictlyNegative) {
        return -0.0;
    }
    dynamic {
        return Math.tan(num);
    }
}

"The hyperbolic sine of the given angle specified in
 radians.

 * `sinh(-0)` is `-0`,
 * `sinh(+0)` is `+0`,
 * `sinh(-infinity)` is `-infinity`,
 * `sinh(+infinity)` is `+infinity`,
 * `sinh(undefined)` is `undefined`.
 "
shared native
Float sinh(Float num);

shared native("jvm")
Float sinh(Float num)
    =>  JVMMath.sinh(num);

shared native("js")
Float sinh(Float num)
    =>  if (!num.finite || num.fractionalPart == 0.0)
        then num
        else (exp(num) - exp(-num)) / 2;

"The hyperbolic cosine of the given angle specified in
 radians.

 * `cosh(0)` is `1`.
 * `cosh(-infinity)` is `+infinity`,
 * `cosh(+infinity)` is `+infinity`,
 * `cosh(undefined)` is `undefined`.
 "
shared native
Float cosh(Float num);

shared native("jvm")
Float cosh(Float num)
    =>  JVMMath.cosh(num);

shared native("js")
Float cosh(Float num)
    =>  (exp(num) + exp(-num)) / 2;

"The hyperbolic tangent of the given angle specified in
 radians.

 * `tanh(+infinity)` is `+1`,
 * `tanh(-infinity)` is `-1`,
 * `tanh(-0)` is `-0`,
 * `tanh(+0)` is `+0`,
 * `tanh(undefined)` is `undefined`.
 "
shared native
Float tanh(Float num);

shared native("jvm")
Float tanh(Float num)
    =>  JVMMath.tanh(num);

shared native("js")
Float tanh(Float num) {
    if (num.infinite) {
        return num.sign.float;
    }
    if (num.fractionalPart == 0.0) {
        return num;
    }
    value pos = exp(num);
    value neg = exp(-num);
    return (pos - neg) / (pos + neg);
}

"The arc sine of the given number.

 * `asin(x)` for any x < -1 is `undefined`,
 * `asin(-0)` is `-0`,
 * `asin(+0)` is `+0`,
 * `asin(x)` for any x > 1 is `undefined`,
 * `asin(undefined) is `undefined`.
 "
shared native
Float asin(Float num);

shared native("jvm")
Float asin(Float num)
    =>  JVMMath.asin(num);

shared native("js")
Float asin(Float num) {
    if (num == 0.0 && num.strictlyNegative) {
        return -0.0;
    }
    dynamic {
        return Math.asin(num);
    }
}

"The arc cosine of the given number.

 * `acos(x)` for any x < -1 is `undefined`,
 * `acos(x)` for any x > 1 is `undefined`,
 * `acos(undefined) is `undefined`.
 "
shared native
Float acos(Float num);

shared native("jvm")
Float acos(Float num)
    =>  JVMMath.acos(num);

shared native("js")
Float acos(Float num) {
    dynamic {
        return Math.acos(num);
    }
}

"The arc tangent of the given number.

 * `atan(-0)` is `-0`,
 * `atan(+0)` is `+0`,
 * `atan(undefined)` is `undefined`.
 "
shared native
Float atan(Float num);

shared native("jvm")
Float atan(Float num)
    =>  JVMMath.atan(num);

shared native("js")
Float atan(Float num) {
    if (num == 0.0 && num.strictlyNegative) {
        return -0.0;
    }
    dynamic {
        return Math.atan(num);
    }
}

"The angle from converting rectangular coordinates
 `x` and `y` to polar coordinates.

 Special cases:

 <table>
 <tbody>
 <tr>
 <th><code>y</code></th>
 <th><code>x</code></th>
 <th><code>atan2(y,x)</code></th>
 </tr>

 <tr>
 <td><code>undefined</code></td>
 <td>any value</td>
 <td><code>undefined</code></td>
 </tr>

 <tr>
 <td>any value</td>
 <td><code>undefined</code></td>
 <td><code>undefined</code></td>
 </tr>

 <tr><td><code>+0</code></td>
 <td><code>&gt; 0</code></td>
 <td><code>+0</code></td>
 </tr>

 <tr>
 <td><code>&gt; 0</code> and not <code>+infinity</code></td>
 <td><code>+infinity</code></td>
 <td><code>+0</code></td></tr>

 <tr>
 <td><code>-0</code></td>
 <td><code>&gt; 0</code></td>
 <td><code>-0</code></td>
 </tr>

 <tr>
 <td><code>&lt; 0</code> and not <code>-infinity</code></td>
 <td><code>+infinity</code></td>
 <td><code>-0</code></td>
 </tr>

 <tr>
 <td><code>+0</code></td>
 <td><code>&lt; 0</code></td>
 <td><code>\{#03C0}</code></td>
 </tr>

 <tr>
 <td><code>&gt; 0</code> and not <code>+infinity</code></td>
 <td><code>-infinity</code></td>
 <td><code>\{#03C0}</code></td>
 </tr>

 <tr>
 <td><code>-0</code></td>
 <td><code>&lt; 0</code></td>
 <td><code>-\{#03C0}</code></td>
 </tr>

 <tr>
 <td><code>&lt; 0</code> and not <code>-infinity</code></td>
 <td><code>-infinity</code></td>
 <td><code>-\{#03C0}</code></td>
 </tr>

 <tr>
 <td><code>&gt; 0</code></td>
 <td><code>+0 or -0</code></td>
 <td><code>\{#03C0}/2</code></td>
 </tr>

 <tr>
 <td><code>+infinity</code></td>
 <td>not <code>+infinity</code> or <code>-infinity</code></td>
 <td><code>\{#03C0}/2</code></td>
 </tr>

 <tr>
 <td><code>&lt; 0</code></td>
 <td><code>+0 or -0</code></td>
 <td><code>-\{#03C0}/2</code></td>
 </tr>

 <tr>
 <td><code>-infinity</code></td>
 <td>not <code>+infinity</code> or <code>-infinity</code></td>
 <td><code>-\{#03C0}/2</code></td>
 </tr>

 <tr>
 <td><code>+infinity</code></td>
 <td><code>+infinity</code></td>
 <td><code>\{#03C0}/4</code></td>
 </tr>

 <tr>
 <td><code>+infinity</code></td>
 <td><code>-infinity</code></td>
 <td><code>3\{#03C0}/4</code></td>
 </tr>

 <tr>
 <td><code>-infinity</code></td>
 <td><code>+infinity</code></td>
 <td><code>-\{#03C0}/4</code></td>
 </tr>

 <tr>
 <td><code>-infinity</code></td>
 <td><code>-infinity</code></td>
 <td><code>-3\{#03C0}/4</code></td>
 </tr>

 </tbody>
 </table>
 "
shared native
Float atan2(Float y, Float x);

shared native("jvm")
Float atan2(Float y, Float x)
    =>  JVMMath.atan2(y, x);

shared native("js")
Float atan2(Float y, Float x) {
    if (y == 0.0 && y.strictlyNegative) {
        if (x.positive) {
            return -0.0;
        }
        else if (x.negative) {
            return -pi;
        }
        else {
            return undefined;
        }
    }
    dynamic {
        return Math.atan2(y, x);
    }
}

"Returns the length of the hypotenuse of a right angle
 triangle with other sides having lengths `x` and `y`. This 
 function may be more accurate than computing
 `sqrt(x^2 + x^2)` directly.

 * `hypot(x,y)` where `x` and/or `y` is `+infinity` or
   `-infinity`, is `+infinity`,
 * `hypot(x,y)`, where `x` and/or `y` is `undefined`,
   is `undefined`.
 "
shared native
Float hypot(Float x, Float y);

shared native("jvm")
Float hypot(Float x, Float y)
    =>  JVMMath.hypot(x, y);

shared native("js")
Float hypot(Float x, Float y) {
    if (x.infinite || y.infinite) {
        return infinity;
    }
    else if (x.undefined || y.undefined) {
        return undefined;
    }
    else {
        return sqrt((x^2) + (y^2));
    }
}

"The positive square root of the given number. This function 
 may be faster and/or more accurate than `num^0.5`.

 * `sqrt(x)` for any x < 0 is `undefined`,
 * `sqrt(-0)` is `-0`,
 * `sqrt(+0) is `+0`,
 * `sqrt(+infinity)` is `+infinity`,
 * `sqrt(undefined)` is `undefined`.
 "
shared native
Float sqrt(Float num);

shared native("jvm")
Float sqrt(Float num)
    =>  JVMMath.sqrt(num);

shared native("js")
Float sqrt(Float num) {
    if (num == 0.0 && num.strictlyNegative) {
        return -0.0;
    }
    dynamic {
        return Math.sqrt(num);
    }
}

"The cube root of the given number. This function may be
 faster and/or more accurate than `num^(1.0/3.0)`.

 * `cbrt(-infinity)` is `-infinity`,
 * `cbrt(-0)` is `-0`,
 * `cbrt(+0)` is `+0`,
 * `cbrt(+infinity)` is `+infinity`,
 * `cbrt(undefined)` is `undefined`.
 "
shared native
Float cbrt(Float num);

shared native("jvm")
Float cbrt(Float num)
    =>  JVMMath.cbrt(num);

shared native("js")
Float cbrt(Float num)
    =>  if (num.negative) then
            -(num.negated ^ (1.0/3.0))
        else if (num == 0.0) then
            num // positive or negative zero
        else
            num ^ (1.0/3.0);

"A number greater than or equal to positive zero and less
 than `1.0`, chosen pseudorandomly and (approximately)
 uniformly distributed."
shared native
Float random();

shared native("jvm")
Float random()
    =>  JVMMath.random();

shared native("js")
Float random() {
    dynamic {
        return Math.random();
    }
}

"The largest value that is less than or equal to the
 argument and equal to an integer.

 * `floor(-infinity)` is `-infinity`,
 * `floor(-0)` is `-0`,
 * `floor(+0)` is `+0`,
 * `floor(+infinity)` is `+infinity`,
 * `floor(undefined)` is `undefined`.
 "
shared see(`function halfEven`, `function ceiling`)
Float floor(Float num)
    =>  if (num.infinite ||
                num.undefined ||
                num.fractionalPart == 0.0) then
            num
        else if (num.negative) then
            num.wholePart - 1.0
        else
            num.wholePart;

"The smallest value that is greater than or equal to the
 argument and equal to an integer.

 * `ceiling(-infinity)` is `-infinity`,
 * `ceiling(x)` for -1.0 < x < -0 is `-0`,
 * `ceiling(-0)` is `-0`,
 * `ceiling(+0)` is `+0`,
 * `ceiling(+infinity)` is `+infinity`,
 * `ceiling(undefined)` is `undefined`.
 "
shared see(`function floor`, `function halfEven`)
Float ceiling(Float num)
    =>  if (num.infinite ||
                num.undefined ||
                num.fractionalPart == 0.0) then
            num
        else if (num.negative) then
            num.wholePart
        else
            num.wholePart + 1.0;

"The closest value to the argument that is equal to a
 mathematical integer, with even values preferred in the
 event of a tie (half even rounding).

 * `halfEven(-infinity)` is `-infinity`
 * `halfEven(-0)` is `-0`
 * `halfEven(+0)` is `+0`
 * `halfEven(+infinity)` is `+infinity`
 * `halfEven(undefined)` is `undefined`
 "
shared see(`function floor`, `function ceiling`)
Float halfEven(Float num) {
    if (num.infinite ||
            num.undefined ||
            num.fractionalPart == 0.0) {
        return num;
    }

    variable value result = num.magnitude;
    if (result >= twoFiftyTwo) {
        return num;
    }

    // else, round
    result = (twoFiftyTwo + result) - twoFiftyTwo;
    return result * num.sign.float;
}

"The smaller of the two arguments.

 * `smallest(-0,+0)` is `-0`
 * `smallest(undefined, x)` is `undefined`
 * `smallest(x, x)` is `x`
 * `smallest(+infinity,x) is `x`
 * `smallest(-infinity,x) is `-infinity`
 "
shared see(`function largest`)
Float smallest(Float x, Float y)
    =>  if (x.strictlyNegative && y.strictlyPositive) 
            then x
        else if (x.strictlyPositive && y.strictlyNegative) 
            then y
        else if (x.undefined || y.undefined) 
            then undefined
        else if (x<y) then x else y;

"The larger of the two arguments.

 * `largest(-0,+0)` is `+0`
 * `largest(undefined, x)` is `undefined`
 * `largest(x, x)` is `x`
 * `largest(+infinity,x) is `+infinity`
 * `largest(-infinity,x) is `x`
 "
shared see(`function smallest`)
Float largest(Float x, Float y)
    =>  if (x.strictlyNegative && y.strictlyPositive) 
            then y
        else if (x.strictlyPositive && y.strictlyNegative) 
            then x
        else if (x.undefined || y.undefined) 
            then undefined
        else if (x>y) then x else y;

"The largest [[Float]] in the given stream, or `null` if the 
 stream is empty. Returns an undefined value if the stream 
 contains an [[undefined value|Float.undefined]]."
shared 
Float|Absent max<Absent>(Iterable<Float,Absent> values)
        given Absent satisfies Null {
    value first = values.first;
    if (exists first) {
        variable value max = first;
        for (x in values) {
            if (x.undefined) {
                return undefined;
            }
            if (x>max || 
                x.strictlyPositive && 
                max.strictlyNegative) {
                max = x;
            }
        }
        return max;
    }
    return first;
}

"The smallest [[Float]] in the given stream, or `null` if 
 the stream is empty. Returns an undefined value if the 
 stream contains an [[undefined value|Float.undefined]]."
shared 
Float|Absent min<Absent>(Iterable<Float,Absent> values)
        given Absent satisfies Null {
    value first = values.first;
    if (exists first) {
        variable value min = first;
        for (x in values) {
            if (x.undefined) {
                return undefined;
            }
            if (x<min ||
                x.strictlyNegative && 
                min.strictlyPositive) {
                min = x;
            }
        }
        return min;
    }
    return first;
}

"The mean of the values in the given stream, or an undefined
 value if the stream is empty."
shared
Float mean({Float*} values) {
    variable Float sum=0.0;
    variable Integer count=0;
    for (x in values) {
        sum+=x;
        count++;
    }
    return sum / count;
}

"The sum of the values in the given stream, or `0.0` if the 
 stream is empty."
shared
Float sum({Float*} values) {
    variable Float sum=0.0;
    for (x in values) {
        sum+=x;
    }
    return sum;
}

"The product of the values in the given stream, or `1.0` if 
 the stream is empty."
shared
Float product({Float*} values) {
    variable Float product=1.0;
    for (x in values) {
        product*=x;
    }
    return product;
}

"The value of `x \{#00D7} 2\{#207F}`, calculated exactly
 for reasonable values of `n` on JVM."
shared native
Float scalb(Float x, Integer n);

shared native("jvm")
Float scalb(Float x, Integer n)
    =>  JVMMath.scalb(x, n);

shared native("js")
Float scalb(Float x, Integer n)
    // faster than other options per
    // http://jsperf.com/scale-pow2/5
    =>  x * 2.0 ^ n;

"The remainder, after dividing the [[dividend]] by the 
 [[divisor]]. This function is defined as:

     dividend - n * divisor

 where `n` is the whole part of `dividend / divisor`. The 
 result will have the same sign as the `dividend`.

 * `remainder(infinity, divisor)` is `undefined`,
 * `remainder(dividend, 0.0)` is `undefined`,
 * `remainder(dividend, infinity)` is `dividend` for 
   non-infinite dividends."
shared
Float remainder(Float dividend, Float divisor) {
    if (dividend==0.0 && divisor!=0.0 
            && !divisor.undefined) {
        return dividend.strictlyNegative 
            then -0.0 else 0.0;
    }
    else if (divisor.infinite && !dividend.infinite) {
        return dividend;
    }
    else {
        // effectively, undefined is returned 
        // when divisor == 0.
        return dividend 
                - (dividend/divisor).wholePart * divisor;
    }
}
