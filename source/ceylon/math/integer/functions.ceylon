import java.lang {
    Math
}

"The smaller of the two arguments."
see(`function largest`)
shared Integer smallest(Integer x, Integer y) {
    return Math.min(x, y);
}

"The larger of the two arguments."
see(`function smallest`)
shared Integer largest(Integer x, Integer y) {
    return Math.max(x, y);
}

"The sum of the given values, or `0` if there are no 
 arguments."
shared Integer sum(Integer* values) {
    variable Integer sum=0;
    for (x in values) {
        sum+=x;
    }
    return sum;
}

"The product of the given values, or `1` if there are 
 no arguments."
shared Integer product(Integer* values) {
    variable Integer sum=1;
    for (x in values) {
        sum*=x;
    }
    return sum;
}

