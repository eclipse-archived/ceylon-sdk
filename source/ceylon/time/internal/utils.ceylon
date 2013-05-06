"return padded value of the number as a string"
shared String leftPad(Integer number, String padding = "00"){
    if (number == 0){
        return padding;
    }

    value string = number.string;
    value digits = string.size;
    if (digits < padding.size) {
        value padded = padding + string;
        return padded.segment(
                      padded.size - padding.size,
                      padding.size );
    }

    return string;
}

"Returns if two ranges has intersection"
shared Boolean intersect<Value>( Value start, Value end, Value otherStart, Value otherEnd ) given Value satisfies Comparable<Value> {
    return start <= otherEnd && end >= otherStart;
}

"Returns the gap between two Ranges represented as [Value,Value]"
shared [Value,Value]|Empty gap<Value>([Value,Value] first, [Value,Value] second) given Value satisfies Comparable<Value>&Ordinal<Value> {

    variable [Value,Value] from = [min{*first}, max{*first}];
    variable [Value,Value] to = [min{*second}, max{*second}]; 

    variable Boolean ascending = true; 
    if( from[0] > to[0] ) {
        ascending = false;
        value aux = from;
        from = to;
        to = aux;
    }

    if (!intersect(from[0], from[1], to[0], to[1])) {
        value sucessor = from[1].successor;
        value predecessor = to[0].predecessor;

        if( sucessor >= to[0] ) {
            return empty;
        }

        return [ascending then sucessor else predecessor, 
                ascending then predecessor else sucessor];
    }

    return empty;
}

"Returns the overlap between two Ranges represented as [Value,Value]"
shared [Value,Value]|Empty overlap<Value>([Value,Value] first, [Value,Value] second) given Value satisfies Comparable<Value>&Ordinal<Value> {
    variable [Value,Value] from = [min{*first}, max{*first}];
    variable [Value,Value] to = [min{*second}, max{*second}]; 

    variable Boolean ascending = true; 
    if( from[0] > to[0] ) {
        ascending = false;
        value aux = from;
        from = to;
        to = aux;
    }

    if (intersect(from[0], from[1], to[0], to[1])) {
        return [ascending then to[0] else min{from[1], to[1] },
                ascending then min{from[1], to[1] } else to[0] ];
    } 
    return empty;
}
