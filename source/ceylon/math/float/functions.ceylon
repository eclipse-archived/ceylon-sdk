import java.lang { Math { jsin=sin, jcos=cos, jtan=tan, jsinh=sinh, jcosh=cosh, jtanh=tanh, jasin=asin, jacos=acos, jatan=atan, jatan2=atan2, jhypot=hypot, jexp=exp, jlog=log, jlog10=log10, jsqrt=sqrt, jcbrt=cbrt, jrandom=random, jfloor=floor, jceiling=ceil, jrint=rint, jmin=min, jmax=max, jscalb=scalb } }

"\{#0001D452} raised to the power of the argument.
 
 * `exp(-infinity)` is `+0`,
 * `exp(+infinity)` is `+infinity`,
 * `exp(undefined)` is `undefined`.
 "
shared Float exp(Float num) {
    return jexp(num);
}

"The natural logarithm (base \{#0001D452}) of the 
 argument.
 
 * `log(x)` for any x < 0 is `undefined`,
 * `log(+0)` and `log(-0)` is `-infinity`,
 * `log(+infinity)` is `+infinity`,
 * `log(undefined)` is `undefined`.
 "
//TODO see(log10)
shared Float log(Float num) {
    return jlog(num);
}

"The base 10 logarithm of the argument.
 
 * `log10(x)` for any x < 0 is `undefined`,
 * `log10(-0)` and `log10(+0)` is `-infinity`,
 * `log10(+infinity)` is `+infinity`,
 * `log10(undefined)` is `undefined`.
 "
//TODO see(log)
shared Float log10(Float num) {
    return jlog10(num);
}

"The given angle (in radians) converted to degrees."
//TODO see(toRadians)
shared Float toDegrees(Float num) {
    return num/pi*180;
}

"The given angle (in degrees) converted to radians."
//TODO see(toDegrees)
shared Float toRadians(Float num) {
    return num/180*pi;
}

"The sine of the given angle specified in radians.
 
 * `sin(-0)` is `-0`,
 * `sin(+0)` is `+0`,
 * `sin(-infinity)` is `undefined`,
 * `sin(+infinity)` is `undefined`,
 * `sin(undefined)` is `undefined`.
 "
shared Float sin(Float num) {
    return jsin(num);
}

"The cosine of the given angle specified in radians.
 
 * `cos(-infinity)` is `undefined`,
 * `cos(+infinity)` is `undefined`,
 * `cos(undefined)` is `undefined`.
 "
shared Float cos(Float num) {
    return jcos(num);
}

"The tangent of the given angle specified in radians.
 
 * `tan(-infinity)` is `undefined`,
 * `tan(-0)` is `-0`,
 * `tan(+0)` is `+0`,
 * `tan(+infinity)` is `undefined`,
 * `tan(undefined)` is `undefined`.
 "
shared Float tan(Float num) {
    return jtan(num);
}

"The hyperbolic sine of the given angle specified in 
 radians.
 
 * `sinh(-0)` is `-0`,
 * `sinh(+0)` is `+0`,
 * `sin(-infinity)` is `-infinity`,
 * `sin(+infinity)` is `+infinity`,
 * `sin(undefined)` is `undefined`.
 "
shared Float sinh(Float num) {
    return jsinh(num);
}

"The hyperbolic cosine of the given angle specified in 
 radians.
 
 * `cosh(0)` is `1`.
 * `cosh(-infinity)` is `+infinity`,
 * `cosh(+infinity)` is `+infinity`,
 * `cosh(undefined)` is `undefined`.
 "
shared Float cosh(Float num) {
    return jcosh(num);
}

"The hyperbolic tangent of the given angle specified in 
 radians.
 
 * `tanh(+infinity)` is `+1`,
 * `tanh(-infinity)` is `-1`,
 * `tanh(-0)` is `-0`,
 * `tanh(+0)` is `+0`,
 * `tanh(undefined)` is `undefined`.
 "
shared Float tanh(Float num) {
    return jtanh(num);
}

