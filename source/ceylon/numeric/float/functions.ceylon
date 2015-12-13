import java.lang {
    JMath=Math
}

"\{#0001D452} raised to the power of the argument.
 
 * `exp(-infinity)` is `+0`,
 * `exp(+infinity)` is `+infinity`,
 * `exp(undefined)` is `undefined`.
 "
see (`function expm1`)
shared native Float exp(Float num);

"The natural logarithm (base \{#0001D452}) of the 
 argument.
 
 * `log(x)` for any x < 0 is `undefined`,
 * `log(+0)` and `log(-0)` is `-infinity`,
 * `log(+infinity)` is `+infinity`,
 * `log(undefined)` is `undefined`.
 "
see(`function log10`, `function log1p`)
shared native Float log(Float num);

"The base 10 logarithm of the argument.
 
 * `log10(x)` for any x < 0 is `undefined`,
 * `log10(-0)` and `log10(+0)` is `-infinity`,
 * `log10(+infinity)` is `+infinity`,
 * `log10(undefined)` is `undefined`.
 "
see(`function log`)
shared native Float log10(Float num);

"The sine of the given angle specified in radians.
 
 * `sin(-0)` is `-0`,
 * `sin(+0)` is `+0`,
 * `sin(-infinity)` is `undefined`,
 * `sin(+infinity)` is `undefined`,
 * `sin(undefined)` is `undefined`.
 "
shared native Float sin(Float num);

"The cosine of the given angle specified in radians.
 
 * `cos(-infinity)` is `undefined`,
 * `cos(+infinity)` is `undefined`,
 * `cos(undefined)` is `undefined`.
 "
shared native Float cos(Float num);

"The tangent of the given angle specified in radians.
 
 * `tan(-infinity)` is `undefined`,
 * `tan(-0)` is `-0`,
 * `tan(+0)` is `+0`,
 * `tan(+infinity)` is `undefined`,
 * `tan(undefined)` is `undefined`.
 "
shared native Float tan(Float num);

"The hyperbolic sine of the given angle specified in 
 radians.
 
 * `sinh(-0)` is `-0`,
 * `sinh(+0)` is `+0`,
 * `sin(-infinity)` is `-infinity`,
 * `sin(+infinity)` is `+infinity`,
 * `sin(undefined)` is `undefined`.
 "
shared native Float sinh(Float num);

"The hyperbolic cosine of the given angle specified in 
 radians.
 
 * `cosh(0)` is `1`.
 * `cosh(-infinity)` is `+infinity`,
 * `cosh(+infinity)` is `+infinity`,
 * `cosh(undefined)` is `undefined`.
 "
shared native Float cosh(Float num);

"The hyperbolic tangent of the given angle specified in 
 radians.
 
 * `tanh(+infinity)` is `+1`,
 * `tanh(-infinity)` is `-1`,
 * `tanh(-0)` is `-0`,
 * `tanh(+0)` is `+0`,
 * `tanh(undefined)` is `undefined`.
 "
shared native Float tanh(Float num);

"The arc sine of the given number.
 
 * `asin(x)` for any x < -1 is `undefined`,
 * `asin(-0)` is `-0`,
 * `asin(+0)` is `+0`,
 * `asin(x)` for any x > 1 is `undefined`,
 * `asin(undefined) is `undefined`.
 "
shared native Float asin(Float num);

"The arc cosine of the given number.
 
 * `acos(x)` for any x < -1 is `undefined`,
 * `acos(x)` for any x > 1 is `undefined`,
 * `acos(undefined) is `undefined`.
 "
shared native Float acos(Float num);

"The arc tangent of the given number.
 
 * `atan(-0)` is `-0`,
 * `atan(+0)` is `+0`,
 * `atan(undefined)` is `undefined`.
 "
shared native Float atan(Float num);

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
shared native Float atan2(Float y, Float x);

"Returns the length of the hypotenuse of a right angle 
 triangle with other sides having lengths `x` and `y`. 
 This method may be more accurate than computing 
 `sqrt(x^2 + x^2)` directly.
 
 * `hypot(x,y)` where `x` and/or `y` is `+infinity` or 
   `-infinity`, is `+infinity`,
 * `hypot(x,y)`, where `x` and/or `y` is `undefined`, 
   is `undefined`.
 "
shared native Float hypot(Float x, Float y);

