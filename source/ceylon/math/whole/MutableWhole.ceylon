import ceylon.math.integer {
    largest
}

final class MutableWhole
        satisfies Integral<MutableWhole> &
                  Exponentiable<MutableWhole, MutableWhole> {

    shared variable Words words;

    shared variable Integer wordsSize;

    shared new Of(Words words, Integer size = -1) {
        this.wordsSize = realSize(words, size);
        this.words = words;
    }

    shared new CopyOf(Words words, Integer size = -1) {
        this.wordsSize = realSize(words, size);
        this.words = wordsOfSize(this.wordsSize);
        words.copyTo(this.words, 0, 0, this.wordsSize);
    }

    shared new CopyOfWhole(Whole whole) {
        this.wordsSize = realSize(whole.words, whole.wordsSize);
        this.words = wordsOfSize(this.wordsSize);
        whole.words.copyTo(this.words, 0, 0, this.wordsSize);
    }

    shared actual MutableWhole plus(MutableWhole other) {
        if (this.zero) {
            return other.copy();
        }
        else if (other.zero) {
            return this.copy();
        }
        else {
            return Of(add(this.wordsSize, this.words,
                      other.wordsSize, other.words));
        }
    }

    shared actual MutableWhole minus(MutableWhole other) {
        if (this.zero && other.zero) {
            return Of(wordsOfSize(0), 0);
        }
        else {
            switch (compareMagnitude(
                    this.wordsSize, this.words,
                    other.wordsSize, other.words))
            case (equal) {
                return Of(wordsOfSize(0), 0);
            }
            case (larger) {
                return Of(subtract(
                        this.wordsSize, this.words,
                       other.wordsSize, other.words));
            }
            case (smaller) {
                throw Exception("Cannot subtract a larger value");
            }
        }
    }

    shared actual MutableWhole plusInteger(Integer integer) => nothing;

    shared actual MutableWhole divided(MutableWhole other) {
        if (other.zero) {
            throw Exception("Divide by zero");
        } else if (zero) {
            return Of(wordsOfSize(0), 0);
        } else if (other.unit) {
            return copy();
        } else {
            switch (compareMagnitude(
                    this.wordsSize, this.words,
                    other.wordsSize, other.words))
            case (equal) {
                return Of(wordsOfOne(1));
            }
            case (smaller) {
                return Of(wordsOfSize(0), 0);
            }
            case (larger) {
                value quotient = wordsOfSize(this.wordsSize);
                divide<Null>(this.wordsSize, this.words,
                             other.wordsSize, other.words,
                             quotient);
                return Of(quotient);
            }
        }
    }

    shared actual MutableWhole remainder(MutableWhole other) {
        if (other.zero) {
            throw Exception("Divide by zero");
        } else if (zero) {
            return Of(wordsOfSize(0), 0);
        } else if (other.unit) {
            return Of(wordsOfSize(0), 0);
        } else {
            switch (compareMagnitude(
                    this.wordsSize, this.words,
                    other.wordsSize, other.words))
            case (equal) {
                return Of(wordsOfSize(0), 0);
            }
            case (smaller) {
                return copy();
            }
            case (larger) {
                value remainder = divide<Nothing>(
                            this.wordsSize, this.words,
                            other.wordsSize, other.words);
                return Of(remainder);
            }
        }
    }

    shared actual MutableWhole power(MutableWhole other) => nothing;

    shared actual MutableWhole powerOfInteger(Integer integer) => nothing;

    shared actual MutableWhole times(MutableWhole other) {
        if (this.zero || other.zero) {
            return Of(wordsOfSize(0), 0);
        } else if (this.unit) {
            return other.copy();
        } else if (other.unit) {
            return copy();
        } else {
            return Of(multiply(
                    this.wordsSize, this.words,
                    other.wordsSize, other.words));
        }
    }

    shared actual MutableWhole timesInteger(Integer integer) => nothing;

    shared actual MutableWhole neighbour(Integer offset) => nothing;

    shared actual Integer offset(MutableWhole other) => nothing;

    shared MutableWhole copy() => CopyOf(words, wordsSize);

    shared actual MutableWhole wholePart => copy();

    shared actual MutableWhole fractionalPart => Of(wordsOfSize(0), 0);

    shared actual Boolean unit => wordsSize == 1 && getw(words, 0) == 1;

    shared actual Boolean negative => false;

    shared actual Boolean positive => wordsSize != 0;

    shared actual Boolean zero => wordsSize == 0;

    shared actual MutableWhole negated {
        assert(zero);
        return copy();
    }

    shared actual Comparison compare(MutableWhole other)
        => compareMagnitude(
                this.wordsSize, this.words,
                other.wordsSize, other.words);

    shared actual String string => Whole.CopyOfMutableWhole(this).string;

    shared void inplaceLeftLogicalShift(Integer shift) {
        // TODO actual inplace shift, if room is available
        words = leftShift(wordsSize, words, shift);
        wordsSize = realSize(words, -1);
    }

    shared void inplaceRightLogicalShift(Integer shift) {
        rightShiftInplaceUnsigned(wordsSize, words, shift);
        wordsSize = realSize(words, wordsSize);
    }

    shared void inplaceAdd(MutableWhole other) {
        value rSize = largest(this.wordsSize, other.wordsSize) + 1;
        if (sizew(words) >= rSize) {
            add(this.wordsSize, this.words,
                other.wordsSize, other.words,
                rSize, this.words);
            wordsSize = realSize(words, rSize);
        }
        else {
            words = add(this.wordsSize, this.words,
                        other.wordsSize, other.words);
            wordsSize = realSize(words, -1);
        }
    }

    shared void inplaceSubtract(MutableWhole other) {
        subtract(this.wordsSize, this.words,
                 other.wordsSize, other.words,
                 this.wordsSize, this.words);
        wordsSize = realSize(words, wordsSize);
    }

    shared Integer trailingZeroWords {
        for (i in 0:wordsSize) {
            if (getw(words, i) != 0) {
                return i;
            }
        } else {
            assert(wordsSize == 0);
            return 0;
        }
    }

    shared Integer trailingZeros
        =>  if (this.zero)
            then 0
            else (let (zeroWords = trailingZeroWords,
                       word = getw(words, zeroWords))
                  zeroWords * wordBits + numberOfTrailingZeros(word));

}
