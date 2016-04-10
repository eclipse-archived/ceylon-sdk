import ceylon.language.meta {
    type
}
import ceylon.language.meta.model {
    Type
}

"Root of the hierarchy of wrapper types.  Allows for numerous possible subclasses to act as wrapper types for commonly
 used types to add better typing context.  See [[WrappedTypedComparable]] and [[WrappedInteger]] for examples of subclasses.
 For example, a subclass of [[WrappedInteger]] can declare a ReferenceNumber class as a subclass that will only be
 comparable to other ReferenceNumber classes, otherwise identical base values of different [[WrappedInteger]] subclasses
 will not be considered equal according to equals().
 "
shared abstract class WrapperType<ValueType>("Underlying value wrapped by the [[WrapperType]]"
                                            shared ValueType baseValue)
        given ValueType satisfies Object {

    "[[Type]] associated with the [[WrapperType]]"
    shared Type<> classType => type(this);

    "Display name of the type (ex WrappedString is \"WrappedString\""
    shared String name => displayNameForType(classType);

    shared actual default Boolean equals(Object other) {
        if (is WrapperType<ValueType> other) {
            if (classType== other.classType) {
                return baseValue == other.baseValue;
            }
        }

        return false;
    }

    shared actual default Integer hash {
        value prime = 31;
        value result = 1;

        return prime * result + baseValue.hash;
    }

    shared actual default String string => "``name``: baseValue->``baseValue``";
}