"The positive square root of the given number. This 
 method may be faster and/or more accurate than 
 `num^0.5`.
 
 * `sqrt(x)` for any x < 0 is `undefined`,
 * `sqrt(-0)` is `-0`,
 * `sqrt(+0) is `+0`,
 * `sqrt(+infinity)` is `+infinity`,
 * `sqrt(undefined)` is `undefined`.     
 "
shared native Float sqrt(Float num);

"The cube root of the given number. This method may be 
 faster and/or more accurate than `num^(1.0/3.0)`.
 
 * `cbrt(-infinity)` is `-infinity`,
 * `cbrt(-0)` is `-0`,
 * `cbrt(+0)` is `+0`,
 * `cbrt(+infinity)` is `+infinity`,
 * `cbrt(undefined)` is `undefined`.    
 "
shared native Float cbrt(Float num);

"A number greater than or equal to positive zero and less 
 than `1.0`, chosen pseudorandomly and (approximately) 
 uniformly distributed."
shared native Float random();

"The largest value that is less than or equal to the 
 argument and equal to an integer.
 
 * `floor(-infinity)` is `-infinity`,
 * `floor(-0)` is `-0`,
 * `floor(+0)` is `+0`,
 * `floor(+infinity)` is `+infinity`,
 * `floor(undefined)` is `undefined`.
 "
see(`function ceiling`)
see(`function round`)
shared native Float floor(Float num);

"The smallest value that is greater than or equal to the 
 argument and equal to an integer.
 
 * `ceiling(-infinity)` is `-infinity`,
 * `ceiling(x)` for -1.0 < x < -0 is `-0`,
 * `ceiling(-0)` is `-0`,
 * `ceiling(+0)` is `+0`,
 * `ceiling(+infinity)` is `+infinity`,
 * `ceiling(undefined)` is `undefined`.
 "
see(`function floor`)
see(`function round`)
shared native Float ceiling(Float num);

"The closest value to the argument that is equal to a
 mathematical integer, with even values preferred in the 
 event of a tie (half even rounding).
 
 * `round(-infinity)` is `-infinity`
 * `round(-0)` is `-0` 
 * `round(+0)` is `+0`
 * `round(+infinity)` is `+infinity`
 * `round(undefined)` is `undefined`
 "
see(`function floor`)
see(`function ceiling`)
shared native Float round(Float num);

"The smaller of the two arguments.
 
 * `smallest(-1,+0)` is `-0`
 * `smallest(undefined, x)` is `undefined`
 * `smallest(x, x)` is `x`
 * `smallest(+infinity,x) is `x`
 * `smallest(-infinity,x) is `-infinity`
 "
see(`function largest`)
shared native Float smallest(Float x, Float y);

"The larger of the two arguments.
 
 * `largest(-1,+0)` is `+0`
 * `largest(undefined, x)` is `undefined`
 * `largest(x, x)` is `x`
 * `largest(+infinity,x) is `+infinity`
 * `largest(-infinity,x) is `x`
 "
see(`function smallest`)
shared native Float largest(Float x, Float y);

"\{#0001D452} raised to the power of the argument.
 
 * `exp(-infinity)` is `+0`,
 * `exp(+infinity)` is `+infinity`,
 * `exp(undefined)` is `undefined`.
 "
see (`function expm1`)
shared native("jvm") Float exp(Float num) 
        => JMath.exp(num);

"The natural logarithm (base \{#0001D452}) of the 
 argument.
 
 * `log(x)` for any x < 0 is `undefined`,
 * `log(+0)` and `log(-0)` is `-infinity`,
 * `log(+infinity)` is `+infinity`,
 * `log(undefined)` is `undefined`.
 "
see(`function log10`, `function log1p`)
shared native("jvm") Float log(Float num) 
        => JMath.log(num);

"The base 10 logarithm of the argument.
 
 * `log10(x)` for any x < 0 is `undefined`,
 * `log10(-0)` and `log10(+0)` is `-infinity`,
 * `log10(+infinity)` is `+infinity`,
 * `log10(undefined)` is `undefined`.
 "
see(`function log`)
shared native("jvm") Float log10(Float num) 
        => JMath.log10(num);

"The sine of the given angle specified in radians.
 
 * `sin(-0)` is `-0`,
 * `sin(+0)` is `+0`,
 * `sin(-infinity)` is `undefined`,
 * `sin(+infinity)` is `undefined`,
 * `sin(undefined)` is `undefined`.
 "
shared native("jvm") Float sin(Float num) 
        => JMath.sin(num);

"The cosine of the given angle specified in radians.
 
 * `cos(-infinity)` is `undefined`,
 * `cos(+infinity)` is `undefined`,
 * `cos(undefined)` is `undefined`.
 "
shared native("jvm") Float cos(Float num) 
        => JMath.cos(num);

"The tangent of the given angle specified in radians.
 
 * `tan(-infinity)` is `undefined`,
 * `tan(-0)` is `-0`,
 * `tan(+0)` is `+0`,
 * `tan(+infinity)` is `undefined`,
 * `tan(undefined)` is `undefined`.
 "
shared native("jvm") Float tan(Float num) 
        => JMath.tan(num);

"The hyperbolic sine of the given angle specified in 
 radians.
 
 * `sinh(-0)` is `-0`,
 * `sinh(+0)` is `+0`,
 * `sin(-infinity)` is `-infinity`,
 * `sin(+infinity)` is `+infinity`,
 * `sin(undefined)` is `undefined`.
 "
shared native("jvm") Float sinh(Float num) 
        => JMath.sinh(num);

"The hyperbolic cosine of the given angle specified in 
 radians.
 
 * `cosh(0)` is `1`.
 * `cosh(-infinity)` is `+infinity`,
 * `cosh(+infinity)` is `+infinity`,
 * `cosh(undefined)` is `undefined`.
 "
shared native("jvm") Float cosh(Float num) 
        => JMath.cosh(num);

"The hyperbolic tangent of the given angle specified in 
 radians.
 
 * `tanh(+infinity)` is `+1`,
 * `tanh(-infinity)` is `-1`,
 * `tanh(-0)` is `-0`,
 * `tanh(+0)` is `+0`,
 * `tanh(undefined)` is `undefined`.
 "
shared native("jvm") Float tanh(Float num) 
        => JMath.tanh(num);

"The arc sine of the given number.
 
 * `asin(x)` for any x < -1 is `undefined`,
 * `asin(-0)` is `-0`,
 * `asin(+0)` is `+0`,
 * `asin(x)` for any x > 1 is `undefined`,
 * `asin(undefined) is `undefined`.
 "
