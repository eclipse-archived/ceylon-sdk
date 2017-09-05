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
        case (String) JString(something)
        case (Integer) JLong(something)
        case (Float) JDouble(something)
        case (Character) JInteger(something.integer)
        case (Byte) JByte(something)
        case (Boolean) JBoolean(something)
        else something;

shared Object toCeylonNotNull(Object something)
        => switch (something)
        case (JString) something.string
        case (JInteger|JLong) something.longValue()
        case (JFloat|JDouble) something.doubleValue()
        case (JCharacter) something.charValue()
        case (JByte) something.byteValue()
        case (JBoolean) something.booleanValue()
        else something;