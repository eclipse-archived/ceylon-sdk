abstract class Sign() of positiveSign, negativeSign, zeroSign
        satisfies Comparable<Sign> {

    shared Boolean positive => this == positiveSign;
    shared Boolean zero => this == zeroSign;
    shared Boolean negative => this == negativeSign;

    shared Sign negated {
        switch (this)
        case (positiveSign) { return negativeSign; }
        case (zeroSign) { return zeroSign; }
        case (negativeSign) { return positiveSign; }
    }

    shared actual Comparison compare(Sign other) {
        switch (this)
        case (positiveSign) {
            return other.positive then equal else larger;
        }
        case (zeroSign) {
            switch (other)
            case (positiveSign) { return smaller; }
            case (zeroSign) { return equal; }
            case (negativeSign) { return larger; }
        }
        case (negativeSign) {
            return other.negative then equal else smaller;
        }
    }
}

object positiveSign extends Sign() {}
object negativeSign extends Sign() {}
object zeroSign extends Sign() {}
