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
