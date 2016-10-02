import ceylon.collection {
    MutableList
}

import java.lang {
    JString=String
}

"A [[MutableList]] with elements of type `ceylon.language::String`
 that wraps a `MutableList` with elements of type `java.lang::String`.

 This class can be used to wrap a `java.util::List` if the
 Java list is first wrapped with [[CeylonMutableList]]:

        CeylonStringMutableList(CeylonMutableList(javaList))

 If the given list is not a [[MutableList]], use [[CeylonStringList]]."
shared class CeylonStringMutableList(MutableList<JString> list)
        extends CeylonStringList(list)
        satisfies MutableList<String> {

    add(String element) => list.add(javaString(element));

    delete(Integer index) => list.delete(index)?.string;

    insert(Integer index, String element)
            => list.insert(index, javaString(element));

    set(Integer index, String element)
            => list.set(index, javaString(element));

    shared actual CeylonStringMutableList clone()
            => CeylonStringMutableList(list.clone());

}