shared native("jvm") Float asin(Float num) 
        => JMath.asin(num);

"The arc cosine of the given number.
 
 * `acos(x)` for any x < -1 is `undefined`,
 * `acos(x)` for any x > 1 is `undefined`,
 * `acos(undefined) is `undefined`.
 "
shared native("jvm") Float acos(Float num) 
        => JMath.acos(num);

"The arc tangent of the given number.
 
 * `atan(-0)` is `-0`,
 * `atan(+0)` is `+0`,
 * `atan(undefined)` is `undefined`.
 "
shared native("jvm") Float atan(Float num) 
        => JMath.atan(num);

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
shared native("jvm") Float atan2(Float y, Float x) 
        => JMath.atan2(y, x);

"Returns the length of the hypotenuse of a right angle 
 triangle with other sides having lengths `x` and `y`. 
 This method may be more accurate than computing 
 `sqrt(x^2 + x^2)` directly.
 
 * `hypot(x,y)` where `x` and/or `y` is `+infinity` or 
   `-infinity`, is `+infinity`,
 * `hypot(x,y)`, where `x` and/or `y` is `undefined`, 
   is `undefined`.
 "
shared native("jvm") Float hypot(Float x, Float y) 
        => JMath.hypot(x, y);

"The positive square root of the given number. This 
 method may be faster and/or more accurate than 
 `num^0.5`.
 
 * `sqrt(x)` for any x < 0 is `undefined`,
 * `sqrt(-0)` is `-0`,
 * `sqrt(+0) is `+0`,
 * `sqrt(+infinity)` is `+infinity`,
 * `sqrt(undefined)` is `undefined`.     
 "
shared native("jvm") Float sqrt(Float num) 
        => JMath.sqrt(num);

"The cube root of the given number. This method may be 
 faster and/or more accurate than `num^(1.0/3.0)`.
 
 * `cbrt(-infinity)` is `-infinity`,
 * `cbrt(-0)` is `-0`,
 * `cbrt(+0)` is `+0`,
 * `cbrt(+infinity)` is `+infinity`,
 * `cbrt(undefined)` is `undefined`.    
 "
shared native("jvm") Float cbrt(Float num) 
        => JMath.cbrt(num);

