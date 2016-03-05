"Attribute indicating how the control wraps text."
tagged("enumerated attribute")
shared class Wrap
        of hard | soft
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "The browser automatically inserts line breaks (CR+LF) so that each line has 
     no more than the width of the control; the cols attribute must be specified."
    shared new hard {
        attributeValue = "hard";
    }
    
    "The browser ensures that all line breaks in the value consist of a CR+LF pair, 
     but does not insert any additional line breaks."
    shared new soft {
        attributeValue = "soft";
    }
    
}
