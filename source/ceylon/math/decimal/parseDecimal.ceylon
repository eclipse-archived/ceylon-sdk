import java.lang {
    NumberFormatException
}
import java.math {
    BigDecimal
}

"The `Decimal` repesented by the given string, or `null` 
 if the given string does not represent a `Decimal`."
shared Decimal? parseDecimal(String str) {
    BigDecimal bd;
    try {
        bd = BigDecimal(str);
    } catch (NumberFormatException e) {
        return null;
    }
    return DecimalImpl(bd);
}