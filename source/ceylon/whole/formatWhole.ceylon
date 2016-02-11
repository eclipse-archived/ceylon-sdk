shared
String formatWhole(Whole whole, Integer radix = 10) {
    assert (minRadix <= radix <= maxRadix);
    assert (is WholeImpl whole);

    // TODO better would be whole.integerRepresentable
    if (whole.safelyAddressable) {
        return formatInteger(whole.integer, radix);
    }

    if (whole.zero) {
        return "0";
    }

    value toRadix = wholeNumber(radix);
    variable value digits = StringBuilder();

    variable Whole x = whole.magnitude;
    while (!x.zero) {
        value qr = x.quotientAndRemainder(toRadix);
        value d = qr.last.integer;
        Character c;
        if (0 <= d <10) {
            c = (d + zeroInt).character;
        }
        else if (10 <= d <36) {
            c = (d - 10 + aIntLower).character;
        }
        else {
            assert (false);
        }
        digits.appendCharacter(c);
        x = qr.first;
    }
    if (whole.negative) {
        digits.appendCharacter('-');
    }
    return digits.reverseInPlace().string;
}
