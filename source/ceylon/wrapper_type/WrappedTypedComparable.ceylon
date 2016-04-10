"A [[WrapperType]] variant that supports subclasses that are [[Comparable]] and its associated attributes and functions.
 An example is [[WrappedString]].
"
shared abstract class WrappedTypedComparable<ValueType>(ValueType baseValue)
        extends WrapperType<ValueType>(baseValue)
        satisfies Comparable<WrappedTypedComparable<ValueType>>
        given ValueType satisfies Comparable<ValueType> {

    shared actual Comparison compare(WrappedTypedComparable<ValueType> other)
            => baseValue.compare(other.baseValue);
}