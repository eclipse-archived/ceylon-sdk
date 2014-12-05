// TODO make private? Currently shared for Whole's shared constructor
shared abstract class Sign() of positiveSign, negativeSign, zeroSign
        satisfies Comparable<Sign> {

    shared Boolean positive => this == positiveSign;
    shared Boolean zero => this == zeroSign;
    shared Boolean negative => this == negativeSign;

    shared Sign negated
        => switch (this)
        case (positiveSign) negativeSign
        case (zeroSign)     zeroSign
        case (negativeSign) positiveSign;

    shared actual Comparison compare(Sign other)
        => switch (this)
        case (positiveSign)
            (other.positive then equal else larger)
        case (zeroSign)
            (switch (other)
             case (positiveSign) smaller
             case (zeroSign)     equal
             case (negativeSign) larger)
        case (negativeSign)
           (other.negative then equal else smaller);

    shared Integer integer
        => switch (this)
        case (positiveSign)  1
        case (zeroSign)      0
        case (negativeSign) -1;
}

shared object positiveSign extends Sign() {}
shared object negativeSign extends Sign() {}
shared object zeroSign extends Sign() {}
