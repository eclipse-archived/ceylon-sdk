/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Alias for attribute value type."
shared alias Attribute<Value> => Value?|Value?();

"Alias for attribute entry."
shared alias AttributeEntry => <String-><Attribute<String>|Attribute<Boolean>|Attribute<Integer>|Attribute<Float>|Attribute<AttributeValueProvider>>>;

"Alias for attribute entries."
shared alias Attributes => [AttributeEntry?*];


"Represents strategy for obtaining attribute value, usually implemented by classes used as enumerated attribute values."
shared interface AttributeValueProvider {
    
    "The attribute value."
    shared formal String? attributeValue;
    
    string => attributeValue else super.string;
    
}

class AttributeBooleanValueProvider(Attribute<Boolean> attributeBoolean, String? trueValue, String? falseValue) satisfies AttributeValueProvider {
    
    function valueOf(Boolean? b) 
            => if(exists b) 
            then (if(b) then trueValue else falseValue) 
            else null;
    
    attributeValue 
            => switch(attributeBoolean) 
            case (Boolean) valueOf(attributeBoolean) 
            case (Boolean?()) valueOf(attributeBoolean()) else null;
    
}

AttributeValueProvider? attributeValueYesNo(Attribute<Boolean> attributeBoolean)
        => if(exists attributeBoolean) then AttributeBooleanValueProvider(attributeBoolean, "yes", "no") else null;

AttributeValueProvider? attributeValueOnOff(Attribute<Boolean> attributeBoolean)
        => if(exists attributeBoolean) then AttributeBooleanValueProvider(attributeBoolean, "on", "off") else null;

AttributeValueProvider? attributeValueTrueFalse(Attribute<Boolean> attributeBoolean)
        => if(exists attributeBoolean) then AttributeBooleanValueProvider(attributeBoolean, "true", "false") else null;

AttributeEntry? attributeEntry(String attributeName, Attribute<String>|Attribute<Boolean>|Attribute<Integer>|Attribute<Float>|Attribute<AttributeValueProvider> attributeValue)
        => if(exists attributeValue) then attributeName->attributeValue else null;
