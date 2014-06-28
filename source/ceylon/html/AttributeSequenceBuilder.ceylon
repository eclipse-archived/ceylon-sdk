import ceylon.collection { ArrayList }

"A sequence builder used to build valid HTML attributes."
class AttributeSequenceBuilder() {
    
    value list = ArrayList<String->Object>();
    
    shared void addAttribute(String name, Object? val) {
        if (exists val) {
            list.add(name->val);
        }
    }

    shared void addNamedBooleanAttribute(String name, Boolean? val) {
        if (exists val, val) {
            list.add(name->name);
        }
    }

    shared void addYesNoBooleanAttribute(String name, Boolean? val) {
        if (exists val) {
            addAttribute(name, val then "yes" else "no");
        }
    }

    shared void addOnOffBooleanAttribute(String name, Boolean? val) {
        if (exists val) {
            addAttribute(name, val then "on" else "off");
        }
    }
    
    shared <String->Object>[] sequence() => list.sequence();
    
    shared void addAll({<String->Object>*} attributes)
            => list.addAll(attributes);
    
}
/*class AttributeSequenceBuilder() 
        extends ArrayList<String->Object>() {
    
    shared void addAttribute(String name, Object? val) {
        if (exists val) {
            add(name->val);
        }
    }
    
    shared void addNamedBooleanAttribute(String name, Boolean? val) {
        if (exists val, val) {
            add(name->name);
        }
    }
    
    shared void addYesNoBooleanAttribute(String name, Boolean? val) {
        if (exists val) {
            addAttribute(name, val then "yes" else "no");
        }
    }
    
    shared void addOnOffBooleanAttribute(String name, Boolean? val) {
        if (exists val) {
            addAttribute(name, val then "on" else "off");
        }
    }
    
}*/