"The arc sine of the given number.
 
 * `asin(x)` for any x < -1 is `undefined`,
 * `asin(-0)` is `-0`,
 * `asin(+0)` is `+0`,
 * `asin(x)` for any x > 1 is `undefined`,
 * `asin(undefined) is `undefined`.
 "
shared Float asin(Float num) {
    return jasin(num);
}

"The arc cosine of the given number.
 
 * `acos(x)` for any x < -1 is `undefined`,
 * `acos(x)` for any x > 1 is `undefined`,
 * `acos(undefined) is `undefined`.
 "
shared Float acos(Float num) {
    return jacos(num);
}

"The arc tangent of the given number.
 
 * `atan(-0)` is `-0`,
 * `atan(+0)` is `+0`,
 * `atan(undefined)` is `undefined`.
 "
shared Float atan(Float num) {
    return jatan(num);
}

"The angle from converting rectangular coordinates `x` 
 and `y` to polar coordinates.
 
 Special cases:
 
 <table>
 <tbody>
 <tr>
 <th><code>y</code></th>
 <th><code>x</code></th>
 <th><code>atan2(y,x)</code></th>
 </tr>
 
 <tr>
 <td>undefined</td>  
 <td>any value</td>  
 <td>undefined</td>
 </tr>
 
 <tr>
 <td>any value</td>  
 <td>undefined</td>  
 <td>undefined</td>
 </tr>
 
 <tr><
 td>+0</td>                       
 <td>&gt; 0</td>     
 <td>+0</td>
 </tr>
 
 <tr>
 <td>&gt; 0 and not +infinity</td> 
 <td>+infinity</td>  
 <td>+0</td></tr>
 
 <tr>
 <td>-0</td>                       
 <td>&gt; 0</td>     
 <td>-0</td>
 </tr>
 
 <tr>
 <td>&lt; 0 and not -infinity</td> 
 <td>+infinity</td>  
 <td>-0</td>
 </tr>
 
 <tr>
 <td>+0</td>                       
 <td>&lt; 0</td>     
 <td>The `Float` best approximating \{#03C0}</td>
 </tr>
 
 <tr>
 <td>&gt; 0 and not +infinity</td> 
 <td>-infinity</td>  
 <td>The `Float` best approximating \{#03C0}</td>
 </tr>
 
 <tr>
 <td>-0</td>                       
 <td>&lt; 0</td>     
 <td>The `Float` best approximating -\{#03C0}</td>
 </tr>
 
 <tr>
 <td>&lt; 0 and not -infinity</td> 
 <td>-infinity</td>  
 <td>The `Float` best approximating -\{#03C0}</td>
 </tr>
 
 <tr>
 <td>&gt; 0</td>    
 <td>+0 or -0</td>                   
 <td>The `Float` best approximating \{#03C0}/2</td>
 </tr>
 
 <tr>
 <td>+infinity</td> 
 <td>not +infinity or -infinity</td> 
 <td>The `Float` best approximating \{#03C0}/2</td>
 </tr>
 
 <tr>
 <td>&lt; 0</td>    
 <td>+0 or -0</td>                   
 <td>The `Float` best approximating -\{#03C0}/2</td>
 </tr>
 
 <tr>
 <td>-infinity</td> 
 <td>not +infinity or -infinity</td> 
 <td>The `Float` best approximating -\{#03C0}/2</td>
 </tr>
 
 <tr>
 <td>+infinity</td> <td>+infinity</td> 
 <td>The `Float` best approximating \{#03C0}/4</td>
 </tr>
 
 <tr>
 <td>+infinity</td> <td>-infinity</td> 
 <td>The `Float` best approximating 3\{#03C0}/4</td>
 </tr>
 
 <tr>
 <td>-infinity</td> 
 <td>+infinity</td> 
 <td>The `Float` best approximating -\{#03C0}/4</td>
 </tr>
 
 <tr>
 <td>-infinity</td> 
 <td>-infinity</td> 
 <td>The `Float` best approximating -3\{#03C0}/4</td>
 </tr>
 
 </tbody>
 </table>
 "
shared Float atan2(Float y, Float x) {
    return jatan2(y, x);
}

"Returns the length of the hypotenuse of a right angle 
 triangle with other sides having lengths `x` and `y`. 
 This method may be more accurate than computing 
 `sqrt(x**2 + x**2)` directly.
 
 `hypot(x,y)`:
 
 * where `x` and/or `y` is `+infinity` or `-infinity`, is 
   `+infinity`,
 * otherwise, where x and/or y is `undefined`, is 
   `undefined`.
 "
shared Float hypot(Float x, Float y) {
    return jhypot(x, y);
}

"The positive square root of the given number. This 
 method may be faster and/or more accurate than 
 `num**0.5`.
 
 * `sqrt(x)` for any x < 0 is `undefined`,
 * `sqrt(-0)` is `-0`,
 * `sqrt(+0) is `+0`,
 * `sqrt(+infinity)` is `+infinity`,
 * `sqrt(undefined)` is `undefined`.     
 "
shared Float sqrt(Float num) {
    return jsqrt(num);
}

"The cube root of the given number. This method may be 
 faster and/or more accurate than `num**(1.0/3.0)`.
 
 * `cbrt(-infinity)` is `-infinity`,
 * `cbrt(-0)` is `-0`,
 * `cbrt(+0)` is `+0`,
 * `cbrt(+infinity)` is `+infinity`,
 * `cbrt(undefined)` is `undefined`.    
 "
shared Float cbrt(Float num) {
    return jcbrt(num);
}

"A number greater than or equal to positive zero and less 
 than `1.0`, chosen pseudorandomly and (approximately) 
 uniformly distributed."
shared Float random() {
    return jrandom();
}

"The largest value that is less than or equal to the 
 argument and equal to an integer.
 
 * `floor(-infinity)` is `-infinity`,
 * `floor(-0)` is `-0`,
 * `floor(+0)` is `+0`,
 * `floor(+infinity)` is `+infinity`,
 * `floor(undefined)` is `undefined`.
 "
//TODO see(ceiling)
//TODO see(halfEven)
shared Float floor(Float num) {
    return jfloor(num);
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
//TODO see(floor)
//TODO see(halfEven)
shared Float ceiling(Float num) {
    return jceiling(num);
}

"The closest value to the argument that is equal to a
 mathematical integer, with even values preferred in the 
 event of a tie (half even rounding).
 
 * `halfEven(-infinity)` is `-infinity`
 * `halfEven(-0)` is `-0` 
 * `halfEven(+0)` is `+0`
 * `halfEven(+infinity)` is `+infinity`
 * `halfEven(undefined)` is `undefined`
 "
//TODO see(floor)
//TODO see(ceiling)
shared Float halfEven(Float num) {
    return jrint(num);
}

"The smaller of the two arguments.
 
 * `smallest(-1,+0)` is `-0`
 * `smallest(undefined, x)` is `undefined`
 * `smallest(x, x)` is `x`
 * `smallest(+infinity,x) is `x`
 * `smallest(-infinity,x) is `-infinity`
 "
//TODO see(largest)
shared Float smallest(Float x, Float y) {
    return jmin(x, y);
}

"The larger of the two arguments.
 
 * `largest(-1,+0)` is `+0`
 * `largest(undefined, x)` is `undefined`
 * `largest(x, x)` is `x`
 * `largest(+infinity,x) is `+infinity`
 * `largest(-infinity,x) is `x`
 "
//TODO see(smallest)
shared Float largest(Float x, Float y) {
    return jmax(x, y);
}

"The sum of the given values, or `0.0` if there are no 
 arguments."
shared Float sum(Float* values) {
    variable Float sum=0.0;
    for (x in values) {
        sum+=x;
    }
    return sum;
}

"The product of the given values, or `1.0` if there are 
 no arguments."
shared Float product(Float* values) {
    variable Float sum=1.0;
    for (x in values) {
        sum*=x;
    }
    return sum;
}

"The value of `x \{#00D7} 2\{#207F}`, calculated exactly 
 for reasonable values of `n`."
shared Float scalb(Float x, Integer n) {
    return jscalb(x, n);
}
