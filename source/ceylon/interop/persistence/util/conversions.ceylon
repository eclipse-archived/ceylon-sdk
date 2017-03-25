import java.lang {
    JLong=Long,
    JFloat=Float,
    JDouble=Double,
    JInteger=Integer,
    JString=String,
    JCharacter=Character,
    JByte=Byte,
    JBoolean=Boolean
}

shared Object? toCeylon(Anything something)
        => if (exists something)
        then toCeylonNotNull(something)
        else null;

shared Object? toJava(Anything something)
        => if (exists something)
        then toJavaNotNull(something)
        else null;

shared Object toJavaNotNull(Object something)
        => switch (something)
        case (is String) JString(something)
        case (is Integer) JLong(something)
        case (is Float) JDouble(something)
        case (is Character) JInteger(something.integer)
        case (is Byte) JByte(something)
        case (is Boolean) JBoolean(something)
        else something;

shared Object toCeylonNotNull(Object something)
        => switch (something)
        case (is JString) something.string
        case (is JInteger|JLong) something.longValue()
        case (is JFloat|JDouble) something.doubleValue()
        case (is JCharacter) something.charValue()
        case (is JByte) something.byteValue()
        case (is JBoolean) something.booleanValue()
        else something;