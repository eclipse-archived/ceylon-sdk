"Attribute indicating the directionality of the element's text."
tagged("enumerated attribute")
shared class Direction
        of ltr | rtl | auto
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "Means left to right and is to be used for languages that are written 
     from the left to the right (like English)."
    shared new ltr {
        attributeValue = "ltr";
    }
    
    "Means right to left and is to be used for languages that are written 
     from the right to the left (like Arabic)."
    shared new rtl {
        attributeValue = "rtl";
    }
    
    "Let the user agent decides. It uses a basic algorithm as it parses 
     the characters inside the element until it finds a character with a strong 
     directionality, then apply that directionality to the whole element."
    shared new auto {
        attributeValue = "auto";
    }
    
}
