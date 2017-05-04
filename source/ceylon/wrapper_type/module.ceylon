"Wrapper types for commonly used types to add unique typing.  Example, in contexts where several
 Integer variables are used for different concepts such as AccountNumber, ReferenceNumber, etc.  This
 adds more safety than raw [[Integer]]s or [[String]]s, etc.

 Examples:
       class AccountNumber(Integer baseValue) extends WrappedInteger(baseValue) {}
       class ReferenceNumber(Integer baseValue) extends WrappedInteger(baseValue) {}

       value accountNum1 = AccountNumber(1);
       value accountNum2 = AccountNumber(2);

       value refNum1 = ReferenceNumber(1);
       value refNum2 = ReferenceNumber(2);

       assertFalse(accountNum1 == accountNum2);
       assertFalse(accountNum1 == referenceNum1);
       assertFalse(referenceNum2 == accountNum2);

 Any time one wishes to simply wrap around a given custom class without supporting comparison, one
 should simply extends [[WrapperType]].  If one wishes to make use of [[Comparable]], then one should
 extends [[WrappedTypedComparable]].

 An example of [[WrappedTypedComparable]] is [[WrappedString]]

 In addition, it is possible to write a custom wrapper for a custom class.

 Example:
        class Widget(shared String name) {}
        class WrappedWidget extends WrapperType<Widget>(baseValue) {}

 Also, there is a displayNameForType function that will output the declaration name for a type for all four possibilities,
 recursively if necessary:

 - [[ceylon.language.meta.model::ClassOrInterface]]
 - [[ceylon.language.meta.model::UnionType]]
 - [[ceylon.language.meta.model::IntersectionType]]
 - [[ceylon.language.meta.model::nothingType]]

        displayNameForType(`String`)

 &gt; <b>String</b>

        displayNameForType(`String|Integer`)

 &gt; <b>String|Integer</b>
"

by("Luke deGruchy")
module ceylon.wrapper_type "1.2.3" {}
