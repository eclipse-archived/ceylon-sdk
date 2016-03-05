"Attribute is used to define the MIME type of the content."
tagged("enumerated attribute")
shared class MimeType satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "Constructor."
    shared new (String mimeType) {
        attributeValue = mimeType;
    }
    
    "text/css"
    shared new textCss {
        attributeValue = "text/css";
    }
    
    "text/html"
    shared new textJavascript {
        attributeValue = "text/javascript";
    }
    
}