"A number greater than or equal to positive zero and less 
 than `1.0`, chosen pseudorandomly and (approximately) 
 uniformly distributed."
shared native("jvm") Float random() 
        => JMath.random();

"The largest value that is less than or equal to the 
 argument and equal to an integer.
 
 * `floor(-infinity)` is `-infinity`,
 * `floor(-0)` is `-0`,
 * `floor(+0)` is `+0`,
 * `floor(+infinity)` is `+infinity`,
 * `floor(undefined)` is `undefined`.
 "
see(`function ceiling`)
see(`function round`)
shared native("jvm") Float floor(Float num) 
        => JMath.floor(num);

"The smallest value that is greater than or equal to the 
 argument and equal to an integer.
 
 * `ceiling(-infinity)` is `-infinity`,
 * `ceiling(x)` for -1.0 < x < -0 is `-0`,
 * `ceiling(-0)` is `-0`,
 * `ceiling(+0)` is `+0`,
 * `ceiling(+infinity)` is `+infinity`,
 * `ceiling(undefined)` is `undefined`.
 "
see(`function floor`)
see(`function round`)
shared native("jvm") Float ceiling(Float num) 
        => JMath.ceil(num);

"The closest value to the argument that is equal to a
 mathematical integer, with even values preferred in the 
 event of a tie (half even rounding).
 
 * `round(-infinity)` is `-infinity`
 * `round(-0)` is `-0` 
 * `round(+0)` is `+0`
 * `round(+infinity)` is `+infinity`
 * `round(undefined)` is `undefined`
 "
see(`function floor`)
see(`function ceiling`)
shared native("jvm") Float round(Float num) 
        => JMath.rint(num);

"The smaller of the two arguments.
 
 * `smallest(-1,+0)` is `-0`
 * `smallest(undefined, x)` is `undefined`
 * `smallest(x, x)` is `x`
 * `smallest(+infinity,x) is `x`
 * `smallest(-infinity,x) is `-infinity`
 "
see(`function largest`)
shared native("jvm") Float smallest(Float x, Float y) 
        => JMath.min(x, y);

"The larger of the two arguments.
 
 * `largest(-1,+0)` is `+0`
 * `largest(undefined, x)` is `undefined`
 * `largest(x, x)` is `x`
 * `largest(+infinity,x) is `+infinity`
 * `largest(-infinity,x) is `x`
 "
see(`function smallest`)
shared native("jvm") Float largest(Float x, Float y) 
        => JMath.max(x, y);

"\{#0001D452} raised to the power of the argument.
 
 * `exp(-infinity)` is `+0`,
 * `exp(+infinity)` is `+infinity`,
 * `exp(undefined)` is `undefined`.
 "
see (`function expm1`)
shared native("js") Float exp(Float num) {
    dynamic {
        return Math.exp(num);
    }
}

"The natural logarithm (base \{#0001D452}) of the 
 argument.
 
 * `log(x)` for any x < 0 is `undefined`,
 * `log(+0)` and `log(-0)` is `-infinity`,
 * `log(+infinity)` is `+infinity`,
 * `log(undefined)` is `undefined`.
 "
see(`function log10`, `function log1p`)
shared native("js") Float log(Float num) {
    dynamic {
        return Math.log(num);
    }
}

"The base 10 logarithm of the argument.
 
 * `log10(x)` for any x < 0 is `undefined`,
 * `log10(-0)` and `log10(+0)` is `-infinity`,
 * `log10(+infinity)` is `+infinity`,
 * `log10(undefined)` is `undefined`.
 "
see(`function log`)
shared native("js") Float log10(Float num) {
    dynamic {
        return Math.log10(num);
    }
}

"The sine of the given angle specified in radians.
 
 * `sin(-0)` is `-0`,
 * `sin(+0)` is `+0`,
 * `sin(-infinity)` is `undefined`,
 * `sin(+infinity)` is `undefined`,
 * `sin(undefined)` is `undefined`.
 "
shared native("js") Float sin(Float num) {
    dynamic {
        return Math.sin(num);
    }
}

"The cosine of the given angle specified in radians.
 
 * `cos(-infinity)` is `undefined`,
 * `cos(+infinity)` is `undefined`,
 * `cos(undefined)` is `undefined`.
 "
