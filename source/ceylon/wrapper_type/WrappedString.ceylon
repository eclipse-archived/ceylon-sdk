"Subclass of [[WrappedTypedComparable]] for [[String]]s.  Supports operations on [[List]]s of [[Character]]s."
shared abstract class WrappedString(String baseValue)
        extends WrappedTypedComparable<String>(baseValue)
        satisfies List<Character> {

    shared actual Boolean equals(Object other) =>
        (super of WrapperType<String>).equals(other);

    shared actual Integer hash => (super of WrapperType<String>).hash;

    shared actual String string => (super of WrapperType<String>).string;

    shared actual String span(Integer from, Integer to) => baseValue.span(from, to);

    shared actual Integer? lastIndex => baseValue.lastIndex;

    shared actual Character? getFromFirst(Integer index) => baseValue.getFromFirst(index);
}
