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

"The largest [[Integer]] in the given stream, or `null`
 if the stream is empty."
shared Integer|Absent max<Absent>
        (Iterable<Integer,Absent> values) 
        given Absent satisfies Null {
    value first = values.first;
    if (exists first) {
        variable value max = first;
        for (x in values) {
            max = Math.max(max, x);
        }
        return max;
    }
    return first;
}

"The smallest [[Integer]] in the given stream, or `null`
 if the stream is empty."
shared Integer|Absent min<Absent>
        (Iterable<Integer,Absent> values) 
        given Absent satisfies Null {
    value first = values.first;
    if (exists first) {
        variable value min = first;
        for (x in values) {
            min = Math.min(min, x);
        }
        return min;
    }
    return first;
}

"The sum of the [[Integer]]s in the given stream, or `0` 
 if the stream is empty."
shared Integer sum({Integer*} values) {
    variable Integer sum=0;
    for (x in values) {
        sum+=x;
    }
    return sum;
}

"The product of the [[Integer]]s in the given stream, or `1` 
 if the stream is empty."
shared Integer product({Integer*} values) {
    variable Integer sum=1;
    for (x in values) {
        sum*=x;
    }
    return sum;
}

