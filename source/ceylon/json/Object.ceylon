import ceylon.collection { ... }
import ceylon.language { LangObject = Object }

"Represents a JSON Object"
by("Stéphane Épardaud")
shared class Object({<String->String|Boolean|Integer|Float|Object|Array|NullInstance>*} values = {}) 
    satisfies MutableMap<String, String|Boolean|Integer|Float|Object|Array|NullInstance> {
    
    value contents = HashMap<String, String|Boolean|Integer|Float|Object|Array|NullInstance>{*values};
    
    "Returns a serialised JSON representation"
    shared actual String string {
        StringPrinter p = StringPrinter();
        p.printObject(this);
        return p.string;
    }

    "Returns a pretty-printed serialised JSON representation"
    shared String pretty {
        StringPrinter p = StringPrinter(true);
        p.printObject(this);
        return p.string;
    }
    
    shared actual void clear() {
        contents.clear();
    }
    
    shared actual Object clone() {
        return Object(contents);
    }
    
    shared actual Null|String|Boolean|Integer|Float|Object|Array|NullInstance get(LangObject key) {
        return contents[key];
    }
    
    shared actual Iterator<Entry<String,String|Boolean|Integer|Float|Object|Array|NullInstance>> iterator() {
        return contents.iterator();
    }
    
    shared actual Null|String|Boolean|Integer|Float|Object|Array|NullInstance put(String key, String|Boolean|Integer|Float|Object|Array|NullInstance item) {
        return contents.put(key, item);
    }
    
    shared actual void putAll({Entry<String,String|Boolean|Integer|Float|Object|Array|NullInstance>*} entries) {
        contents.putAll(entries);
    }
    
    shared actual Null|String|Boolean|Integer|Float|Object|Array|NullInstance remove(String key) {
        return contents.remove(key);
    }
    
    shared actual Integer size {
        return contents.size;
    }
    
    shared actual Integer hash {
        return contents.hash;
    }
    
    shared actual Boolean equals(LangObject that) {
        if(is Object that){
            return this === that || contents == that.contents;
        }
        return false;
    }
    
    // auto-casting
    
    "Returns an [[Integer]] value."
    throws(`class InvalidTypeException`,
        "If the key dot not exist or points to a type that is not [[Integer]].")
    shared Integer getInteger(String key){
        value val = get(key);
        if(is Integer val){
            return val;
        }
        throw InvalidTypeException("Expecting an Integer but got: `` val else "null" ``");
    }

    "Returns an [[Float]] value."
    throws(`class InvalidTypeException`,
        "If the key dot not exist or points to a type that is not [[Float]].")
    shared Float getFloat(String key){
        value val = get(key);
        if(is Float val){
            return val;
        }
        throw InvalidTypeException("Expecting a Float but got: `` val else "null" ``");
    }

    "Returns an [[Boolean]] value."
    throws(`class InvalidTypeException`,
        "If the key dot not exist or points to a type that is not [[Boolean]].")
    shared Boolean getBoolean(String key){
        value val = get(key);
        if(is Boolean val){
            return val;
        }
        throw InvalidTypeException("Expecting a Boolean but got: `` val else "null" ``");
    }

    "Returns an [[String]] value."
    throws(`class InvalidTypeException`,
        "If the key dot not exist or points to a type that is not [[String]].")
    shared String getString(String key){
        value val = get(key);
        if(is String val){
            return val;
        }
        throw InvalidTypeException("Expecting a String but got: `` val else "null" ``");
    }

    "Returns an [[Object]] value."
    throws(`class InvalidTypeException`,
        "If the key dot not exist or points to a type that is not [[Object]].")
    shared Object getObject(String key){
        value val = get(key);
        if(is Object val){
            return val;
        }
        throw InvalidTypeException("Expecting an Object but got: `` val else "null" ``");
    }
    
    "Returns an [[Array]] value."
    throws(`class InvalidTypeException`,
        "If the key dot not exist or points to a type that is not [[Array]].")
    shared Array getArray(String key){
        value val = get(key);
        if(is Array val){
            return val;
        }
        throw InvalidTypeException("Expecting an Array but got: `` val else "null" ``");
    }
    
    // optional auto-casting
    
    "Returns an [[Integer]] value, unless the key does not exist, or the value is null."
    throws(`class InvalidTypeException`,
        "If the key points to a type that is neither [[Integer]] nor [[NullInstance]].")
    shared Integer? getIntegerOrNull(String key){
        value val = get(key);
        if(is Integer|Null val){
            return val;
        }
        if(is NullInstance val){
            return null;
        }
        throw InvalidTypeException("Expecting an Integer but got: `` val else "null" ``");
    }

    "Returns an [[Float]] value, unless the key does not exist, or the value is null."
    throws(`class InvalidTypeException`,
        "If the key points to a type that is neither [[Float]] nor [[NullInstance]].")
    shared Float? getFloatOrNull(String key){
        value val = get(key);
        if(is Float|Null val){
            return val;
        }
        if(is NullInstance val){
            return null;
        }
        throw InvalidTypeException("Expecting a Float but got: `` val else "null" ``");
    }

    "Returns an [[Boolean]] value, unless the key does not exist, or the value is null."
    throws(`class InvalidTypeException`,
        "If the key points to a type that is neither [[Boolean]] nor [[NullInstance]].")
    shared Boolean? getBooleanOrNull(String key){
        value val = get(key);
        if(is Boolean|Null val){
            return val;
        }
        if(is NullInstance val){
            return null;
        }
        throw InvalidTypeException("Expecting a Boolean but got: `` val else "null" ``");
    }

    "Returns an [[String]] value, unless the key does not exist, or the value is null."
    throws(`class InvalidTypeException`,
        "If the key points to a type that is neither [[String]] nor [[NullInstance]].")
    shared String? getStringOrNull(String key){
        value val = get(key);
        if(is String|Null val){
            return val;
        }
        if(is NullInstance val){
            return null;
        }
        throw InvalidTypeException("Expecting a String but got: `` val else "null" ``");
    }

    "Returns an [[Object]] value, unless the key does not exist, or the value is null."
    throws(`class InvalidTypeException`,
        "If the key points to a type that is neither [[Object]] nor [[NullInstance]].")
    shared Object? getObjectOrNull(String key){
        value val = get(key);
        if(is Object|Null val){
            return val;
        }
        if(is NullInstance val){
            return null;
        }
        throw InvalidTypeException("Expecting an Object but got: `` val else "null" ``");
    }
    
    "Returns an [[Array]] value, unless the key does not exist, or the value is null."
    throws(`class InvalidTypeException`,
        "If the key points to a type that is neither [[Array]] nor [[NullInstance]].")
    shared Array? getArrayOrNull(String key){
        value val = get(key);
        if(is Array|Null val){
            return val;
        }
        if(is NullInstance val){
            return null;
        }
        throw InvalidTypeException("Expecting an Array but got: `` val else "null" ``");
    }
}