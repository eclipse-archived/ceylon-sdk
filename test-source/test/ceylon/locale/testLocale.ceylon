import ceylon.locale {
    locale
}
import ceylon.test {
    assertEquals,
    test
}
import ceylon.time {
    dateTime
}
import ceylon.time.base {
    january,
    december
}

test shared void testLocale() {
    assert(exists ptBr = locale("pt-BR"));
    assert(exists ptBrCurrency = ptBr.currency);
    
    //Currency
    assertEquals(ptBrCurrency.displayName, "Real brasileiro");
    assertEquals(ptBrCurrency.fractionalDigits, 2);
    assertEquals(ptBrCurrency.numericCode, "986");
    assertEquals(ptBrCurrency.symbol, "R$");
    
    //Date
    assertEquals(
        "1 de Janeiro de 2014",
        ptBr.formats.longFormatDate(dateTime(2014, january, 1, 23, 59, 59, 999))
    );
    
    assertEquals(
        "01/12/2014",
        ptBr.formats.mediumFormatDate(dateTime(2014, december, 1, 23, 59, 59, 999))
    );
    
    assertEquals(
        "01/12/14",
        ptBr.formats.shortFormatDate(dateTime(2014, december, 1, 23, 59, 59, 999))
    );
    
    //Time
    assertEquals(
        "23:59",
        ptBr.formats.shortFormatTime(dateTime(2014, december, 1, 23, 59, 59, 999))
    );
    
    assertEquals(
        "23:59:59",
        ptBr.formats.mediumFormatTime(dateTime(2014, december, 1, 23, 59, 59, 999))
    );
    
    /*assertEquals(
        "23h59min59s",
        ptBr.formats.longFormatTime(dateTime(2014, december, 1, 23, 59, 59, 999))
    );*/

}
