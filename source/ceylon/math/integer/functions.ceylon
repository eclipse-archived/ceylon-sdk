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

"The sum of the values in the given stream, or 
 `0` if the stream is empty."
shared Integer sum({Integer*} values) {
    variable Integer sum=0;
    for (x in values) {
        sum+=x;
    }
    return sum;
}

"The product of the values in the given stream, or 
 `1` if the stream is empty."
shared Integer product({Integer*} values) {
    variable Integer sum=1;
    for (x in values) {
        sum*=x;
    }
    return sum;
}

