import java.lang{ Math { jmin=min, jmax=max } }

doc "The smaller of the two arguments."
see(largest)
shared Integer smallest(Integer x, Integer y) {
    return jmin(x, y);
}

doc "The larger of the two arguments."
see(smallest)
shared Integer largest(Integer x, Integer y) {
    return jmax(x, y);
}

doc "The sum of the given values, or `0` if there are no 
     arguments."
shared Integer sum(Integer... values) {
    variable Integer sum:=0;
    for (x in values) {
        sum+=x;
    }
    return sum;
}

doc "The product of the given values, or `1` if there are 
     no arguments."
shared Integer product(Integer... values) {
    variable Integer sum:=1;
    for (x in values) {
        sum*=x;
    }
    return sum;
}

