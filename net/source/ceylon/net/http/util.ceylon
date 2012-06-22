import java.util { JavaMap = Map, JavaList = List }
import java.lang { JString = String }
import ceylon.collection { MutableList, LinkedList, MutableMap, HashMap }
import ceylon.net.iop { toIterable }

List<String> toList(JavaList<JString> javaList){
    MutableList<String> ret = LinkedList<String>();
    for(item in toIterable(javaList)){
        ret.add(item.string);
    }
    return ret;
}

T? toOptional<T>(T t){
    return t;
}

Map<String, List<String>> toMap(JavaMap<JString, JavaList<JString>> javaMap){
    MutableMap<String, List<String>> ret = HashMap<String, List<String>>();
    for(entry in toIterable(javaMap.entrySet())){
        if(exists JString key = toOptional(entry.key)){
            ret.put(entry.key.string, toList(entry.\ivalue));
        }
    }
    return ret; 
}

