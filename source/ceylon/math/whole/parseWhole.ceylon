import java.lang {
    NumberFormatException
}
import java.math {
    BigInteger
}

"The `Whole` repesented by the given string, or `null` 
 if the given string does not represent a `Whole`."
shared Whole? parseWhole(String num) {
    BigInteger bi;
    try {
        //TODO: Use something more like the Ceylon literal 
        //      format
        bi = BigInteger(num);
    } catch (NumberFormatException e) {
        return null;
    }
    return WholeImpl(bi);
}