shared native("js") Float cos(Float num) {
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
shared native("js") Float tan(Float num) {
    dynamic {
        return Math.tan(num);
    }
}

"The hyperbolic sine of the given angle specified in 
 radians.
 
 * `sinh(-0)` is `-0`,
 * `sinh(+0)` is `+0`,
 * `sin(-infinity)` is `-infinity`,
 * `sin(+infinity)` is `+infinity`,
 * `sin(undefined)` is `undefined`.
 "
shared native("js") Float sinh(Float num) {
    dynamic {
        return Math.sinh(num);
    }
}

"The hyperbolic cosine of the given angle specified in 
 radians.
 
 * `cosh(0)` is `1`.
 * `cosh(-infinity)` is `+infinity`,
 * `cosh(+infinity)` is `+infinity`,
 * `cosh(undefined)` is `undefined`.
 "
shared native("js") Float cosh(Float num) {
    dynamic {
        return Math.cosh(num);
    }
}

"The hyperbolic tangent of the given angle specified in 
 radians.
 
 * `tanh(+infinity)` is `+1`,
 * `tanh(-infinity)` is `-1`,
 * `tanh(-0)` is `-0`,
 * `tanh(+0)` is `+0`,
 * `tanh(undefined)` is `undefined`.
 "
shared native("js") Float tanh(Float num) {
    dynamic {
        return Math.tanh(num);
    }
}

"The arc sine of the given number.
 
 * `asin(x)` for any x < -1 is `undefined`,
 * `asin(-0)` is `-0`,
 * `asin(+0)` is `+0`,
 * `asin(x)` for any x > 1 is `undefined`,
 * `asin(undefined) is `undefined`.
 "
shared native("js") Float asin(Float num) {
    dynamic {
        return Math.asin(num);
    }
}

"The arc cosine of the given number.
 
 * `acos(x)` for any x < -1 is `undefined`,
 * `acos(x)` for any x > 1 is `undefined`,
 * `acos(undefined) is `undefined`.
 "
shared native("js") Float acos(Float num) {
    dynamic {
        return Math.acos(num);
    }
}

"The arc tangent of the given number.
 
 * `atan(-0)` is `-0`,
 * `atan(+0)` is `+0`,
 * `atan(undefined)` is `undefined`.
 "
shared native("js") Float atan(Float num) {
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
shared native("js") Float atan2(Float y, Float x) {
    dynamic {
        return Math.atan2(y, x);
    }
}

"Returns the length of the hypotenuse of a right angle 
 triangle with other sides having lengths `x` and `y`. 
 This method may be more accurate than computing 
 `sqrt(x^2 + x^2)` directly.
 
 * `hypot(x,y)` where `x` and/or `y` is `+infinity` or 
   `-infinity`, is `+infinity`,
 * `hypot(x,y)`, where `x` and/or `y` is `undefined`, 
   is `undefined`.
 "
shared native("js") Float hypot(Float x, Float y) {
    dynamic {
        return Math.hypot(x, y);
    }
}

"The positive square root of the given number. This 
 method may be faster and/or more accurate than 
 `num^0.5`.
 
 * `sqrt(x)` for any x < 0 is `undefined`,
 * `sqrt(-0)` is `-0`,
 * `sqrt(+0) is `+0`,
 * `sqrt(+infinity)` is `+infinity`,
 * `sqrt(undefined)` is `undefined`.     
 "
shared native("js") Float sqrt(Float num) {
    dynamic {
        return Math.sqrt(num);
    }
}

"The cube root of the given number. This method may be 
 faster and/or more accurate than `num^(1.0/3.0)`.
 
 * `cbrt(-infinity)` is `-infinity`,
 * `cbrt(-0)` is `-0`,
 * `cbrt(+0)` is `+0`,
 * `cbrt(+infinity)` is `+infinity`,
 * `cbrt(undefined)` is `undefined`.    
 "
shared native("js") Float cbrt(Float num) {
    dynamic {
        return Math.cbrt(num);
    }
}

"A number greater than or equal to positive zero and less 
 than `1.0`, chosen pseudorandomly and (approximately) 
 uniformly distributed."
shared native("js") Float random() {
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
see(`function ceiling`)
see(`function round`)
shared native("js") Float floor(Float num) {
    dynamic {
        return Math.floor(num);
    }
}

"The smallest value that is greater than or equal to the 
 argument and equal to an integer.
 
 * `ceiling(-infinity)` is `-infinity`,
 * `ceiling(x)` for -1.0 < x < -0 is `-0`,
 * `ceiling(-0)` is `-0`,
 * `ceiling(+0)` is `+0`,
 * `ceiling(+infinity)` is `+infinity`,
 * `ceiling(undefined)` is `undefined`.
 "
see(`function floor`)
see(`function round`)
shared native("js") Float ceiling(Float num) {
    dynamic {
        return Math.ceil(num);
    }
}

"The closest value to the argument that is equal to a
 mathematical integer, with even values preferred in the 
 event of a tie (half even rounding).
 
 * `round(-infinity)` is `-infinity`
 * `round(-0)` is `-0` 
 * `round(+0)` is `+0`
 * `round(+infinity)` is `+infinity`
 * `round(undefined)` is `undefined`
 "
see(`function floor`)
see(`function ceiling`)
shared native("js") Float round(Float num) {
    dynamic {
        return Math.round(num);
    }
}

"The smaller of the two arguments.
 
 * `smallest(-1,+0)` is `-0`
 * `smallest(undefined, x)` is `undefined`
 * `smallest(x, x)` is `x`
 * `smallest(+infinity,x) is `x`
 * `smallest(-infinity,x) is `-infinity`
 "
see(`function largest`)
shared native("js") Float smallest(Float x, Float y) {
    dynamic {
        return Math.min(x, y);
    }
}

"The larger of the two arguments.
 
 * `largest(-1,+0)` is `+0`
 * `largest(undefined, x)` is `undefined`
 * `largest(x, x)` is `x`
 * `largest(+infinity,x) is `+infinity`
 * `largest(-infinity,x) is `x`
 "
see(`function smallest`)
shared native("js") Float largest(Float x, Float y) {
    dynamic {
        return Math.max(x, y);
    }
}

"The largest [[Float]] in the given stream, or `null`
 if the stream is empty."
shared Float|Absent max<Absent>
        (Iterable<Float,Absent> values) 
        given Absent satisfies Null {
    value first = values.first;
    if (exists first) {
        variable value max = first;
        for (x in values) {
            max = largest(max, x);
        }
        return max;
    }
    return first;
}

"The smallest [[Float]] in the given stream, or `null`
 if the stream is empty."
shared Float|Absent min<Absent>
        (Iterable<Float,Absent> values) 
        given Absent satisfies Null {
    value first = values.first;
    if (exists first) {
        variable value min = first;
        for (x in values) {
            min = smallest(min, x);
        }
        return min;
    }
    return first;
}

"The sum of the [[Float]]s in the given stream, or `0.0` 
 if the stream is empty."
shared Float sum({Float*} values) {
    variable Float sum=0.0;
    for (x in values) {
        sum+=x;
    }
    return sum;
}

"The product of the [[Float]]s in the given stream, or `1.0` 
 if the stream is empty."
shared Float product({Float*} values) {
    variable Float sum=1.0;
    for (x in values) {
        sum*=x;
    }
    return sum;
}

//"The value of `x \{#00D7} 2\{#207F}`, calculated exactly 
// for reasonable values of `n`."
//shared native Float scalb(Float x, Integer n);

"A more accurate computation of `log(1.0+x)` for `x` near
 zero."
shared native Float log1p(Float num);

"A more accurate computation of `exp(x)-1.0` for `x` near
 zero."
shared native Float expm1(Float num);

//"The value of `x \{#00D7} 2\{#207F}`, calculated exactly 
// for reasonable values of `n`."
//shared native("jvm") Float scalb(Float x, Integer n) {
//    return Math.scalb(x, n);
//}

"A more accurate computation of `log(1.0+x)` for `x` near
 zero."
shared native("jvm") Float log1p(Float num) 
        => JMath.log1p(num);

"A more accurate computation of `exp(x)-1.0` for `x` near
 zero."
shared native("jvm") Float expm1(Float num) 
        => JMath.expm1(num);

"A more accurate computation of `log(1.0+x)` for `x` near
 zero."
shared native("js") Float log1p(Float num) {
    dynamic {
        return Math.log1p(num);
    }
}

"A more accurate computation of `exp(x)-1.0` for `x` near
 zero."
shared native("js") Float expm1(Float num) {
    dynamic {
        return Math.expm1(num);
    }
}

"The given angle (in radians) converted to degrees."
see(`function toRadians`)
shared Float toDegrees(Float num) => num/pi*180;

"The given angle (in degrees) converted to radians."
see(`function toDegrees`)
shared Float toRadians(Float num) => num/180*pi;

