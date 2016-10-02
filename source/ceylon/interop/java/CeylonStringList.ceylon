import java.lang {
    JString=String
}

"A [[List]] with keys of type `String` that wraps a [[List]]
 with keys of type `java.lang::String`.

 This class can be used to wrap a `java.util::List` if the
 Java map is first wrapped with [[CeylonList]]:

     CeylonStringList(CeylonList(javaList))
"
shared class CeylonStringList(List<JString> list)
        satisfies List<String> {

    getFromFirst(Integer index)
            => if (exists string = list[index])
            then string.string
            else null;

    contains(Object element)
            => if (is String element)
            then javaString(element) in list
            else false;

    lastIndex => list.lastIndex;

    size => list.size;

    shared actual default CeylonStringList clone()
            => CeylonStringList(list.clone());

    hash => (super of List<String>).hash;

    equals(Object that) => (super of List<String>).equals(that);


}